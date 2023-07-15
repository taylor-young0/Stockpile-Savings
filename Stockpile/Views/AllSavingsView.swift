//
//  AllSavingsView.swift
//  Stockpile
//
//  Created by Taylor Young on 2023-07-14.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import SwiftUI

struct AllSavingsView: View {
    var julySavings: some View {
        VStack(alignment: .leading) {
            Text("July 2023")
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
                }
            }
            .cornerRadius(10)
        }
    }

    var juneSavings: some View {
        VStack(alignment: .leading) {
            Text("June 2023")
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
                }
            }
            .cornerRadius(10)
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    julySavings
                    juneSavings
                }
            }
            .background(Color.gray.opacity(0.2))
            .navigationTitle(Text("All Savings"))
        }
    }
}

struct AllSavingsView_Previews: PreviewProvider {
    static var previews: some View {
        AllSavingsView()
    }
}
