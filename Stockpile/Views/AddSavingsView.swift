//
//  AddSavingsView.swift
//  Stockpile
//
//  Created by Taylor Young on 2021-09-13.
//  Copyright © 2021 Taylor Young. All rights reserved.
//

import SwiftUI

struct AddSavingsView: View {
    @StateObject private var viewModel: AddSavingsViewModel
    @Binding private var showingSheet: Bool

    init(showingSheet: Binding<Bool>, context: ManagedObjectContextType = StorageType.persistent.managedObjectContext) {
        self._viewModel = StateObject(wrappedValue: AddSavingsViewModel(context: context))
        self._showingSheet = showingSheet
    }

    // MARK: - Body

    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: AddSavingsFormView(showingSheet: $showingSheet)) {
                        Text("💰 Add new savings from scratch")
                    }
                }
                
                Section(header: Text("Create from template")) {
                    ForEach(viewModel.uniqueSavings, id: \.id) { stockpileSaving in
                        NavigationLink(destination: AddSavingsFormView(fromTemplate: stockpileSaving, showingSheet: $showingSheet)) {
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

struct AddSavingsView_Previews: PreviewProvider {
    static var previews: some View {
        AddSavingsView(showingSheet: .constant(true), context: StorageType.inmemory(.few).managedObjectContext)

        AddSavingsView(showingSheet: .constant(true), context: StorageType.inmemory(.manyWithDuplicates).managedObjectContext)

        AddSavingsView(showingSheet: .constant(true), context: StorageType.inmemory(.few).managedObjectContext)
            .preferredColorScheme(.dark)
    }
}
