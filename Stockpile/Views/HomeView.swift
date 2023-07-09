//
//  HomeView.swift
//  Stockpile
//
//  Created by Taylor Young on 2023-07-08.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                headerView
                    .padding(.horizontal)
                statsSection
                recentPurchasesSection
            }
        }
        .background(Color.gray.opacity(0.3))
    }

    var headerView: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Stockpile")
                .font(.title3.bold())

            Spacer(minLength: 0)

            Button {

            } label: {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(Color("Stockpile"))
                    .font(.title)
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
                    RecentSavingsRow(emoji: "🍌", name: "Bananas", units: 2, savingsAmount: 4, savingsPercentage: 25)
                    RecentSavingsRow(emoji: "🥑", name: "Avocados", units: 2, savingsAmount: 4, savingsPercentage: 25)
                    RecentSavingsRow(emoji: "🥐", name: "Croissants", units: 2, savingsAmount: 4, savingsPercentage: 25)
                    RecentSavingsRow(emoji: "🍇", name: "Grapes", units: 2, savingsAmount: 4, savingsPercentage: 25)
                    RecentSavingsRow(emoji: "🥨", name: "Pretzels", units: 2, savingsAmount: 4, savingsPercentage: 25)
                    viewAllSavingsRow
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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
