//
//  BaseStatisticsCard.swift
//  Stockpile
//
//  Created by Taylor Young on 2023-07-08.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import SwiftUI

struct BaseStatisticsCard<Content: View>: View {
    var color: Color
    var content: () -> Content

    var body: some View {
        ZStack {
            color
            content()
        }
        .frame(width: 200)
        .frame(minHeight: 180)
        .clipShape(Rectangle())
        .cornerRadius(15)
    }
}

struct BaseStatisticCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            LifetimeSavingsCard(lifetimeSavings: "$287.19", firstSavingsDate: Date())
        }
    }
}
