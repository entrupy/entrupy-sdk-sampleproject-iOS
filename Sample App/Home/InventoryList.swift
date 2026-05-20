//
//  InventoryList.swift
//  Sample App
//
//  Created by Dharini Raghavan on 6/17/22.
//

import SwiftUI
import EntrupySDK

// MARK: - Design System Colors (from EntrupySDK asset catalog)

private enum EntrupyColors {
    private static let sdkBundle = Bundle(for: EntrupyApp.self)

    static let background = Color("PrimaryBlack", bundle: sdkBundle)
    static let cardBackground = Color("PrimaryBlue00", bundle: sdkBundle)
    static let gold = Color("PrimaryGold", bundle: sdkBundle)
    static let fieldBorder = Color("TransparentWhite20", bundle: sdkBundle)
    static let fieldText = Color("PrimaryWhite", bundle: sdkBundle)
    static let placeholderText = Color("TransparentWhite40", bundle: sdkBundle)
    static let subtitleText = Color("PrimaryWhite", bundle: sdkBundle).opacity(0.6)
    static let redBorder = Color("PrimaryRed00", bundle: sdkBundle)
}

// MARK: - Main View

struct InventoryList: View {
    let entrupyApp = EntrupyApp.sharedInstance()

    private var dataDelegate = InventoryListDataDelegate()
    @StateObject private var configManager = ConfigurationManager()
    @State private var isLoading = false

    @State private var brand = ""
    @State private var itemType = ""
    @State private var customerItemID = "SAMPLE-ITEM-001"

    @Binding var selectedTab: MenuItem

    init(selectedTab: Binding<MenuItem>) {
        self._selectedTab = selectedTab
    }


    var body: some View {
        ZStack {
            EntrupyColors.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    titleBar
                    captureConfigurationCard
                    startCaptureButton
                    logoutButton
                    poweredByFooter
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
        }
        .onAppear {
            guard selectedTab == .inventory else { return }
            guard !isLoading && !configManager.isConfigurationLoaded else { return }
            ensureAuthorizedAndLoadConfig()
        }
        .onChange(of: configManager.isConfigurationLoaded) { _ in
            isLoading = false
        }
    }

    // MARK: - Subviews

