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

    @State private var showCustomerItemInput = false
    @State private var customerItemInput = ""

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
        .alert("Enter Customer Item ID", isPresented: $showCustomerItemInput) {
            TextField("Customer Item ID", text: $customerItemInput)
            Button("Cancel", role: .cancel) {
                customerItemInput = ""
            }
            Button("Continue") {
                proceedWithCapture(customItemID: customerItemInput)
                customerItemInput = ""
            }
        } message: {
            Text("Enter the customer item ID for this \(item.displayName.lowercased()) operation")
        }
    }

    private func handleCaptureTap() {
        // Check if this is a fingerprint item
        if item.displayName == "Register" || item.displayName == "Compare" {
            showCustomerItemInput = true
            return
        }

        // For non-fingerprint items, proceed normally
        do {
            try item.validateRequiredFields()
            let input = item.buildInput()

            withAuthorization(entrupyApp: entrupyApp) {
                guard let vc = rootViewController else { return }
                startCapture(with: input, using: entrupyApp, in: vc)
            }
        } catch {
            postErrorAlert(error.localizedDescription)
        }
    }

    private func proceedWithCapture(customItemID: String) {
        do {
            try item.validateRequiredFields()
            var input = item.buildInput()

            // Override the customer_item_id with the user input
            if !customItemID.isEmpty {
                input["customer_item_id"] = customItemID
            }

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
