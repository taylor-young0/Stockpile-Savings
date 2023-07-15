//
//  HomeViewModel.swift
//  Stockpile
//
//  Created by Taylor Young on 2023-07-14.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var allStockpileSavings: [StockpileSaving] = []
}
