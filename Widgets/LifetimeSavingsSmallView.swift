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
    @Environment(\.dynamicTypeSize) var dynamicTypeSize: DynamicTypeSize
    private let viewModel: LifetimeSavingsSmallViewModel

    init(entry: LifetimeSavingsProvider.Entry) {
        self.viewModel = LifetimeSavingsSmallViewModel(entry: entry)
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Lifetime savings".uppercased())
                    .fontWeight(.bold)
                Text(viewModel.lifetimeSavingsFormatted)
                    .font(.title.bold())
                
                Spacer(minLength: 0)

                if viewModel.shouldShowTotalSavingsText(for: dynamicTypeSize) {
                    Text(viewModel.totalSavingsText)
                        .foregroundColor(.gray)
                }
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
