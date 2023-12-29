//
//  AddSavingsViewModel.swift
//  Stockpile
//
//  Created by Taylor Young on 2023-01-15.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import Foundation
import Combine
import CoreData

class AddSavingsViewModel: ObservableObject {
    @Published private var allStockpileSavings: [StockpileSaving] = []
    @Published var showingErrorAlert = false
    private let managedObjectContext: ManagedObjectContextType

    init(context: ManagedObjectContextType) {
        self.managedObjectContext = context
    }

    var uniqueSavings: [StockpileSaving] {
        var uniqueDescriptions: [String] = []
        var uniqueSavings: [StockpileSaving] = []
        for saving in allStockpileSavings {
            if !uniqueDescriptions.contains(saving.productDescription) {
                uniqueSavings.append(saving)
                uniqueDescriptions.append(saving.productDescription)
            }
        }
        return uniqueSavings
    }

    private func fetchAllStockpiles() {
        do {
            let fetchResults: [StockpileSaving] = try managedObjectContext.fetch(StockpileSaving.getAllSavings())
            allStockpileSavings = fetchResults
        } catch {
            showingErrorAlert = true
        }
    }

    func reloadData() {
        fetchAllStockpiles()
    }
}
