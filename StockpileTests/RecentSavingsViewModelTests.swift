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

    var viewModel: RecentSavingsViewModel!
    var widgetCenter: MockWidgetCenter!

    override func setUp() {
        super.setUp()

        widgetCenter = MockWidgetCenter()
        viewModel = RecentSavingsViewModel(context: StorageType.inmemory(.none).managedObjectContext, widgetCenter: widgetCenter)
        viewModel.reloadData()
    }

    func setUpWithSamples() {
        viewModel = RecentSavingsViewModel(context: StorageType.inmemory(.many).managedObjectContext, widgetCenter: widgetCenter)
        viewModel.reloadData()
    }

    func test_errorAlertStartsHidden() {
        XCTAssertFalse(viewModel.showingErrorAlert)
    }

    func test_showingSheetStartsFalse() {
        XCTAssertFalse(viewModel.showingSheet)
    }

    func test_deletingMissingIndexShowsError() {
        guard !viewModel.showingErrorAlert else {
            XCTFail("Was expecting error alert to initially be hidden")
            return
        }

        viewModel.deleteStockpileSaving(at: nil)
        XCTAssert(viewModel.showingErrorAlert)
        XCTAssertEqual(viewModel.errorText, "Could not find a savings to delete. Please try again.")
        XCTAssertFalse(widgetCenter.hasReloadedTimelines)
    }

    func test_deletingInvalidIndexShowsError() {
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
        XCTAssertFalse(widgetCenter.hasReloadedTimelines)
    }

    func test_deletionOfValidIndex() {
        setUpWithSamples()

        viewModel.deleteStockpileSaving(at: 2)
        XCTAssertFalse(viewModel.showingErrorAlert)
        XCTAssertTrue(widgetCenter.hasReloadedTimelines)

        let recentSavingsDescriptions: String = viewModel.recentStockpiles.reduce("") {
            $0 + $1.productDescription
        }

        XCTAssertEqual(
            recentSavingsDescriptions,
            "🌭 Hot Dogs🥨 Pretzels🧀 Cheese🥜 Peanut Butter🍯 Honey🍆 Eggplant🍩 Donut🍪 Cookies🥖 Baguette🥯 Bagels"
        )
    }

    func test_lifetimeSavingsDefaultsToZero() {
        XCTAssertEqual(viewModel.lifetimeSavings, "$0.00")
    }

    func test_lifetimeSavings() {
        setUpWithSamples()
        XCTAssertEqual(viewModel.lifetimeSavings, "$34.40")
    }

    func test_firstSavingsDateDefaultsToNil() {
        XCTAssertNil(viewModel.firstSavingsDate)
    }

    func test_firstSavingsDate() {
        setUpWithSamples()
        let date: Date = Date()
        let comparison: ComparisonResult = Calendar.current.compare(viewModel.firstSavingsDate!, to: date, toGranularity: .day)
        XCTAssert(comparison == .orderedSame)
    }

    func test_averagePercentageSavingsDefaultsToNil() {
        XCTAssertNil(viewModel.averagePercentageSavings)
    }

    func test_averagePercentageSavings() {
        setUpWithSamples()
        XCTAssertEqual(viewModel.averagePercentageSavings, 20)
    }

    func test_percentageSavingsRangeDefaultsToNil() {
        XCTAssertNil(viewModel.percentageSavingsRange)
    }

    func test_percentageSavingsRange() {
        setUpWithSamples()

        XCTAssertEqual(viewModel.percentageSavingsRange?.0, 5)
        XCTAssertEqual(viewModel.percentageSavingsRange?.1, 40)
    }

    func test_recentStockpilesDefaultsEmpty() {
        XCTAssert(viewModel.recentStockpiles.isEmpty)
    }

    func test_recentStockpiles() {
        setUpWithSamples()

        XCTAssertEqual(viewModel.recentStockpiles.count, 10)

        let recentSavingsDescriptions: String = viewModel.recentStockpiles.reduce("") {
            $0 + $1.productDescription
        }

        XCTAssertEqual(
            recentSavingsDescriptions,
            "🌭 Hot Dogs🥨 Pretzels🥞 Pancake Mix🧀 Cheese🥜 Peanut Butter🍯 Honey🍆 Eggplant🍩 Donut🍪 Cookies🥖 Baguette"
        )
    }
}
