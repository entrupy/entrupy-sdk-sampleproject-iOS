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

class SamplePartialTheme: EntrupyTheme {
    var borderColor: UIColor? = nil
    var backgroundColor: UIColor? = UIColor.white
    var foregroundColor: UIColor? = nil
}

class SampleBlackTheme: EntrupyTheme {
    var borderColor: UIColor? = UIColor.darkGray
    var backgroundColor: UIColor? = UIColor.black
    var foregroundColor: UIColor? = UIColor.white
}

enum SampleThemeOption: String, CaseIterable, Identifiable {
    case sdkDefault
    case light
    case partial
    case black

    static let storageKey = "sample_app_sdk_theme"

    static var stored: SampleThemeOption {
        UserDefaults.standard.string(forKey: storageKey).flatMap(SampleThemeOption.init(rawValue:)) ?? .sdkDefault
    }

    var id: Self { self }

    var title: String {
        switch self {
        case .sdkDefault:
            return "Default"
        case .light:
            return "Light"
        case .partial:
            return "Partial"
        case .black:
            return "Black"
        }
    }

    var theme: EntrupyTheme? {
        switch self {
        case .sdkDefault:
            return nil
        case .light:
            return Theme()
        case .partial:
            return SamplePartialTheme()
        case .black:
            return SampleBlackTheme()
        }
    }
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
