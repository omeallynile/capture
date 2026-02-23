import WidgetKit
import SwiftUI
import AppIntents

struct CaptureProvider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = SimpleEntry(date: Date())
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct CaptureWidgetEntryView : View {
    var entry: CaptureProvider.Entry

    var body: some View {
        HStack {
            // Combo Capture (Main)
            Button(intent: StartComboCaptureIntent()) {
                VStack {
                    Image(systemName: "camera.shutter.button")
                        .font(.title)
                    Text("Capture")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.red.opacity(0.1))
                .clipShape(ContainerRelativeShape())
            }
            .buttonStyle(.plain)

            VStack {
                // Audio Only
                Button(intent: StartComboCaptureIntent()) { // Ideally parameterized, but for POC just reuse
                    Image(systemName: "mic.fill")
                        .font(.title2)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(ContainerRelativeShape())
                }
                .buttonStyle(.plain)

                // Photo Only
                Button(intent: StartComboCaptureIntent()) {
                    Image(systemName: "camera.fill")
                        .font(.title2)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.green.opacity(0.1))
                        .clipShape(ContainerRelativeShape())
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
    }
}

// @main // Uncomment this if this file is the entry point for the Widget Extension
struct CaptureWidget: Widget {
    let kind: String = "CaptureWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CaptureProvider()) { entry in
            CaptureWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Quick Capture")
        .description("Instantly capture moments.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
