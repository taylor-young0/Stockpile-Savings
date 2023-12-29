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
public class StockpileSaving: NSManagedObject, Identifiable, StockpileSavingType {
    public let id: UUID = UUID()

    @NSManaged public var consumption: Double
    @NSManaged public var consumptionUnit: String
    @NSManaged public var dateComputed: Date
    @NSManaged public var productDescription: String
    @NSManaged public var productExpiryDate: Date
    @NSManaged public var regularPrice: Double
    @NSManaged public var salePrice: Double
    @NSManaged public var unitsPurchased: Int
}
