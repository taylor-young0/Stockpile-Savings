//
//  LifetimeSavingsMediumLargeViewModelTests.swift
//  StockpileTests
//
//  Created by Taylor Young on 2023-12-19.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import XCTest
import WidgetKit
@testable import WidgetsExtension

final class LifetimeSavingsMediumLargeViewModelTests: XCTestCase {

    var viewModel = LifetimeSavingsMediumLargeViewModel(
        entry: LifetimeSavingsEntry(
            date: Date(),
            lifetimeSavings: 25.87,
            stockpiles: [GroupedStockpileSaving(name: "Apples", savings: 25.87)]
        ),
        family: .systemMedium
    )

    func setUpWithStockpiles(_ stockpiles: [GroupedStockpileSaving], family: WidgetFamily = .systemMedium) {
        let lifetimeSavings: Double = stockpiles.reduce(0) { $0 + $1.savings }

        viewModel = LifetimeSavingsMediumLargeViewModel(
            entry: LifetimeSavingsEntry(
                date: Date(),
                lifetimeSavings: lifetimeSavings,
                stockpiles: stockpiles
            ),
            family: family
        )
    }

    func test_lifetimeSavingsFormatting() {
        XCTAssertEqual(viewModel.lifetimeSavingsFormatted, "$25.87")

        setUpWithStockpiles([])
        XCTAssertEqual(viewModel.lifetimeSavingsFormatted, "$0.00")
    }

    func test_shouldntShowNumNonDisplayedSavingsText() {
        XCTAssertFalse(viewModel.shouldShowNumNonDisplayedSavingsText)

        setUpWithStockpiles([
            GroupedStockpileSaving(name: "Apple", savings: 2),
            GroupedStockpileSaving(name: "Banana", savings: 2)
        ])
        XCTAssertFalse(viewModel.shouldShowNumNonDisplayedSavingsText)

        setUpWithStockpiles([
            GroupedStockpileSaving(name: "Apple", savings: 2),
            GroupedStockpileSaving(name: "Banana", savings: 2),
            GroupedStockpileSaving(name: "Carrot", savings: 2),
            GroupedStockpileSaving(name: "Eggplant", savings: 2),
            GroupedStockpileSaving(name: "Orange", savings: 2),
            GroupedStockpileSaving(name: "Potato", savings: 2),
            GroupedStockpileSaving(name: "Watermelon", savings: 2)
        ], family: .systemLarge)
        XCTAssertFalse(viewModel.shouldShowNumNonDisplayedSavingsText)
    }

    func test_shouldShowNumNonDisplayedSavingsText() {
        setUpWithStockpiles([
            GroupedStockpileSaving(name: "Apple", savings: 2),
            GroupedStockpileSaving(name: "Banana", savings: 2),
            GroupedStockpileSaving(name: "Carrot", savings: 2)
        ])
        XCTAssertTrue(viewModel.shouldShowNumNonDisplayedSavingsText)

        setUpWithStockpiles([
            GroupedStockpileSaving(name: "Apple", savings: 2),
            GroupedStockpileSaving(name: "Banana", savings: 2),
            GroupedStockpileSaving(name: "Carrot", savings: 2),
            GroupedStockpileSaving(name: "Eggplant", savings: 2),
            GroupedStockpileSaving(name: "Orange", savings: 2),
            GroupedStockpileSaving(name: "Potato", savings: 2),
            GroupedStockpileSaving(name: "Watermelon", savings: 2),
            GroupedStockpileSaving(name: "Zucchini", savings: 2),
        ], family: .systemLarge)
        XCTAssertTrue(viewModel.shouldShowNumNonDisplayedSavingsText)
    }

    func test_numNonDisplayedSavingsText() {
        setUpWithStockpiles([
            GroupedStockpileSaving(name: "Apple", savings: 2),
            GroupedStockpileSaving(name: "Banana", savings: 2),
            GroupedStockpileSaving(name: "Carrot", savings: 2),
            GroupedStockpileSaving(name: "Eggplant", savings: 2)
        ])
        XCTAssertEqual(viewModel.numNonDisplayedSavingsText, "2 more")

        setUpWithStockpiles([
            GroupedStockpileSaving(name: "Apple", savings: 2),
            GroupedStockpileSaving(name: "Banana", savings: 2),
            GroupedStockpileSaving(name: "Carrot", savings: 2),
            GroupedStockpileSaving(name: "Eggplant", savings: 2),
            GroupedStockpileSaving(name: "Orange", savings: 2),
            GroupedStockpileSaving(name: "Potato", savings: 2),
            GroupedStockpileSaving(name: "Watermelon", savings: 2),
            GroupedStockpileSaving(name: "Zucchini", savings: 2),
        ], family: .systemLarge)
        XCTAssertEqual(viewModel.numNonDisplayedSavingsText, "1 more")
    }

    func test_numDisplayedSavingsMedium() {
        XCTAssertEqual(viewModel.numDisplayedSavings, 1)

        setUpWithStockpiles([
            GroupedStockpileSaving(name: "Apple", savings: 2),
            GroupedStockpileSaving(name: "Banana", savings: 2)
        ])
        XCTAssertEqual(viewModel.numDisplayedSavings, 2)

        setUpWithStockpiles([
            GroupedStockpileSaving(name: "Apple", savings: 2),
            GroupedStockpileSaving(name: "Banana", savings: 2),
            GroupedStockpileSaving(name: "Carrot", savings: 2),
            GroupedStockpileSaving(name: "Eggplant", savings: 2)
        ])
        XCTAssertEqual(viewModel.numDisplayedSavings, 2)
    }

    func test_numDisplayedSavingsLarge() {
        setUpWithStockpiles([
            GroupedStockpileSaving(name: "Apple", savings: 2),
            GroupedStockpileSaving(name: "Banana", savings: 2)
        ], family: .systemLarge)
        XCTAssertEqual(viewModel.numDisplayedSavings, 2)

        setUpWithStockpiles([
            GroupedStockpileSaving(name: "Apple", savings: 2),
            GroupedStockpileSaving(name: "Banana", savings: 2),
            GroupedStockpileSaving(name: "Carrot", savings: 2),
            GroupedStockpileSaving(name: "Orange", savings: 2),
            GroupedStockpileSaving(name: "Potato", savings: 2),
            GroupedStockpileSaving(name: "Watermelon", savings: 2),
            GroupedStockpileSaving(name: "Zucchini", savings: 2),
        ], family: .systemLarge)
        XCTAssertEqual(viewModel.numDisplayedSavings, 7)

        setUpWithStockpiles([
            GroupedStockpileSaving(name: "Apple", savings: 2),
            GroupedStockpileSaving(name: "Banana", savings: 2),
            GroupedStockpileSaving(name: "Carrot", savings: 2),
            GroupedStockpileSaving(name: "Eggplant", savings: 2),
            GroupedStockpileSaving(name: "Orange", savings: 2),
            GroupedStockpileSaving(name: "Potato", savings: 2),
            GroupedStockpileSaving(name: "Watermelon", savings: 2),
            GroupedStockpileSaving(name: "Zucchini", savings: 2),
        ], family: .systemLarge)
        XCTAssertEqual(viewModel.numDisplayedSavings, 7)
    }

    func test_currencyFormatting() {
        XCTAssertEqual(viewModel.currencyFormatted(0.0), "$0.00")
        XCTAssertEqual(viewModel.currencyFormatted(12.87), "$12.87")
    }

}
