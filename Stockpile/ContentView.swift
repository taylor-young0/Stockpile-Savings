//
//  ContentView.swift
//  Stockpile
//
//  Created by Taylor Young on 2020-05-31.
//  Copyright © 2020 Taylor Young. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @FetchRequest(fetchRequest: StockpileSaving.getRecentSavings(fetchLimit: 10)) var recentStockpiles: FetchedResults<StockpileSaving>
    @FetchRequest(fetchRequest: StockpileSaving.getAllSavings()) var allStockpileSavings: FetchedResults<StockpileSaving>
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @State var showingSheet = false
    
    static let paddingAmount: CGFloat = 10
    
    var lifetimeSavings: Double {
        var sum = 0.0
        for stockpile in allStockpileSavings {
            sum += stockpile.savings
        }

        return sum
    }
    
    var coreBody: some View {
        List {
            Section {
                HStack {
                    Text("🤑 Lifetime savings")
                    Spacer()
                    Text("$\(self.lifetimeSavings, specifier: "%.2f")")
                }
            }
            Section(header: Text("Recent Savings")) {
                if recentStockpiles.count != 0 {
                    ForEach(recentStockpiles) { stockpile in
                        StockpileSavingRow(stockpile: stockpile)
                    }.onDelete(perform: { indexSet in
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
        }.navigationBarTitle(Text("Stockpile"))
        .navigationBarItems(
            trailing: Button(
                action: {self.showingSheet.toggle()},
                label: {
                    Image(systemName:"plus")
                        .imageScale(.large)
                        .padding(ContentView.paddingAmount)
                }
            )
        ).sheet(
            isPresented: $showingSheet,
            content: {
                AddNewStockpileSavingView(showingSheet: self.$showingSheet)
                    .environment(\.managedObjectContext, self.managedObjectContext)
            }
        )
    }
    
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
                .previewDevice(.init(rawValue: "iPhone 11"))
            
            ContentView().environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
                .environment(\.colorScheme, .dark)
                .previewDevice(.init(rawValue: "iPhone 11"))
            
            EmptySavingsRow().previewLayout(.fixed(width: 375, height: 70))
                .padding(.horizontal)
        }
    }
}

struct EmptySavingsRow: View {
    var body: some View {
        VStack {
            HStack() {
                Text("😢 No savings added yet!")
                Spacer()
            }
            HStack {
                Text("Add savings by completing a new calculation by pressing the + icon in the top right")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
    }
}

struct StockpileSavingRow: View {
    var stockpile: StockpileSaving
    var body: some View {
        VStack {
            HStack {
                Text("\(stockpile.productDescription!)")
                Spacer()
                Text("$\(stockpile.savings, specifier: "%.2f") off")
            }
            HStack {
                Text("\(stockpile.unitsPurchased) unit\(stockpile.unitsPurchased == 1 ? "" : "s")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(stockpile.percentageSavings, specifier: "%.0f")% savings")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}
