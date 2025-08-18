//
//  InventoryData.swift
//  Sample App
//
//  Created by Felipe Garcia on 14/08/2025.
//

import Foundation

struct InventoryData {
    static let luxury = [
        LuxuryItem(
            brand: "Louis Vuitton",
            material: "Monogram Canvas",
            customerItemID: "item-000"
        )
    ]
    
    static let sneakers = [
        SneakerItem(
            brand: "Nike",
            styleName: "Air Jordan 1 High OG Stash",
            usSize: "9.5",
            customerItemID: "item-001"
        )
    ]
    
    static let apparel = [
        ApparelItem(
            brand: "Bape", //Fear of God Essentials
            itemType: "Outerwear",
            customerItemID: "item-002"
        )
    ]
    
    static var allCategories: [(String, [any InventoryItem])] {
        return [
            ("Luxury", luxury),
            ("Sneakers", sneakers),
            ("Apparel", apparel)
        ]
    }
}
