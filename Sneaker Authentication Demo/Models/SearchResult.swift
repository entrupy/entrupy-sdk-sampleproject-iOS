//
//  SearchResult.swift
//  Sneaker Authentication Demo
//
//  Created by Felipe Garcia on 12/09/2022.
//

import Foundation

struct SearchResult: Codable {
    let itemCount: Int //Number of items returned
    let items: [CaptureResult]
    let nextCursor: [String]? //Next page cursor
}

extension SearchResult {
    init(dictionary: [AnyHashable: Any]) throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601

        self = try decoder.decode(SearchResult.self, from: JSONSerialization.data(withJSONObject: dictionary))
    }
}
