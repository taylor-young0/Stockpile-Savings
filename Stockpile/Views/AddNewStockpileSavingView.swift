//
//  AddNewStockpileSavingView.swift
//  Stockpile
//
//  Created by Taylor Young on 2020-05-31.
//  Copyright © 2020 Taylor Young. All rights reserved.
//

import SwiftUI
import SwiftUIFormHelper
import WidgetKit

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
        let consumptionInDays = (consumption.doubleValue ?? 0.0) / Double(daysInConsumptionUnit)
        
        let daysToExpiration = Calendar.current.dateComponents([.day], from: Date(), to: productExpiryDate)
        return Int(consumptionInDays * Double(daysToExpiration.day ?? 0))
    }
    
    var maximumSavings: Double {
        let savingsPerUnit = (regularPrice.doubleValue ?? 0.0) - (salePrice.doubleValue ?? 0.0)
        
        return savingsPerUnit * Double(maximumStockpileQuantity)
    }
    
    var savings: Double {
        let savingsPerUnit = (regularPrice.doubleValue ?? 0.0) - (salePrice.doubleValue ?? 0.0)
        let purchasedUnits = Int(unitsPurchased) ?? 0
        
        return savingsPerUnit * Double(purchasedUnits)
    }
    
    fileprivate func addNewSavings() {
        let stockpileSaving = StockpileSaving(context: self.managedObjectContext)
        stockpileSaving.productDescription = self.productDescription
        stockpileSaving.dateComputed = Date()
        stockpileSaving.consumption = self.consumption.doubleValue!
        stockpileSaving.consumptionUnit = self.consumptionUnit
        stockpileSaving.productExpiryDate = self.productExpiryDate
        stockpileSaving.regularPrice = self.regularPrice.doubleValue!
        stockpileSaving.salePrice = self.salePrice.doubleValue!
        stockpileSaving.unitsPurchased = Int(unitsPurchased)!
        
        try? self.managedObjectContext.save()
        self.showingSheet.toggle()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    var validInput: Bool {
        if productDescription.isEmpty || consumption.doubleValue == nil || regularPrice.doubleValue == nil
            || salePrice.doubleValue == nil || Int(unitsPurchased) == nil || regularPrice.doubleValue! < salePrice.doubleValue! {
            return false
        }
        
        return true
    }
    
    // colour depends on whether input is valid i.e., button is enabled
    var addButtonColour: Color {
        return validInput ? Color("Stockpile") : Color.secondary
    }
    
    var savingsLocalized: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return formatter.string(from: NSNumber(value: savings))!
    }
    
    var maxSavingsLocalized: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return formatter.string(from: NSNumber(value: maximumSavings))!
    }
    
    var zeroDollarsLocalized: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return formatter.string(from: 0.00)!
    }
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    init(showingSheet: Binding<Bool>) {
        _showingSheet = showingSheet
    }
    
    init(fromTemplate stockpile: StockpileSaving, showingSheet: Binding<Bool>) {
        // Format for the user's locale, as some locales use commas as the decimal separator
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let consumption = formatter.string(for: stockpile.consumption)
        let regularPrice = formatter.string(for: stockpile.regularPrice)
        
        _showingSheet = showingSheet
        _productDescription = .init(initialValue: stockpile.productDescription!)
        _consumption = .init(initialValue: consumption!)
        _consumptionUnit = .init(initialValue: stockpile.consumptionUnit!)
        _regularPrice = .init(initialValue: regularPrice!)
    }
    
    // MARK: - Body
    
    var body: some View {
        Form {
            productInformation
            pricingInformation
            stockpileInformation
        }
        .navigationBarTitle(Text("New Savings"), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(
                action: { self.showingSheet.toggle() },
                label: { Text("Cancel") }
            )
            .padding(RecentSavingsView.paddingAmount)
            .foregroundColor(Color("Stockpile")),
            trailing: Button(
                action: { self.addNewSavings() },
                label: { Text("Add") }
            )
            .padding(RecentSavingsView.paddingAmount)
            .foregroundColor(addButtonColour)
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
    
    // MARK: Product Information
    var productInformation: some View {
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
    }
    
    // MARK: Pricing Information
    var pricingInformation: some View {
        Section(header: Text("Price Information")) {
            HStack {
                Text("Regular price")
                Divider()
                Spacer()
                TextField(zeroDollarsLocalized, text: $regularPrice)
                    .multilineTextAlignment(.trailing)
                    .scaledToFit()
                    .keyboardType(.decimalPad)
                Text(Locale.current.currencyCode ?? "")
            }
            .onTapGesture(perform: dismissKeyboard)
            
            HStack {
                Text("Sale price")
                Divider()
                Spacer()
                TextField(zeroDollarsLocalized, text: $salePrice)
                    .multilineTextAlignment(.trailing)
                    .scaledToFit()
                    .keyboardType(.decimalPad)
                Text(Locale.current.currencyCode ?? "")
            }
            .onTapGesture(perform: dismissKeyboard)
        }
    }
    
    // MARK: Stockpile Information
    var stockpileInformation: some View {
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
                Text(maxSavingsLocalized)
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
                Text(savingsLocalized)
            }
            .onTapGesture(perform: dismissKeyboard)
        }
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
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Lifetime savings".uppercased())
                        .fontWeight(.bold)
                        .foregroundColor(Color("Stockpile"))
                    Text(50, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                        .font(.title.bold())
                        .foregroundColor(Color("Stockpile"))
                }
                
                Spacer()
            }
            .redacted(reason: .placeholder)
        }
    }
}
