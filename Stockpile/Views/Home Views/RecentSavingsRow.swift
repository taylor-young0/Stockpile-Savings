//
//  RecentSavingsRow.swift
//  Stockpile
//
//  Created by Taylor Young on 2023-07-09.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import SwiftUI

struct RecentSavingsRow: View {
    var emoji: String
    var name: String
    var units: Int
    var savingsAmount: Double
    var savingsPercentage: Int

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(emoji)
                    .padding(6)
                    .background(Color.gray.opacity(0.3))
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text(name)
                    Text("\(units) units")
                        .foregroundColor(.secondary)
                }
                .font(.caption)
                .multilineTextAlignment(.leading)

                Spacer()

                VStack(alignment: .trailing) {
                    Text("$\(savingsAmount, specifier: "%.2f") off")
                    Text("\(savingsPercentage)% savings")
                        .foregroundColor(.secondary)
                }
                .font(.caption)
                .multilineTextAlignment(.trailing)
            }
            .padding()

            Divider()
                .padding(.leading)
        }
    }
}
struct RecentSavingsRow_Previews: PreviewProvider {
    static var previews: some View {
        RecentSavingsRow(emoji: "🍌", name: "Bananas", units: 2, savingsAmount: 4, savingsPercentage: 25)
    }
}
