//
//  PercentageSavingsCard.swift
//  Stockpile
//
//  Created by Taylor Young on 2023-07-08.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import SwiftUI

struct PercentageSavingsCard: View {
    var body: some View {
        BaseStatisticsCard(color: Color("Stockpile")) {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading) {
                    Text("Average percentage savings")
                        .font(.caption)
                    Text("30%")
                        .font(.title)
                }
                .padding(.bottom)

                Spacer()

                VStack(alignment: .leading) {
                    Text("Range")
                        .font(.caption)
                    Text("10% - 65%")
                        .font(.caption2)
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
            PercentageSavingsCard()
        }
    }
}
