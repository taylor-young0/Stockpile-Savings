//
//  HomeView.swift
//  Stockpile
//
//  Created by Taylor Young on 2023-07-08.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel = HomeViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    statsSection
                    recentPurchasesSection
                }
            }
            .background(Color.gray.opacity(0.3))
            .navigationTitle(Text("Stockpile"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {

                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Color("Stockpile"))
                            .font(.title3)
                    }
                }
            }
        }
    }

    var statsSection: some View {
        VStack(alignment: .leading) {
            Text("Statistics")
                .font(.headline)
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    StatisticsCard(.lifetimeSavings)
                        .padding(.leading)
                    StatisticsCard(.averagePercentageSavings)
                        .padding(.trailing)
                }
            }
        }
    }

    var recentPurchasesSection: some View {
        VStack(alignment: .leading) {
            Text("Recent savings")
                .font(.headline)
                .padding(.horizontal)

            ZStack {
                Color.white

                VStack(alignment: .leading, spacing: 0) {
                    if viewModel.allStockpileSavings.isEmpty {
                        noSavingsYetRow
                    } else {
                        ForEach(viewModel.allStockpileSavings) { stockpile in
                            RecentSavingsRow(emoji: "🍌", name: "Bananas", units: 2, savingsAmount: 4, savingsPercentage: 25)
                        }
                        viewAllSavingsRow
                    }
                }
            }
            .cornerRadius(10)
        }
    }

    var viewAllSavingsRow: some View {
        HStack {
            Text("View all savings")
                .font(.caption)
                .fontWeight(.medium)

            Spacer(minLength: 0)

            Image(systemName: "arrow.right.square.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, Color("Stockpile"))
                .font(.title3)
        }
        .padding()
    }

    var noSavingsYetRow: some View {
        VStack(alignment: .leading) {
            Text("No savings added yet!")
                .font(.caption)
                .fontWeight(.medium)
            Text("Add savings by completing a new calculation by pressing the + icon in the top right")
                .font(.caption2)
        }
        .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
