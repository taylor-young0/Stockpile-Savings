//
//  Constants.swift
//  Stockpile
//
//  Created by Taylor Young on 2022-10-23.
//  Copyright © 2022 Taylor Young. All rights reserved.
//

import Foundation
import SwiftUI

struct Constants {
    fileprivate static let stockpileColorAssetName = "Stockpile"

    static let stockpileColor: Color = Color(stockpileColorAssetName)
    static let stockpileUIColor: UIColor = UIColor(named: stockpileColorAssetName) ?? .white
    static let defaultPadding: CGFloat = 10.0
}
