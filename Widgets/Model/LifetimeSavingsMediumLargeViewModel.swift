//
//  LifetimeSavingsMediumLargeViewModel.swift
//  Stockpile
//
//  Created by Taylor Young on 2023-12-19.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import Foundation
import WidgetKit
import SwiftUI

struct LifetimeSavingsMediumLargeViewModel {
    private let entry: LifetimeSavingsEntry
    let family: WidgetFamily

    init(entry: LifetimeSavingsEntry, family: WidgetFamily) {
        self.entry = entry
        self.family = family
    }

    var stockpiles: [GroupedStockpileSaving] {
        entry.groupedStockpiles
    }

    var lifetimeSavingsFormatted: String {
        currencyFormatted(entry.lifetimeSavings)
    }

    var shouldShowNumNonDisplayedSavingsText: Bool {
        numNonDisplayedSavings > 0
    }

    var numNonDisplayedSavingsText: String {
        "\(numNonDisplayedSavings) more"
    }

    var numDisplayedSavings: Int {
        switch(family) {
        case .systemMedium:
            return min(2, entry.groupedStockpiles.count)
        case .systemLarge:
            return min(7, entry.groupedStockpiles.count)
        default:
            return 0
        }
    }

    private var numNonDisplayedSavings: Int {
        entry.groupedStockpiles.count - numDisplayedSavings
    }

    func currencyFormatted(_ amount: Double) -> String {
        amount.asLocalizedCurrency
    }

}
