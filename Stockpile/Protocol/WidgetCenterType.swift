//
//  WidgetCenterType.swift
//  Stockpile
//
//  Created by Taylor Young on 2023-12-20.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import WidgetKit

protocol WidgetCenterType {
    func reloadTimelines()
}

extension WidgetCenter: WidgetCenterType {
    func reloadTimelines() {
        WidgetCenter.shared.reloadAllTimelines()
    }
}

class MockWidgetCenter: WidgetCenterType {
    var hasReloadedTimelines = false

    func reloadTimelines() {
        hasReloadedTimelines = true
    }
}
