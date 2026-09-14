package com.enesguntav.drinkly

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.app.PendingIntent
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONArray
import org.json.JSONObject
import java.time.Instant

class DrinklyWidgetProvider : HomeWidgetProvider() {
  companion object {
    private const val ACTION_ADD_WATER = "com.enesguntav.drinkly.ADD_WATER"
    private const val EXTRA_AMOUNT = "amount"
  }

  override fun onReceive(context: Context, intent: Intent) {
    if (intent.action == ACTION_ADD_WATER) {
      val amount = intent.getIntExtra(EXTRA_AMOUNT, 0)
      if (amount > 0) {
        val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
        val today = java.time.LocalDate.now().toString()
        val total = if (prefs.getString("totalDay", null) == today) {
          prefs.getInt("todayTotal", 0)
        } else 0
        prefs.edit().putInt("todayTotal", total + amount).putString("totalDay", today).apply()
        appendPendingAction(prefs, amount)
        DrinklyWearSync.publishState(context, prefs)
      }
      AppWidgetManager.getInstance(context).notifyAppWidgetViewDataChanged(
          AppWidgetManager.getInstance(context).getAppWidgetIds(
              android.content.ComponentName(context, DrinklyWidgetProvider::class.java)),
          R.id.widget_total)
      onUpdate(
          context,
          AppWidgetManager.getInstance(context),
          AppWidgetManager.getInstance(context).getAppWidgetIds(
              android.content.ComponentName(context, DrinklyWidgetProvider::class.java)),
          context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE))
      return
    }
    if (intent.action == Intent.ACTION_DATE_CHANGED ||
        intent.action == Intent.ACTION_TIME_CHANGED ||
        intent.action == Intent.ACTION_TIMEZONE_CHANGED) {
      val manager = AppWidgetManager.getInstance(context)
      val ids = manager.getAppWidgetIds(
          android.content.ComponentName(context, DrinklyWidgetProvider::class.java))
      onUpdate(
          context,
          manager,
          ids,
          context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE))
      return
    }
    super.onReceive(context, intent)
  }

  private fun appendPendingAction(prefs: SharedPreferences, amount: Int) {
    val actions = try {
      JSONArray(prefs.getString("pendingActions", "[]"))
    } catch (_: Exception) {
      JSONArray()
    }
    actions.put(JSONObject().apply {
      put("id", java.util.UUID.randomUUID().toString())
      put("amount", amount)
      put("timestamp", Instant.now().toString())
    })
    prefs.edit().putString("pendingActions", actions.toString()).commit()
  }

  override fun onUpdate(
      context: Context,
      appWidgetManager: AppWidgetManager,
      appWidgetIds: IntArray,
      widgetData: SharedPreferences,
  ) {
    val today = java.time.LocalDate.now().toString()
    val total = if (widgetData.getString("totalDay", null) == today) {
      widgetData.getInt("todayTotal", 0)
    } else 0
    val goal = widgetData.getInt("dailyGoal", 2500).coerceAtLeast(1)
    DrinklyWearSync.publishState(context, widgetData)
    appWidgetIds.forEach { id ->
      val views = RemoteViews(context.packageName, R.layout.drinkly_widget).apply {
        setTextViewText(R.id.widget_total, "$total ml")
        setTextViewText(R.id.widget_goal, "of $goal ml today")
        val progress = (total * 100 / goal).coerceIn(0, 100)
        setTextViewText(R.id.widget_percent, "$progress%")
        setProgressBar(R.id.widget_progress, 100, progress, false)
        setOnClickPendingIntent(
            R.id.widget_container,
            HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java),
        )
        setOnClickPendingIntent(R.id.widget_add_250, addWaterIntent(context, 250))
        setOnClickPendingIntent(R.id.widget_add_500, addWaterIntent(context, 500))
      }
      appWidgetManager.updateAppWidget(id, views)
    }
  }

  private fun addWaterIntent(context: Context, amount: Int): PendingIntent {
    val intent = Intent(context, DrinklyWidgetProvider::class.java).apply {
      action = ACTION_ADD_WATER
      putExtra(EXTRA_AMOUNT, amount)
    }
    return PendingIntent.getBroadcast(
        context,
        amount,
        intent,
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
    )
  }
}
