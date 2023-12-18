//
//  LifetimeSavingsMediumLargeView.swift
//  WidgetsExtension
//
//  Created by Taylor Young on 2023-12-18.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import SwiftUI
import WidgetKit

struct LifetimeSavingsMediumLargeView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: LifetimeSavingsProvider.Entry

    var body: some View {
        VStack(alignment: .trailing) {
            lifetimeSavingsHeader
                .padding(.bottom, family == .systemLarge ? 6 : 0)

            ForEach(0..<numDisplayedSavings, id: \.self) { index in
                recentSavingsCell(savings: entry.stockpiles[index])
                    .lineLimit(1)
            }

            Spacer()

            // only show if there is not enough space to show all savings
            if numNonDisplayedSavings > 0 {
                Text("\(numNonDisplayedSavings) more")
                    .foregroundColor(.gray)
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

    func recentSavingsCell(savings: GroupedStockpileSaving) -> some View {
        HStack {
            Text(savings.name)
            Spacer()
            Text(savings.savings.asLocalizedCurrency)
                .bold()
                .monospacedDigit()
        }
        .padding(.bottom, 1)
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
}

struct LifetimeSavingsMediumView_Previews: PreviewProvider {
    static let lifetimeSavings = 143.74
    static let stockpiles = [
        GroupedStockpileSaving(name: "🌭 6-pack Hot Dogs", savings: 100.0),
        GroupedStockpileSaving(name: "🍿 Popcorn", savings: 35.74),
        GroupedStockpileSaving(name: "🥜 Crunchy Peanut Butter", savings: 8.0)
    ]
    
    static var previews: some View {
        LifetimeSavingsMediumLargeView(entry: LifetimeSavingsEntry(date: Date(), lifetimeSavings: lifetimeSavings, stockpiles: stockpiles))
            .previewContext(WidgetPreviewContext(family: .systemMedium))

        LifetimeSavingsMediumLargeView(entry: LifetimeSavingsEntry(date: Date(), lifetimeSavings: lifetimeSavings, stockpiles: stockpiles))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
