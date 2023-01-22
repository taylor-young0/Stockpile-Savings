//
//  StockpileSaving+FetchRequest.swift
//  Stockpile
//
//  Created by Taylor Young on 2023-01-22.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import Foundation
import CoreData

extension StockpileSaving {
    @nonobjc public class func getAllSavings() -> NSFetchRequest<StockpileSaving> {
        let request = NSFetchRequest<StockpileSaving>(entityName: "StockpileSaving")
        request.sortDescriptors = [NSSortDescriptor(key: "dateComputed", ascending: false)]
        return request
    }
}
