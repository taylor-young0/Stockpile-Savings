//
//  StockpileSaving.swift
//  Stockpile
//
//  Created by Taylor Young on 2020-05-31.
//  Copyright © 2020 Taylor Young. All rights reserved.
//

import Foundation
import CoreData

public class StockpileSaving: NSManagedObject, Identifiable {
    @NSManaged var dateComputed: Date
    @NSManaged var productDescription: String
    @NSManaged var productExpiryDate: Date
    @NSManaged var consumption: Double
    @NSManaged var consumptionUnit: String
    
    @NSManaged var regularPrice: Double
    @NSManaged var salePrice: Double
    
    /// The number of units the user should Stockpile in order to save the most money after
    /// taking into effect the other variables (productExpiryDate, consumption, etc...)
    var quantity: Int {
        var consumptionInDays = consumption
        // Check if we need to convert our consumption to days
        if consumptionUnit != ConsumptionUnit.Day.rawValue {
            consumptionInDays = (consumptionUnit == ConsumptionUnit.Week.rawValue) ?
                (consumptionInDays / 7) : (consumptionInDays / 30)
        }
        let daysBetween = Calendar.current.dateComponents([.day], from: Date(), to: productExpiryDate)
        return Int(consumptionInDays * Double(daysBetween.day ?? 0))
    }
    
    /// The total monetary savings in dollars for the StockpileSaving assuming the user buys
    /// quantity amount.
    var savings: Double {
        let savingsPerUnit = regularPrice - salePrice
        return savingsPerUnit * Double(quantity)
    }
    
//    init(productDescription: String, productExpiryDate: Date, consumption: Double, consumptionUnit: String) {
//        super.init(context: NSManagedObjectContext())
//        self.productDescription = productDescription
//        self.productExpiryDate = productExpiryDate
//        self.consumption = consumption
//        self.consumptionUnit = consumptionUnit
//    }
}

enum ConsumptionUnit: String, CaseIterable {
    case Day = "Day"
    case Week = "Week"
    case Month = "Month"
}
