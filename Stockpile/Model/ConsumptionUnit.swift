//
//  ConsumptionUnit.swift
//  Stockpile
//
//  Created by Taylor Young on 2021-09-03.
//  Copyright © 2021 Taylor Young. All rights reserved.
//

import Foundation

enum ConsumptionUnit: String, CaseIterable {
    case Day = "Day"
    case Week = "Week"
    case Month = "Month"
    
    var numberOfDaysInUnit: Int {
        switch self {
        case .Day:
            return 1
        case .Week:
            return 7
        case .Month:
            return 30
        }
    }
}
