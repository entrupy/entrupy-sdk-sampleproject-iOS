//
//  Sneakers.swift
//  Sneaker Authentication Demo
//
//  Created by Dharini Raghavan on 6/17/22.
//

import Foundation

struct Sneaker: Identifiable {
  var id: Int
  let brand: String
  let style: String
  let USSize: String
  let UPC: String?
  let styleCode: String?
  let customerItemID: String?
}

var sneakerList = [
    Sneaker(id: 0, brand: "Nike", style: "Air Jordan 1 High OG 'Stash'", USSize: "9.5", UPC: nil, styleCode: nil, customerItemID: "Item-0"),
    Sneaker(id: 1, brand: "Nike", style: "Air Max 97/BW Metallic Gold Red", USSize: "8.5", UPC: nil, styleCode: nil, customerItemID: "Item-1"),
    Sneaker(id: 2, brand: "Nike", style: "Air Max 90 Essential Volt", USSize: "10", UPC: nil, styleCode: nil, customerItemID: "Item-2"),
    Sneaker(id: 3, brand: "Adidas", style: "Yeezy Boost 350 V2 Black Red", USSize: "11", UPC: nil, styleCode: nil, customerItemID: "Item-3"),
    Sneaker(id: 4, brand: "Adidas", style: "Top Ten Hi Miami Hurricanes", USSize: "11", UPC: nil, styleCode: nil, customerItemID: "Item-4"),
    Sneaker(id: 5, brand: "Nike", style: "AIR FORCE 1 MID 07", USSize: "8", UPC: nil, styleCode: "315123-111", customerItemID: "Item-5"),
    Sneaker(id: 6, brand: "Nike", style: "NIKE AIR VAPORMAX FLYKNIT 2", USSize: "11", UPC: nil, styleCode: "942842-017", customerItemID: "Item-6"),
    Sneaker(id: 7, brand: "Nike", style: "Air Max 97 UL 17", USSize: "11", UPC: nil, styleCode: "918356-003", customerItemID: "Item-7"),
    Sneaker(id: 8, brand: "Nike", style: "AIR FORCE 1  07", USSize: "10", UPC: nil, styleCode: "AA4083-102", customerItemID: "Item-8"),
    Sneaker(id: 9, brand: "Nike", style: "AIR FORCE 1 '07 LV8 1", USSize: "10", UPC: nil, styleCode: "AO2439-600", customerItemID: "Item-9"),
    Sneaker(id: 10, brand: "Nike", style: "AIR FORCE 1 07", USSize: "9", UPC: nil, styleCode: "AA4083-102", customerItemID: "Item-10"),
    Sneaker(id: 11, brand: "Nike", style: "NIKE AIR VAPORMAX FLYKNIT 2", USSize: "9", UPC: nil, styleCode: "942842-017", customerItemID: "Item-11"),
    Sneaker(id: 12, brand: "Nike", style: "AIR JORDAN 12 RETRO CNY (GS)", USSize: "6", UPC: nil, styleCode: "BQ6497-006", customerItemID: "Item-12"),
    Sneaker(id: 13, brand: "Nike", style: "AIR FORCE 1 '07 LV8 1", USSize: "10", UPC: nil, styleCode: "AO2439-600", customerItemID: "Item-13"),
    Sneaker(id: 14, brand: "Nike", style: "AIR JORDAN 6 RETRO LTR", USSize: "9", UPC: nil, styleCode: "CL3125-100", customerItemID: "Item-14"),
    Sneaker(id: 15, brand: "New Balance", style: "New Balance 1906", USSize: "9", UPC: nil, styleCode: "M1906NC", customerItemID: "Item-15"),
    Sneaker(id: 16, brand: "New Balance", style: "New Balance 990v6", USSize: "8.5", UPC: nil, styleCode: "M990GL6", customerItemID: "Item-16")
  ]
