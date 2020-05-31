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
        return 1
    }
    
    /// The total monetary savings in dollars for the StockpileSaving assuming the user buys
    /// quantity amount.
    var savings: Double {
        return Double((regularPrice - salePrice) * Double(quantity))
    }
}

enum ConsumptionUnit: String, CaseIterable {
    case Day = "Day"
    case Week = "Week"
    case Month = "Month"
}
