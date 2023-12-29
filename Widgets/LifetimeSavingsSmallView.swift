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
                    .font(.caption.bold())
                Text(viewModel.lifetimeSavingsFormatted)
                    .font(.title.bold())
                
                Spacer(minLength: 0)

                if viewModel.shouldShowNumberOfItemsText(for: dynamicTypeSize) {
                    Text(viewModel.numberOfItemsText)
                        .font(.footnote)
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
    static let context: ManagedObjectContextType = StorageType.inmemory(.many).managedObjectContext

    static var previews: some View {
        let savings: [StockpileSaving] = try! context.fetch(StockpileSaving.fetchRequest()) as! [StockpileSaving]

        return LifetimeSavingsSmallView(entry: LifetimeSavingsEntry(date: Date(), allStockpiles: savings))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
