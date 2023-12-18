//
//  AddNewStockpileSavingViewModel.swift
//  Stockpile
//
//  Created by Taylor Young on 2022-10-15.
//  Copyright © 2022 Taylor Young. All rights reserved.
//

import SwiftUI
import Combine

class AddNewStockpileSavingViewModel: ObservableObject {
    @Published var showingError: Bool = false
    // MARK: Input
    @Published var productDescription: String = "" {
        didSet {
            productDescriptionValid = !productDescription.isEmpty
        }
    }
    @Published var productExpiryDate: Date = Date()
    @Published var consumptionInput: String = ""
    @Published var consumptionUnit: ConsumptionUnit = .Day
    @Published var regularPriceInput: String = ""
    @Published var salePriceInput: String = ""
    @Published var unitsPurchasedInput: String = ""
    // MARK: Values parsed from input
    @Published private(set) var consumption: Double = .zero
    @Published private(set) var regularPrice: Double = .zero
    @Published private(set) var salePrice: Double = .zero
    @Published private(set) var unitsPurchased: Int = .zero
    // MARK: Validation state
    @Published private var productDescriptionValid: Bool = false
    @Published private var consumptionValid: Bool = false
    @Published private var regularPriceValid: Bool = false
    @Published private var salePriceValid: Bool = false
    @Published private var unitsPurchasedValid: Bool = false

    private var cancellables: Set<AnyCancellable> = []

    init(productDescription: String = "", consumption: String = "", consumptionUnit: ConsumptionUnit = .Day, regularPrice: String = "") {
        setupSubscribers()
        self.productDescription = productDescription
        self.consumptionInput = consumption
        self.consumptionUnit = consumptionUnit
        self.regularPriceInput = regularPrice
    }

    func setupSubscribers() {
        $consumptionInput
            .map {
                $0.doubleValue ?? -1
            }
            .removeDuplicates()
            .sink(receiveValue: { [unowned self] consumption in
                if consumption <= 0 {
                    self.consumptionValid = false
                    return
                }
                self.consumption = consumption
                self.consumptionValid = true
            })
            .store(in: &cancellables)

        $regularPriceInput
            .map {
                $0.doubleValue ?? -1
            }
            .removeDuplicates()
            .sink(receiveValue: { [unowned self] regularPrice in
                if regularPrice <= 0 || regularPrice <= salePrice {
                    self.regularPriceValid = false
                    return
                }
                self.regularPrice = regularPrice
                self.regularPriceValid = true
            })
            .store(in: &cancellables)

        $salePriceInput
            .map {
                $0.doubleValue ?? -1
            }
            .removeDuplicates()
            .sink(receiveValue: { [unowned self] salePrice in
                if salePrice < 0 || salePrice >= regularPrice {
                    self.salePriceValid = false
                    return
                }
                self.salePrice = salePrice
                self.salePriceValid = true
            })
            .store(in: &cancellables)

        $unitsPurchasedInput
            .map {
                Int($0) ?? -1
            }
            .removeDuplicates()
            .sink(receiveValue: { [unowned self] unitsPurchased in
                if unitsPurchased < 1 {
                    self.unitsPurchasedValid = false
                    return
                }
                self.unitsPurchased = unitsPurchased
                self.unitsPurchasedValid = true
            })
            .store(in: &cancellables)
    }

    // MARK: Stockpile Calculations

    var maximumStockpileQuantity: Int {
        if consumptionValid {
            let consumptionInDays = consumption / Double(consumptionUnit.numberOfDaysInUnit)
            let daysToExpiration = Calendar.current.dateComponents([.day], from: Date(), to: productExpiryDate)
            let daysToConsume = Double(daysToExpiration.day ?? 0)
            return Int(consumptionInDays * daysToConsume)
        }
        return 0
    }

    var maximumSavings: Double {
        if regularPriceValid && salePriceValid {
            let savingsPerUnit: Double = regularPrice - salePrice
            return savingsPerUnit * Double(maximumStockpileQuantity)
        }
        return 0
    }

    var savings: Double {
        if regularPriceValid && salePriceValid && unitsPurchasedValid {
            let savingsPerUnit: Double = regularPrice - salePrice
            return savingsPerUnit * Double(unitsPurchased)
        }
        return 0
    }

    var isInputValid: Bool {
        return productDescriptionValid && consumptionValid && regularPriceValid && salePriceValid && unitsPurchasedValid
    }

    // colour depends on whether input is valid i.e., button is enabled
    var addButtonColour: Color {
        return isInputValid ? Constants.stockpileColor : Color.secondary
    }
}
