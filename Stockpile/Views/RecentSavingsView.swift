//
//  RecentSavingsView.swift
//  Stockpile
//
//  Created by Taylor Young on 2020-05-31.
//  Copyright © 2020 Taylor Young. All rights reserved.
//

import SwiftUI

struct RecentSavingsView: View {

    @FetchRequest(fetchRequest: StockpileSaving.getRecentSavings(fetchLimit: 10)) var recentStockpiles: FetchedResults<StockpileSaving>
    @FetchRequest(fetchRequest: StockpileSaving.getAllSavings()) var allStockpileSavings: FetchedResults<StockpileSaving>
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @State var showingSheet = false
    
    static let paddingAmount: CGFloat = 10
    
    var lifetimeSavings: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        var savings = 0.0
        for stockpile in allStockpileSavings {
            savings += stockpile.savings
        }

        return formatter.string(from: NSNumber(value: savings))!
    }
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(named: "Stockpile")!]
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(named: "Stockpile")!]
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            // Adjust the list style to be the equivalent of InsetGroupedListStyle regardless of iOS version
            if #available(iOS 14.0, *) {
                coreBody
                    .listStyle(InsetGroupedListStyle())
            } else {
                coreBody
                    .listStyle(GroupedListStyle())
                    .environment(\.horizontalSizeClass, .regular)
            }
        }
    }
    
    // MARK: - coreBody
    
    var coreBody: some View {
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
                        StockpileSavingRow(description: stockpile.productDescription!, savings: stockpile.savings, unitsPurchased: stockpile.unitsPurchased, percentageSavings: stockpile.percentageSavings)
                    }
                    .onDelete(perform: { indexSet in
                        let deleteItem = self.recentStockpiles[indexSet.first!]
                        self.managedObjectContext.delete(deleteItem)
                        
                        do {
                            try self.managedObjectContext.save()
                        } catch {
                            print(error)
                        }
                    })
                } else {
                    EmptySavingsRow()
                }
            }
        }
        .navigationBarTitle(Text("Stockpile"))
        .navigationBarItems(
            trailing: Button(
                action: { self.showingSheet.toggle() },
                label: {
                    Image(systemName:"plus")
                        .imageScale(.large)
                        .foregroundColor(Color("Stockpile"))
                        .padding(RecentSavingsView.paddingAmount)
                }
            )
        )
        .sheet(
            isPresented: $showingSheet,
            content: {
                AddNewStockpileView(showingSheet: $showingSheet)
                    .environment(\.managedObjectContext, self.managedObjectContext)
            }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RecentSavingsView().environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
                .previewDevice(.init(rawValue: "iPhone 11"))
            
            RecentSavingsView().environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
                .environment(\.colorScheme, .dark)
                .previewDevice(.init(rawValue: "iPhone 11"))
            
            EmptySavingsRow().previewLayout(.fixed(width: 375, height: 70))
                .padding(.horizontal)
        }
    }
}
