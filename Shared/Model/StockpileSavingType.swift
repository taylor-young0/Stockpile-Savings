//
//  StockpileSavingType.swift
//  Stockpile
//
//  Created by Taylor Young on 2023-07-16.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import Foundation

protocol StockpileSavingType: AnyObject {
    var id: UUID { get }
    var consumption: Double { get set }
    var consumptionUnit: String { get set }
    var dateComputed: Date { get set }
    var productDescription: String { get set }
    var productExpiryDate: Date { get set }
    var regularPrice: Double { get set }
    var salePrice: Double { get set }
    var unitsPurchased: Int { get set }
    var savings: Double { get }
    var percentageSavings: Double { get }
}
