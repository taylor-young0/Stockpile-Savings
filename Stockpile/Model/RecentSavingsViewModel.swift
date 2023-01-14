//
//  RecentSavingsViewModel.swift
//  Stockpile
//
//  Created by Taylor Young on 2023-01-07.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import CoreData
import Combine
import WidgetKit

class RecentSavingsViewModel: ObservableObject {
    private let managedObjectContext: NSManagedObjectContext = CoreDataStack.shared.persistentContainer.viewContext
    let navigationBarTitle: String = "Stockpile"
    let addStockpileSavingIconName: String = "plus"
    let lifetimeSavingsText: String = "🤑 Lifetime savings"
    let recentSavingsHeader: String = "Recent Savings"
    @Published var errorText: String = ""
    @Published var allStockpileSavings: [StockpileSaving] = []
    @Published var showingSheet: Bool = false
    @Published var showingErrorAlert: Bool = false

    var lifetimeSavings: String {
        var savings: Double = 0.0
        for stockpile in allStockpileSavings {
            savings += stockpile.savings
        }
        return savings.asLocalizedCurrency
    }

    var recentStockpiles: [StockpileSaving] {
        return Array(allStockpileSavings.prefix(10))
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

    func deleteStockpileSaving(at index: IndexSet.Element?) {
        guard let index, index < recentStockpiles.count else {
            errorText = "Could not find a savings to delete. Please try again."
            showingErrorAlert = true
            return
        }

        let itemToDelete: StockpileSaving = recentStockpiles[index]
        self.managedObjectContext.delete(itemToDelete)

        do {
            try managedObjectContext.save()
            reloadData()
        } catch {
            errorText = "An error occured while trying to save your changes. Please try again."
            showingErrorAlert = true
        }

        WidgetCenter.shared.reloadAllTimelines()
    }
}
