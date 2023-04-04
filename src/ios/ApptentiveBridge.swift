//
//  ApptentiveBridge.swift
//  ApptentiveCordova
//
//  Created by Frank Schmitt on 4/3/23.
//

import Foundation
import ApptentiveKit

@objc(ApptentiveBridge)
class ApptentiveBridge: CDVPlugin {

    var apptentiveInitialized = false
    var registeredForMessageNotifications = false
    var messageNotificationCallback: String?

    var observation: NSKeyValueObservation?

    override func pluginInitialize() {
        super.pluginInitialize()
    }

    @objc func execute(_ command: CDVInvokedUrlCommand) {
        guard let callbackID = command.callbackId else {
            assertionFailure("Missing callback ID in Apptentive Plugin")
            return
        }

        do {
            guard let functionCall = command.arguments.first as? String else {
                throw PluginError.invalidCommandArgument(command.arguments.first)
            }

            switch functionCall {
            case "deviceReady", "registerWithLogs":
                let (credentials, logLevel, distributionVersion, sanitizeLogMessages) = try Self.resolveConfiguration(from: command.arguments)
                ApptentiveLogger.logLevel = logLevel
                ApptentiveLogger.shouldHideSensitiveLogs = sanitizeLogMessages
                Apptentive.shared.distributionVersion = distributionVersion
                Apptentive.shared.register(with: credentials) { result in
                    switch result {
                    case .success:
                        self.commandDelegate.send(.init(status: CDVCommandStatus_OK, messageAs: "Apptentive SDK registered successfully."), callbackId: callbackID)

                    case .failure(let error):
                        self.commandDelegate.send(.init(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: callbackID)
                    }
                }
                return

            case "engage":
                Apptentive.shared.engage(event: Event(name: try Self.string(from: command.arguments))) { result in
                    switch result {
                    case .success(let didShowInteraction):
                        self.commandDelegate.send(.init(status: CDVCommandStatus_OK, messageAs: didShowInteraction), callbackId: callbackID)

                    case .failure(let error):
                        self.commandDelegate.send(.init(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: callbackID)
                    }
                }
                return

            case "addCustomDeviceData":
                let (key, value) = try Self.customDataPair(from: command.arguments)
                Apptentive.shared.deviceCustomData[key] = value

            case "addCustomPersonData":
                let (key, value) = try Self.customDataPair(from: command.arguments)
                Apptentive.shared.personCustomData[key] = value

            case "showMessageCenter":
                let customData = try Self.maybeCustomData(from: command.arguments)
                Apptentive.shared.presentMessageCenter(from: self.viewController, with: customData) { result in
                    switch result {
                    case .success(let didShow):
                        self.commandDelegate.send(.init(status: CDVCommandStatus_OK, messageAs: didShow), callbackId: callbackID)

                    case .failure(let error):
                        self.commandDelegate.send(.init(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: callbackID)
                    }
                }
                return

            case "removeCustomDeviceData":
                Apptentive.shared.deviceCustomData[try Self.string(from: command.arguments)] = nil

            case "removeCustomPersonData":
                Apptentive.shared.personCustomData[try Self.string(from: command.arguments)] = nil

            case "sendAttachmentFileWithMimeType":
                let _ = try Self.checkArgumentCount(command.arguments, 2...2)
                throw PluginError.unimplementedCommand(functionCall)

            case "sendAttachmentImage":
                let _ = try Self.checkArgumentCount(command.arguments, 2...2)
                throw PluginError.unimplementedCommand(functionCall)

            case "sendAttachmentText":
                Apptentive.shared.sendAttachment(try Self.string(from: command.arguments))

            case "setProperty":
                let (key, value) = try Self.propertyPair(from: command.arguments)
                Apptentive.shared[keyPath: try Self.property(from: key)] = value

            case "getProperty":
                let result = Apptentive.shared[keyPath: try Self.property(from: Self.string(from: command.arguments))]
                return self.commandDelegate.send(.init(status: CDVCommandStatus_OK, messageAs: result), callbackId: callbackID)

            case "unreadMessageCount":
                let result = Apptentive.shared.unreadMessageCount
                return self.commandDelegate.send(.init(status: CDVCommandStatus_OK, messageAs: result), callbackId: callbackID)

            case "registerForMessageNotifications":
                let _ = try Self.checkArgumentCount(command.arguments, 0...0)
                self.observation = Apptentive.shared.observe(\.unreadMessageCount, options: [.new]) { [weak self] _, _ in
                    guard let self = self else { return }
                    let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: Apptentive.shared.unreadMessageCount)
                    result?.setKeepCallbackAs(true)
                    self.commandDelegate.send(result, callbackId: callbackID)
                }
                return

            case "unregisterForNotifications":
                self.observation?.invalidate()

            case "canShowInteraction":
                Apptentive.shared.canShowInteraction(event: Event(name: try Self.string(from: command.arguments))) { result in
                    switch result {
                    case .success(let canShow):
                        self.commandDelegate.send(.init(status: CDVCommandStatus_OK, messageAs: canShow), callbackId: callbackID)

                    case .failure(let error):
                        self.commandDelegate.send(.init(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: callbackID)
                    }
                }
                return

            case "canShowMessageCenter":
                let _ = try Self.checkArgumentCount(command.arguments, 0...0)
                throw PluginError.unimplementedCommand(functionCall)

            case "openAppStore":
                let _ = try Self.checkArgumentCount(command.arguments, 0...0)
                throw PluginError.unimplementedCommand(functionCall)

            default:
                throw PluginError.unrecognizedCommand(functionCall)
            }

            self.commandDelegate.send(.init(status: CDVCommandStatus_OK), callbackId: callbackID)
        } catch let error {
            self.commandDelegate.send(.init(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: callbackID)
        }
    }

    // MARK: - Helper functions

    static func checkArgumentCount(_ arguments: [Any], _ range: ClosedRange<Int>) throws -> [Any] {
        let nonFunctionArgumentCount = arguments.count - 1
        guard range.contains(nonFunctionArgumentCount) else {
            throw PluginError.incorrectArgumentCount(function: (arguments.first as? String) ?? "<unknown>", expecting: range, received: nonFunctionArgumentCount)
        }

        return Array(arguments.suffix(from: 1))
    }

    static func resolveConfiguration(from arguments: [Any]) throws -> (Apptentive.AppCredentials, LogLevel, String, Bool) {
        let functionArguments = try self.checkArgumentCount(arguments, 0...1)

        guard let apptentiveKey = Bundle.main.object(forInfoDictionaryKey: "ApptentiveKey") as? String,
              let apptentiveSignature = Bundle.main.object(forInfoDictionaryKey: "ApptentiveSignature") as? String,
              let pluginVersion = Bundle.main.object(forInfoDictionaryKey: "ApptentivePluginVersion") as? String
        else {
            throw PluginError.missingVariablesInInfoDictionary
        }

        let sanitizeLogMessages = (Bundle.main.object(forInfoDictionaryKey: "ApptentiveSanitizeLogMessages") as? Bool) ?? true

        var logLevel: LogLevel
        if let logLevelArgument = functionArguments.first {
            guard let logLevelString = logLevelArgument as? String else {
                throw PluginError.invalidArgumentType(atIndex: 0, expecting: "String")
            }
            logLevel = try self.parseLogLevel(logLevelString)
        } else {
            logLevel = .info
        }

        return (.init(key: apptentiveKey, signature: apptentiveSignature), logLevel, pluginVersion, sanitizeLogMessages)
    }

    static func parseLogLevel(_ logLevelString: String) throws -> LogLevel {
        switch logLevelString.lowercased() {
        case "verbose":
            return .debug
        case "debug":
            return .debug
        case "info":
            return .info
        case "warn":
            return .warning
        case "error":
            return .error
        case "critical":
            return .critical
        default:
            throw PluginError.unrecognizedLogLevel(logLevelString)
        }
    }

    static func string(from arguments: [Any]) throws -> String {
        let functionArguments = try checkArgumentCount(arguments, 1...1)

        guard let string = functionArguments[0] as? String else {
            throw PluginError.invalidArgumentType(atIndex: 0, expecting: "String")
        }

        return string
    }

    static func propertyPair(from arguments: [Any]) throws -> (String, String?) {
        let functionArguments = try checkArgumentCount(arguments, 2...2)

        guard let key = functionArguments[0] as? String else {
            throw PluginError.invalidPropertyKeyType
        }

        guard let value = functionArguments[1] as? String? else {
            throw PluginError.invalidPropertyValueType
        }

        return (key, value)
    }

    static func property(from key: String) throws -> ReferenceWritableKeyPath<Apptentive, String?> {
        switch key {
        case "personName":
            return \Apptentive.personName

        case "personEmailAddress":
            return \Apptentive.personEmailAddress

        default:
            throw PluginError.invalidPropertyKeyType
        }
    }

    static func customDataPair(from arguments: [Any]) throws -> (String, CustomDataCompatible) {
        let functionArguments = try checkArgumentCount(arguments, 2...2)

        guard let key = functionArguments[0] as? String else {
            throw PluginError.invalidCustomDataKeyType
        }

        let value = try self.convertCustomDataValue(functionArguments[1])

        return (key, value)
    }

    static func maybeCustomData(from arguments: [Any]) throws -> CustomData? {
        let functionArguments = try self.checkArgumentCount(arguments, 0...1)

        guard functionArguments.count == 1 else {
            return nil
        }

        if let customDataDictionary = functionArguments[0] as? [AnyHashable: Any] {
            return try self.convertCustomData(customDataDictionary)
        } else if let jsonString = functionArguments[0] as? String {
            guard let data = jsonString.data(using: .utf8) else {
                throw PluginError.invalidJSONData
            }

            return try JSONDecoder().decode(CustomData.self, from: data)
        } else {
            throw PluginError.invalidJSONData
        }
    }

    static func convertCustomData(_ customData: [AnyHashable: Any]?) throws -> CustomData? {
        var result = CustomData()

        if let customData = customData {
            for (key, value) in customData {
                guard let key = key as? String else {
                    throw PluginError.invalidCustomDataKeyType
                }

                result[key] = try self.convertCustomDataValue(value)
            }
        }

        return result.keys.count > 0 ? result : nil
    }

    static func convertCustomDataValue(_ value: Any) throws -> CustomDataCompatible {
        switch value {
        case let bool as Bool:
            return bool

        case let int as Int:
            return int

        case let double as Double:
            return double

        case let string as String:
            return string

        default:
            throw PluginError.invalidCustomDataValueType
        }

    }

    enum PluginError: Swift.Error, LocalizedError {
        case missingVariablesInInfoDictionary
        case invalidCustomDataKeyType
        case invalidCustomDataValueType
        case invalidPropertyKeyType
        case invalidPropertyValueType
        case unrecognizedPropertyKey(String)
        case unrecognizedCommand(String)
        case invalidCommandArgument(Any?)
        case incorrectArgumentCount(function: String, expecting: ClosedRange<Int>, received: Int)
        case invalidArgumentType(atIndex: Int, expecting: String)
        case unimplementedCommand(String)
        case invalidJSONData
        case unrecognizedLogLevel(String)

        var errorDescription: String? {
            switch self {
            case .missingVariablesInInfoDictionary:
                return "One or more of the variables expected in Info.plist was missing (ApptentiveKey, ApptentiveSignature, and/or ApptentivePluginVersion)."

            case .invalidCustomDataKeyType:
                return "Found a non-string type when expecting a custom data key."

            case .invalidCustomDataValueType:
                return "Found an incompatible custom data value (allowed types are strings, booleans, and numbers)."

            case .invalidPropertyKeyType:
                return "Found a non-string type when expecting a property name."

            case .invalidPropertyValueType:
                return "Found a non-string type when expecting a property value."

            case .unrecognizedPropertyKey(let key):
                return "Unrecognized property name: \(key). Allowed keys are personName and personEmailAddress."

            case .unrecognizedCommand(let command):
                return "Received an unrecognized command: \(command)."

            case .invalidCommandArgument(let argument):
                return "Received an invalid command argument: \(String(describing: argument))."

            case .incorrectArgumentCount(function: let function, expecting: let expecting, received: let received):
                return "The number of arguments to the command \(String(describing: function)) was \(received) (expected \(expecting))."

            case .invalidArgumentType(atIndex: let index, expecting: let expecting):
                return "The type of the argument at \(index) was expected to be \(expecting)."

            case .unimplementedCommand(let command):
                return "The command \(command) is not implemented in this release."

            case .invalidJSONData:
                return "The string passed for the custom data argument is not valid JSON."

            case .unrecognizedLogLevel(let logLevel):
                return "The log level (\"\(logLevel)\") is not a valid log level (valid values are \"verbose\", \"debug\", \"info\", \"warn\", \"error\", and \"critical\")."
            }
        }
    }
}
