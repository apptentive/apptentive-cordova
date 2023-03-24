package com.apptentive.cordova

import org.json.JSONArray
import org.json.JSONObject

object JsonHelper {
  fun toMap(obj: JSONObject): Map<String, Any?>? {
    val map = mutableMapOf<String, Any?>()
    val keys = obj.keys()
    if (!keys.hasNext()) return null
    else while (keys.hasNext()) {
      val key = keys.next() as String
      map[key] = fromJson(obj.get(key))
    }
    return map
  }

  private fun toList(array: JSONArray): List<*> {
    val list = mutableListOf<Any?>()
    for (i in 0 until array.length()) {
      list.add(fromJson(array.get(i)))
    }
    return list
  }

  private fun fromJson(json: Any): Any? {
    return when {
      json === JSONObject.NULL -> null
      json is JSONObject -> toMap(json)
      json is JSONArray -> toList(json)
      else -> json
    }
  }
}