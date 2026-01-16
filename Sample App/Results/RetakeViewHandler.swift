//
//  RetakeViewHandler.swift
//  Sample App
//
//  Created by abdul on 03/09/25.
//

import Foundation
import EntrupySDK
import SwiftUI

class RetakeViewHandler: NSObject, ObservableObject, EntrupyRetakeCaptureDelegate {
    @Published var isLoading: Bool = false
    @Published var loadingEntrupyID: String? = nil
    let entrupyApp = EntrupyApp.sharedInstance()
    
    func openRetake(for entrupyID: String) {
        isLoading = true
        loadingEntrupyID = entrupyID
        entrupyApp.retakeCaptureDelegate = self
        entrupyApp.startRetakeCaptureForItem(withEntrupyID: entrupyID)

    }
    
    func didRetakeCaptureCompleteSuccessfully(_ result: [AnyHashable : Any], forItemWithEntrupyID entrupyID: String) {
        debugPrint("didRetakeCaptureCompleteSuccessfully withEntrupyID: \(entrupyID)")
        DispatchQueue.main.async {
            self.isLoading = false
            self.loadingEntrupyID = nil
        }
    }
    
    func didUserCancelRetakeCaptureForItem(withEntrupyID entrupyID: String) {
        debugPrint("didUserCancelRetakeCaptureForItem withEntrupyID: \(entrupyID)")
        DispatchQueue.main.async {
            self.isLoading = false
            self.loadingEntrupyID = nil
        }
    }
    
    func didRetakeCaptureFailWithError(_ errorCode: EntrupyErrorCode, description: String, localizedDescription: String, forItemWithEntrupyID entrupyID: String) {
        debugPrint("didRetakeCaptureFailWithError : \(errorCode), \(localizedDescription), withEntrupyID: \(entrupyID)")
        DispatchQueue.main.async {
            self.isLoading = false
            self.loadingEntrupyID = nil
            NotificationCenter.default.post(name: .showAlert,
                                          object: AlertData(title: Text("Error"),
                                                            message: Text(localizedDescription),
                                                            dismissButton: .default(Text("OK"))))
        }
    }
    
    func didRetakeCaptureTimeoutForItem(withEntrupyID entrupyID: String) {
        debugPrint("didRetakeCaptureTimeoutForItem withEntrupyID: \(entrupyID)")
        DispatchQueue.main.async {
            self.isLoading = false
            self.loadingEntrupyID = nil
            NotificationCenter.default.post(name: .showAlert,
                                          object: AlertData(title: Text("Timeout Alert"),
                                                            message: Text("Retake capture timeout for item with Entrupy ID: \(entrupyID)"),
                                                            dismissButton: .default(Text("OK"))))
        }
    }
}
