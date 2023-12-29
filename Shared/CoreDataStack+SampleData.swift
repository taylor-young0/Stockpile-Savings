//
//  CoreDataStack+SampleData.swift
//  Stockpile
//
//  Created by Taylor Young on 2023-12-22.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import Foundation

extension CoreDataStack {
    func initializeWithSampleData(with amount: SampleDataAmount) {
        if amount == .one {
            initializeWithOneSample()
        } else if amount == .few {
            initializeWithFewSamples()
        } else if amount == .many {
            initializeWithManySamples()
        } else if amount == .manyWithDuplicates {
            initializeWithManyDuplicateSamples()
        }
        try? self.managedObjectContext.save()
    }

    private func initializeWithOneSample() {
        createStockpileSaving(description: "🍎 Apples", consumption: 2, regularPrice: 2.99, salePrice: 1.89, unitsPurchased: 4)
    }

    private func initializeWithFewSamples() {
        createStockpileSaving(description: "🍎 Apples", consumption: 2, regularPrice: 2.99, salePrice: 1.89, unitsPurchased: 4)
        createStockpileSaving(description: "🥯 Bagels", consumption: 3, regularPrice: 4.99, salePrice: 3.99, unitsPurchased: 2)
        createStockpileSaving(description: "🥖 Baguette", consumption: 1, regularPrice: 4.99, salePrice: 3.99, unitsPurchased: 2)
        createStockpileSaving(description: "🍪 Cookies", consumption: 4, regularPrice: 3.99, salePrice: 3.49, unitsPurchased: 2)
    }

    private func initializeWithManySamples() {
        createStockpileSaving(description: "🍎 Apples", consumption: 2, regularPrice: 2.99, salePrice: 1.89, unitsPurchased: 4)
        createStockpileSaving(description: "🥯 Bagels", consumption: 3, regularPrice: 4.99, salePrice: 3.99, unitsPurchased: 2)
        createStockpileSaving(description: "🥖 Baguette", consumption: 1, regularPrice: 4.99, salePrice: 3.99, unitsPurchased: 2)
        createStockpileSaving(description: "🍪 Cookies", consumption: 4, regularPrice: 3.99, salePrice: 3.49, unitsPurchased: 2)
        createStockpileSaving(description: "🍩 Donut", consumption: 1, regularPrice: 3.99, salePrice: 3.79, unitsPurchased: 4)
        createStockpileSaving(description: "🍆 Eggplant", consumption: 1, regularPrice: 2.99, salePrice: 1.79, unitsPurchased: 2)
        createStockpileSaving(description: "🍯 Honey", consumption: 1, regularPrice: 8.99, salePrice: 5.99, unitsPurchased: 4)
        createStockpileSaving(description: "🥜 Peanut Butter", consumption: 2, regularPrice: 6.99, salePrice: 5.99, unitsPurchased: 3)
        createStockpileSaving(description: "🧀 Cheese", consumption: 2, regularPrice: 4.99, salePrice: 4.49, unitsPurchased: 2)
        createStockpileSaving(description: "🥞 Pancake Mix", consumption: 2, regularPrice: 5.99, salePrice: 5.29, unitsPurchased: 4)
        createStockpileSaving(description: "🥨 Pretzels", consumption: 1, regularPrice: 4.99, salePrice: 3.99, unitsPurchased: 2)
        createStockpileSaving(description: "🌭 Hot Dogs", consumption: 2, regularPrice: 4.99, salePrice: 3.99, unitsPurchased: 1)
    }

    private func initializeWithManyDuplicateSamples() {
        createStockpileSaving(description: "🍎 Apples", consumption: 2, regularPrice: 2.99, salePrice: 1.89, unitsPurchased: 4)
        createStockpileSaving(description: "🥯 Bagels", consumption: 3, regularPrice: 4.99, salePrice: 3.99, unitsPurchased: 2)
        createStockpileSaving(description: "🥯 Bagels", consumption: 3, regularPrice: 4.99, salePrice: 2.99, unitsPurchased: 4)
        createStockpileSaving(description: "🥖 Baguette", consumption: 1, regularPrice: 4.99, salePrice: 3.99, unitsPurchased: 2)
        createStockpileSaving(description: "🍪 Cookies", consumption: 4, regularPrice: 3.99, salePrice: 3.49, unitsPurchased: 2)
        createStockpileSaving(description: "🍩 Donut", consumption: 1, regularPrice: 3.99, salePrice: 3.79, unitsPurchased: 4)
        createStockpileSaving(description: "🍩 Donut", consumption: 1, regularPrice: 3.99, salePrice: 2.99, unitsPurchased: 4)
        createStockpileSaving(description: "🍆 Eggplant", consumption: 1, regularPrice: 2.99, salePrice: 1.79, unitsPurchased: 2)
        createStockpileSaving(description: "🍯 Honey", consumption: 1, regularPrice: 8.99, salePrice: 5.99, unitsPurchased: 4)
        createStockpileSaving(description: "🥜 Peanut Butter", consumption: 2, regularPrice: 6.99, salePrice: 5.99, unitsPurchased: 3)
        createStockpileSaving(description: "🧀 Cheese", consumption: 2, regularPrice: 4.99, salePrice: 4.49, unitsPurchased: 2)
        createStockpileSaving(description: "🥞 Pancake Mix", consumption: 2, regularPrice: 5.99, salePrice: 5.29, unitsPurchased: 4)
        createStockpileSaving(description: "🥨 Pretzels", consumption: 1, regularPrice: 4.99, salePrice: 3.99, unitsPurchased: 2)
        createStockpileSaving(description: "🌭 Hot Dogs", consumption: 2, regularPrice: 4.99, salePrice: 3.99, unitsPurchased: 1)
        createStockpileSaving(description: "🌭 Hot Dogs", consumption: 2, regularPrice: 4.99, salePrice: 2.99, unitsPurchased: 3)
    }

    private func createStockpileSaving(description: String,
                                       consumption: Double,
                                       consumptionUnit: ConsumptionUnit = .Day,
                                       expiryDate: Date = Date(),
                                       regularPrice: Double,
                                       salePrice: Double,
                                       unitsPurchased: Int) {
        let stockpile: StockpileSaving = StockpileSaving(context: self.managedObjectContext)
        stockpile.productDescription = description
        stockpile.consumption = consumption
        stockpile.consumptionUnit = consumptionUnit.rawValue
        stockpile.dateComputed = Date()
        stockpile.productExpiryDate = expiryDate
        stockpile.regularPrice = regularPrice
        stockpile.salePrice = salePrice
        stockpile.unitsPurchased = unitsPurchased
    }
}
