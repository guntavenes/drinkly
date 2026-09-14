package com.enesguntav.drinkly

import android.content.Context
import android.content.SharedPreferences
import com.google.android.gms.wearable.PutDataMapRequest
import com.google.android.gms.wearable.Wearable
import java.time.LocalDate

object DrinklyWearSync {
  const val STATE_PATH = "/drinkly/state"

  fun publishState(context: Context, prefs: SharedPreferences) {
    val today = LocalDate.now().toString()
    val total = if (prefs.getString("totalDay", null) == today) prefs.getInt("todayTotal", 0) else 0
    val request = PutDataMapRequest.create(STATE_PATH).apply {
      dataMap.putInt("todayTotal", total)
      dataMap.putInt("dailyGoal", prefs.getInt("dailyGoal", 2500).coerceAtLeast(1))
      dataMap.putString("totalDay", today)
      dataMap.putLong("updatedAt", System.currentTimeMillis())
    }.asPutDataRequest().setUrgent()
    Wearable.getDataClient(context).putDataItem(request)
  }
}
