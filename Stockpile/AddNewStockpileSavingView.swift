//
//  AddNewStockpileSavingView.swift
//  Stockpile
//
//  Created by Taylor Young on 2020-05-31.
//  Copyright © 2020 Taylor Young. All rights reserved.
//

import SwiftUI

struct AddNewStockpileSavingView: View {
    
    //@State var stockpileSaving: StockpileSaving
    @State var productDescription: String = ""
    @State var productExpiryDate: Date = Date()
    @State var consumption: String = ""
    @State var consumptionUnit: String = ConsumptionUnit.Day.rawValue
    @State var regularPrice: String = ""
    @State var salePrice: String = ""
    
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
                        TextField("0.00", text: $regularPrice)
                            .multilineTextAlignment(.trailing)
                            .scaledToFit()
                    }
                }
                Section(header: Text("Results")) {
                    HStack {
                        Text("Stockpile quantity")
                        Spacer()
                        Text("5 units")
                    }
                    HStack {
                        Text("Savings")
                        Spacer()
                        Text("$5")
                    }
                }
            }.navigationBarTitle(Text("New Savings"), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    print("test")
                }, label: {Text("Cancel")}),
                trailing: Button(action: {
                    print("")
                }, label: {Text("Add")}))
        }
    }
}

struct AddNewStockpileSavingView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewStockpileSavingView()
    }
}
