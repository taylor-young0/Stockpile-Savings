//
//  StockpileSaving+Samples.swift
//  StockpileTests
//
//  Created by Taylor Young on 2023-01-07.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import Foundation

public extension StockpileSaving {
    static var sample: StockpileSaving {
        let stockpile = StockpileSaving()
        stockpile.consumption = 0.5
        stockpile.consumptionUnit = ConsumptionUnit.Week.rawValue
        stockpile.dateComputed = Date()
        stockpile.productDescription = "🧀 Organic Meadow cheese"
        stockpile.productExpiryDate = Date.distantFuture
        stockpile.regularPrice = 9.99
        stockpile.salePrice = 7.49
        stockpile.unitsPurchased = 4

        return stockpile
    }

    static var samples: [StockpileSaving] {
        let stockpile = StockpileSaving(context: CoreDataStack.shared.managedObjectContext)
        stockpile.consumption = 0.5
        stockpile.consumptionUnit = ConsumptionUnit.Week.rawValue
        stockpile.dateComputed = Date()
        stockpile.productDescription = "🧀 Organic Meadow cheese"
        stockpile.productExpiryDate = Date.distantFuture
        stockpile.regularPrice = 9.99
        stockpile.salePrice = 7.49
        stockpile.unitsPurchased = 4

        let stockpileTwo = StockpileSaving()
        stockpileTwo.consumption = 1
        stockpileTwo.consumptionUnit = ConsumptionUnit.Month.rawValue
        stockpileTwo.dateComputed = Date()
        stockpileTwo.productDescription = "🍕 Amy's vegan margherita frozen pizza"
        stockpileTwo.productExpiryDate = Date.distantFuture
        stockpileTwo.regularPrice = 12.99
        stockpileTwo.salePrice = 9.99
        stockpileTwo.unitsPurchased = 2

        let stockpileThree = StockpileSaving()
        stockpileThree.consumption = 2
        stockpileThree.consumptionUnit = ConsumptionUnit.Week.rawValue
        stockpileThree.dateComputed = Date()
        stockpileThree.productDescription = "🧃 Kiju organic apple juice 1L"
        stockpileThree.productExpiryDate = Date.distantFuture
        stockpileThree.regularPrice = 4.99
        stockpileThree.salePrice = 3.49
        stockpileThree.unitsPurchased = 6

        let stockpileFour = StockpileSaving()
        stockpileThree.consumption = 1
        stockpileThree.consumptionUnit = ConsumptionUnit.Week.rawValue
        stockpileThree.dateComputed = Date()
        stockpileThree.productDescription = "🌭 6-pack hot dogs"
        stockpileThree.productExpiryDate = Date.distantFuture
        stockpileThree.regularPrice = 4.99
        stockpileThree.salePrice = 3.49
        stockpileThree.unitsPurchased = 4

        return [stockpile, stockpileTwo, stockpileThree, stockpileFour, stockpile,
                stockpileThree, stockpileTwo, stockpile, stockpile, stockpileFour]
    }
}
