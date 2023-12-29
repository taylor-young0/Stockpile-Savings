//
//  LifetimeSavingsWidget.swift
//  LifetimeSavingsWidget
//
//  Created by Taylor Young on 2021-12-08.
//  Copyright © 2021 Taylor Young. All rights reserved.
//

import WidgetKit
import SwiftUI
import CoreData

struct LifetimeSavingsProvider: TimelineProvider {
    func placeholder(in context: Context) -> LifetimeSavingsEntry {
        let stockpiles: [StockpileSaving] = getStockpileSavings()

        return LifetimeSavingsEntry(date: Date(), allStockpiles: stockpiles)
    }

    func getSnapshot(in context: Context, completion: @escaping (LifetimeSavingsEntry) -> ()) {
        let stockpiles: [StockpileSaving] = getStockpileSavings()
        
        let entry = LifetimeSavingsEntry(date: Date(), allStockpiles: stockpiles)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<LifetimeSavingsEntry>) -> ()) {
        let stockpiles: [StockpileSaving] = getStockpileSavings()
        let entry: LifetimeSavingsEntry = LifetimeSavingsEntry(date: Date(), allStockpiles: stockpiles)

        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }

    func getStockpileSavings() -> [StockpileSaving] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "StockpileSaving")

        do {
            let stockpiles = try CoreDataStack.shared.managedObjectContext.fetch(request) as! [StockpileSaving]
            return stockpiles
        } catch {
            print(error.localizedDescription)
        }

        return []
    }
}

struct LifetimeSavingsWidgetView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: LifetimeSavingsEntry

    var body: some View {
        switch (family) {
        case .systemSmall:
            LifetimeSavingsSmallView(entry: entry)
        case .systemMedium, .systemLarge:
            LifetimeSavingsMediumLargeView(entry: entry, family: family)
        default: EmptyView()
        }
    }
}

@main
struct LifetimeSavingsWidget: Widget {
    let kind: String = "Lifetime Savings"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LifetimeSavingsProvider()) { entry in
            LifetimeSavingsWidgetView(entry: entry)
        }
        .configurationDisplayName("Lifetime Savings")
        .description("Lifetime Savings from all purchases.")
    }
}
