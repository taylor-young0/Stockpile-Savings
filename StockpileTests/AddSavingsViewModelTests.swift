//
//  AddSavingsViewModelTests.swift
//  AddSavingsViewModelTests
//
//  Created by Taylor Young on 2023-01-15.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import XCTest
@testable import Stockpile

final class AddSavingsViewModelTests: XCTestCase {
    var viewModel: AddSavingsViewModel = AddSavingsViewModel()

    override func setUp() {
        super.setUp()
        viewModel = AddSavingsViewModel()
    }

    func testErrorAlertStartsHidden() {
        XCTAssertFalse(viewModel.showingErrorAlert)
    }

    func testUniqueSavingsStartsEmpty() {
        XCTAssert(viewModel.uniqueSavings.isEmpty)
    }

    func testUniqueSavings() {
        let uniqueSavings: [MockStockpileSaving] = MockStockpileSaving.samples
        viewModel = AddSavingsViewModel(savings: uniqueSavings + uniqueSavings)

        XCTAssertEqual(viewModel.uniqueSavings as? [MockStockpileSaving], uniqueSavings)
    }
}
