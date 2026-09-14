package com.enesguntav.drinkly

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import com.google.android.gms.wearable.MessageEvent
import com.google.android.gms.wearable.WearableListenerService
import org.json.JSONArray
import org.json.JSONObject
import java.time.Instant
import java.time.LocalDate
import java.util.UUID

class DrinklyWearListenerService : WearableListenerService() {
  override fun onMessageReceived(event: MessageEvent) {
    val prefs = getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
    when (event.path) {
      "/drinkly/add" -> {
        val amount = event.data.toString(Charsets.UTF_8).toIntOrNull() ?: return
        if (amount <= 0) return
        synchronized(DrinklyWearSync) {
          val today = LocalDate.now().toString()
          val total = if (prefs.getString("totalDay", null) == today) prefs.getInt("todayTotal", 0) else 0
          val actions = try { JSONArray(prefs.getString("pendingActions", "[]")) } catch (_: Exception) { JSONArray() }
          actions.put(JSONObject().apply {
            put("id", UUID.randomUUID().toString())
            put("amount", amount)
            put("timestamp", Instant.now().toString())
          })
          prefs.edit().putInt("todayTotal", total + amount).putString("totalDay", today)
            .putString("pendingActions", actions.toString()).commit()
        }
        refreshWidget(prefs)
      }
      "/drinkly/request_state" -> DrinklyWearSync.publishState(this, prefs)
    }
  }

  private fun refreshWidget(prefs: android.content.SharedPreferences) {
    val manager = AppWidgetManager.getInstance(this)
    val ids = manager.getAppWidgetIds(ComponentName(this, DrinklyWidgetProvider::class.java))
    DrinklyWidgetProvider().onUpdate(this, manager, ids, prefs)
    DrinklyWearSync.publishState(this, prefs)
  }
}
