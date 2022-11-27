//
//  QuizListComplication.swift
//  QuizListComplication
//
//  Created by Alexander von Below on 26.11.22.
//  Copyright © 2022 None. All rights reserved.
//
// Mystery Soda! Image by Toby Oxborrow, CCbySA
// https://flic.kr/p/5rRy6t

import WidgetKit
import SwiftUI
import Intents

#if os(watchOS)
#else
// This seems to be necessary
extension UIImage {
  func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
    let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
    let format = imageRendererFormat
    format.opaque = isOpaque
    return UIGraphicsImageRenderer(size: canvas, format: format).image {
      _ in draw(in: CGRect(origin: .zero, size: canvas))
    }
  }
}
#endif

struct Provider: IntentTimelineProvider {
    func recommendations() -> [IntentRecommendation<ConfigurationIntent>] {
        return [
            IntentRecommendation(intent: ConfigurationIntent(), description: "My Intent Widget")
        ]
    }

    func placeholder(in context: Context) -> QuizEntry {
        QuizEntry(
            date: Date(),
            configuration: ConfigurationIntent(),
            heading: "#1",
            image: UIImage(named: "MysterySoda"),
            text: "sample"
            )
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (QuizEntry) -> ()) {
        let entry = QuizEntry(
            date: Date(),
            configuration: configuration,
            heading: "#1",
            image: UIImage(named: "MysterySoda"),
            text: "sample"
        )
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [QuizEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = QuizEntry(
                date: entryDate,
                configuration: configuration,
                heading: "Heading",
                image: nil,
                text: "Text")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct QuizEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let heading: String
    let image: UIImage?
    let text: String
}

struct QuizListWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family

    @ViewBuilder
    var body: some View {
        switch family {
        case .systemMedium, .systemLarge:
            HStack (spacing: 0) {
                VStack {
                    Text (entry.heading)
                        .padding()
                    Spacer(minLength: 0)
                    Text (entry.text)
                        .padding()
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                if let image = entry.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .clipped()
                }
            }

        case .accessoryRectangular:
            VStack {
                Text (entry.heading)
                Text (entry.text)
            }
        case .accessoryInline:
            Text("\(entry.heading) \(entry.text)")
        default:
            if let image = entry.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .bold()
                    .foregroundColor(.black)
            } else {
                VStack {
                    Text (entry.heading)
                    Text (entry.text)
                }
            }
        }
    }
}

@main
struct QuizListWidget: Widget {
    let kind: String = "QuizListWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            QuizListWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct QuizListComplication_Previews: PreviewProvider {
    static var previews: some View {
#if os(watchOS)
        let uiImage: UIImage? = nil
#else
        let uiImage = UIImage(named: "MysterySoda")!.resized(toWidth: 200)
#endif
        QuizListWidgetEntryView(
            entry: QuizEntry(
                date: Date(),
                configuration: ConfigurationIntent(),
                heading: "#1",
                image: uiImage,
                text: "Number one"
            ))
        #if os(watchOS)
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
        #else
            .previewContext(WidgetPreviewContext(family: .systemLarge))
        #endif
    }
}
