//
//  AddSavingsFormView.swift
//  Stockpile
//
//  Created by Taylor Young on 2020-05-31.
//  Copyright © 2020 Taylor Young. All rights reserved.
//

import SwiftUI
import WidgetKit

struct AddSavingsFormView: View {
    @Binding var showingSheet: Bool
    @StateObject var viewModel: AddSavingsFormViewModel
    @FocusState var focusedField: AddSavingsFormField?
    
    init(fromTemplate stockpile: StockpileSaving? = nil,
         showingSheet: Binding<Bool>,
         context: ManagedObjectContextType = StorageType.persistent.managedObjectContext) {
        _showingSheet = showingSheet
        _viewModel = StateObject(wrappedValue: AddSavingsFormViewModel(fromTemplate: stockpile, context: context))
    }

    func dismissKeyboard() {
        focusedField = nil
    }
    
    // MARK: - Body
    
    var body: some View {
        Form {
            productInformation
            pricingInformation
            stockpileInformation
        }
        .navigationTitle(Text("New Savings"))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    viewModel.showingSheet.toggle()
                }
                .padding(Constants.defaultPadding)
                .foregroundColor(Constants.stockpileColor)
            }
            ToolbarItem(placement: .primaryAction) {
                Button("Add") {
                    viewModel.addSavings()
                }
                .padding(Constants.defaultPadding)
                .foregroundColor(viewModel.addButtonColour)
                .disabled(!viewModel.isInputValid)
            }
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    dismissKeyboard()
                }
            }
        }
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
        .tint(Constants.stockpileColor)
        .onChange(of: viewModel.showingSheet) {
            showingSheet = $0
        }
    }
    
    // MARK: Product Information
    var productInformation: some View {
        Section(header: Text("Product Information")) {
            HStack {
                Text("Description")
                Divider()
                TextField("Product name", text: $viewModel.productDescription)
                    .multilineTextAlignment(.trailing)
                    .focused($focusedField, equals: .description)
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
                    HStack(spacing: 2) {
                        TextField("units", text: $viewModel.consumptionInput)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .focused($focusedField, equals: .consumption)
                        Text("/\(viewModel.consumptionUnit.rawValue)")
                            .onTapGesture {
                                focusedField = .consumption
                            }
                    }
                }
                .onTapGesture(perform: dismissKeyboard)
            }

            Picker("Consumption Units", selection: $viewModel.consumptionUnit) {
                ForEach(ConsumptionUnit.allCases, id: \.self) { unit in
                    Text(unit.rawValue).tag(unit)
                }
            }
            .pickerStyle(.menu)
        }
    }
    
    // MARK: Pricing Information
    var pricingInformation: some View {
        Section(header: Text("Price Information")) {
            HStack {
                Text("Regular price")
                Divider()
                Spacer()
                TextField(Double.zero.asLocalizedCurrency, text: $viewModel.regularPriceInput)
                    .multilineTextAlignment(.trailing)
                    .scaledToFit()
                    .keyboardType(.decimalPad)
                    .focused($focusedField, equals: .regularPrice)
                Text(Locale.current.currencyCode ?? "")
            }
            .onTapGesture(perform: dismissKeyboard)
            
            HStack {
                Text("Sale price")
                Divider()
                Spacer()
                TextField(Double.zero.asLocalizedCurrency, text: $viewModel.salePriceInput)
                    .multilineTextAlignment(.trailing)
                    .scaledToFit()
                    .keyboardType(.decimalPad)
                    .focused($focusedField, equals: .salePrice)
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
                Text(viewModel.maximumSavings.asLocalizedCurrency)
            }
            .onTapGesture(perform: dismissKeyboard)
            
            HStack {
                Text("Units purchased")
                Divider()
                Spacer()
                TextField("0", text: $viewModel.unitsPurchasedInput)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .unitsPurchased)
            }
            .onTapGesture(perform: dismissKeyboard)
            
            HStack {
                Text("Savings")
                Spacer()
                Text(viewModel.savings.asLocalizedCurrency)
            }
            .onTapGesture(perform: dismissKeyboard)
        }
    }
}

struct AddSavingsFormView_Previews: PreviewProvider {
    static let vm = RecentSavingsViewModel(context: StorageType.inmemory(.one).managedObjectContext)

    static var previews: some View {
        vm.reloadData()

        return Group {
            NavigationView {
                AddSavingsFormView(showingSheet: .constant(true), context: StorageType.inmemory(.none).managedObjectContext)
            }

            NavigationView {
                AddSavingsFormView(fromTemplate: vm.recentStockpiles.first!, showingSheet: .constant(true), context: StorageType.inmemory(.none).managedObjectContext)
            }

            NavigationView {
                AddSavingsFormView(showingSheet: .constant(true), context: StorageType.inmemory(.none).managedObjectContext)
                    .environment(\.colorScheme, .dark)
            }
        }
    }
}
