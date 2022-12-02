//
//  InventoryList.swift
//  Sneaker Authentication Demo
//
//  Created by Dharini Raghavan on 6/17/22.
//

import SwiftUI
import EntrupySDK

struct InventoryList: View {
    let entrupyApp = EntrupyApp.sharedInstance()

    private let inventoryListHandlers = InventoryListHandlers()
    private var dataDelegate = InventoryListDataDelegate()

    @Binding var selectedTab: MenuItem

    init(selectedTab: Binding<MenuItem>) {
        self._selectedTab = selectedTab
    }
    
    var body: some View {

        NavigationView {
            List(sneakerList) { sneaker in
                InventoryRow(
                    sneaker: sneaker,
                    captureDelegate: dataDelegate
                )
            }
            .navigationBarTitle("Inventory")
            .buttonStyle(PlainButtonStyle())
        }.onAppear {
            
            guard selectedTab == .inventory else { return }
            
            if SDKAuthorization.sharedInstance.isAboutToExpire() {

                SDKAuthorization.sharedInstance.createSDKAuthorizationRequest { success, error in
                    guard error == nil else {
                        print(error?.description ?? "")

                        DispatchQueue.main.async {
                        NotificationCenter.default.post(name: .showAlert,
                                                        object: AlertData(title: Text("Error"),
                                                                          message: Text(error?.description ?? ""),
                                                                          dismissButton: .default(Text("OK"))))
                        }
                        
                        return
                    }
                    if success {
                       print("SDK Authorization completed successfully!")
                    }
                }
            }
            
            if (entrupyApp.isAuthorizationValid()) {
                entrupyApp.configDelegate = inventoryListHandlers
                entrupyApp.fetchConfigurationType(EntrupyConfigType.ConfigTypeProduction)
            }
            else {
                //Re-authorize and call fetchConfigurationType again
                SDKAuthorization.sharedInstance.createSDKAuthorizationRequest { success, error in
                    guard error == nil else {
                        print(error?.description ?? "")

                        DispatchQueue.main.async {
                        NotificationCenter.default.post(name: .showAlert,
                                                        object: AlertData(title: Text("Error"),
                                                                          message: Text(error?.description ?? ""),
                                                                          dismissButton: .default(Text("OK"))))
                        }
                        
                        return
                    }
                    if success {
                        print("SDK Authorization completed successfully!")
                        entrupyApp.configDelegate = inventoryListHandlers
                        entrupyApp.fetchConfigurationType(EntrupyConfigType.ConfigTypeProduction)
                    }
                }
            }
        }
    }
}

class InventoryListDataDelegate: NSObject, EntrupyCaptureDelegate {
  
    func didCaptureTimeout(forItem item: [AnyHashable : Any]) {
        DispatchQueue.main.async {

        NotificationCenter.default.post(name: .showAlert,
                                        object: AlertData(title: Text("Info"),
                                                          message: Text("The capture timed out. Please resubmit the item."),
                                                          dismissButton: .default(Text("OK"))))
        }

    }
    
    
    
    func didCaptureCompleteSuccessfully(_ result: [AnyHashable : Any], forItem item: [AnyHashable : Any]) {
        DispatchQueue.main.async {
            
            do {
                let parsedData = try CaptureResult(dictionary:result)
                
                NotificationCenter.default.post(name: .showAlert,
                                                object: AlertData(title: Text("Info"),
                                                                  message: Text("Your \(parsedData.properties.brand.display["name"]!) item was successfully submitted to Entrupy for verification"),
                                                                  dismissButton: .default(Text("OK"))))
            } catch {
                print(error)
            }
        }
        
    }
    
    func didUserCancelCapture(forItem item: [AnyHashable : Any]) {
        print("The user canceled the capture and did not submit the item for verification\n")
        //Add any necessry handling

    }
    
    func didCaptureFailWithError(_ errorCode: EntrupyErrorCode, description: String, localizedDescription: String, forItem item: [AnyHashable : Any]) {
        
        DispatchQueue.main.async {

        NotificationCenter.default.post(name: .showAlert,
                                        object: AlertData(title: Text("didCaptureFailWithError"),
                                                          message: Text(localizedDescription),
                                                          dismissButton: .default(Text("OK"))))
        }
    }
}
class InventoryListHandlers: NSObject, EntrupyConfigDelegate {
    
    func didFetchConfigurationSuccessfully() {
        print("The configuration was fetched successfully\n")
    }
    
    func didFetchConfigurationFailWithError(_ errorCode: EntrupyErrorCode, description: String, localizedDescription: String) {
        DispatchQueue.main.async {

        NotificationCenter.default.post(name: .showAlert,
                                        object: AlertData(title: Text("didFetchConfigurationFailWithError"),
                                                          message: Text(localizedDescription),
                                                          dismissButton: .default(Text("OK"))))
        }
    }

}


struct InventoryList_Previews: PreviewProvider {
    static var previews: some View {
        InventoryList(selectedTab: Binding.constant(.inventory))
    }
}
