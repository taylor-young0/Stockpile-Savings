//
//  MockStockpileSaving.swift
//  Stockpile
//
//  Created by Taylor Young on 2023-07-16.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import Foundation

class MockStockpileSaving: StockpileSavingType {
    let id: UUID = UUID()
    var consumption: Double
    var consumptionUnit: String
    var dateComputed: Date
    var productDescription: String
    var productExpiryDate: Date
    var regularPrice: Double
    var salePrice: Double
    var unitsPurchased: Int

    init(consumption: Double = 2, consumptionUnit: ConsumptionUnit = .Week, dateComputed: Date = Date(), productDescription: String,
         productExpiryDate: Date = Date(), regularPrice: Double, salePrice: Double, unitsPurchased: Int) {
        self.consumption = consumption
        self.consumptionUnit = consumptionUnit.rawValue
        self.dateComputed = dateComputed
        self.productDescription = productDescription
        self.productExpiryDate = productExpiryDate
        self.regularPrice = regularPrice
        self.salePrice = salePrice
        self.unitsPurchased = unitsPurchased
    }

    var savings: Double {
        let savingsPerUnit = regularPrice - salePrice
        return savingsPerUnit * Double(unitsPurchased)
    }

    var percentageSavings: Double {
        return (((regularPrice - salePrice) / regularPrice) * 100)
    }
}
