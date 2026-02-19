//
//  MarketEdgeViewHandler.swift
//  Sample App
//
//  Created by abdul on 06/01/26.
//

import Foundation
import EntrupySDK
import SwiftUI

class MarketEdgeViewHandler: NSObject, ObservableObject, EntrupyMarketEdgeViewDelegate {

    @Published var isLoading: Bool = false
    @Published var loadingEntrupyID: String? = nil
    
    let entrupyApp = EntrupyApp.sharedInstance()
    
    func openMarketEdgeView(for entrupyID: String) {
        isLoading = true
        loadingEntrupyID = entrupyID
        entrupyApp.marketEdgeViewDelegate = self
        let viewConfiguration = EntrupyMarketEdgeViewConfiguration(displayMarketGrade: true,
                                                                   displayMarketValue: true,
                                                                   displayMarketMatch: true,
                                                                   displayRegionSelection: true)
        entrupyApp.displayMarketEdgeViewForItem(withEntrupyID: entrupyID, withConfiguration: viewConfiguration)
    }
    
    func didDisplayMarketEdgeViewForItem(withEntrupyID entrupyID: String) {
        debugPrint("didDisplayMarketEdgeViewForItem withEntrupyID: \(entrupyID)")
        DispatchQueue.main.async {
            self.isLoading = false
            self.loadingEntrupyID = nil
        }
    }
    
    func didDismissMarketEdgeViewForItem(withEntrupyID entrupyID: String) {
        debugPrint("didDismissMarketEdgeViewForItem withEntrupyID: \(entrupyID)")
        DispatchQueue.main.async {
            self.isLoading = false
            self.loadingEntrupyID = nil
        }
    }
    
    func didDisplayMarketEdgeViewFailWithError(_ errorCode: EntrupyErrorCode, description: String, localizedDescription: String, forEntrupyID entrupyID: String) {
        debugPrint("didDisplayMarketEdgeViewFailWithError : \(errorCode), \(localizedDescription), withEntrupyID: \(entrupyID)")
        DispatchQueue.main.async {
            self.isLoading = false
            self.loadingEntrupyID = nil
            NotificationCenter.default.post(name: .showAlert,
                                          object: AlertData(title: Text("Error"),
                                                            message: Text(localizedDescription),
                                                            dismissButton: .default(Text("OK"))))
        }
    }
    

}
