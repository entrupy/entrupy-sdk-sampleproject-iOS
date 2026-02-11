//
//  InventoryData.swift
//  Sample App
//
//  Created by Felipe Garcia on 14/08/2025.
//

import Foundation

struct InventoryData {
    // Product items for Authentication section
    static let luxuryProducts: [any InventoryItem] = [
        LuxuryItem(
            brand: "Louis Vuitton",
            material: "Monogram Canvas",
            customerItemID: "item-000"
        )
    ]

    static let sneakerProducts: [any InventoryItem] = [
        SneakerItem(
            brand: "Nike",
            styleName: "Air Jordan 1 High OG Stash",
            usSize: "9.5",
            customerItemID: "item-001"
        )
    ]

    static let apparelProducts: [any InventoryItem] = [
        ApparelItem(
            brand: "Bape",
            itemType: "Outerwear",
            customerItemID: "item-002"
        )
    ]

    // Fingerprint items for Fingerprint section
    static let luxuryFingerprint: [any InventoryItem] = [
        FingerprintItem(
            productCategory: "luxury",
            captureWorkflow: "fingerprint_register",
            actionName: "Register",
            customerItemID: "FP-LUX-001"
        ),
        FingerprintItem(
            productCategory: "luxury",
            captureWorkflow: "fingerprint_compare",
            actionName: "Compare",
            customerItemID: "FP-LUX-001"
        )
    ]

    static let sneakerFingerprint: [any InventoryItem] = [
        FingerprintItem(
            productCategory: "sneakers",
            captureWorkflow: "fingerprint_register",
            actionName: "Register",
            customerItemID: "FP-SNK-001"
        ),
        FingerprintItem(
            productCategory: "sneakers",
            captureWorkflow: "fingerprint_compare",
            actionName: "Compare",
            customerItemID: "FP-SNK-001"
        )
    ]

    static let apparelFingerprint: [any InventoryItem] = [
        FingerprintItem(
            productCategory: "apparel",
            captureWorkflow: "fingerprint_register",
            actionName: "Register",
            customerItemID: "FP-APP-001"
        ),
        FingerprintItem(
            productCategory: "apparel",
            captureWorkflow: "fingerprint_compare",
            actionName: "Compare",
            customerItemID: "FP-APP-001"
        )
    ]

    // Main sections with subsections
    static var allSections: [(String, [(String, [any InventoryItem])])] {
        return [
            ("Authentication", [
                ("Luxury", luxuryProducts),
                ("Sneakers", sneakerProducts),
                ("Apparel", apparelProducts)
            ]),
            ("Fingerprint", [
                ("Luxury", luxuryFingerprint),
                ("Sneakers", sneakerFingerprint),
                ("Apparel", apparelFingerprint)
            ])
        ]
    }
}
