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

    init(stockpile: StockpileSaving) {
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
    static let viewModel: StockpileSavingRowViewModel = StockpileSavingRowViewModel(description: "🧀 Organic Meadow cheese", savings: 10.0,
                                                                                    unitsPurchased: 5, percentageSavings: 20.0)

    static var previews: some View {
        StockpileSavingRow(viewModel: viewModel)
            .previewLayout(.fixed(width: 375, height: 70))
            .padding(.horizontal)
        
        StockpileSavingRow(viewModel: viewModel)
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 375, height: 70))
            .padding(.horizontal)
            
        List {
            StockpileSavingRow(viewModel: viewModel)
        }
        .listStyle(InsetGroupedListStyle())
            
        List {
            StockpileSavingRow(viewModel: viewModel)
        }
        .preferredColorScheme(.dark)
        .listStyle(InsetGroupedListStyle())
    }
    
}
