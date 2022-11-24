//
//  StockpileTests.swift
//  StockpileTests
//
//  Created by Taylor Young on 2022-10-31.
//  Copyright © 2022 Taylor Young. All rights reserved.
//

import XCTest

final class StockpileTests: XCTestCase {

    var viewModel: AddNewStockpileSavingViewModel = AddNewStockpileSavingViewModel()

    override func setUp() {
        viewModel = AddNewStockpileSavingViewModel()
    }

    func setUpWithValidSampleData() {
        viewModel = AddNewStockpileSavingViewModel(productDescription: "🍎 Apples", consumption: "3", consumptionUnit: .Week, regularPrice: "3.99")
        viewModel.salePriceInput = "2.99"
        viewModel.unitsPurchasedInput = "4"
    }

    func testEmptyViewModelIsInvalidInput() {
        XCTAssertFalse(viewModel.isInputValid)
    }

    func testSampleDataIsValidInput() {
        setUpWithValidSampleData()
        XCTAssert(viewModel.isInputValid)
    }

    func testDefaultInputData() {
        XCTAssert(viewModel.productDescription.isEmpty)
        let date: Date = Date()
        let comparison: ComparisonResult = Calendar.current.compare(viewModel.productExpiryDate, to: date, toGranularity: .day)
        XCTAssert(comparison == .orderedSame)
        XCTAssert(viewModel.consumptionInput.isEmpty)
        XCTAssert(viewModel.consumptionUnit == .Day)
        XCTAssert(viewModel.regularPriceInput.isEmpty)
        XCTAssert(viewModel.salePriceInput.isEmpty)
        XCTAssert(viewModel.unitsPurchasedInput.isEmpty)
    }

    func testDefaultComputedData() {
        XCTAssert(viewModel.maximumStockpileQuantity == 0)
        XCTAssert(viewModel.maximumSavings == 0)
        XCTAssert(viewModel.savings == 0)
    }

    func testOneMissingValueIsInvalidInput() {
        setUpWithValidSampleData()
        viewModel.productDescription = ""
        XCTAssertFalse(viewModel.isInputValid)

        setUpWithValidSampleData()
        viewModel.consumptionInput = ""
        XCTAssertFalse(viewModel.isInputValid)

        setUpWithValidSampleData()
        viewModel.regularPriceInput = ""
        XCTAssertFalse(viewModel.isInputValid)

        setUpWithValidSampleData()
        viewModel.salePriceInput = ""
        XCTAssertFalse(viewModel.isInputValid)

        setUpWithValidSampleData()
        viewModel.unitsPurchasedInput = ""
        XCTAssertFalse(viewModel.isInputValid)
    }

}
