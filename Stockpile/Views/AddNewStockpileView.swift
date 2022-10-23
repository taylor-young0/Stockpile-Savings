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
    
    var distinctSavings: [String] {
        allStockpileSavings.compactMap({ $0.productDescription })
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            let uniqueSavings = Set(distinctSavings)
            let sortedUnique = uniqueSavings.sorted()
            List {
                Section {
                    NavigationLink(destination: AddNewStockpileSavingView(showingSheet: $showingSheet)) {
                        Text("💰 Add new savings from scratch")
                    }
                }
                
                Section(header: Text("Create from template")) {
                    ForEach(sortedUnique, id: \.self) { desc in
                        let saving = allStockpileSavings.filter({ $0.productDescription == desc })
                        NavigationLink(destination: AddNewStockpileSavingView(fromTemplate: saving[0], showingSheet: $showingSheet)) {
                            Text(saving[0].productDescription!)
                        }
                    }
                    
                    // if running in preview show sample savings, see https://stackoverflow.com/a/61741858
                    if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                        let sampleProducts = ["🍕 Amy's vegan margherita frozen pizza", "🧃 Kiju organic apple juice 1L", "🧀 Organic Meadow aged cheddar cheese"]
                        ForEach(sampleProducts, id: \.self) { product in
                            NavigationLink(destination: Text("a")) {
                                Text(product)
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle(Text("Add Savings"), displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button("Cancel", action: { showingSheet.toggle() })
                        .foregroundColor(Constants.stockpileColor)
            )
        }
    }
}

struct AddNewStockpileView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewStockpileView(showingSheet: .constant(true))
    }
}
