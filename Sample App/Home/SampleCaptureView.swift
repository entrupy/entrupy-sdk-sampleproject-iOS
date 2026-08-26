//
//  SampleCaptureView.swift
//  Sample App
//
//  Created by Dharini Raghavan on 6/17/22.
//

import SwiftUI
import EntrupySDK

private enum CaptureMode: CaseIterable, Identifiable {
    case authentication
    case fingerprint

    var id: Self { self }

    var title: String {
        switch self {
        case .authentication:
            return "Authentication"
        case .fingerprint:
            return "Fingerprint"
        }
    }
}

private enum FingerprintWorkflow: String, CaseIterable, Identifiable {
    case register = "fingerprint_register"
    case compare = "fingerprint_compare"

    var id: Self { self }

    var title: String {
        switch self {
        case .register:
            return "Register"
        case .compare:
            return "Compare"
        }
    }
}

private enum FingerprintCompareIdentifier: CaseIterable, Identifiable {
    case customerItemID
    case entrupyID

    var id: Self { self }

    var title: String {
        switch self {
        case .customerItemID:
            return "Customer Item ID"
        case .entrupyID:
            return "Entrupy ID"
        }
    }

    var inputKey: String {
        switch self {
        case .customerItemID:
            return "customer_item_id"
        case .entrupyID:
            return "entrupy_id"
        }
    }
}

// MARK: - Main View

struct SampleCaptureView: View {
    let entrupyApp = EntrupyApp.sharedInstance()

    @StateObject private var captureViewHandler = CaptureViewHandler()
    @StateObject private var configManager = ConfigurationManager()
    @State private var isLoading = false

    @State private var brand = ""
    @State private var itemType = ""
    @State private var customerItemID = "SAMPLE-ITEM-001"
    @State private var captureMode: CaptureMode = .authentication
    @State private var fingerprintWorkflow: FingerprintWorkflow = .register
    @State private var fingerprintCompareIdentifier: FingerprintCompareIdentifier = .customerItemID

