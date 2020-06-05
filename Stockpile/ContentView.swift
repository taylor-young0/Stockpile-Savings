//
//  ContentView.swift
//  Stockpile
//
//  Created by Taylor Young on 2020-05-31.
//  Copyright © 2020 Taylor Young. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    //@FetchRequest(fetchRequest: StockpileSaving.getRecentSavings(fetchLimit: 10)) var recentStockpiles: FetchedResults<StockpileSaving>
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var showingSheet = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    LifetimeSavingsRow()
                }
                Section(header: Text("Recent Savings")) {
//                    if recentStockpiles.count != 0 {
//                        ForEach(recentStockpiles) { stockpile in
//                            StockpileSavingRow(stockpile: stockpile)
//                        }
//                    } else {
//                        EmptySavingsRow()
//                    }
                    Text("")
                }
            }.navigationBarTitle(Text("Stockpile"))
            .listStyle(GroupedListStyle())
            .navigationBarItems(trailing: Button(action: {
                self.showingSheet.toggle()
            }, label: {
                Image(systemName: "plus")
                })).sheet(isPresented: $showingSheet, content: {
                    AddNewStockpileSavingView(showingSheet: self.$showingSheet).environment(\.managedObjectContext, self.managedObjectContext)
                })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
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
                    .foregroundColor(.gray)
                Spacer()
            }
        }
    }
}

struct LifetimeSavingsRow: View {
    var body: some View {
        HStack {
            Text("🤑 Lifetime savings")
            Spacer()
            Text("$0.00")
        }
    }
}

struct StockpileSavingRow: View {
    var stockpile: StockpileSaving
    var body: some View {
        VStack {
            HStack {
                Text("\(stockpile.productDescription!)")
                    .font(.title)
                    .foregroundColor(.gray)
                Spacer()
                Text("\(stockpile.savings, specifier: "%.2f")")
            }
            HStack {
                Text("\(stockpile.quantity) units")
                    .font(.subheadline)
                Spacer()
                Text("25% savings")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}
