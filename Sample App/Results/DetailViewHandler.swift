//
//  DetailViewHandler.swift
//  Sample App
//
//  Created by abdul on 12/08/25.
//

import Foundation
import EntrupySDK
import SwiftUI

class DetailViewHandler: NSObject, ObservableObject, EntrupyDetailViewDelegate {
    
    let entrupyApp = EntrupyApp.sharedInstance()
    
    func showDetailView(for entrupyID: String) {
        entrupyApp.detailViewDelegate = self
        let viewConfiguration = EntrupyDetailViewConfiguration(displayTimeline: true,
                                                               displayUploadedImages: true,
                                                               enableFlagging: true,
                                                               enableItemDetailEdit: true)
        entrupyApp.displayDetailViewForItem(withEntrupyID: entrupyID, withConfiguration: viewConfiguration)
    }
    
    func didDisplayDetailViewForItem(withEntrupyID entrupyID: String) {
        debugPrint("didDisplayDetailViewForItem withEntrupyID: \(entrupyID)")
    }
    
    func didDismissDetailViewForItem(withEntrupyID entrupyID: String) {
        debugPrint("didDismissDetailViewForItem withEntrupyID: \(entrupyID)")
    }
    
    func didDisplayDetailViewFailWithError(_ errorCode: EntrupyErrorCode, description: String, localizedDescription: String, forEntrupyID entrupyID: String) {
        debugPrint("didDisplayDetailViewFailWithError : \(errorCode), \(localizedDescription), withEntrupyID: \(entrupyID)")
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .showAlert,
                                          object: AlertData(title: Text("Error"),
                                                            message: Text(localizedDescription),
                                                            dismissButton: .default(Text("OK"))))
        }
    }
}
