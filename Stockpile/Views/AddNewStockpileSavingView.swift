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
    @StateObject var viewModel: AddNewStockpileSavingViewModel = AddNewStockpileSavingViewModel()
    
    init(showingSheet: Binding<Bool>) {
        _showingSheet = showingSheet
    }
    
    init(fromTemplate stockpile: StockpileSaving, showingSheet: Binding<Bool>) {
        // Format for the user's locale, as some locales use commas as the decimal separator
        let consumption: String = stockpile.consumption.localizedDecimal
        let consumptionUnit: ConsumptionUnit = ConsumptionUnit(rawValue: stockpile.consumptionUnit ?? "") ?? .Day
        let regularPrice: String = stockpile.regularPrice.localizedDecimal
        
        _showingSheet = showingSheet
        _viewModel = StateObject(wrappedValue: AddNewStockpileSavingViewModel(productDescription: stockpile.productDescription ?? "",
                                                                              consumption: consumption,
                                                                              consumptionUnit: consumptionUnit,
                                                                              regularPrice: regularPrice))
    }

    fileprivate func addNewSavings() {
        let stockpileSaving = StockpileSaving(context: self.managedObjectContext)
        stockpileSaving.productDescription = viewModel.productDescription
        stockpileSaving.dateComputed = Date()
        stockpileSaving.consumption = viewModel.consumption
        stockpileSaving.consumptionUnit = viewModel.consumptionUnit.rawValue
        stockpileSaving.productExpiryDate = viewModel.productExpiryDate
        stockpileSaving.regularPrice = viewModel.regularPrice
        stockpileSaving.salePrice = viewModel.salePrice
        stockpileSaving.unitsPurchased = viewModel.unitsPurchased

        try? self.managedObjectContext.save()
        self.showingSheet.toggle()
        WidgetCenter.shared.reloadAllTimelines()
    }

    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
            leading:
                Button(
                    action: { self.showingSheet.toggle() },
                    label: { Text("Cancel") }
                )
                .padding(Constants.defaultPadding)
                .foregroundColor(Constants.stockpileColor),
            trailing:
                Button(
                    action: { self.addNewSavings() },
                    label: { Text("Add") }
                )
                .padding(Constants.defaultPadding)
                .foregroundColor(viewModel.addButtonColour)
                .disabled(!viewModel.isInputValid)
        )
        .alert(
            isPresented: $viewModel.showingError,
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
                TextField("Product name", text: $viewModel.productDescription)
                    .multilineTextAlignment(.trailing)
            }
            .onTapGesture(perform: dismissKeyboard)
            
            VStack(alignment: .leading) {
                DatePicker("Expiry Date", selection: $viewModel.productExpiryDate, in: Date()..., displayedComponents: .date)
                    .multilineTextAlignment(.trailing)
            }
            
            VStack {
                HStack {
                    Text("Consumption")
                    Divider()
                    TextField("units", text: $viewModel.consumptionInput)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                    Text("/\(viewModel.consumptionUnit.rawValue)")
                }
                .onTapGesture(perform: dismissKeyboard)
                
                Picker("Consumption Units", selection: $viewModel.consumptionUnit) {
                    ForEach(ConsumptionUnit.allCases, id: \.self) { unit in
                        Text(unit.rawValue).tag(unit)
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
                TextField(Double.zero.localizedCurrency, text: $viewModel.regularPriceInput)
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
                TextField(Double.zero.localizedCurrency, text: $viewModel.salePriceInput)
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
        Section(header: Text("Stockpile Info"),
                footer: Text("Maximum stockpile quantity is the maximum number of units you could purchase to maximize savings without having the products expire.")) {
            HStack {
                Text("Maximum stockpile quantity")
                Spacer()
                Text("\(viewModel.maximumStockpileQuantity) unit\(viewModel.maximumStockpileQuantity == 1 ? "" : "s")")
            }
            .onTapGesture(perform: dismissKeyboard)
            
            HStack {
                Text("Maximum savings")
                Spacer()
                Text(viewModel.maximumSavings.localizedCurrency)
            }
            .onTapGesture(perform: dismissKeyboard)
            
            HStack {
                Text("Units purchased")
                Divider()
                Spacer()
                TextField("0", text: $viewModel.unitsPurchasedInput)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numberPad)
            }
            .onTapGesture(perform: dismissKeyboard)
            
            HStack {
                Text("Savings")
                Spacer()
                Text(viewModel.savings.localizedCurrency)
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
                        .foregroundColor(Constants.stockpileColor)
                    Text(50, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                        .font(.title.bold())
                        .foregroundColor(Constants.stockpileColor)
                }
                
                Spacer()
            }
            .redacted(reason: .placeholder)
        }
    }
}
