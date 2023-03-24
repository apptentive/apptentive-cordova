package com.apptentive.cordova

import android.content.Context
import android.content.pm.PackageManager
import apptentive.com.android.util.Log
import apptentive.com.android.util.LogTag

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
      android.util.Log.d("Apptentive", "Unexpected error while reading application or package info.")
    }
    return null
  }
}