    @Binding var selectedTab: MenuItem

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
                Text(captureConfigurationSubtitle)
                    .font(.system(size: 13, design: .monospaced))
                    .foregroundColor(EntrupyColors.subtitleText)
            }

            captureModeSegment

            if captureMode == .fingerprint {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Capture Workflow")
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundColor(EntrupyColors.subtitleText)

                    fingerprintWorkflowField
                }
            }

            if captureMode == .fingerprint, fingerprintWorkflow == .compare {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Compare Identifier")
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundColor(EntrupyColors.subtitleText)

                    fingerprintCompareIdentifierField
                }
            }

            if captureMode == .authentication {
                entrupyTextField(label: "Brand", text: $brand, placeholder: "e.g. Louis Vuitton")
                    .accessibilityIdentifier("sample_app_brand_field")
            }

            if captureMode == .authentication || fingerprintWorkflow == .register {
                entrupyTextField(label: "Item Type", text: $itemType, placeholder: "e.g. Tops")
                    .accessibilityIdentifier("sample_app_item_type_field")
            }

            entrupyTextField(
                label: itemIdentifierLabel,
                text: $customerItemID,
                placeholder: itemIdentifierPlaceholder
            )
            .accessibilityIdentifier(itemIdentifierAccessibilityIdentifier)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(EntrupyColors.cardBackground)
        )
    }

    private var captureModeSegment: some View {
        HStack(spacing: 4) {
            ForEach(CaptureMode.allCases) { mode in
                Button {
                    captureMode = mode
                } label: {
                    Text(mode.title)
                        .font(.system(size: 14, weight: .semibold, design: .monospaced))
                        .foregroundColor(mode == captureMode ? .black : EntrupyColors.fieldText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(mode == captureMode ? EntrupyColors.gold : .clear)
                        )
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("sample_app_capture_mode_\(mode.title.lowercased())")
            }
        }
        .padding(4)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(EntrupyColors.fieldBorder, lineWidth: 1)
        )
    }

    private var fingerprintWorkflowField: some View {
        HStack(spacing: 24) {
            ForEach(FingerprintWorkflow.allCases) { workflow in
                Button {
                    fingerprintWorkflow = workflow
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: fingerprintWorkflow == workflow ? "largecircle.fill.circle" : "circle")
                            .font(.system(size: 18))
                        Text(workflow.title)
                            .font(.system(size: 16, design: .monospaced))
                    }
                    .foregroundColor(fingerprintWorkflow == workflow ? EntrupyColors.gold : EntrupyColors.fieldText)
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("sample_app_capture_workflow_\(workflow.rawValue)")
            }
        }
        .padding(.bottom, 5)
        .accessibilityElement(children: .contain)
    }

    private var fingerprintCompareIdentifierField: some View {
        HStack(spacing: 24) {
            ForEach(FingerprintCompareIdentifier.allCases) { identifier in
                Button {
                    fingerprintCompareIdentifier = identifier
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: fingerprintCompareIdentifier == identifier ? "largecircle.fill.circle" : "circle")
                            .font(.system(size: 18))
                        Text(identifier.title)
                            .font(.system(size: 16, design: .monospaced))
                    }
                    .foregroundColor(fingerprintCompareIdentifier == identifier ? EntrupyColors.gold : EntrupyColors.fieldText)
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("sample_app_compare_identifier_\(identifier.inputKey)")
            }
        }
        .padding(.bottom, 5)
        .accessibilityElement(children: .contain)
    }

    private var startCaptureButton: some View {
        Button(action: handleStartCapture) {
            HStack(spacing: 8) {
                Image(systemName: "camera.viewfinder")
                    .font(.system(size: 18, weight: .semibold))
                Text(startCaptureButtonTitle)
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

    private var captureConfigurationSubtitle: String {
        switch captureMode {
        case .authentication:
            return "Configure the item to authenticate"
        case .fingerprint:
            return "Configure the fingerprint capture workflow"
        }
    }

    private var startCaptureButtonTitle: String {
        switch captureMode {
        case .authentication:
            return "Start Capture"
        case .fingerprint:
            return fingerprintWorkflow == .register ? "Register Item" : "Compare Item"
        }
    }

    private var itemIdentifierLabel: String {
        if captureMode == .fingerprint, fingerprintWorkflow == .compare {
            return fingerprintCompareIdentifier.title
        }
        return "Customer Item ID"
    }

    private var itemIdentifierPlaceholder: String {
        if captureMode == .fingerprint,
           fingerprintWorkflow == .compare,
           fingerprintCompareIdentifier == .entrupyID {
            return "e.g. 72H3B4R9"
        }
        return "e.g. SAMPLE-ITEM-001"
    }

    private var itemIdentifierAccessibilityIdentifier: String {
        if captureMode == .fingerprint,
           fingerprintWorkflow == .compare,
           fingerprintCompareIdentifier == .entrupyID {
            return "sample_app_entrupy_id_field"
        }
        return "sample_app_customer_item_id_field"
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

        switch captureMode {
        case .authentication:
            if !brand.isEmpty {
                input["brand"] = brand
            }
            if !itemType.isEmpty {
                input["item_type"] = itemType
            }
        case .fingerprint:
            input["capture_workflow"] = fingerprintWorkflow.rawValue

            if fingerprintWorkflow == .register, !itemType.isEmpty {
                input["item_type"] = itemType
            }
        }

        if !customerItemID.isEmpty {
            if captureMode == .fingerprint, fingerprintWorkflow == .compare {
                input[fingerprintCompareIdentifier.inputKey] = customerItemID
            } else {
                input["customer_item_id"] = customerItemID
            }
        }

        captureViewHandler.startCapture(with: input)
    }

    private func ensureAuthorizedAndLoadConfig() {
        let needsAuthorization = SDKAuthorization.sharedInstance.isAboutToExpire()
            || !entrupyApp.isAuthorizationValid()

        guard needsAuthorization else {
            loadConfiguration()
            return
        }

        isLoading = true
        SDKAuthorization.sharedInstance.createSDKAuthorizationRequest { success, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                self.postErrorAlert(error?.description ?? "")
                return
            }

            DispatchQueue.main.async {
                guard success else {
                    self.isLoading = false
                    return
                }
                self.loadConfiguration()
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

struct SampleCaptureView_Previews: PreviewProvider {
    static var previews: some View {
        SampleCaptureView(selectedTab: Binding.constant(.inventory))
            .preferredColorScheme(.dark)
    }
}
