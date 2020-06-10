//
//  StockpileSaving.swift
//  Stockpile
//
//  Created by Taylor Young on 2020-05-31.
//  Copyright © 2020 Taylor Young. All rights reserved.
//

import Foundation
import CoreData

@objc(StockpileSaving)
public class StockpileSaving: NSManagedObject, Identifiable {
    @NSManaged public var consumption: Double
    @NSManaged public var consumptionUnit: String?
    @NSManaged public var dateComputed: Date?
    @NSManaged public var productDescription: String?
    @NSManaged public var productExpiryDate: Date?
    @NSManaged public var regularPrice: Double
    @NSManaged public var salePrice: Double

    /// The number of units the user should Stockpile in order to save the most money after
    /// taking into effect the other variables (productExpiryDate, consumption, etc...)
    var quantity: Int {
        var consumptionInDays = consumption
        // Check if we need to convert our consumption to days
        if consumptionUnit != ConsumptionUnit.Day.rawValue {
            consumptionInDays = (consumptionUnit == ConsumptionUnit.Week.rawValue) ?
                (consumptionInDays / 7) : (consumptionInDays / 30)
        }
        let daysBetween = Calendar.current.dateComponents([.day], from: dateComputed ?? Date(), to: productExpiryDate ?? Date())
        return Int(consumptionInDays * Double(daysBetween.day ?? 0))
    }

    /// The total monetary savings in dollars for the StockpileSaving assuming the user buys
    /// quantity amount.
    var savings: Double {
        let savingsPerUnit = regularPrice - salePrice
        return savingsPerUnit * Double(quantity)
    }
    
    /// The percentage savings per unit purchased given the salePrice and regularPrice
    var percentageSavings: Double {
        return (((regularPrice - salePrice) / regularPrice) * 100)
    }
}

extension StockpileSaving {
    @nonobjc public class func getRecentSavings(fetchLimit num: Int) -> NSFetchRequest<StockpileSaving> {
        let request = NSFetchRequest<StockpileSaving>(entityName: "StockpileSaving")
        request.sortDescriptors = [NSSortDescriptor(key: "dateComputed", ascending: false)]
        request.fetchBatchSize = num
        request.fetchLimit = num
        return request
    }
    
    @nonobjc public class func getAllSavings() -> NSFetchRequest<StockpileSaving> {
        let request = NSFetchRequest<StockpileSaving>(entityName: "StockpileSaving")
        request.sortDescriptors = [NSSortDescriptor(key: "dateComputed", ascending: false)]
        return request
    }
}

enum ConsumptionUnit: String, CaseIterable {
    case Day = "Day"
    case Week = "Week"
    case Month = "Month"
}
