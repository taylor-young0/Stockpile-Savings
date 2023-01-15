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
    @Published var allStockpileSavings: [StockpileSaving] = []
    @Published var errorText: String = ""
    @Published var showingErrorAlert = false
    private let managedObjectContext: NSManagedObjectContext = CoreDataStack.shared.persistentContainer.viewContext

    var uniqueSavings: [StockpileSaving] {
        // if running in preview show sample savings, see https://stackoverflow.com/a/61741858
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            return StockpileSaving.samples
        } else {
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
    }

    private func fetchAllStockpiles() {
        do {
            let fetchResults: [StockpileSaving] = try managedObjectContext.fetch(StockpileSaving.getAllSavings())
            allStockpileSavings = fetchResults
        } catch {
            errorText = "An error occurred when trying to fetch all savings."
            showingErrorAlert = true
        }
    }

    func reloadData() {
        fetchAllStockpiles()
    }
}
