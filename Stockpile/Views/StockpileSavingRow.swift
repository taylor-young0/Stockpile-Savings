//
//  StockpileSavingRow.swift
//  Stockpile
//
//  Created by Taylor Young on 2021-09-03.
//  Copyright © 2021 Taylor Young. All rights reserved.
//

import CoreData
import SwiftUI

struct StockpileSavingRow: View {
    private let viewModel: StockpileSavingRowViewModel

    init(viewModel: StockpileSavingRowViewModel) {
        self.viewModel = viewModel
    }

    init(stockpile: any StockpileSavingType) {
        self.viewModel = StockpileSavingRowViewModel(description: stockpile.productDescription, savings: stockpile.savings,
                                                     unitsPurchased: stockpile.unitsPurchased, percentageSavings: stockpile.percentageSavings)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(viewModel.description)
                Spacer()
                Text("\(viewModel.savings.asLocalizedCurrency) off")
                    .monospacedDigit()
            }
            
            HStack {
                Text("\(viewModel.unitsPurchased) unit\(viewModel.unitsPurchased == 1 ? "" : "s")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(viewModel.percentageSavings, specifier: "%.0f")% savings")
                    .font(.subheadline)
                    .monospacedDigit()
                    .foregroundColor(.gray)
            }
        }
    }
}

struct StockpileSavingRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            StockpileSavingRow(stockpile: MockStockpileSaving.samples[0])
        }
        .listStyle(InsetGroupedListStyle())
            
        List {
            StockpileSavingRow(stockpile: MockStockpileSaving.samples[0])
        }
        .preferredColorScheme(.dark)
        .listStyle(InsetGroupedListStyle())
    }
}
