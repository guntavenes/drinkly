import AppIntents
import SwiftUI
import WidgetKit

private let appGroupId = "group.com.enesguntav.drinkly"
private let widgetKind = "DrinklyWidget"

private struct HydrationEntry: TimelineEntry {
    let date: Date
    let total: Int
    let goal: Int
    let theme: String

    var progress: Double {
        guard goal > 0 else { return 0 }
        return min(Double(total) / Double(goal), 1)
    }
}

private struct HydrationProvider: TimelineProvider {
    func placeholder(in context: Context) -> HydrationEntry {
        HydrationEntry(date: .now, total: 1450, goal: 2500, theme: "ocean")
    }

    func getSnapshot(in context: Context, completion: @escaping (HydrationEntry) -> Void) {
        completion(readEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<HydrationEntry>) -> Void) {
        let entry = readEntry()
        let nextMidnight = Calendar.current.nextDate(
            after: .now,
            matching: DateComponents(hour: 0, minute: 0),
            matchingPolicy: .nextTime
        ) ?? .now.addingTimeInterval(3600)
        completion(Timeline(entries: [entry], policy: .after(nextMidnight)))
    }

    private func readEntry() -> HydrationEntry {
        let defaults = UserDefaults(suiteName: appGroupId)
        return HydrationEntry(
            date: .now,
            total: defaults?.integer(forKey: "todayTotal") ?? 0,
            goal: max(defaults?.integer(forKey: "dailyGoal") ?? 2500, 1),
            theme: defaults?.string(forKey: "themeStyle") ?? "ocean"
        )
    }
}

struct AddWaterIntent: AppIntent {
    static var title: LocalizedStringResource = "Add water"
    static var description = IntentDescription("Adds water to today's Drinkly total.")

    @Parameter(title: "Amount")
    var amount: Int

    init() {
        amount = 250
    }

    init(amount: Int) {
        self.amount = amount
    }

    func perform() async throws -> some IntentResult {
        guard let defaults = UserDefaults(suiteName: appGroupId), amount > 0 else {
            return .result()
        }

        let currentTotal = defaults.integer(forKey: "todayTotal")
        defaults.set(currentTotal + amount, forKey: "todayTotal")

        var actions: [[String: Any]] = []
        if let raw = defaults.string(forKey: "pendingActions"),
           let data = raw.data(using: .utf8),
           let existing = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
            actions = existing
        }

        actions.append([
            "amount": amount,
            "timestamp": ISO8601DateFormatter().string(from: .now)
        ])

        if let data = try? JSONSerialization.data(withJSONObject: actions),
           let raw = String(data: data, encoding: .utf8) {
            defaults.set(raw, forKey: "pendingActions")
        }

        WidgetCenter.shared.reloadTimelines(ofKind: widgetKind)
        return .result()
    }
}

private struct DrinklyWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: HydrationEntry

    private var colors: [Color] {
        switch entry.theme {
        case "aurora": return [Color(red: 0.41, green: 0.28, blue: 0.91), Color(red: 0.20, green: 0.75, blue: 0.66)]
        case "sunset": return [Color(red: 1.0, green: 0.37, blue: 0.43), Color(red: 1.0, green: 0.66, blue: 0.30)]
        case "midnight": return [Color(red: 0.15, green: 0.21, blue: 0.37), Color(red: 0.32, green: 0.44, blue: 0.69)]
        default: return [Color(red: 0.07, green: 0.41, blue: 0.95), Color(red: 0.29, green: 0.69, blue: 1.0)]
        }
    }

    var body: some View {
        Group {
            switch family {
            case .accessoryCircular:
                circularLockScreen
            case .accessoryRectangular:
                rectangularLockScreen
            case .systemMedium:
                mediumWidget
            default:
                smallWidget
            }
        }
        .widgetURL(URL(string: "drinkly://home"))
        .containerBackground(for: .widget) {
            LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }

    private var smallWidget: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "drop.fill")
                Text("DRINKLY").font(.caption2.weight(.bold)).tracking(1)
                Spacer()
                Text("\(Int(entry.progress * 100))%").font(.caption.weight(.bold))
            }

            Spacer()
            Text("\(entry.total)")
                .font(.system(size: 31, weight: .black, design: .rounded))
            Text("of \(entry.goal) ml")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.78))

            Button(intent: AddWaterIntent(amount: 250)) {
                Label("Add 250 ml", systemImage: "plus")
                    .frame(maxWidth: .infinity)
                    .font(.caption.weight(.bold))
            }
            .buttonStyle(.borderedProminent)
            .tint(.white.opacity(0.22))
        }
        .foregroundStyle(.white)
    }

    private var mediumWidget: some View {
        HStack(spacing: 18) {
            ZStack {
                Circle().stroke(.white.opacity(0.18), lineWidth: 9)
                Circle()
                    .trim(from: 0, to: entry.progress)
                    .stroke(.white, style: StrokeStyle(lineWidth: 9, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                VStack(spacing: 1) {
                    Text("\(Int(entry.progress * 100))%")
                        .font(.title3.weight(.black))
                    Text("TODAY").font(.system(size: 8, weight: .bold)).tracking(1)
                }
            }
            .frame(width: 94, height: 94)

            VStack(alignment: .leading, spacing: 8) {
                Label("Your hydration", systemImage: "drop.fill")
                    .font(.headline.weight(.bold))
                Text("\(entry.total) of \(entry.goal) ml")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.8))
                HStack(spacing: 8) {
                    quickButton(250)
                    quickButton(500)
                }
            }
        }
        .foregroundStyle(.white)
    }

    private func quickButton(_ amount: Int) -> some View {
        Button(intent: AddWaterIntent(amount: amount)) {
            Text("+\(amount)")
                .font(.caption.weight(.bold))
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(.white.opacity(0.22))
    }

    private var circularLockScreen: some View {
        Gauge(value: entry.progress) {
            Image(systemName: "drop.fill")
        } currentValueLabel: {
            Text("\(Int(entry.progress * 100))")
        }
        .gaugeStyle(.accessoryCircularCapacity)
    }

    private var rectangularLockScreen: some View {
        VStack(alignment: .leading, spacing: 3) {
            Label("Drinkly", systemImage: "drop.fill").font(.headline)
            Text("\(entry.total) / \(entry.goal) ml · \(Int(entry.progress * 100))%")
                .font(.caption)
            ProgressView(value: entry.progress)
        }
    }
}

@main
struct DrinklyWidget: Widget {
    let kind = widgetKind

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HydrationProvider()) { entry in
            DrinklyWidgetView(entry: entry)
        }
        .configurationDisplayName("Drinkly Hydration")
        .description("See your progress and quickly log water.")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .accessoryCircular,
            .accessoryRectangular
        ])
    }
}
