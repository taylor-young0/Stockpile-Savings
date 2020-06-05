//
//  AddNewStockpileSavingView.swift
//  Stockpile
//
//  Created by Taylor Young on 2020-05-31.
//  Copyright © 2020 Taylor Young. All rights reserved.
//

import SwiftUI

struct AddNewStockpileSavingView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: StockpileSaving.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \StockpileSaving.dateComputed, ascending: true)
        ]
    ) var languages: FetchedResults<StockpileSaving>
    
    @Binding var showingSheet: Bool
    @State var productDescription: String = ""
    @State var productExpiryDate: Date = Date()
    @State var consumption: String = ""
    @State var consumptionUnit: String = ConsumptionUnit.Day.rawValue
    @State var regularPrice: String = ""
    @State var salePrice: String = ""
    
    var quantity: Int {
        var consumptionInDays = Double(consumption) ?? 0.0
        // Check if we need to convert our consumption to days
        if consumptionUnit != ConsumptionUnit.Day.rawValue {
            consumptionInDays = (consumptionUnit == ConsumptionUnit.Week.rawValue) ?
                (consumptionInDays / 7) : (consumptionInDays / 30)
        }
        let daysBetween = Calendar.current.dateComponents([.day], from: Date(), to: productExpiryDate)
        return Int(consumptionInDays * Double(daysBetween.day ?? 0))
    }
    
    var savings: Double {
        let savingsPerUnit = (Double(regularPrice) ?? 0.0) - (Double(salePrice) ?? 0.0)
        return savingsPerUnit * Double(quantity)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Product Information")) {
                    HStack {
                        Text("Description")
                        Divider()
                        TextField("Add some spice with emoji 🍇😀", text: $productDescription)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        DatePicker(selection: $productExpiryDate, in: (Date()...), displayedComponents: .date) {
                            Text("Expiry Date")
                        }
                    }
                    HStack {
                        Text("Consumption")
                        Divider()
                        TextField("units", text: $consumption).multilineTextAlignment(.trailing)
                        Text("/\(consumptionUnit)")
                    }
                    HStack {
                        Picker("Consumption Units", selection: $consumptionUnit) {
                            ForEach(ConsumptionUnit.allCases, id: \.self) { unit in
                                Text(unit.rawValue).tag(unit)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                Section(header: Text("Price Information")) {
                    HStack {
                        Text("Regular price")
                        Divider()
                        Spacer()
                        Text("$")
                        TextField("0.00", text: $regularPrice)
                            .multilineTextAlignment(.trailing)
                            .scaledToFit()
                    }
                    HStack {
                        Text("Sale price")
                        Divider()
                        Spacer()
                        Text("$")
                        TextField("0.00", text: $salePrice)
                            .multilineTextAlignment(.trailing)
                            .scaledToFit()
                    }
                }
                Section(header: Text("Results")) {
                    HStack {
                        Text("Stockpile quantity")
                        Spacer()
                        Text("\(quantity) units")
                    }
                    HStack {
                        Text("Savings")
                        Spacer()
                        Text("$\(savings, specifier: "%.2f")")
                    }
                }
            }.navigationBarTitle(Text("New Savings"), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    self.showingSheet.toggle()
                }, label: {Text("Cancel")}),
                trailing: Button(action: {
                    print("")
                }, label: {Text("Add")}))
        }
    }
}

//struct AddNewStockpileSavingView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddNewStockpileSavingView(showingSheet: false)
//    }
//}
