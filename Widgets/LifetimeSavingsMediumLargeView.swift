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
    private let viewModel: LifetimeSavingsMediumLargeViewModel

    init(entry: LifetimeSavingsProvider.Entry, family: WidgetFamily) {
        self.viewModel = LifetimeSavingsMediumLargeViewModel(entry: entry, family: family)
    }

    var body: some View {
        VStack(alignment: .trailing) {
            lifetimeSavingsHeader
                .padding(.bottom, viewModel.family == .systemLarge ? 6 : 0)

            ForEach(0..<viewModel.numDisplayedSavings, id: \.self) { index in
                recentSavingsCell(stockpile: viewModel.stockpiles[index])
                    .lineLimit(1)
            }

            Spacer()

            // only show if there is not enough space to show all savings
            if viewModel.shouldShowNumNonDisplayedSavingsText {
                Text(viewModel.numNonDisplayedSavingsText)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }

    var lifetimeSavingsHeader: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("Lifetime savings".uppercased())
                    .font(.caption.bold())
                Text(viewModel.lifetimeSavingsFormatted)
                    .font(.title.bold())
            }
            .foregroundColor(Constants.stockpileColor)

            Spacer()
        }
    }

    func recentSavingsCell(stockpile: GroupedStockpileSaving) -> some View {
        HStack {
            Text(stockpile.name)
            Spacer()
            Text(viewModel.currencyFormatted(stockpile.savings))
                .bold()
                .monospacedDigit()
        }
        .padding(.bottom, 1)
    }
}

struct LifetimeSavingsMediumLargeView_Previews: PreviewProvider {
    static let context: ManagedObjectContextType = StorageType.inmemory(.many).managedObjectContext

    static var previews: some View {
        let savings: [StockpileSaving] = try! context.fetch(StockpileSaving.fetchRequest()) as! [StockpileSaving]

        return Group {
            LifetimeSavingsMediumLargeView(entry: LifetimeSavingsEntry(date: Date(), allStockpiles: savings), family: .systemMedium)
                .previewContext(WidgetPreviewContext(family: .systemMedium))

            LifetimeSavingsMediumLargeView(entry: LifetimeSavingsEntry(date: Date(), allStockpiles: savings), family: .systemLarge)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
