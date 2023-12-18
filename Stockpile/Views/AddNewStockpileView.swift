//
//  AddNewStockpileView.swift
//  Stockpile
//
//  Created by Taylor Young on 2021-09-13.
//  Copyright © 2021 Taylor Young. All rights reserved.
//

import SwiftUI

struct AddNewStockpileView: View {
    @StateObject private var viewModel: AddNewStockpileViewModel
    @Binding private var showingSheet: Bool

    init(savings: [any StockpileSavingType] = [], showingSheet: Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: AddNewStockpileViewModel(savings: savings))
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
                    ForEach(viewModel.uniqueSavings, id: \.id) { stockpileSaving in
                        NavigationLink(destination: AddNewStockpileSavingView(fromTemplate: stockpileSaving, showingSheet: $showingSheet)) {
                            Text(stockpileSaving.productDescription)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(Text("Add Savings"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showingSheet.toggle()
                    }
                    .padding(Constants.defaultPadding)
                    .foregroundColor(Constants.stockpileColor)
                }
            }
            .alert("An error occurred when trying to fetch all savings.", isPresented: $viewModel.showingErrorAlert) {
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
        Group {
            AddNewStockpileView(savings: MockStockpileSaving.samples, showingSheet: .constant(true))

            AddNewStockpileView(savings: MockStockpileSaving.samples, showingSheet: .constant(true))
                .preferredColorScheme(.dark)
        }
    }
}
