//
//  LifetimeSavingsCard.swift
//  Stockpile
//
//  Created by Taylor Young on 2023-07-08.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import SwiftUI

struct LifetimeSavingsCard: View {
    var lifetimeSavings: String
    var firstSavingsDate: Date?

    var body: some View {
        BaseStatisticsCard(color: .gray) {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading) {
                    Text("Lifetime savings")
                        .font(.caption)
                    Text(lifetimeSavings)
                        .font(.title)
                }

                Spacer()

                if let firstSavingsDate {
                    VStack(alignment: .leading) {
                        Text("Since")
                            .font(.caption)
                        Text(firstSavingsDate, style: .date)
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

struct LifetimeSavingsCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            LifetimeSavingsCard(lifetimeSavings: "$287.19", firstSavingsDate: Date())
        }
    }
}
