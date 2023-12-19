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
        XCTAssertEqual(viewModel.totalSavingsText, "1 total saving")

        setUpWithStockpiles([])
        XCTAssertEqual(viewModel.totalSavingsText, "0 total savings")

        setUpWithStockpiles([
            GroupedStockpileSaving(name: "Apples", savings: 4.18),
            GroupedStockpileSaving(name: "Oranges", savings: 5.89),
            GroupedStockpileSaving(name: "Bananas", savings: 12.89)
        ])
        XCTAssertEqual(viewModel.totalSavingsText, "3 total savings")
    }

    func testTotalSavingsTextHides() {
        XCTAssertTrue(viewModel.shouldShowTotalSavingsText(for: .large))
        XCTAssertFalse(viewModel.shouldShowTotalSavingsText(for: .xLarge))
    }

}
