//
//  AddNewStockpileView.swift
//  Stockpile
//
//  Created by Taylor Young on 2021-09-13.
//  Copyright © 2021 Taylor Young. All rights reserved.
//

import SwiftUI

struct AddNewStockpileView: View {
    @FetchRequest(fetchRequest: StockpileSaving.getAllSavings()) var allStockpileSavings: FetchedResults<StockpileSaving>
    @Environment(\.managedObjectContext) var managedObjectContext
    @Binding var showingSheet: Bool

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

    // MARK: - Body

    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: AddNewStockpileSavingView(showingSheet: $showingSheet)) {
                        Text("💰 Add new savings from scratch")
                    }
                }
                
                Section(header: Text("Create from template")) {
                    ForEach(uniqueSavings, id: \.self) { stockpileSaving in
                        NavigationLink(destination: AddNewStockpileSavingView(fromTemplate: stockpileSaving, showingSheet: $showingSheet)) {
                            Text(stockpileSaving.productDescription)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle(Text("Add Savings"), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showingSheet.toggle()
                    }
                    .padding(Constants.defaultPadding)
                    .foregroundColor(Constants.stockpileColor)
                }
            }
        }
    }
}

struct AddNewStockpileView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewStockpileView(showingSheet: .constant(true))
    }
}
