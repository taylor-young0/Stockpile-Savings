//
//  StockpileTests.swift
//  StockpileTests
//
//  Created by Taylor Young on 2022-10-31.
//  Copyright © 2022 Taylor Young. All rights reserved.
//

import XCTest

final class RecentSavingsViewModelTests: XCTestCase {
    var viewModel: RecentSavingsViewModel = RecentSavingsViewModel()

    override func setUp() {
        viewModel = RecentSavingsViewModel()
    }

    func testErrorAlertStartsHidden() {
        XCTAssertFalse(viewModel.showingErrorAlert)
    }

    func testShowingSheetStartsFalse() {
        XCTAssertFalse(viewModel.showingSheet)
    }

    func testMissingIndexShowsError() {
        guard !viewModel.showingErrorAlert else {
            XCTFail("Was expecting error alert to initially be hidden")
            return
        }

        viewModel.deleteStockpileSaving(at: nil)
        XCTAssert(viewModel.showingErrorAlert)
        XCTAssertEqual(viewModel.errorText, "Could not find a savings to delete. Please try again.")
    }

    func testInvalidIndexShowsError() {
        guard !viewModel.showingErrorAlert else {
            XCTFail("Was expecting error alert to initially be hidden")
            return
        }

        guard viewModel.recentStockpiles.count == 0 else {
            XCTFail("Was expecting there to be no recent stockpiles")
            return
        }

        viewModel.deleteStockpileSaving(at: 0)
        XCTAssert(viewModel.showingErrorAlert)
        XCTAssertEqual(viewModel.errorText, "Could not find a savings to delete. Please try again.")
    }
}
