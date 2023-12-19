//
//  LifetimeSavingsEntry.swift
//  WidgetsExtension
//
//  Created by Taylor Young on 2023-12-19.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import WidgetKit

struct LifetimeSavingsEntry: TimelineEntry {
    let date: Date
    let lifetimeSavings: Double
    let stockpiles: [GroupedStockpileSaving]
}
