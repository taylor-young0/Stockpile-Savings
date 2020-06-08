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
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @State var showingSheet = false
    var lifetimeSavings: Double {
        var sum = 0.0
        for stockpile in recentStockpiles {
            sum += stockpile.savings
        }

        return sum
    }
    
    var body: some View {
        NavigationView {
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
            .listStyle(GroupedListStyle())
            .navigationBarItems(trailing: Button(action: {
                self.showingSheet.toggle()
            }, label: {
                Image(systemName: "plus")
                    .imageScale(.large)
                })).sheet(isPresented: $showingSheet, content: {
                    AddNewStockpileSavingView(showingSheet: self.$showingSheet).environment(\.managedObjectContext, self.managedObjectContext)
                })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
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
                Text("\(stockpile.savings, specifier: "%.2f")")
            }
            HStack {
                Text("\(stockpile.quantity) units")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("25% savings")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}
