//
//  ConfigurationManager.swift
//  Sample App
//
//  Created by abdul on 12/08/25.
//

import Foundation
import EntrupySDK
import SwiftUI

class ConfigurationManager: NSObject, ObservableObject {
    let entrupyApp = EntrupyApp.sharedInstance()
    @Published var isConfigurationLoaded = false
    
    override init() {
        super.init()
        entrupyApp.configDelegate = self
    }
    
    func loadConfiguration() {
        debugPrint("ConfigurationManager: Starting configuration load...")
        entrupyApp.fetchConfigurationType(EntrupyConfigType.ConfigTypeProduction)
    }
}

//MARK: - Config Delegates
extension ConfigurationManager: EntrupyConfigDelegate {
    func didFetchConfigurationSuccessfully() {
        debugPrint("ConfigurationManager: didFetchConfigurationSuccessfully")
        DispatchQueue.main.async {
            self.isConfigurationLoaded = true
        }
    }
    
    func didFetchConfigurationFailWithError(_ errorCode: EntrupyErrorCode, description: String, localizedDescription: String) {
        debugPrint("ConfigurationManager: didFetchConfigurationFailWithError - \(localizedDescription)")
        DispatchQueue.main.async {
            self.isConfigurationLoaded = false
            NotificationCenter.default.post(name: .showAlert,
                                            object: AlertData(title: Text("Configuration Error"),
                                                              message: Text(localizedDescription),
                                                              dismissButton: .default(Text("OK"))))
        }
    }
}