    private var titleBar: some View {
        Text("SDK Sample")
            .font(.system(size: 18, weight: .bold, design: .monospaced))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.bottom, 4)
    }

    private var captureConfigurationCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Capture Configuration")
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                Text("Configure the item to authenticate")
                    .font(.system(size: 13, design: .monospaced))
                    .foregroundColor(EntrupyColors.subtitleText)
            }

            entrupyTextField(label: "Brand", text: $brand, placeholder: "e.g. Louis Vuitton")
                .accessibilityIdentifier("sample_app_brand_field")
            entrupyTextField(label: "Item Type", text: $itemType, placeholder: "e.g. Tops")
                .accessibilityIdentifier("sample_app_item_type_field")
            entrupyTextField(label: "Customer Item ID", text: $customerItemID, placeholder: "e.g. SAMPLE-ITEM-001")
                .accessibilityIdentifier("sample_app_customer_item_id_field")
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(EntrupyColors.cardBackground)
        )
    }

    private var startCaptureButton: some View {
        Button(action: handleStartCapture) {
            HStack(spacing: 8) {
                Image(systemName: "camera.viewfinder")
                    .font(.system(size: 18, weight: .semibold))
                Text("Start Capture")
                    .font(.system(size: 17, weight: .bold, design: .monospaced))
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(configManager.isConfigurationLoaded ? EntrupyColors.gold : EntrupyColors.gold.opacity(0.4))
            )
        }
        .disabled(!configManager.isConfigurationLoaded)
        .accessibilityIdentifier("sample_app_start_capture_button")
    }

    private var logoutButton: some View {
        Button(action: {
            entrupyApp.cleanup()
            try? KeychainUtility.deleteAccountFromKeychain()
            selectedTab = .logout
        }) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.right.square")
                    .font(.system(size: 16))
                Text("Logout")
                    .font(.system(size: 16, weight: .semibold, design: .monospaced))
            }
            .foregroundColor(.red)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(EntrupyColors.redBorder, lineWidth: 1.5)
            )
        }
    }

    private var poweredByFooter: some View {
        Text("Powered by Entrupy")
            .font(.system(size: 13, design: .monospaced))
            .foregroundColor(EntrupyColors.subtitleText)
            .padding(.top, 8)
    }

    // MARK: - Field Component

    private func entrupyTextField(label: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(text.wrappedValue.isEmpty ? EntrupyColors.fieldBorder : EntrupyColors.gold, lineWidth: 1)
                    .frame(height: 56)

                // Floating label
                Text(label)
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundColor(EntrupyColors.subtitleText)
                    .padding(.horizontal, 6)
                    .background(EntrupyColors.cardBackground)
                    .offset(x: 12, y: -8)

                TextField("", text: text)
                    .font(.system(size: 16, design: .monospaced))
                    .foregroundColor(EntrupyColors.fieldText)
                    .padding(.horizontal, 16)
                    .frame(height: 56)
                    .placeholder(when: text.wrappedValue.isEmpty) {
                        Text(placeholder)
                            .font(.system(size: 16, design: .monospaced))
                            .foregroundColor(EntrupyColors.placeholderText)
                            .padding(.horizontal, 16)
                    }
            }
        }
    }

    // MARK: - Actions

    private func handleStartCapture() {
        var input: [String: Any] = [:]

        if !brand.isEmpty {
            input["brand"] = brand
        }
        if !itemType.isEmpty {
            input["item_type"] = itemType
        }
        if !customerItemID.isEmpty {
            input["customer_item_id"] = customerItemID
        }

        guard let vc = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first?.rootViewController else { return }

        entrupyApp.captureDelegate = dataDelegate
        entrupyApp.startCapture(forItem: input, viewController: vc)
    }

    private func ensureAuthorizedAndLoadConfig() {
        if SDKAuthorization.sharedInstance.isAboutToExpire() {
            SDKAuthorization.sharedInstance.createSDKAuthorizationRequest { _, error in
                guard error == nil else {
                    postErrorAlert(error?.description ?? "")
                    return
                }
            }
        }

        if entrupyApp.isAuthorizationValid() {
            loadConfiguration()
        } else {
            SDKAuthorization.sharedInstance.createSDKAuthorizationRequest { success, error in
                guard error == nil else {
                    postErrorAlert(error?.description ?? "")
                    return
                }
                if success { loadConfiguration() }
            }
        }
    }

    private func loadConfiguration() {
        isLoading = true
        configManager.loadConfiguration()
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

// MARK: - Capture Delegate

class InventoryListDataDelegate: NSObject, EntrupyCaptureDelegate {

    func didCaptureTimeout(forItem item: [AnyHashable: Any]) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .showAlert,
                                            object: AlertData(title: Text("Info"),
                                                              message: Text("The capture timed out. Please resubmit the item."),
                                                              dismissButton: .default(Text("OK"))))
        }
    }

    func didCaptureCompleteSuccessfully(_ result: [AnyHashable: Any], forItem item: [AnyHashable: Any]) {
        DispatchQueue.main.async {
            do {
                let parsedData = try EntrupyCaptureResult(dictionary: result)
                NotificationCenter.default.post(name: .showAlert,
                                                object: AlertData(title: Text("Info"),
                                                                  message: Text("Your \(parsedData.properties.brand.display["name"]!) item was successfully submitted to Entrupy for verification"),
                                                                  dismissButton: .default(Text("OK"))))
            } catch {
                print(error)
            }
        }
    }

    func didUserCancelCapture(forItem item: [AnyHashable: Any]) {
        print("The user canceled the capture and did not submit the item for verification\n")
    }

    func didCaptureFailWithError(_ errorCode: EntrupyErrorCode, description: String, localizedDescription: String, forItem item: [AnyHashable: Any]) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .showAlert,
                                            object: AlertData(title: Text("Capture Error"),
                                                              message: Text(localizedDescription),
                                                              dismissButton: .default(Text("OK"))))
        }
    }
}

// MARK: - Placeholder Modifier

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct InventoryList_Previews: PreviewProvider {
    static var previews: some View {
        InventoryList(selectedTab: Binding.constant(.inventory))
            .preferredColorScheme(.dark)
    }
}
