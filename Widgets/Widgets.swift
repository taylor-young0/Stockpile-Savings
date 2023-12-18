//
//  Widgets.swift
//  Widgets
//
//  Created by Taylor Young on 2021-12-08.
//  Copyright © 2021 Taylor Young. All rights reserved.
//

import WidgetKit
import SwiftUI
import CoreData

struct LifetimeSavingsProvider: TimelineProvider {
    let lifetimeSavings = 143.74
    let stockpiles = [
        GroupedStockpileSaving(name: "🌭 6-pack Hot Dogs", savings: 100.0),
        GroupedStockpileSaving(name: "🍿 Popcorn", savings: 35.74),
        GroupedStockpileSaving(name: "🥜 Crunchy Peanut Butter", savings: 8.0)
    ]
    
    func placeholder(in context: Context) -> LifetimeSavingsEntry {
        return LifetimeSavingsEntry(date: Date(), lifetimeSavings: lifetimeSavings, stockpiles: stockpiles)
    }

    func getSnapshot(in context: Context, completion: @escaping (LifetimeSavingsEntry) -> ()) {
        let results = getSavingsAndStockpiles()
        let lifetimeSavings = results.0
        let stockpiles = results.1
        
        let entry = LifetimeSavingsEntry(date: Date(), lifetimeSavings: lifetimeSavings, stockpiles: stockpiles)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<LifetimeSavingsEntry>) -> ()) {
        let results = getSavingsAndStockpiles()
        let lifetimeSavings = results.0
        let stockpiles = results.1
        
        let entries: [LifetimeSavingsEntry] = [LifetimeSavingsEntry(date: Date(), lifetimeSavings: lifetimeSavings, stockpiles: stockpiles)]
        
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
    
    func getSavingsAndStockpiles() -> (Double, [GroupedStockpileSaving]) {
        var lifetimeSavings: Double
        var stockpiles: [GroupedStockpileSaving] = []
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "StockpileSaving")
        do {
            lifetimeSavings = 0.0
            let savings = try CoreDataStack.shared.managedObjectContext.fetch(request) as! [StockpileSaving]
            for saving in savings {
                lifetimeSavings = lifetimeSavings + saving.savings
                
                // stockpiles are grouped by productDescription
                // if item already added to stockpiles, update its savings accordingly
                let currentSavingsIndex = stockpiles.firstIndex(where: { saving.productDescription == $0.name })
                
                // if we do have a savings already under that product name
                if let currentSavingsIndex = currentSavingsIndex {
                    // add previous savings of this item to the current savings
                    let currentSavings = stockpiles[currentSavingsIndex].savings
                    stockpiles[currentSavingsIndex] = GroupedStockpileSaving(name: saving.productDescription, savings: saving.savings + currentSavings)
                } else {
                    // else, first time adding product of that name
                    stockpiles.append(GroupedStockpileSaving(name: saving.productDescription, savings: saving.savings))
                }
            }
            
            stockpiles.sort(by: { $0.savings > $1.savings })
        } catch {
            print(error.localizedDescription)
        }
        
        return (lifetimeSavings, stockpiles)
    }
}

struct LifetimeSavingsEntry: TimelineEntry {
    let date: Date
    let lifetimeSavings: Double
    let stockpiles: [GroupedStockpileSaving]
}

struct LifetimeSavingsWidgetView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: LifetimeSavingsEntry

    var body: some View {
        switch (family) {
        case .systemSmall:
            LifetimeSavingsSmallView(entry: entry)
        case .systemMedium, .systemLarge:
            LifetimeSavingsMediumLargeView(entry: entry)
        default: EmptyView()
        }
    }
}

@main
struct Widgets: Widget {
    let kind: String = "Lifetime Savings"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LifetimeSavingsProvider()) { entry in
            LifetimeSavingsWidgetView(entry: entry)
        }
        .configurationDisplayName("Lifetime Savings")
        .description("Lifetime Savings from all purchases.")
    }
}

struct Widgets_Previews: PreviewProvider {
    static let lifetimeSavings = 143.74
    static let stockpiles = [
        GroupedStockpileSaving(name: "🌭 6-pack Hot Dogs", savings: 100.0),
        GroupedStockpileSaving(name: "🍿 Popcorn", savings: 35.74),
        GroupedStockpileSaving(name: "🥜 Crunchy Peanut Butter", savings: 8.0)
    ]
    
    static var previews: some View {

        // MARK: systemSmall
        
        LifetimeSavingsWidgetView(entry: LifetimeSavingsEntry(date: Date(), lifetimeSavings: lifetimeSavings, stockpiles: stockpiles))
            .previewDevice("iPhone 8")
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        LifetimeSavingsWidgetView(entry: LifetimeSavingsEntry(date: Date(), lifetimeSavings: lifetimeSavings, stockpiles: stockpiles))
            .previewDevice("iPhone 13 Pro Max")
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        // MARK: systemMedium
        
        LifetimeSavingsWidgetView(entry: LifetimeSavingsEntry(date: Date(), lifetimeSavings: lifetimeSavings, stockpiles: stockpiles))
            .previewDevice("iPhone 8")
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        
        LifetimeSavingsWidgetView(entry: LifetimeSavingsEntry(date: Date(), lifetimeSavings: lifetimeSavings, stockpiles: stockpiles))
            .previewDevice("iPhone 13 Pro Max")
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        
        // MARK: systemLarge
        
        LifetimeSavingsWidgetView(entry: LifetimeSavingsEntry(date: Date(), lifetimeSavings: lifetimeSavings, stockpiles: stockpiles))
            .previewDevice("iPhone 8")
            .previewContext(WidgetPreviewContext(family: .systemLarge))
        
        LifetimeSavingsWidgetView(entry: LifetimeSavingsEntry(date: Date(), lifetimeSavings: lifetimeSavings, stockpiles: stockpiles))
            .previewDevice("iPhone 13 Pro Max")
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
