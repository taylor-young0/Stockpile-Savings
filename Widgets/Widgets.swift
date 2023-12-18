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

struct Provider: TimelineProvider {
    let lifetimeSavings = 143.74
    let stockpiles = [
        GroupedStockpileSaving(name: "🌭 6-pack Hot Dogs", savings: 100.0),
        GroupedStockpileSaving(name: "🍿 Popcorn", savings: 35.74),
        GroupedStockpileSaving(name: "🥜 Crunchy Peanut Butter", savings: 8.0)
    ]
    
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date(), lifetimeSavings: lifetimeSavings, stockpiles: stockpiles)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let results = getSavingsAndStockpiles()
        let lifetimeSavings = results.0
        let stockpiles = results.1
        
        let entry = SimpleEntry(date: Date(), lifetimeSavings: lifetimeSavings, stockpiles: stockpiles)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let results = getSavingsAndStockpiles()
        let lifetimeSavings = results.0
        let stockpiles = results.1
        
        let entries: [SimpleEntry] = [SimpleEntry(date: Date(), lifetimeSavings: lifetimeSavings, stockpiles: stockpiles)]
        
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

struct SimpleEntry: TimelineEntry {
    let date: Date
    let lifetimeSavings: Double
    let stockpiles: [GroupedStockpileSaving]
}

struct WidgetsEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry

    @ViewBuilder
    var body: some View {
        switch (family) {
        case .systemSmall: lifetimeSavingsSmall
        case .systemMedium: lifetimeSavingsMedium
        case .systemLarge: lifetimeSavingsLarge
        default: Text("")
        }
    }
    
    var lifetimeSavingsSmall: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Lifetime savings".uppercased())
                    .fontWeight(.bold)
                    .foregroundColor(Constants.stockpileColor)
                Text(entry.lifetimeSavings.asLocalizedCurrency)
                    .font(.title.bold())
                    .foregroundColor(Constants.stockpileColor)

                Spacer()

                Text("\(entry.stockpiles.count) total saving\(entry.stockpiles.count == 1 ? "" : "s")")
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
    }
    
    var lifetimeSavingsMedium: some View {
        VStack(alignment: .trailing) {
            lifetimeSavingsHeader
            
            ForEach(0..<numDisplayedSavings, id: \.self) { index in
                recentSavingsCell(savings: entry.stockpiles[index])
                    .lineLimit(1)
            }
            
            // only show if there is not enough space to show all savings
            Text("\(numNonDisplayedSavings) more")
                .foregroundColor(.gray)
                .opacity(numNonDisplayedSavings >= 1 ? 1 : 0)
        }
        .padding()
    }
    
    var lifetimeSavingsLarge: some View {
        VStack(alignment: .leading) {
            lifetimeSavingsHeader
                .foregroundColor(Constants.stockpileColor)
                .padding(.bottom)
            
            ForEach(0..<numDisplayedSavings, id: \.self) { index in
                recentSavingsCell(savings: entry.stockpiles[index])
                    .lineLimit(1)
            }
            
            Spacer()
            
            HStack {
                Spacer()
                // only show if there is not enough space to show all savings
                Text("\(numNonDisplayedSavings) more")
                    .foregroundColor(.gray)
                    .opacity(numNonDisplayedSavings >= 1 ? 1 : 0)
            }
        }
        .padding()
    }
    
    var lifetimeSavingsHeader: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("Lifetime savings".uppercased())
                    .fontWeight(.bold)
                    .foregroundColor(Constants.stockpileColor)
                Text(entry.lifetimeSavings.asLocalizedCurrency)
                    .font(.title.bold())
                    .foregroundColor(Constants.stockpileColor)
            }
            
            Spacer()
        }
    }
    
    var numDisplayedSavings: Int {
        switch(family) {
            
        case .systemMedium:
            return min(2, entry.stockpiles.count)
        case .systemLarge:
            return min(7, entry.stockpiles.count)
        default:
            return 0
        }
    }
    
    var numNonDisplayedSavings: Int {
        return entry.stockpiles.count - numDisplayedSavings
    }
    
    func recentSavingsCell(savings: GroupedStockpileSaving) -> some View {
        return HStack {
            Text(savings.name)
            Spacer()
            Text(savings.savings.asLocalizedCurrency)
                .bold()
                .monospacedDigit()
        }
        .padding(.bottom, 1)
    }
}

@main
struct Widgets: Widget {
    let kind: String = "Lifetime Savings"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetsEntryView(entry: entry)
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
        
        WidgetsEntryView(entry: SimpleEntry(date: Date(), lifetimeSavings: lifetimeSavings, stockpiles: stockpiles))
            .previewDevice("iPhone 8")
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        WidgetsEntryView(entry: SimpleEntry(date: Date(), lifetimeSavings: lifetimeSavings, stockpiles: stockpiles))
            .previewDevice("iPhone 13 Pro Max")
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        // MARK: systemMedium
        
        WidgetsEntryView(entry: SimpleEntry(date: Date(), lifetimeSavings: lifetimeSavings, stockpiles: stockpiles))
            .previewDevice("iPhone 8")
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        
        WidgetsEntryView(entry: SimpleEntry(date: Date(), lifetimeSavings: lifetimeSavings, stockpiles: stockpiles))
            .previewDevice("iPhone 13 Pro Max")
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        
        // MARK: systemLarge
        
        WidgetsEntryView(entry: SimpleEntry(date: Date(), lifetimeSavings: lifetimeSavings, stockpiles: stockpiles))
            .previewDevice("iPhone 8")
            .previewContext(WidgetPreviewContext(family: .systemLarge))
        
        WidgetsEntryView(entry: SimpleEntry(date: Date(), lifetimeSavings: lifetimeSavings, stockpiles: stockpiles))
            .previewDevice("iPhone 13 Pro Max")
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
