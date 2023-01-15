//
//  AddNewStockpileViewModelTests.swift
//  AddNewStockpileViewModelTests
//
//  Created by Taylor Young on 2023-01-15.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import XCTest

final class AddNewStockpileViewModelTests: XCTestCase {
    var viewModel: AddNewStockpileViewModel = AddNewStockpileViewModel()

    override func setUp() {
        viewModel = AddNewStockpileViewModel()
    }

    func testErrorAlertStartsHidden() {
        XCTAssertFalse(viewModel.showingErrorAlert)
    }
}
