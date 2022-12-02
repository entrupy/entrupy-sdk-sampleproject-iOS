//
//  BottomTab.swift
//  Sneaker Authentication Demo
//
//  Created by Dharini Raghavan on 6/17/22.
//

import SwiftUI
import EntrupySDK

enum MenuItem: Int, Codable {
    case inventory
    case authentications
    case logout
}

struct BottomTab: View {
    @State private var selectedTab = MenuItem.inventory
    @SwiftUI.State private var showAlert = false
    @SwiftUI.State private var alertData = AlertData.empty
    
    @Binding var showHome: Bool
    
    var body: some View {

        TabView(selection: $selectedTab) {
            InventoryList(selectedTab: $selectedTab)
                .tabItem {
                    Label("Inventory", systemImage: "star.fill")
                }
                .tag(MenuItem.inventory)
            
            AuthenticationsList(selectedTab: $selectedTab)
                .tabItem {
                    Label("Authentications", systemImage: "circle.fill")
                }
                .tag(MenuItem.authentications)
            
            Text("Logout")
                .tabItem {
                    Label("Logout", systemImage: "arrowshape.turn.up.forward.circle")
                }
                .tag(MenuItem.logout)
        }.onAppear {
            let entrupyApp = EntrupyApp.sharedInstance()
            
            //Uncomment to set a custom theme
            //entrupyApp.theme = Theme()
            
            if (!entrupyApp.isAuthorizationValid()){
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
                        print("SDK Authorization Request created successfully!")
                    }
                }

            }
        }
        .onChange(of: selectedTab, perform: { newValue in
            if newValue == MenuItem.logout {
                EntrupyApp.sharedInstance().cleanup()
                try? KeychainUtility.deleteAccountFromKeychain()
                showHome = false
            }
        })
            .onReceive(NotificationCenter.default.publisher(for: .showAlert)) { notif in
                  if let data = notif.object as? AlertData {
                    alertData = data
                    showAlert = true
                  }
                }
                .alert(isPresented: $showAlert) {
                  Alert(title: alertData.title,
                        message: alertData.message,
                        dismissButton: alertData.dismissButton)
                }

    }
    
    
}

struct BottomTab_Previews: PreviewProvider {
    static var previews: some View {
        BottomTab(showHome: Binding.constant(false))
    }
}
