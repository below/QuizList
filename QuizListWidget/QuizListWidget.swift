//
//  QuizListWidget.swift
//  QuizListWidget
//
//  Created by Alexander von Below on 16.10.22.
//  Copyright © 2022 None. All rights reserved.
//
// Mystery Soda! Image by Toby Oxborrow, CCbySA
// https://flic.kr/p/5rRy6t

import WidgetKit
import SwiftUI
import Intents

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

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> QuizEntry {
        QuizEntry(
            date: Date(),
            configuration: ConfigurationIntent(),
            heading: "#1",
            image: UIImage(named: "MysterySoda")!,
            text: "sample"
            )
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (QuizEntry) -> ()) {
        let entry = QuizEntry(
            date: Date(),
            configuration: configuration,
            heading: "#1",
            image: UIImage(named: "MysterySoda")!,
            text: "sample"
        )
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [QuizEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        
        if let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.vonbelow.quizlist")
        {
            do {
                let content = try FileManager.default.contentsOfDirectory(
                    at: url,
                    includingPropertiesForKeys: nil)
                if let url = content.first(
                    where: { $0.pathExtension == Constants.FileExtenstion.rawValue }),
                   let bundle = Bundle(url: url),
                   let list = QuizList(contentsOf: bundle) {
                    
                    var date = Date()
                    var imagePaths = list.imagePaths
                    
                    imagePaths = Array(imagePaths.prefix(upTo: 8))
                    
                    let imageList = imagePaths.compactMap {
                        do {
                            let data = try Data(contentsOf: $0)
                            let image = UIImage(data: data)
                            return image?.resized(toWidth: 500)
                        } catch {
                            return nil
                        }
                    }
                    
                    for item in list.items.shuffled() {
                        let image = imageList.randomElement()!
                        let entry = QuizEntry(
                            date: date,
                            configuration: configuration,
                            heading: "#\(item.number)",
                            image: image,
                            text: item.text)
                        entries.append(entry)
                        date = Calendar.current.date(
                            byAdding: .minute,
                            value: 5,
                            to: date)!

                    }
                }
            }
            catch {
                print ("We got an error:\(error)")
            }
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct QuizEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let heading: String
    let image: UIImage
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
                    Spacer()
                    Text (entry.text)
                        .padding()
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                
                Image(uiImage: entry.image)
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .clipped()
            }

        case .accessoryRectangular:
            VStack {
                Text (entry.heading)
                Text (entry.text)
            }
        case .accessoryInline:
            Text("\(entry.heading) \(entry.text)")
        default:
            Image(uiImage: entry.image)
                .resizable()
                .scaledToFit()
                .bold()
                .foregroundColor(.black)
            
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
        .supportedFamilies([
            .accessoryInline,
            .accessoryRectangular,
            .systemSmall,
            .systemMedium,
            .systemLarge,
            .systemExtraLarge]
        )
    }
}

struct QuizListWidget_Previews: PreviewProvider {
    static var previews: some View {
        let uiImage = UIImage(named: "MysterySoda")!.resized(toWidth: 200)!
        QuizListWidgetEntryView(
            entry: QuizEntry(
                date: Date(),
                configuration: ConfigurationIntent(),
                heading: "#1",
                image: uiImage,
                text: "Number one"
            ))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
