//
//  Double+Ext.swift
//  Stockpile
//
//  Created by Taylor Young on 2022-10-23.
//  Copyright © 2022 Taylor Young. All rights reserved.
//

import Foundation

extension Double {
    var asLocalizedCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }

    var asLocalizedDecimal: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
