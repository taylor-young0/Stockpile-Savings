//
//  AddSavingsFormViewModelTests.swift
//  AddSavingsFormViewModelTests
//
//  Created by Taylor Young on 2022-10-31.
//  Copyright © 2022 Taylor Young. All rights reserved.
//

import XCTest

final class AddSavingsFormViewModelTests: XCTestCase {

    var viewModel: AddSavingsFormViewModel = AddSavingsFormViewModel()

    override func setUp() {
        viewModel = AddSavingsFormViewModel()
    }

    func setUpWithValidSampleData() {
        viewModel = AddSavingsFormViewModel(
            fromTemplate: MockStockpileSaving(
                consumption: 3.0, consumptionUnit: .Week, productDescription: "🍎 Apples", regularPrice: 3.99, salePrice: 2.49, unitsPurchased: 4
            )
        )
        viewModel.salePriceInput = "2.49"
        viewModel.unitsPurchasedInput = "4"
    }

    func testShowingErrorStartsFalse() {
        XCTAssertFalse(viewModel.showingError)
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

    func testInvalidConsumptionIsInvalid() {
        setUpWithValidSampleData()
        viewModel.consumptionInput = "a"
        XCTAssertFalse(viewModel.isInputValid)

        setUpWithValidSampleData()
        viewModel.consumptionInput = "0"
        XCTAssertFalse(viewModel.isInputValid)

        setUpWithValidSampleData()
        viewModel.consumptionInput = "-1"
        XCTAssertFalse(viewModel.isInputValid)
    }

    func testInvalidRegularPriceIsInvalid() {
        setUpWithValidSampleData()
        viewModel.regularPriceInput = "b"
        XCTAssertFalse(viewModel.isInputValid)

        setUpWithValidSampleData()
        viewModel.regularPriceInput = "0"
        XCTAssertFalse(viewModel.isInputValid)

        setUpWithValidSampleData()
        viewModel.regularPriceInput = "-1"
        XCTAssertFalse(viewModel.isInputValid)
    }

    func testInvalidSalePriceIsInvalid() {
        setUpWithValidSampleData()
        viewModel.salePriceInput = "c"
        XCTAssertFalse(viewModel.isInputValid)

        setUpWithValidSampleData()
        viewModel.salePriceInput = "-1"
        XCTAssertFalse(viewModel.isInputValid)
    }

    func testInvalidUnitsPurchasedIsInvalid() {
        setUpWithValidSampleData()
        viewModel.unitsPurchasedInput = "d"
        XCTAssertFalse(viewModel.isInputValid)

        setUpWithValidSampleData()
        viewModel.unitsPurchasedInput = "0"
        XCTAssertFalse(viewModel.isInputValid)

        setUpWithValidSampleData()
        viewModel.unitsPurchasedInput = "-1"
        XCTAssertFalse(viewModel.isInputValid)
    }

    func testSalePriceGreaterEqualToRegularPrice() {
        setUpWithValidSampleData()
        viewModel.salePriceInput = "4.99"
        viewModel.regularPriceInput = "4.99"
        XCTAssertFalse(viewModel.isInputValid)

        setUpWithValidSampleData()
        viewModel.salePriceInput = "5.99"
        viewModel.regularPriceInput = "4.99"
        XCTAssertFalse(viewModel.isInputValid)
    }

    func testMaximumStockpileQuantityInvalid() {
        XCTAssertEqual(viewModel.maximumStockpileQuantity, 0)
    }

    func testMaximumStockpileQuantityValid() {
        setUpWithValidSampleData()
        let nextWeek: Date = Calendar.current.date(byAdding: .day, value: 7, to: .now)!

        viewModel.consumptionUnit = .Day
        viewModel.productExpiryDate = nextWeek
        XCTAssertEqual(viewModel.maximumStockpileQuantity, 18)

        viewModel.consumptionUnit = .Week
        XCTAssertEqual(viewModel.maximumStockpileQuantity, 2)

        viewModel.consumptionUnit = .Month
        XCTAssertEqual(viewModel.maximumStockpileQuantity, 0)
    }

    func testMaximumSavingsInvalid() {
        XCTAssertEqual(viewModel.maximumSavings, 0)
    }

    func testMaximumSavingsValid() {
        setUpWithValidSampleData()
        let nextWeek: Date = Calendar.current.date(byAdding: .day, value: 7, to: .now)!

        viewModel.consumptionUnit = .Day
        viewModel.productExpiryDate = nextWeek
        XCTAssertEqual(viewModel.maximumSavings, 27)

        viewModel.consumptionUnit = .Week
        XCTAssertEqual(viewModel.maximumSavings, 3)

        viewModel.consumptionUnit = .Month
        XCTAssertEqual(viewModel.maximumSavings, 0)
    }

    func testSavingsInvalid() {
        XCTAssertEqual(viewModel.savings, 0)
    }

    func testSavingsValid() {
        setUpWithValidSampleData()
        viewModel.unitsPurchasedInput = "55"
        XCTAssertEqual(viewModel.savings, 82.5)
    }

    func testAddButtonColor() {
        XCTAssertEqual(viewModel.addButtonColour, .secondary)
        setUpWithValidSampleData()
        XCTAssertEqual(viewModel.addButtonColour, Constants.stockpileColor)
    }
}
