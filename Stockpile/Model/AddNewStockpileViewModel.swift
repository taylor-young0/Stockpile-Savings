//
//  AddNewStockpileViewModel.swift
//  Stockpile
//
//  Created by Taylor Young on 2023-01-15.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import Foundation
import Combine
import CoreData

class AddNewStockpileViewModel: ObservableObject {
    @Published var allStockpileSavings: [any StockpileSavingType] = []
    @Published var errorText: String = ""
    @Published var showingErrorAlert = false
    private let managedObjectContext: NSManagedObjectContext = CoreDataStack.shared.persistentContainer.viewContext

    init(savings: [any StockpileSavingType] = []) {
        self.allStockpileSavings = savings
    }

    var uniqueSavings: [any StockpileSavingType] {
        var uniqueDescriptions: [String] = []
        var uniqueSavings: [any StockpileSavingType] = []
        for saving in allStockpileSavings {
            if !uniqueDescriptions.contains(saving.productDescription) {
                uniqueSavings.append(saving)
                uniqueDescriptions.append(saving.productDescription)
            }
        }
        return uniqueSavings
    }

    private func fetchAllStockpiles() {
        if allStockpileSavings.isEmpty || allStockpileSavings.first is StockpileSaving {
            do {
                let fetchResults: [StockpileSaving] = try managedObjectContext.fetch(StockpileSaving.getAllSavings())
                allStockpileSavings = fetchResults
            } catch {
                errorText = "An error occurred when trying to fetch all savings."
                showingErrorAlert = true
            }
        }
    }

    func reloadData() {
        fetchAllStockpiles()
    }
}
