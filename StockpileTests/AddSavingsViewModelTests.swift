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

    var viewModel: AddSavingsViewModel!

    override func setUp() {
        super.setUp()
        viewModel = AddSavingsViewModel(context: StorageType.inmemory(.none).managedObjectContext)
        viewModel.reloadData()
    }

    func test_errorAlertStartsHidden() {
        XCTAssertFalse(viewModel.showingErrorAlert)
    }

    func test_uniqueSavingsStartsEmpty() {
        XCTAssert(viewModel.uniqueSavings.isEmpty)
    }

    func test_uniqueSavings() {
        viewModel = AddSavingsViewModel(context: StorageType.inmemory(.manyWithDuplicates).managedObjectContext)
        viewModel.reloadData()

        XCTAssertEqual(viewModel.uniqueSavings.count, 12)

        let uniqueSavingsDescriptions: String = viewModel.uniqueSavings.reduce("") {
            $0 + $1.productDescription
        }

        XCTAssertEqual(
            uniqueSavingsDescriptions,
            "🌭 Hot Dogs🥨 Pretzels🥞 Pancake Mix🧀 Cheese🥜 Peanut Butter🍯 Honey🍆 Eggplant🍩 Donut🍪 Cookies🥖 Baguette🥯 Bagels🍎 Apples"
        )
    }

    func test_loadingErrorShowsErrorAlert() {
        viewModel = AddSavingsViewModel(context: MockManagedObjectContext())
        viewModel.reloadData()

        XCTAssertTrue(viewModel.showingErrorAlert)
    }
}
