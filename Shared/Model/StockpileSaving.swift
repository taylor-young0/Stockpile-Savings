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
        let stockpile = StockpileSaving()
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

        return [stockpile, stockpileTwo, stockpileThree]
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
