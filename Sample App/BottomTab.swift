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
            SampleCaptureView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Home", systemImage: "star.fill")
                }
                .tag(MenuItem.inventory)

            AuthenticationsList(selectedTab: $selectedTab)
                .tabItem {
                    Label("Results", systemImage: "circle.fill")
                }
                .tag(MenuItem.authentications)
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
