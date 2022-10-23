//
//  RecentSavingsView.swift
//  Stockpile
//
//  Created by Taylor Young on 2020-05-31.
//  Copyright © 2020 Taylor Young. All rights reserved.
//

import SwiftUI
import WidgetKit

struct RecentSavingsView: View {

    @FetchRequest(fetchRequest: StockpileSaving.getRecentSavings(fetchLimit: 10)) var recentStockpiles: FetchedResults<StockpileSaving>
    @FetchRequest(fetchRequest: StockpileSaving.getAllSavings()) var allStockpileSavings: FetchedResults<StockpileSaving>
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @State var showingSheet = false
    
    var lifetimeSavings: String {
        var savings: Double = 0.0
        for stockpile in allStockpileSavings {
            savings += stockpile.savings
        }
        return savings.asLocalizedCurrency
    }
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(named: "Stockpile")!]
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(named: "Stockpile")!]
    }
        
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Text("🤑 Lifetime savings")
                        Spacer()
                        Text(lifetimeSavings)
                    }
                }
                
                Section(header: Text("Recent Savings")) {
                    if recentStockpiles.count != 0 {
                        ForEach(recentStockpiles) { stockpile in
                            StockpileSavingRow(description: stockpile.productDescription, savings: stockpile.savings, unitsPurchased: stockpile.unitsPurchased, percentageSavings: stockpile.percentageSavings)
                        }
                        .onDelete(perform: { indexSet in
                            let deleteItem = self.recentStockpiles[indexSet.first!]
                            self.managedObjectContext.delete(deleteItem)
                            
                            do {
                                try self.managedObjectContext.save()
                            } catch {
                                print(error)
                            }
                            
                            WidgetCenter.shared.reloadAllTimelines()
                        })
                    } else {
                        EmptySavingsRow()
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle(Text("Stockpile"))
            .navigationBarItems(
                trailing: Button(
                    action: { self.showingSheet.toggle() },
                    label: {
                        Image(systemName:"plus")
                            .font(.title3.bold())
                            .foregroundColor(Constants.stockpileColor)
                            .padding(Constants.defaultPadding)
                    }
                )
            )
            .sheet(
                isPresented: $showingSheet,
                content: {
                    if recentStockpiles.count > 0 {
                        AddNewStockpileView(showingSheet: $showingSheet)
                            .environment(\.managedObjectContext, self.managedObjectContext)
                    } else {
                        NavigationView {
                            AddNewStockpileSavingView(showingSheet: $showingSheet)
                        }
                    }
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RecentSavingsView().environment(\.managedObjectContext, CoreDataStack.shared.persistentContainer.viewContext)
                .previewDevice(.init(rawValue: "iPhone 11"))
            
            RecentSavingsView().environment(\.managedObjectContext, CoreDataStack.shared.persistentContainer.viewContext)
                .environment(\.colorScheme, .dark)
                .previewDevice(.init(rawValue: "iPhone 11"))
            
            EmptySavingsRow().previewLayout(.fixed(width: 375, height: 70))
                .padding(.horizontal)
        }
    }
}
