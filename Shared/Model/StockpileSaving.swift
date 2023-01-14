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
    @NSManaged public var consumptionUnit: String
    @NSManaged public var dateComputed: Date
    @NSManaged public var productDescription: String
    @NSManaged public var productExpiryDate: Date
    @NSManaged public var regularPrice: Double
    @NSManaged public var salePrice: Double
    @NSManaged public var unitsPurchased: Int

    /// The total monetary savings in dollars for the StockpileSaving assuming the user buys
    /// unitsPurchased amount.
    var savings: Double {
        let savingsPerUnit = regularPrice - salePrice
        return savingsPerUnit * Double(unitsPurchased)
    }
    
    /// The percentage savings per unit purchased given the salePrice and regularPrice
    var percentageSavings: Double {
        return (((regularPrice - salePrice) / regularPrice) * 100)
    }
}

extension StockpileSaving {
    @nonobjc public class func getRecentSavings(fetchLimit num: Int = 10) -> NSFetchRequest<StockpileSaving> {
        let request = NSFetchRequest<StockpileSaving>(entityName: "StockpileSaving")
        request.sortDescriptors = [NSSortDescriptor(key: "dateComputed", ascending: false)]
        request.fetchLimit = num
        return request
    }
    
    @nonobjc public class func getAllSavings() -> NSFetchRequest<StockpileSaving> {
        let request = NSFetchRequest<StockpileSaving>(entityName: "StockpileSaving")
        request.sortDescriptors = [NSSortDescriptor(key: "dateComputed", ascending: false)]
        return request
    }
}
