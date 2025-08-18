//
//  InventoryItem.swift
//  Sample App
//
//  Created by Felipe Garcia on 14/08/2025.
//

import Foundation

// Base protocol for all inventory items
protocol InventoryItem {
    var productCategory: String { get }
    var customerItemID: String? { get }
    var displayName: String { get }
    var displaySubtitle: String { get }
    
    func validateRequiredFields() throws
    func buildInput() -> [String: Any]
}

// Sneaker model (updated)
struct SneakerItem: InventoryItem {
    let productCategory: String = "sneakers"
    let brand: String
    let styleName: String
    var usSize: String?
    var customerItemID: String?
    var styleCode: String?
    var upc: String?
    
    var displayName: String { brand }
    var displaySubtitle: String { styleName }
    
    func validateRequiredFields() throws {
        var missingFields: [String] = []
        
        if brand.isEmpty { missingFields.append("brand") }
        if styleName.isEmpty { missingFields.append("style_name") }
        
        if !missingFields.isEmpty {
            throw InventoryItemError.missingMandatoryFields("Sneaker: \(missingFields.joined(separator: ", "))")
        }
    }
    
    func buildInput() -> [String: Any] {
        return [
            "product_category": productCategory,
            "brand": brand,
            "style_name": styleName,
            "us_size": usSize ?? "",
            "style_code": styleCode ?? "",
            "upc": upc ?? "",
            "customer_item_id": customerItemID ?? ""
        ]
    }
}

// Apparel model (new)
struct ApparelItem: InventoryItem {
    let productCategory: String = "apparel"
    let brand: String
    let itemType: String
    var customerItemID: String?
    
    var displayName: String { brand }
    var displaySubtitle: String { itemType }
    
    func validateRequiredFields() throws {
        var missingFields: [String] = []
        
        if brand.isEmpty { missingFields.append("brand") }
        if itemType.isEmpty { missingFields.append("item_type") }
        
        if !missingFields.isEmpty {
            throw InventoryItemError.missingMandatoryFields("Apparel: \(missingFields.joined(separator: ", "))")
        }
    }
    
    func buildInput() -> [String: Any] {
        return [
            "product_category": productCategory,
            "brand": brand,
            "item_type": itemType,
            "customer_item_id": customerItemID ?? ""
        ]
    }
}

// Luxury model (new)
struct LuxuryItem: InventoryItem {
    let productCategory: String = "luxury"
    let brand: String
    var material: String?
    let customerItemID: String?

    var displayName: String { brand }
    var displaySubtitle: String { material ?? "" }

    func validateRequiredFields() throws {
     var missingFields: [String] = []
     
     if brand.isEmpty { missingFields.append("brand") }
     
     if !missingFields.isEmpty {
         throw InventoryItemError.missingMandatoryFields("Luxury: \(missingFields.joined(separator: ", "))")
     }
    }

    func buildInput() -> [String: Any] {
     return [
         "product_category": productCategory,
         "brand": brand,
         "material": material ?? "",
         "customer_item_id": customerItemID ?? ""
     ]
    }
}

enum InventoryItemError: LocalizedError {
    case missingMandatoryFields(String)
    
    var errorDescription: String? {
        switch self {
        case .missingMandatoryFields(let message):
            return "Missing required information: \(message)"
        }
    }
}
