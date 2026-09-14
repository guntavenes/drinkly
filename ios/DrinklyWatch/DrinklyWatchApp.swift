import SwiftUI
import WatchConnectivity

@main
struct DrinklyWatchApp: App {
  @StateObject private var hydration = WatchHydrationStore()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(hydration)
    }
  }
}

@MainActor
final class WatchHydrationStore: NSObject, ObservableObject, WCSessionDelegate {
  @Published var total: Int
  @Published var goal: Int
  @Published var isConnected = false
  private var queuedAmount = 0
  private var requestInFlight = false
  private var currentDay: String?

  private let defaults = UserDefaults.standard

  private var progress: Double {
    min(Double(total) / Double(max(goal, 1)), 1)
  }

  override init() {
    total = UserDefaults.standard.integer(forKey: "todayTotal")
    goal = max(UserDefaults.standard.integer(forKey: "dailyGoal"), 2500)
    super.init()
    if WCSession.isSupported() {
      WCSession.default.delegate = self
      WCSession.default.activate()
    }
  }

  func refresh() {
    send(["action": "state"])
  }

  func add(_ amount: Int) {
    total += amount
    save()
    queuedAmount += amount
    flushQueue()
  }

  private func flushQueue() {
    guard !requestInFlight, queuedAmount > 0 else { return }
    let amount = queuedAmount
    queuedAmount = 0
    requestInFlight = true
    send(["action": "addWater", "amount": amount])
  }

  private func send(_ message: [String: Any]) {
    let session = WCSession.default
    guard session.activationState == .activated else {
      requestInFlight = false
      isConnected = false
      return
    }
    guard session.isReachable else {
      if message["action"] as? String == "addWater" {
        session.transferUserInfo(message)
      }
      requestInFlight = false
      isConnected = false
      return
    }
    isConnected = true
    session.sendMessage(message, replyHandler: { [weak self] reply in
      Task { @MainActor in
        self?.apply(reply)
        self?.requestInFlight = false
        self?.flushQueue()
      }
    }, errorHandler: { [weak self] _ in
      Task { @MainActor in
        self?.isConnected = false
        self?.requestInFlight = false
        self?.queuedAmount += (message["amount"] as? Int ?? 0)
        self?.flushQueue()
      }
    })
  }

  private func apply(_ state: [String: Any]) {
    let confirmedTotal = state["todayTotal"] as? Int ?? total
    let serverDay = state["totalDay"] as? String
    if let serverDay, currentDay != nil, serverDay != currentDay {
      total = confirmedTotal
      queuedAmount = 0
    } else {
      // Replies can arrive out of order; never let an older reply lower the UI.
      total = max(total, confirmedTotal + queuedAmount)
    }
    currentDay = serverDay ?? currentDay
    goal = max(state["dailyGoal"] as? Int ?? goal, 1)
    save()
    isConnected = true
  }

  private func save() {
    defaults.set(total, forKey: "todayTotal")
    defaults.set(goal, forKey: "dailyGoal")
  }

  nonisolated func session(
    _ session: WCSession,
    activationDidCompleteWith activationState: WCSessionActivationState,
    error: Error?
  ) {
    Task { @MainActor in
      self.isConnected = activationState == .activated
      self.refresh()
    }
  }

  nonisolated func session(
    _ session: WCSession,
    didReceiveApplicationContext applicationContext: [String: Any]
  ) {
    Task { @MainActor in self.apply(applicationContext) }
  }
}

private struct ContentView: View {
  @EnvironmentObject private var hydration: WatchHydrationStore

  private var progress: Double {
    min(Double(hydration.total) / Double(max(hydration.goal, 1)), 1)
  }

  var body: some View {
    ScrollView {
      VStack(spacing: 10) {
        ZStack {
          Circle().stroke(.white.opacity(0.16), lineWidth: 9)
          Circle()
            .trim(from: 0, to: progress)
            .stroke(
              LinearGradient(colors: [.pink, .orange], startPoint: .topLeading, endPoint: .bottomTrailing),
              style: StrokeStyle(lineWidth: 9, lineCap: .round)
            )
            .rotationEffect(.degrees(-90))
          VStack(spacing: 1) {
            Image(systemName: "drop.fill").foregroundStyle(.orange)
            Text("\(Int(progress * 100))%").font(.headline.bold())
          }
        }
        .frame(width: 96, height: 96)

        Text("\(hydration.total) / \(hydration.goal) ml")
          .font(.caption.weight(.semibold))
          .foregroundStyle(.secondary)

        HStack(spacing: 8) {
          addButton(250)
          addButton(500)
        }

        Button {
          hydration.refresh()
        } label: {
          Label("Refresh", systemImage: "arrow.clockwise")
        }
        .font(.caption)
        .buttonStyle(.plain)
        .foregroundStyle(.secondary)
      }
      .padding(.horizontal, 6)
    }
    .navigationTitle("Drinkly")
    .onAppear { hydration.refresh() }
  }

  private func addButton(_ amount: Int) -> some View {
    Button("+\(amount)") { hydration.add(amount) }
      .buttonStyle(.borderedProminent)
      .tint(amount == 250 ? .pink : .orange)
  }
}
