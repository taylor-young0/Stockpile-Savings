//
//  LifetimeSavingsCard.swift
//  Stockpile
//
//  Created by Taylor Young on 2023-07-08.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import SwiftUI

struct LifetimeSavingsCard: View {
    var body: some View {
        BaseStatisticsCard(color: .black) {
            VStack(alignment: .leading, spacing: 0) {
                Text("CAD")
                    .font(.headline)

                VStack(alignment: .leading) {
                    Text("Lifetime savings")
                        .font(.caption)
                    Text("$287.19")
                        .font(.title)
                }
                .padding(.vertical)

                Spacer()

                VStack(alignment: .leading) {
                    Text("Since")
                        .font(.caption)
                    Text("January 10th, 2021")
                        .font(.caption2)
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
            LifetimeSavingsCard()
        }
    }
}
