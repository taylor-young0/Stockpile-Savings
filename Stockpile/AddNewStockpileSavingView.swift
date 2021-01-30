//
//  AddNewStockpileSavingView.swift
//  Stockpile
//
//  Created by Taylor Young on 2020-05-31.
//  Copyright © 2020 Taylor Young. All rights reserved.
//

import SwiftUI
import SwiftUIFormHelper

struct AddNewStockpileSavingView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Binding var showingSheet: Bool
    
    @State var showingError: Bool = false
    @State var productDescription: String = ""
    @State var productExpiryDate: Date = Date()
    @State var consumption: String = ""
    @State var consumptionUnit: String = ConsumptionUnit.Day.rawValue
    @State var regularPrice: String = ""
    @State var salePrice: String = ""
    @State var unitsPurchased: String = ""
    
    var maximumStockpileQuantity: Int {
        let daysInConsumptionUnit = ConsumptionUnit.init(rawValue: consumptionUnit)?.numberOfDaysInUnit ?? 1
        let consumptionInDays = (Double(consumption) ?? 0.0) / Double(daysInConsumptionUnit)

        let daysToExpiration = Calendar.current.dateComponents([.day], from: Date(), to: productExpiryDate)
        return Int(consumptionInDays * Double(daysToExpiration.day ?? 0))
    }
    
    var maximumSavings: Double {
        let savingsPerUnit = (Double(regularPrice) ?? 0.0) - (Double(salePrice) ?? 0.0)
        return savingsPerUnit * Double(maximumStockpileQuantity)
    }
    
    var savings: Double {
        let savingsPerUnit = ((Double(regularPrice) ?? 0.0) - (Double(salePrice) ?? 0.0))
        let purchasedUnits = Double(Int(unitsPurchased) ?? 0)
        return savingsPerUnit * purchasedUnits
    }
    
    fileprivate func addNewSavings() {
        let stockpileSaving = StockpileSaving(context: self.managedObjectContext)
        stockpileSaving.productDescription = self.productDescription
        stockpileSaving.dateComputed = Date()
        stockpileSaving.consumption = Double(self.consumption)!
        stockpileSaving.consumptionUnit = self.consumptionUnit
        stockpileSaving.productExpiryDate = self.productExpiryDate
        stockpileSaving.regularPrice = Double(self.regularPrice)!
        stockpileSaving.salePrice = Double(self.salePrice)!
        stockpileSaving.unitsPurchased = Int(unitsPurchased)!
        
        try? self.managedObjectContext.save()
        self.showingSheet.toggle()
    }
    
    var validInput: Bool {
        if productDescription.isEmpty || Double(consumption) == nil || Double(regularPrice) == nil
            || Double(salePrice) == nil || Double(unitsPurchased) == nil || Double(regularPrice)! < Double(salePrice)! {
            return false
        }
        
        return true
    }
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var body: some View {
        if #available(iOS 14.0, *) {
            NavigationView {
                coreBody
            }
        } else {
            // default to old iOS 13 offset
            NavigationView {
                coreBody
                    .enableKeyboardOffset()
            }
        }
    }
    
    var coreBody: some View {
        Form {
            // MARK: Product Information
            Section(header: Text("Product Information")) {
                HStack {
                    Text("Description")
                    Divider()
                    TextField("Product name", text: $productDescription)
                        .multilineTextAlignment(.trailing)
                }
                .onTapGesture(perform: dismissKeyboard)
                
                VStack(alignment: .leading) {
                    DatePicker("Expiry Date", selection: $productExpiryDate, in: Date()..., displayedComponents: .date)
                        .multilineTextAlignment(.trailing)
                }
                .animation(nil)
                
                VStack {
                    HStack {
                        Text("Consumption")
                        Divider()
                        TextField("units", text: $consumption)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                        Text("/\(consumptionUnit)")
                    }
                    .onTapGesture(perform: dismissKeyboard)
                    
                    Picker("Consumption Units", selection: $consumptionUnit) {
                        ForEach(ConsumptionUnit.allCases, id: \.self) { unit in
                            Text(unit.rawValue).tag(unit.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            // MARK: Price Information
            Section(header: Text("Price Information")) {
                HStack {
                    Text("Regular price")
                    Divider()
                    Spacer()
                    Text("$")
                    TextField("0.00", text: $regularPrice)
                        .multilineTextAlignment(.trailing)
                        .scaledToFit()
                        .keyboardType(.decimalPad)
                }
                .onTapGesture(perform: dismissKeyboard)
                
                HStack {
                    Text("Sale price")
                    Divider()
                    Spacer()
                    Text("$")
                    TextField("0.00", text: $salePrice)
                        .multilineTextAlignment(.trailing)
                        .scaledToFit()
                        .keyboardType(.decimalPad)
                }
                .onTapGesture(perform: dismissKeyboard)
            }
            
            // MARK: Stockpile Info
            Section(header: Text("Stockpile Info"), footer: Text("Maximum stockpile quantity is the maximum number of units you could purchase to maximize savings without having the products expire.")) {
                HStack {
                    Text("Maximum stockpile quantity")
                    Spacer()
                    Text("\(maximumStockpileQuantity) unit\(maximumStockpileQuantity == 1 ? "" : "s")")
                }
                .onTapGesture(perform: dismissKeyboard)
                
                HStack {
                    Text("Maximum savings")
                    Spacer()
                    Text("$\(maximumSavings, specifier: "%.2f")")
                }
                .onTapGesture(perform: dismissKeyboard)
                
                HStack {
                    Text("Units purchased")
                    Divider()
                    Spacer()
                    TextField("0", text: $unitsPurchased)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                }
                .onTapGesture(perform: dismissKeyboard)
                
                HStack {
                    Text("Savings")
                    Spacer()
                    Text("$\(savings, specifier: "%.2f")")
                }
                .onTapGesture(perform: dismissKeyboard)
            }
        }
        .environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle(Text("New Savings"), displayMode: .inline)
        .navigationBarItems(
            leading: Button(
                action: { self.showingSheet.toggle() },
                label: { Text("Cancel").padding(ContentView.paddingAmount) }),
            trailing: Button(
                action: { self.addNewSavings() },
                label: { Text("Add").padding(ContentView.paddingAmount) }
            )
            .disabled(!validInput)
        )
        .alert(
            isPresented: $showingError,
            content: {
                Alert(
                    title: Text("Error"),
                    message: Text("There was an error adding the savings"),
                    dismissButton: .default(Text("Dismiss"))
                )
            }
        )
    }
}

struct AddNewStockpileSavingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddNewStockpileSavingView(showingSheet: .constant(true))
                .previewDevice(.init(rawValue: "iPhone 11"))
            
            AddNewStockpileSavingView(showingSheet: .constant(true))
                .previewDevice(.init(rawValue: "iPhone 11"))
                .environment(\.colorScheme, .dark)
        }
    }
}
