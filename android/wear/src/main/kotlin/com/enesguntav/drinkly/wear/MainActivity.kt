package com.enesguntav.drinkly.wear

import android.app.Activity
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.widget.Button
import android.widget.ProgressBar
import android.widget.TextView
import com.google.android.gms.wearable.DataClient
import com.google.android.gms.wearable.DataEvent
import com.google.android.gms.wearable.DataEventBuffer
import com.google.android.gms.wearable.DataMapItem
import com.google.android.gms.wearable.Wearable

class MainActivity : Activity(), DataClient.OnDataChangedListener {
  private lateinit var totalText: TextView
  private lateinit var percentText: TextView
  private lateinit var progress: ProgressBar
  private val handler = Handler(Looper.getMainLooper())
  private var total = 0
  private var goal = 2500
  private var queuedAmount = 0
  private var currentDay: String? = null
  private val flush = Runnable { flushQueuedWater() }

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_main)
    totalText = findViewById(R.id.total)
    percentText = findViewById(R.id.percent)
    progress = findViewById(R.id.progress)
    findViewById<Button>(R.id.add250).setOnClickListener { addWater(250) }
    findViewById<Button>(R.id.add500).setOnClickListener { addWater(500) }
    render()
  }

  override fun onResume() {
    super.onResume()
    Wearable.getDataClient(this).addListener(this)
    requestState()
  }

  override fun onPause() {
    Wearable.getDataClient(this).removeListener(this)
    handler.removeCallbacks(flush)
    if (queuedAmount > 0) flushQueuedWater()
    super.onPause()
  }

  private fun addWater(amount: Int) {
    total += amount
    queuedAmount += amount
    render()
    handler.removeCallbacks(flush)
    handler.postDelayed(flush, 180)
  }

  private fun flushQueuedWater() {
    val amount = queuedAmount
    if (amount <= 0) return
    queuedAmount = 0
    Wearable.getNodeClient(this).connectedNodes.addOnSuccessListener { nodes ->
      if (nodes.isEmpty()) {
        queuedAmount += amount
        return@addOnSuccessListener
      }
      nodes.forEach { node ->
        Wearable.getMessageClient(this).sendMessage(node.id, "/drinkly/add", amount.toString().toByteArray())
          .addOnFailureListener { queuedAmount += amount }
      }
    }.addOnFailureListener { queuedAmount += amount }
  }

  private fun requestState() {
    Wearable.getNodeClient(this).connectedNodes.addOnSuccessListener { nodes ->
      nodes.forEach { Wearable.getMessageClient(this).sendMessage(it.id, "/drinkly/request_state", byteArrayOf()) }
    }
  }

  override fun onDataChanged(events: DataEventBuffer) {
    events.forEach { event ->
      if (event.type == DataEvent.TYPE_CHANGED && event.dataItem.uri.path == "/drinkly/state") {
        val data = DataMapItem.fromDataItem(event.dataItem).dataMap
        val day = data.getString("totalDay")
        val confirmed = data.getInt("todayTotal")
        if (currentDay != null && day != currentDay) {
          total = confirmed
          queuedAmount = 0
        } else {
          total = maxOf(total, confirmed + queuedAmount)
        }
        currentDay = day
        goal = data.getInt("dailyGoal", 2500).coerceAtLeast(1)
        runOnUiThread { render() }
      }
    }
  }

  private fun render() {
    val value = (total * 100 / goal.coerceAtLeast(1)).coerceIn(0, 100)
    totalText.text = "$total / $goal ml"
    percentText.text = "$value%"
    progress.progress = value
  }
}
