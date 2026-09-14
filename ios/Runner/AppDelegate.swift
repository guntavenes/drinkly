import Flutter
import UIKit
import WatchConnectivity
import WidgetKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate, WCSessionDelegate {
  private let appGroupId = "group.com.enesguntav.drinkly"
  private let hydrationQueue = DispatchQueue(label: "com.enesguntav.drinkly.watch-hydration")

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if WCSession.isSupported() {
      WCSession.default.delegate = self
      WCSession.default.activate()
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  func session(
    _ session: WCSession,
    activationDidCompleteWith activationState: WCSessionActivationState,
    error: Error?
  ) {
    guard activationState == .activated else { return }
    pushStateToWatch()
  }

  func sessionDidBecomeInactive(_ session: WCSession) {}
  func sessionDidDeactivate(_ session: WCSession) { session.activate() }

  func session(
    _ session: WCSession,
    didReceiveMessage message: [String: Any],
    replyHandler: @escaping ([String: Any]) -> Void
  ) {
    guard message["action"] as? String == "addWater", let amount = message["amount"] as? Int, amount > 0 else {
      replyHandler(currentHydrationState())
      return
    }
    hydrationQueue.async { [weak self] in
      guard let self else { return }
      self.addWater(amount)
      replyHandler(self.currentHydrationState())
    }
  }

  func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
    if userInfo["action"] as? String == "addWater",
       let amount = userInfo["amount"] as? Int,
       amount > 0 {
      hydrationQueue.async { [weak self] in self?.addWater(amount) }
    }
  }

  private func currentHydrationState() -> [String: Any] {
    let defaults = UserDefaults(suiteName: appGroupId)
    let formatter = DateFormatter()
    formatter.calendar = .current
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd"
    let today = formatter.string(from: Date())
    let total = defaults?.string(forKey: "totalDay") == today
      ? defaults?.integer(forKey: "todayTotal") ?? 0
      : 0
    return [
      "todayTotal": total,
      "dailyGoal": max(defaults?.integer(forKey: "dailyGoal") ?? 2500, 1),
      "totalDay": today,
      "themeStyle": defaults?.string(forKey: "themeStyle") ?? "ocean"
    ]
  }

  private func addWater(_ amount: Int) {
    guard let defaults = UserDefaults(suiteName: appGroupId) else { return }
    let state = currentHydrationState()
    let total = state["todayTotal"] as? Int ?? 0
    let today = state["totalDay"] as? String ?? ""
    defaults.set(total + amount, forKey: "todayTotal")
    defaults.set(today, forKey: "totalDay")

    var actions: [[String: Any]] = []
    if let raw = defaults.string(forKey: "pendingActions"),
       let data = raw.data(using: .utf8),
       let existing = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
      actions = existing
    }
    actions.append([
      "amount": amount,
      "timestamp": ISO8601DateFormatter().string(from: Date())
    ])
    if let data = try? JSONSerialization.data(withJSONObject: actions),
       let raw = String(data: data, encoding: .utf8) {
      defaults.set(raw, forKey: "pendingActions")
    }
    WidgetCenter.shared.reloadAllTimelines()
    pushStateToWatch()
  }

  private func pushStateToWatch() {
    guard WCSession.default.activationState == .activated else { return }
    try? WCSession.default.updateApplicationContext(currentHydrationState())
  }
}
