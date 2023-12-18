//
//  AddSavingsViewModelTests.swift
//  AddSavingsViewModelTests
//
//  Created by Taylor Young on 2023-01-15.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import XCTest

final class AddSavingsViewModelTests: XCTestCase {
    var viewModel: AddSavingsViewModel = AddSavingsViewModel()

    override func setUp() {
        viewModel = AddSavingsViewModel()
    }

    func testErrorAlertStartsHidden() {
        XCTAssertFalse(viewModel.showingErrorAlert)
    }
}
