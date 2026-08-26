//
//  Theme.swift
//  Sneaker Authentication Demo
//
//  Created by Muhammad Waqas on 01/12/2022.
//

import Foundation
import EntrupySDK
import SwiftUI

class Theme: EntrupyTheme {
    
    var borderColor: UIColor? = UIColor.lightGray
    var backgroundColor: UIColor? = UIColor.white
    var foregroundColor: UIColor? = UIColor.black
    
}


enum EntrupyColors {
    private static let sdkBundle = Bundle(for: EntrupyApp.self)

    static let background = Color("PrimaryBlack", bundle: sdkBundle)
    static let cardBackground = Color("PrimaryBlue00", bundle: sdkBundle)
    static let gold = Color("PrimaryGold", bundle: sdkBundle)
    static let fieldBorder = Color("TransparentWhite20", bundle: sdkBundle)
    static let fieldText = Color("PrimaryWhite", bundle: sdkBundle)
    static let placeholderText = Color("TransparentWhite40", bundle: sdkBundle)
    static let subtitleText = Color("PrimaryWhite", bundle: sdkBundle).opacity(0.6)
    static let redBorder = Color("PrimaryRed00", bundle: sdkBundle)
}
