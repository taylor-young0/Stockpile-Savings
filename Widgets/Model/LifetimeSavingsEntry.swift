//
//  LifetimeSavingsEntry.swift
//  WidgetsExtension
//
//  Created by Taylor Young on 2023-12-19.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import WidgetKit

struct LifetimeSavingsEntry: TimelineEntry {
    let date: Date
    let allStockpiles: [StockpileSaving]

    var lifetimeSavings: Double {
        return allStockpiles.reduce(0) { $0 + $1.savings }
    }

    var groupedStockpiles: [GroupedStockpileSaving] {
        var groupedStockpiles: [GroupedStockpileSaving] = []

        for stockpile in allStockpiles {
            // stockpiles are grouped by productDescription
            // if item already added to stockpiles, update its savings accordingly
            let existingIndex = groupedStockpiles.firstIndex(where: { stockpile.productDescription == $0.name })

            // if we do have a savings already under that product name
            if let existingIndex {
                // add previous savings of this item to the current savings
                let currentSavings = allStockpiles[existingIndex].savings
                let newSavings = currentSavings + stockpile.savings

                groupedStockpiles[existingIndex] = GroupedStockpileSaving(name: stockpile.productDescription, savings: newSavings)
            } else {
                // else, first time adding product of that name
                groupedStockpiles.append(GroupedStockpileSaving(name: stockpile.productDescription, savings: stockpile.savings))
            }
        }

        groupedStockpiles.sort(by: { $0.savings > $1.savings })
        return groupedStockpiles
    }
}
