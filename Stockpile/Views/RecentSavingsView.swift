//
//  RecentSavingsView.swift
//  Stockpile
//
//  Created by Taylor Young on 2020-05-31.
//  Copyright © 2020 Taylor Young. All rights reserved.
//

import SwiftUI
import WidgetKit

struct RecentSavingsView: View {
    @StateObject private var viewModel: RecentSavingsViewModel = RecentSavingsViewModel()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: Constants.stockpileUIColor]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: Constants.stockpileUIColor]
    }
        
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Text(viewModel.lifetimeSavingsText)
                        Spacer()
                        Text(viewModel.lifetimeSavings)
                    }
                }
                
                Section(header: Text(viewModel.recentSavingsHeader)) {
                    if viewModel.recentStockpiles.count != 0 {
                        ForEach(viewModel.recentStockpiles) { stockpile in
                            StockpileSavingRow(stockpile: stockpile)
                        }
                        .onDelete { indexSet in
                            viewModel.deleteStockpileSaving(at: indexSet.first)
                        }
                    } else {
                        EmptySavingsRow()
                    }
                }
            }
            .onAppear {
                viewModel.reloadData()
            }
            .onChange(of: viewModel.showingSheet, perform: { newValue in
                if newValue == false {
                    viewModel.reloadData()
                }
            })
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle(Text(viewModel.navigationBarTitle))
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        viewModel.showingSheet.toggle()
                    } label: {
                        Image(systemName: viewModel.addStockpileSavingIconName)
                            .font(.title3.bold())
                            .foregroundColor(Constants.stockpileColor)
                            .padding(Constants.defaultPadding)
                    }
                }
            }
            .sheet(
                isPresented: $viewModel.showingSheet,
                content: {
                    if viewModel.recentStockpiles.count > 0 {
                        AddNewStockpileView(showingSheet: $viewModel.showingSheet)
                    } else {
                        NavigationView {
                            AddNewStockpileSavingView(showingSheet: $viewModel.showingSheet)
                        }
                    }
                }
            )
            .alert(viewModel.errorText, isPresented: $viewModel.showingErrorAlert) {
                Button("OK", role: .cancel) { }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RecentSavingsView()
                .previewDevice(.init(rawValue: "iPhone 11"))
            
            RecentSavingsView()
                .environment(\.colorScheme, .dark)
                .previewDevice(.init(rawValue: "iPhone 11"))
            
            EmptySavingsRow().previewLayout(.fixed(width: 375, height: 70))
                .padding(.horizontal)
        }
    }
}
