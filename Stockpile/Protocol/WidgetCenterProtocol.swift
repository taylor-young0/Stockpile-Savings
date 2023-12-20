//
//  WidgetCenterProtocol.swift
//  Stockpile
//
//  Created by Taylor Young on 2023-12-20.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import WidgetKit

protocol WidgetCenterProtocol {
    func reloadTimelines()
}

extension WidgetCenter: WidgetCenterProtocol {
    func reloadTimelines() {
        WidgetCenter.shared.reloadAllTimelines()
    }
}

class MockWidgetCenter: WidgetCenterProtocol {
    var hasReloadedTimelines = false

    func reloadTimelines() {
        hasReloadedTimelines = true
    }
}
