//
//  PercentageSavingsCard.swift
//  Stockpile
//
//  Created by Taylor Young on 2023-07-08.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import SwiftUI

struct PercentageSavingsCard: View {
    var averagePercentageSavings: Int?
    var savingsRange: (Int, Int)?

    private var averagePercentageSavingsText: String {
        if let averagePercentageSavings {
            return "\(averagePercentageSavings)%"
        } else {
            return "--"
        }
    }

    var body: some View {
        BaseStatisticsCard(color: Color("Stockpile")) {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading) {
                    Text("Average percentage savings")
                        .font(.caption)
                    Text(averagePercentageSavingsText)
                        .font(.title)
                }
                .padding(.bottom)

                Spacer()

                if let savingsRange {
                    VStack(alignment: .leading) {
                        Text("Range")
                            .font(.caption)
                        Text("\(savingsRange.0)% - \(savingsRange.1)%")
                            .font(.caption2)
                    }
                }
            }
            .padding()
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct PercentageSavingsCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            PercentageSavingsCard(averagePercentageSavings: 25, savingsRange: (20, 50))
        }
    }
}
