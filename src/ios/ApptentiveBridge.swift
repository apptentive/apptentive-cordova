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

    override func dispose() {
        self.observation?.invalidate()
        NotificationCenter.default.removeObserver(self)

        super.dispose()
    }

    @objc func addCustomDeviceData(_ command: CDVInvokedUrlCommand) {
        do {
            let (key, value) = try Self.customDataPair(from: command)
            Apptentive.shared.deviceCustomData[key] = value
            self.commandDelegate.send(.init(status: CDVCommandStatus_OK), callbackId: command.callbackId)
        } catch let error {
            self.commandDelegate.send(.init(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: command.callbackId)
        }
    }

    @objc func addCustomPersonData(_ command: CDVInvokedUrlCommand) {
        do {
            let (key, value) = try Self.customDataPair(from: command)
            Apptentive.shared.personCustomData[key] = value
            self.commandDelegate.send(.init(status: CDVCommandStatus_OK), callbackId: command.callbackId)
        } catch let error {
            self.commandDelegate.send(.init(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: command.callbackId)
        }
    }

    @objc func deviceReady(_ command: CDVInvokedUrlCommand) {
        do {
            let (credentials, logLevel, distributionVersion, sanitizeLogMessages) = try Self.resolveConfiguration(from: command)
            ApptentiveLogger.logLevel = logLevel
            ApptentiveLogger.shouldHideSensitiveLogs = sanitizeLogMessages
            Apptentive.shared.distributionVersion = distributionVersion
            Apptentive.shared.distributionName = "Cordova"
            Apptentive.shared.register(with: credentials) { result in
                switch result {
                case .success:
                    self.commandDelegate.send(.init(status: CDVCommandStatus_OK, messageAs: "Apptentive SDK registered successfully."), callbackId: command.callbackId)

                case .failure(let error):
                    self.commandDelegate.send(.init(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: command.callbackId)
                }
            }
        } catch let error {
            self.commandDelegate.send(.init(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: command.callbackId)
        }
    }

    @objc func engage(_ command: CDVInvokedUrlCommand) {
        do {
            var event = Event(name: try Self.string(from: command, range: 1...2))

            if let customData = try Self.maybeCustomData(from: command, precedingArgumentCount: 1) {
                event.customData = customData
            }

            Apptentive.shared.engage(event: event) { result in
                switch result {
                case .success(let didShowInteraction):
                    self.commandDelegate.send(.init(status: CDVCommandStatus_OK, messageAs: didShowInteraction), callbackId: command.callbackId)

                case .failure(let error):
                    self.commandDelegate.send(.init(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: command.callbackId)
                }
            }
        } catch let error {
            self.commandDelegate.send(.init(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: command.callbackId)
        }
    }

    @objc func getUnreadMessageCount(_ command: CDVInvokedUrlCommand) {
        let result = Apptentive.shared.unreadMessageCount
        return self.commandDelegate.send(.init(status: CDVCommandStatus_OK, messageAs: result), callbackId: command.callbackId)
    }

    @objc func putRatingProviderArg(_ command: CDVInvokedUrlCommand) {
        self.sendUnimplementedError(command)
    }

    @objc func removeCustomDeviceData(_ command: CDVInvokedUrlCommand) {
        do {
            Apptentive.shared.deviceCustomData[try Self.string(from: command)] = nil
            self.commandDelegate.send(.init(status: CDVCommandStatus_OK), callbackId: command.callbackId)
        } catch let error {
            self.commandDelegate.send(.init(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: command.callbackId)
        }
    }

    @objc func removeCustomPersonData(_ command: CDVInvokedUrlCommand) {
        do {
            Apptentive.shared.personCustomData[try Self.string(from: command)] = nil
            self.commandDelegate.send(.init(status: CDVCommandStatus_OK), callbackId: command.callbackId)
        } catch let error {
            self.commandDelegate.send(.init(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: command.callbackId)
        }
    }

    @objc func getPersonEmail(_ command: CDVInvokedUrlCommand) {
        let result = Apptentive.shared.personEmailAddress
        return self.commandDelegate.send(.init(status: CDVCommandStatus_OK, messageAs: result), callbackId: command.callbackId)
    }

    @objc func setPersonEmail(_ command: CDVInvokedUrlCommand) {
        do {
            Apptentive.shared.personEmailAddress = try Self.string(from: command)
            return self.commandDelegate.send(.init(status: CDVCommandStatus_OK), callbackId: command.callbackId)
        } catch let error {
            self.commandDelegate.send(.init(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: command.callbackId)
        }
    }

    @objc func getPersonName(_ command: CDVInvokedUrlCommand) {
        let result = Apptentive.shared.personName
        return self.commandDelegate.send(.init(status: CDVCommandStatus_OK, messageAs: result), callbackId: command.callbackId)
    }

    @objc func setPersonName(_ command: CDVInvokedUrlCommand) {
        do {
            Apptentive.shared.personName = try Self.string(from: command)
            return self.commandDelegate.send(.init(status: CDVCommandStatus_OK), callbackId: command.callbackId)
        } catch let error {
            self.commandDelegate.send(.init(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: command.callbackId)
        }
    }

    @objc func addUnreadMessagesListener(_ command: CDVInvokedUrlCommand) {
        do {
            let _ = try Self.checkArgumentCount(command, 0...0)
            self.observation = Apptentive.shared.observe(\.unreadMessageCount, options: [.new]) { [weak self] _, _ in
                guard let self = self else { return }
                let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: Apptentive.shared.unreadMessageCount)
                result?.setKeepCallbackAs(true)
                self.commandDelegate.send(result, callbackId: command.callbackId)
            }
        } catch let error {
            self.commandDelegate.send(.init(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: command.callbackId)
        }
    }

    @objc func setOnSurveyFinishedListener(_ command: CDVInvokedUrlCommand) {
        do {
            let _ = try Self.checkArgumentCount(command, 0...0)
            NotificationCenter.default.addObserver(forName: .apptentiveEventEngaged, object: nil, queue: nil) { [weak self] (notification) in
                if notification.userInfo?["eventType"] as? String == "submit" && notification.userInfo?["interactionType"] as? String == "Survey" {
                    let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: Apptentive.shared.unreadMessageCount)
                    result?.setKeepCallbackAs(true)
                    self?.commandDelegate.send(result, callbackId: command.callbackId)
                }
            }
        } catch let error {
            self.commandDelegate.send(.init(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: command.callbackId)
        }
    }

    @objc func showMessageCenter(_ command: CDVInvokedUrlCommand) {
        do {
            let customData = try Self.maybeCustomData(from: command)
            Apptentive.shared.presentMessageCenter(from: self.viewController, with: customData) { result in
                switch result {
                case .success(let didShow):
                    self.commandDelegate.send(.init(status: CDVCommandStatus_OK, messageAs: didShow), callbackId: command.callbackId)

                case .failure(let error):
                    self.commandDelegate.send(.init(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: command.callbackId)
                }
            }
        } catch let error {
            self.commandDelegate.send(.init(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: command.callbackId)
        }
    }

    @objc func canShowMessageCenter(_ command: CDVInvokedUrlCommand) {
        do {
            let _ = try Self.checkArgumentCount(command, 0...0)
            Apptentive.shared.canShowMessageCenter { result in
                switch result {
                case .success(let canShow):
                    self.commandDelegate.send(.init(status: CDVCommandStatus_OK, messageAs: canShow), callbackId: command.callbackId)

                case .failure(let error):
                    self.commandDelegate.send(.init(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: command.callbackId)
                }
            }
        } catch let error {
            self.commandDelegate.send(.init(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: command.callbackId)
        }
    }

    @objc func canShowInteraction(_ command: CDVInvokedUrlCommand) {
        do {
            Apptentive.shared.canShowInteraction(event: Event(name: try Self.string(from: command))) { result in
                switch result {
                case .success(let canShow):
                    self.commandDelegate.send(.init(status: CDVCommandStatus_OK, messageAs: canShow), callbackId: command.callbackId)

                case .failure(let error):
                    self.commandDelegate.send(.init(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: command.callbackId)
                }
            }
        } catch let error {
            self.commandDelegate.send(.init(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: command.callbackId)
        }
    }

    @objc func sendAttachmentText(_ command: CDVInvokedUrlCommand) {
        do {
            let _ = try Self.checkArgumentCount(command, 1...1)
            Apptentive.shared.sendAttachment(try Self.string(from: command))
            self.commandDelegate.send(.init(status: CDVCommandStatus_OK), callbackId: command.callbackId)
        } catch let error {
            self.commandDelegate.send(.init(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: command.callbackId)
        }
    }

    // MARK: - Helper functions

    func sendUnimplementedError(_ command: CDVInvokedUrlCommand) {
        self.commandDelegate.send(.init(status: CDVCommandStatus_ERROR, messageAs: PluginError.unimplementedCommand(command.methodName).localizedDescription), callbackId: command.callbackId)
    }

    static func checkArgumentCount(_ command: CDVInvokedUrlCommand, _ range: ClosedRange<Int>) throws -> [Any] {
        guard range.contains(command.arguments.count) else {
            throw PluginError.incorrectArgumentCount(function: command.methodName, expecting: range, received: command.arguments.count)
        }

        return command.arguments
    }

    static func resolveConfiguration(from command: CDVInvokedUrlCommand) throws -> (Apptentive.AppCredentials, LogLevel, String, Bool) {
        let functionArguments = try self.checkArgumentCount(command, 2...2)

        guard let apptentiveKey = Bundle.main.object(forInfoDictionaryKey: "ApptentiveKey") as? String,
              let apptentiveSignature = Bundle.main.object(forInfoDictionaryKey: "ApptentiveSignature") as? String
        else {
            throw PluginError.missingVariablesInInfoDictionary
        }

        let sanitizeLogMessagesString = Bundle.main.object(forInfoDictionaryKey: "ApptentiveSanitizeLogMessages") as? String ?? "true"
        let sanitizeLogMessages = sanitizeLogMessagesString.lowercased() != "false"

        let logLevel = try self.parseLogLevel(functionArguments[1])
        guard let distributionVersion = functionArguments.first as? String else {
            throw PluginError.invalidArgumentType(atIndex: 0, expecting: "String")
        }

        return (.init(key: apptentiveKey, signature: apptentiveSignature), logLevel, distributionVersion, sanitizeLogMessages)
    }

    static func parseLogLevel(_ logLevel: Any) throws -> LogLevel {
        switch (logLevel as? String)?.lowercased() {
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
        case .some(let logLevelString):
            throw PluginError.unrecognizedLogLevel(logLevelString)
        default:
            throw PluginError.invalidArgumentType(atIndex: 1, expecting: "String")
        }
    }

    static func string(from command: CDVInvokedUrlCommand, range: ClosedRange<Int> = 1...1) throws -> String {
        let functionArguments = try checkArgumentCount(command, range)

        guard let string = functionArguments[0] as? String else {
            throw PluginError.invalidArgumentType(atIndex: 0, expecting: "String")
        }

        return string
    }

    static func customDataPair(from command: CDVInvokedUrlCommand) throws -> (String, CustomDataCompatible) {
        let functionArguments = try checkArgumentCount(command, 2...2)

        guard let key = functionArguments[0] as? String else {
            throw PluginError.invalidCustomDataKeyType
        }

        let value = try self.convertCustomDataValue(functionArguments[1])

        return (key, value)
    }

    static func maybeCustomData(from command: CDVInvokedUrlCommand, precedingArgumentCount: Int = 0) throws -> CustomData? {
        let functionArguments = try self.checkArgumentCount(command, precedingArgumentCount...(precedingArgumentCount + 1))

        guard functionArguments.count == precedingArgumentCount + 1 else {
            return nil
        }

        if let customDataDictionary = functionArguments[precedingArgumentCount] as? [AnyHashable: Any] {
            return try self.convertCustomData(customDataDictionary)
        } else if let jsonString = functionArguments[precedingArgumentCount] as? String {
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
