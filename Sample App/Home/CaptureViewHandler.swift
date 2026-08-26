//
//  CaptureViewHandler.swift
//  Sample App
//
//  Created by abdul on 28/07/26.
//

import Foundation
import SwiftUI
import UIKit
import EntrupySDK

final class CaptureViewHandler: NSObject, ObservableObject, EntrupyCaptureDelegate {
    private let entrupyApp = EntrupyApp.sharedInstance()

    func startCapture(with input: [String: Any]) {
        guard let viewController = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first?.rootViewController else {
            return
        }

        entrupyApp.captureDelegate = self
        entrupyApp.startCapture(forItem: input, viewController: viewController)
    }

    func didCaptureTimeout(forItem item: [AnyHashable: Any]) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .showAlert,
                                            object: AlertData(title: Text("Info"),
                                                              message: Text("The capture timed out. Please resubmit the item."),
                                                              dismissButton: .default(Text("OK"))))
        }
    }

    func didCaptureCompleteSuccessfully(_ result: [AnyHashable: Any], forItem item: [AnyHashable: Any]) {
        DispatchQueue.main.async {
            do {
                let parsedData = try EntrupyCaptureResult(dictionary: result)
                let brandName = parsedData.properties.brand.display["name"] ?? "-"
                NotificationCenter.default.post(name: .showAlert,
                                                object: AlertData(title: Text("Info"),
                                                                  message: Text("Your \(brandName) item was successfully submitted to Entrupy for verification"),
                                                                  dismissButton: .default(Text("OK"))))
            } catch {
                NotificationCenter.default.post(name: .showAlert,
                                                object: AlertData(title: Text("Capture Error"),
                                                                  message: Text(error.localizedDescription),
                                                                  dismissButton: .default(Text("OK"))))
            }
        }
    }

    func didUserCancelCapture(forItem item: [AnyHashable: Any]) {
        print("The user canceled the capture and did not submit the item for verification\n")
    }

    func didCaptureFailWithError(_ errorCode: EntrupyErrorCode, description: String, localizedDescription: String, forItem item: [AnyHashable: Any]) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .showAlert,
                                            object: AlertData(title: Text("Capture Error"),
                                                              message: Text(localizedDescription),
                                                              dismissButton: .default(Text("OK"))))
        }
    }
}
