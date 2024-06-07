//
//  CaptureResult.swift
//  Sneaker Authentication Demo
//
//  Created by Felipe Garcia on 11/09/2022.
//

import Foundation
import EntrupySDK

extension EntrupySearchResult {
    init(dictionary: [AnyHashable: Any]) throws {
        let decoder = JSONDecoder()
        let jsonData = try JSONSerialization.data(withJSONObject: dictionary)
        self = try decoder.decode(EntrupySearchResult.self, from: jsonData)
    }
}

extension EntrupyCaptureResult {
    init(dictionary: [AnyHashable: Any]) throws {
        let decoder = JSONDecoder()
        let jsonData = try JSONSerialization.data(withJSONObject: dictionary)
        self = try decoder.decode(EntrupyCaptureResult.self, from: jsonData)
    }
}
