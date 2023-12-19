//
//  LifetimeSavingsSmallViewModelTests.swift
//  StockpileTests
//
//  Created by Taylor Young on 2023-12-19.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import XCTest

final class LifetimeSavingsSmallViewModelTests: XCTestCase {

    var viewModel: LifetimeSavingsSmallViewModel = LifetimeSavingsSmallViewModel(
        entry: LifetimeSavingsEntry(
            date: Date(),
            lifetimeSavings: 25.87,
            stockpiles: [GroupedStockpileSaving(name: "Apples", savings: 25.87)]
        )
    )

    func setUpWithStockpiles(_ stockpiles: [GroupedStockpileSaving]) {
        let lifetimeSavings: Double = stockpiles.reduce(0) { $0 + $1.savings }

        viewModel = LifetimeSavingsSmallViewModel(
            entry: LifetimeSavingsEntry(
                date: Date(),
                lifetimeSavings: lifetimeSavings,
                stockpiles: stockpiles
            )
        )
    }

    func testLifetimeSavingsFormatting() {
        XCTAssertEqual(viewModel.lifetimeSavingsFormatted, "$25.87")

        setUpWithStockpiles([])
        XCTAssertEqual(viewModel.lifetimeSavingsFormatted, "$0.00")
    }

    func testTotalSavingsText() {
        XCTAssertEqual(viewModel.numberOfItemsText, "on 1 item")

        setUpWithStockpiles([])
        XCTAssertEqual(viewModel.numberOfItemsText, "on 0 items")

        setUpWithStockpiles([
            GroupedStockpileSaving(name: "Apples", savings: 4.18),
            GroupedStockpileSaving(name: "Oranges", savings: 5.89),
            GroupedStockpileSaving(name: "Bananas", savings: 12.89)
        ])
        XCTAssertEqual(viewModel.numberOfItemsText, "on 3 items")
    }

    func testTotalSavingsTextHides() {
        XCTAssertTrue(viewModel.shouldShowNumberOfItemsText(for: .large))
        XCTAssertFalse(viewModel.shouldShowNumberOfItemsText(for: .xLarge))
    }

}
