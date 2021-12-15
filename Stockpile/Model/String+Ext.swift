//
//  String+Ext.swift
//  Stockpile
//
//  Created by Taylor Young on 2021-10-11.
//  Copyright © 2021 Taylor Young. All rights reserved.
//
//  Modified from https://stackoverflow.com/a/28314223
//

import Foundation

// Modified from https://stackoverflow.com/a/28314223
extension String {
    static let numberFormatter = NumberFormatter()
    
    var doubleValue: Double? {
        if let value = Double(self) {
            return value
        } else {
            // try using a comma as the decimal separator
            String.numberFormatter.decimalSeparator = ","
            return String.numberFormatter.number(from: self)?.doubleValue
        }
    }
}
