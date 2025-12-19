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

    private var dataDelegate = InventoryListDataDelegate()
    @StateObject private var configManager = ConfigurationManager()
    @State private var isLoading = false
    
    @Binding var selectedTab: MenuItem

    init(selectedTab: Binding<MenuItem>) {
        self._selectedTab = selectedTab
    }
    
    var body: some View {
        NavigationView {
            if isLoading {
                VStack {
                    ProgressView("Loading configuration...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
            } else if configManager.isConfigurationLoaded {
                List {
                    ForEach(InventoryData.allCategories, id: \.0) { category, items in
                        Section(header: Text(category)) {
                            ForEach(items, id: \.productCategory) { item in
                                InventoryRow(
                                    item: item,
                                    captureDelegate: dataDelegate
                                )
                            }
                        }
                    }
                }
                .navigationBarTitle("Home")
                .buttonStyle(PlainButtonStyle())

            } else {
                VStack {
                    Text("Configuration not loaded")
                        .foregroundColor(.secondary)
                        .padding()
                    Button("Retry Configuration") {
                        loadConfiguration()
                    }
                    .foregroundColor(.blue)
                    .padding()
                }
            }
        }.onAppear {
            guard selectedTab == .inventory else { return }
            guard !isLoading && !configManager.isConfigurationLoaded else { return }
            
            if SDKAuthorization.sharedInstance.isAboutToExpire() {
                SDKAuthorization.sharedInstance.createSDKAuthorizationRequest { success, error in
                    guard error == nil else {
                        DispatchQueue.main.async {
                        NotificationCenter.default.post(name: .showAlert,
                                                        object: AlertData(title: Text("Error"),
                                                                          message: Text(error?.description ?? ""),
                                                                          dismissButton: .default(Text("OK"))))
                        }
                        return
                    }
                }
            }
            
            if (entrupyApp.isAuthorizationValid()) {
                loadConfiguration()
            }
            else {
                SDKAuthorization.sharedInstance.createSDKAuthorizationRequest { success, error in
                    guard error == nil else {
                        DispatchQueue.main.async {
                        NotificationCenter.default.post(name: .showAlert,
                                                        object: AlertData(title: Text("Error"),
                                                                          message: Text(error?.description ?? ""),
                                                                          dismissButton: .default(Text("OK"))))
                        }
                        return
                    }
                    if success {
                        loadConfiguration()
                    }
                }
            }
        }
        .onChange(of: configManager.isConfigurationLoaded) { _ in
            isLoading = false
        }
    }
    
    private func loadConfiguration() {
        isLoading = true
        configManager.loadConfiguration()
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
                let parsedData = try EntrupyCaptureResult(dictionary:result)
                
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


struct InventoryList_Previews: PreviewProvider {
    static var previews: some View {
        InventoryList(selectedTab: Binding.constant(.inventory))
    }
}
