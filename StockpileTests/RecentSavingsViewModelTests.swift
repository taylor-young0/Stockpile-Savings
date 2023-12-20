//
//  StockpileTests.swift
//  StockpileTests
//
//  Created by Taylor Young on 2022-10-31.
//  Copyright © 2022 Taylor Young. All rights reserved.
//

import XCTest
@testable import Stockpile

final class RecentSavingsViewModelTests: XCTestCase {
    var viewModel: RecentSavingsViewModel = RecentSavingsViewModel()

    override func setUp() {
        super.setUp()
        viewModel = RecentSavingsViewModel()
    }

    func setUpWithSamples() {
        viewModel = RecentSavingsViewModel(savings: MockStockpileSaving.samples)
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

    func testLifetimeSavingsDefaultsToZero() {
        XCTAssertEqual(viewModel.lifetimeSavings, "$0.00")
    }

    func testLifetimeSavings() {
        setUpWithSamples()
        XCTAssertEqual(viewModel.lifetimeSavings, "$71.50")
    }

    func testFirstSavingsDateDefaultsToNil() {
        XCTAssertNil(viewModel.firstSavingsDate)
    }

    func testFirstSavingsDate() {
        setUpWithSamples()
        let date: Date = Date()
        let comparison: ComparisonResult = Calendar.current.compare(viewModel.firstSavingsDate!, to: date, toGranularity: .day)
        XCTAssert(comparison == .orderedSame)
    }

    func testAveragePercentageSavingsDefaultsToNil() {
        XCTAssertNil(viewModel.averagePercentageSavings)
    }

    func testAveragePercentageSavings() {
        setUpWithSamples()
        XCTAssertEqual(viewModel.averagePercentageSavings, 21)
    }

    func testPercentageSavingsRangeDefaultsToNil() {
        XCTAssertNil(viewModel.percentageSavingsRange)
    }

    func testPercentageSavingsRange() {
        setUpWithSamples()
        XCTAssertEqual(viewModel.percentageSavingsRange?.0, 10)
        XCTAssertEqual(viewModel.percentageSavingsRange?.1, 50)
    }

    func testRecentStockpilesDefaultsEmpty() {
        XCTAssert(viewModel.recentStockpiles.isEmpty)
    }

    func testRecentStockpiles() {
        setUpWithSamples()
        XCTAssertEqual(viewModel.recentStockpiles.count, 10)
    }
}
