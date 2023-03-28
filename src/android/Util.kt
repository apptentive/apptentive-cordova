package com.apptentive.cordova

import android.content.Context
import android.content.pm.PackageManager

object Util {
  /**
   * Helper method for resolving manifest metadata [String] value
   */
  fun getManifestMetadataString(context: Context, key: String): String? {
    try {
      val appPackageName = context.packageName
      val packageManager = context.packageManager
      val packageInfo = packageManager.getPackageInfo(
        appPackageName,
        PackageManager.GET_META_DATA or PackageManager.GET_RECEIVERS
      )
      val metaData = packageInfo.applicationInfo.metaData

      return metaData?.getString(key)?.trim()
    } catch (e: Exception) {
      android.util.Log.e("Apptentive", "[CORDOVA] Unexpected error while reading application or package info.")
    }
    return null
  }

  /**
   * Helper method for resolving manifest metadata [Boolean] value
   */
  fun getManifestMetadataBoolean(context: Context, key: String, default: Boolean): Boolean {
    try {
      val appPackageName = context.packageName
      val packageManager = context.packageManager
      val packageInfo = packageManager.getPackageInfo(
        appPackageName,
        PackageManager.GET_META_DATA or PackageManager.GET_RECEIVERS
      )
      val metaData = packageInfo.applicationInfo.metaData
      return metaData?.getBoolean(key) == true
    } catch (e: Exception) {
      android.util.Log.e("Apptentive", "[CORDOVA] Unexpected error while reading application or package info.", e)
    }
    return default
  }
}