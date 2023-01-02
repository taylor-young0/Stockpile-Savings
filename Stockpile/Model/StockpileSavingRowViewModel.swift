//
//  StockpileSavingRowViewModel.swift
//  Stockpile
//
//  Created by Taylor Young on 2023-01-02.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

class StockpileSavingRowViewModel {
    let description: String
    let savings: Double
    let unitsPurchased: Int
    let percentageSavings: Double

    init(description: String, savings: Double, unitsPurchased: Int, percentageSavings: Double) {
        self.description = description
        self.savings = savings
        self.unitsPurchased = unitsPurchased
        self.percentageSavings = percentageSavings
    }
}
