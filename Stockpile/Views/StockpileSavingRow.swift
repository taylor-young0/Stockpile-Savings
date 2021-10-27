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
    
    var description: String
    var savings: Double
    var unitsPurchased: Int
    var percentageSavings: Double
    
    var savingsLocalized: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return formatter.string(from: NSNumber(value: savings))!
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(description)
                Spacer()
                Text("\(savingsLocalized) off")
            }
            
            HStack {
                Text("\(unitsPurchased) unit\(unitsPurchased == 1 ? "" : "s")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(percentageSavings, specifier: "%.0f")% savings")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct StockpileSavingRow_Previews: PreviewProvider {
    
    static var description = "🧀 Organic Meadow cheese"
    static var savings = 10.0
    static var unitsPurchased = 5
    static var percentageSavings = 20.0
    
    
    static var previews: some View {
        StockpileSavingRow(description: description, savings: savings, unitsPurchased: unitsPurchased, percentageSavings: percentageSavings)
            .previewLayout(.fixed(width: 375, height: 70))
            .padding(.horizontal)
        
        StockpileSavingRow(description: description, savings: savings, unitsPurchased: unitsPurchased, percentageSavings: percentageSavings)
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 375, height: 70))
            .padding(.horizontal)
        
        if #available(iOS 14.0, *) {
            
            // MARK: - iOS 14 Previews
            
            List {
                StockpileSavingRow(description: description, savings: savings, unitsPurchased: unitsPurchased, percentageSavings: percentageSavings)
            }
            .listStyle(InsetGroupedListStyle())
            
            List {
                StockpileSavingRow(description: description, savings: savings, unitsPurchased: unitsPurchased, percentageSavings: percentageSavings)
            }
            .preferredColorScheme(.dark)
            .listStyle(InsetGroupedListStyle())
        } else {
            
            // MARK: - iOS 13 Previews
            
            List {
                StockpileSavingRow(description: description, savings: savings, unitsPurchased: unitsPurchased, percentageSavings: percentageSavings)
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            
            List {
                StockpileSavingRow(description: description, savings: savings, unitsPurchased: unitsPurchased, percentageSavings: percentageSavings)
            }
            .preferredColorScheme(.dark)
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
        }
    }
    
}
