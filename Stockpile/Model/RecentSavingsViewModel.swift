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
    @Published var allStockpileSavings: [any StockpileSavingType]
    @Published var showingSheet: Bool = false
    @Published var showingErrorAlert: Bool = false

    init(savings: [any StockpileSavingType] = []) {
        self.allStockpileSavings = savings
    }

    var lifetimeSavings: String {
        var savings: Double = 0.0
        for stockpile in allStockpileSavings {
            savings += stockpile.savings
        }
        return savings.asLocalizedCurrency
    }

    var firstSavingsDate: Date? {
        return allStockpileSavings.last?.dateComputed ?? nil
    }

    var averagePercentageSavings: Int? {
        guard allStockpileSavings.count != 0 else {
            return nil
        }

        var totalPercentageSavings: Double = 0.0
        for stockpile in allStockpileSavings {
            totalPercentageSavings += stockpile.percentageSavings
        }

        return Int(totalPercentageSavings) / allStockpileSavings.count
    }

    var percentageSavingsRange: (Int, Int)? {
        let sortedSavings: [Int] = allStockpileSavings.sorted {
            $0.percentageSavings < $1.percentageSavings
        }.map {
            Int($0.percentageSavings)
        }

        if let leastSavings = sortedSavings.first, let mostSavings = sortedSavings.last, leastSavings != mostSavings {
            return (leastSavings, mostSavings)
        }

        return nil
    }

    var recentStockpiles: [any StockpileSavingType] {
        return Array(allStockpileSavings.prefix(10))
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

    func deleteStockpileSaving(at index: IndexSet.Element?) {
        guard let index, index < recentStockpiles.count, let itemToDelete = recentStockpiles[index] as? StockpileSaving else {
            errorText = "Could not find a savings to delete. Please try again."
            showingErrorAlert = true
            return
        }

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
