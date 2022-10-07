//
//  CaptureResult.swift
//  Sneaker Authentication Demo
//
//  Created by Felipe Garcia on 11/09/2022.
//

import Foundation


struct CaptureResult: Codable {
    let authenticationId: String  //ID assigned by Entrupy for each submission
    let properties: CaptureResultProperties //Item details
    let status: CaptureResultStatus //Submission status
    let moreDetails: CaptureResultMoreDetails //More details about the submission
    let textFields: [CaptureResultTextField] //The text input submitted
    let timestamp: CaptureResultTimeStamp //Authentication start time
}

extension CaptureResult {
    init(dictionary: [AnyHashable: Any]) throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601

        self = try decoder.decode(CaptureResult.self, from: JSONSerialization.data(withJSONObject: dictionary))
    }
}

struct CaptureResultMoreDetailsPreview: Codable {
    var preview: String? //Link to the certificate issued. Applicable only if the result issued is Authentic
}

struct CaptureResultMoreDetails: Codable {
    let certificate: CaptureResultMoreDetailsPreview
}

struct CaptureResultProperties: Codable {
    let brand: CaptureResultPropertiesBrand
}

struct CaptureResultPropertiesBrand: Codable {
    let display: [String: String] //Display name for the brand submitted
    let id: String
}

struct CaptureResultStatus: Codable {
    let flag: CaptureResultStatusFlag
    let result: CaptureResultStatusResult //Result details
}

struct CaptureResultStatusFlag: Codable {
    let id: String
    let isFlaggable: Bool
}

struct CaptureResultStatusResult: Codable {
    let display: CaptureResultStatusResultDisplay //Result content for display
    let id: String //Result ID
    /*
     Possible id values and their corressponding display headers.
     Note that display values should not be assumed to be fixed.
     
     authentic: Authentic
     unknown: Unidentified
     not_supported: Not Supported
     needs_review: Under Review
     invalid: Invalid
     */
}

struct CaptureResultStatusResultDisplay: Codable {
    let header: String //Result display string
    let message: String? //More information about the result that can be displayed to the user
}

struct CaptureResultTextField: Codable {
    var content: String? //Text input or barcodes read
    let displayName: String //Display name for the input requested
}

struct CaptureResultTimeStamp: Codable {
    let display: String //Human-readable UTC timestamp
    let epoch: Double //The UNIX epoch (seconds since Jan 1 1970 UTC) for when the authentication was started
}

