//
//  LifetimeSavingsSmallViewModel.swift
//  WidgetsExtension
//
//  Created by Taylor Young on 2023-12-19.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import Foundation
import SwiftUI

struct LifetimeSavingsSmallViewModel {
    private let entry: LifetimeSavingsEntry

    init(entry: LifetimeSavingsEntry) {
        self.entry = entry
    }

    var lifetimeSavingsFormatted: String {
        entry.lifetimeSavings.asLocalizedCurrency
    }

    var numberOfItemsText: String {
        "on \(entry.stockpiles.count) item\(entry.stockpiles.count == 1 ? "" : "s")"
    }

    func shouldShowNumberOfItemsText(for dynamicTypeSize: DynamicTypeSize) -> Bool {
        dynamicTypeSize <= .large
    }
}
