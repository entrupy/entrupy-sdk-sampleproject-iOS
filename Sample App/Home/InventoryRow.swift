//
//  InventoryRow.swift
//  Sneaker Authentication Demo
//
//  Created by Dharini Raghavan on 6/17/22.
//

import SwiftUI
import EntrupySDK

struct InventoryRow: View {
    
    var item: any InventoryItem
    weak var captureDelegate: EntrupyCaptureDelegate?
        
    private let entrupyApp = EntrupyApp.sharedInstance()
    private let rootViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.displayName)
                    .fontWeight(.bold)
                Text(item.displaySubtitle)
                    .foregroundColor(.gray)
                    .font(.caption)
            }.padding()
            
            Spacer()
            Button(action: handleCaptureTap) {
                Text("Authenticate")
                    .foregroundColor(Color.blue)
            }
        }
    }

    private func handleCaptureTap() {
        do {
            try item.validateRequiredFields()  // Using item's validation
            let input = item.buildInput()      // Using item's input building
            
            withAuthorization(entrupyApp: entrupyApp) {
                guard let vc = rootViewController else { return }
                startCapture(with: input, using: entrupyApp, in: vc)
            }
        } catch {
            postErrorAlert(error.localizedDescription)
        }
    }
    
    private func withAuthorization(entrupyApp: EntrupyApp, then action: @escaping () -> Void) {
        if entrupyApp.isAuthorizationValid() {
            action()
            return
        }
        
        SDKAuthorization.sharedInstance.createSDKAuthorizationRequest { success, error in
            if let error = error {
                postErrorAlert(error.description ?? "")
                return
            }
            guard success else {
                postErrorAlert("Authorization failed. Please try again.")
                return
            }
            action()
        }
    }
    
    private func startCapture(with input: [String: Any],
                              using entrupyApp: EntrupyApp,
                              in viewController: UIViewController) {
        entrupyApp.captureDelegate = captureDelegate
        entrupyApp.startCapture(forItem: input, viewController: viewController)
    }
    
    private func postErrorAlert(_ message: String) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: .showAlert,
                object: AlertData(
                    title: Text("Error"),
                    message: Text(message),
                    dismissButton: .default(Text("OK"))
                )
            )
        }
    }
}
