//
//  MockStockpileSaving+Samples.swift
//  Stockpile
//
//  Created by Taylor Young on 2023-07-16.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import Foundation

extension MockStockpileSaving {
    static var samples: [MockStockpileSaving] {
        [
            MockStockpileSaving(productDescription: "🍌 Bananas", regularPrice: 4, salePrice: 2, unitsPurchased: 6),
            MockStockpileSaving(productDescription: "🥑 Avocados", regularPrice: 8, salePrice: 6, unitsPurchased: 2),
            MockStockpileSaving(productDescription: "🥨 Pretzels", regularPrice: 4, salePrice: 3.50, unitsPurchased: 2),
            MockStockpileSaving(productDescription: "🍇 Grapes", regularPrice: 2, salePrice: 1.50, unitsPurchased: 1),
            MockStockpileSaving(productDescription: "🥐 Croissants", regularPrice: 10.99, salePrice: 8.99, unitsPurchased: 2),
            MockStockpileSaving(productDescription: "🧀 Cheese", regularPrice: 14.49, salePrice: 12.49, unitsPurchased: 1),
            MockStockpileSaving(productDescription: "🔋 Batteries", regularPrice: 14.99, salePrice: 12.99, unitsPurchased: 2),
            MockStockpileSaving(productDescription: "💡 Lightbulbs", regularPrice: 10.99, salePrice: 8.99, unitsPurchased: 4),
            MockStockpileSaving(productDescription: "🪒 Razor blades", regularPrice: 54.99, salePrice: 38.99, unitsPurchased: 2),
            MockStockpileSaving(productDescription: "🐢 Turtle food", regularPrice: 9.99, salePrice: 8.99, unitsPurchased: 3)
        ]
    }
}
