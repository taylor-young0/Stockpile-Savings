//
//  AddSavingsFormViewModelTests.swift
//  AddSavingsFormViewModelTests
//
//  Created by Taylor Young on 2022-10-31.
//  Copyright © 2022 Taylor Young. All rights reserved.
//

import XCTest
@testable import Stockpile

final class AddSavingsFormViewModelTests: XCTestCase {

    var viewModel: AddSavingsFormViewModel!
    var widgetCenter: MockWidgetCenter!

    override func setUp() {
        super.setUp()

        self.widgetCenter = MockWidgetCenter()
        self.setUpEmpty()
    }

    func setUpWithValidSampleData(throwsSavingError: Bool = false) {
        let mockStockpile: MockStockpileSaving = MockStockpileSaving(
            consumption: 3.0,
            consumptionUnit: .Week,
            productDescription: "🍎 Apples",
            regularPrice: 3.99,
            salePrice: 2.49,
            unitsPurchased: 4
        )
        let context: ManagedObjectContextType = throwsSavingError ? MockManagedObjectContext() : StorageType.inmemory(.none).managedObjectContext

        viewModel = AddSavingsFormViewModel(fromTemplate: mockStockpile, context: context, widgetCenter: widgetCenter)

        viewModel.salePriceInput = "2.49"
        viewModel.unitsPurchasedInput = "4"
    }

    func setUpEmpty() {
        viewModel = AddSavingsFormViewModel(context: StorageType.inmemory(.none).managedObjectContext)
    }

    func test_sampleValidDataIsValid() {
        setUpWithValidSampleData()
        XCTAssertTrue(viewModel.isInputValid)
    }

    func test_addSavingsWithValidInput() {
        setUpWithValidSampleData()
        viewModel.addSavings()

        XCTAssertFalse(viewModel.showingSheet)
        XCTAssertFalse(viewModel.showingError)
        XCTAssertTrue(widgetCenter.hasReloadedTimelines)
    }

    func test_addSavingsValidInputThrowsError() {
        setUpWithValidSampleData(throwsSavingError: true)
        viewModel.addSavings()

        XCTAssertTrue(viewModel.showingSheet)
        XCTAssertTrue(viewModel.showingError)
        XCTAssertFalse(widgetCenter.hasReloadedTimelines)
    }

    func test_addSavingsInvalidInput() {
        viewModel.addSavings()

        XCTAssertFalse(viewModel.isInputValid)
        XCTAssertTrue(viewModel.showingSheet)
        XCTAssertFalse(viewModel.showingError)
        XCTAssertFalse(widgetCenter.hasReloadedTimelines)
    }

    func test_defaultValues() {
        let date: Date = Date()
        let expiryDateComparison = Calendar.current.compare(viewModel.productExpiryDate, to: date, toGranularity: .day)

        XCTAssertTrue(viewModel.showingSheet)
        XCTAssertFalse(viewModel.showingError)
        XCTAssertTrue(viewModel.productDescription.isEmpty)
        XCTAssertEqual(expiryDateComparison, .orderedSame)
        XCTAssertTrue(viewModel.consumptionInput.isEmpty)
        XCTAssertEqual(viewModel.consumptionUnit, .Day)
        XCTAssertTrue(viewModel.regularPriceInput.isEmpty)
        XCTAssertTrue(viewModel.salePriceInput.isEmpty)
        XCTAssertTrue(viewModel.unitsPurchasedInput.isEmpty)
    }

    func test_createFromTemplatePopulatedFields() {
        let templateSavings = MockStockpileSaving(
            consumption: 4,
            consumptionUnit: .Week,
            productDescription: "🍊 Oranges",
            regularPrice: 2.99,
            salePrice: 1.99,
            unitsPurchased: 2
        )
        viewModel = AddSavingsFormViewModel(fromTemplate: templateSavings, context: StorageType.inmemory(.none).managedObjectContext, widgetCenter: widgetCenter)

        XCTAssertEqual(viewModel.productDescription, "🍊 Oranges")
        XCTAssertEqual(viewModel.regularPriceInput, "2.99")
        XCTAssertEqual(viewModel.consumptionInput, "4")
        XCTAssertEqual(viewModel.consumptionUnit, .Week)

        XCTAssertTrue(viewModel.salePriceInput.isEmpty)
        XCTAssertTrue(viewModel.unitsPurchasedInput.isEmpty)
    }

    func test_oneMissingValueIsInvalidInput() {
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

    func test_invalidConsumptionIsInvalid() {
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

    func test_invalidRegularPriceIsInvalid() {
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

    func test_invalidSalePriceIsInvalid() {
        setUpWithValidSampleData()
        viewModel.salePriceInput = "c"
        XCTAssertFalse(viewModel.isInputValid)

        setUpWithValidSampleData()
        viewModel.salePriceInput = "-1"
        XCTAssertFalse(viewModel.isInputValid)
    }

    func test_invalidUnitsPurchasedIsInvalid() {
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

    func test_salePriceGreaterEqualToRegularPrice() {
        setUpWithValidSampleData()
        viewModel.salePriceInput = "4.99"
        viewModel.regularPriceInput = "4.99"
        XCTAssertFalse(viewModel.isInputValid)

        setUpWithValidSampleData()
        viewModel.salePriceInput = "5.99"
        viewModel.regularPriceInput = "4.99"
        XCTAssertFalse(viewModel.isInputValid)
    }

    func test_maximumStockpileQuantityInvalid() {
        XCTAssertEqual(viewModel.maximumStockpileQuantity, 0)
    }

    func test_maximumStockpileQuantityValid() {
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

    func test_maximumSavingsInvalid() {
        XCTAssertEqual(viewModel.maximumSavings, 0)
    }

    func test_maximumSavingsValid() {
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

    func test_savingsInvalid() {
        XCTAssertEqual(viewModel.savings, 0)
    }

    func test_savingsValid() {
        setUpWithValidSampleData()
        viewModel.unitsPurchasedInput = "55"
        XCTAssertEqual(viewModel.savings, 82.5)
    }

    func test_addButtonColor() {
        XCTAssertEqual(viewModel.addButtonColour, .secondary)
        setUpWithValidSampleData()
        XCTAssertEqual(viewModel.addButtonColour, Constants.stockpileColor)
    }
}
