//
//  AddNewStockpileView.swift
//  Stockpile
//
//  Created by Taylor Young on 2021-09-13.
//  Copyright © 2021 Taylor Young. All rights reserved.
//

import SwiftUI

struct AddNewStockpileView: View {
    @StateObject private var viewModel: AddNewStockpileViewModel = AddNewStockpileViewModel()
    @Binding private var showingSheet: Bool

    init(showingSheet: Binding<Bool>) {
        self._showingSheet = showingSheet
    }

    // MARK: - Body

    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: AddNewStockpileSavingView(showingSheet: $showingSheet)) {
                        Text("💰 Add new savings from scratch")
                    }
                }
                
                Section(header: Text("Create from template")) {
                    ForEach(viewModel.uniqueSavings, id: \.self) { stockpileSaving in
                        NavigationLink(destination: AddNewStockpileSavingView(fromTemplate: stockpileSaving, showingSheet: $showingSheet)) {
                            Text(stockpileSaving.productDescription)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle(Text("Add Savings"), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showingSheet.toggle()
                    }
                    .padding(Constants.defaultPadding)
                    .foregroundColor(Constants.stockpileColor)
                }
            }
            .alert(viewModel.errorText, isPresented: $viewModel.showingErrorAlert) {
                Button("OK", role: .cancel) { }
            }
            .onAppear {
                viewModel.reloadData()
            }
        }
    }
}

struct AddNewStockpileView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewStockpileView(showingSheet: .constant(true))
    }
}
