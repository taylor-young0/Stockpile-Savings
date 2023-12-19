//
//  LifetimeSavingsSmallView.swift
//  WidgetsExtension
//
//  Created by Taylor Young on 2023-12-18.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import SwiftUI
import WidgetKit

struct LifetimeSavingsSmallView: View {
    var entry: LifetimeSavingsProvider.Entry

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Lifetime savings".uppercased())
                    .fontWeight(.bold)
                Text(entry.lifetimeSavings.asLocalizedCurrency)
                    .font(.title.bold())
                
                Spacer()
                
                Text("\(entry.stockpiles.count) total saving\(entry.stockpiles.count == 1 ? "" : "s")")
                    .foregroundColor(.gray)
            }
            .foregroundColor(Constants.stockpileColor)

            Spacer()
        }
        .padding()
    }
}

struct LifetimeSavingsSmallWidgetView_Previews: PreviewProvider {
    static let lifetimeSavings = 143.74
    static let stockpiles = [
        GroupedStockpileSaving(name: "🌭 6-pack Hot Dogs", savings: 100.0),
        GroupedStockpileSaving(name: "🍿 Popcorn", savings: 35.74),
        GroupedStockpileSaving(name: "🥜 Crunchy Peanut Butter", savings: 8.0)
    ]

    static var previews: some View {
        LifetimeSavingsSmallView(entry: LifetimeSavingsEntry(date: Date(), lifetimeSavings: lifetimeSavings, stockpiles: stockpiles))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
