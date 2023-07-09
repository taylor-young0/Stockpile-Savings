//
//  StatisticsCard.swift
//  Stockpile
//
//  Created by Taylor Young on 2023-07-08.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import SwiftUI

struct StatisticsCard: View {
    var type: StatType

    init(_ type: StatType) {
        self.type = type
    }

    var body: some View {
        switch type {
        case .lifetimeSavings:
            LifetimeSavingsCard()
        case .averagePercentageSavings:
            PercentageSavingsCard()
        }
    }
}

extension StatisticsCard {
    enum StatType {
        case lifetimeSavings
        case averagePercentageSavings
    }
}

struct StatisticsCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            StatisticsCard(.lifetimeSavings)
        }
    }
}
