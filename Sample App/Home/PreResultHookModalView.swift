//
//  PreResultHookModalView.swift
//  Sample App
//

import SwiftUI

/// Stands in for a host app's own step before the result (for example a payment), so QA can
/// exercise `startCapture(forItem:viewController:preResultHook:)`. Presented full screen, so it
/// only closes through its buttons, and every button answers the SDK.
struct PreResultHookModalView: View {
    /// `true` for Proceed; `false` for Cancel or close.
    let onAnswer: (Bool) -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            EntrupyColors.background.ignoresSafeArea()

            VStack(spacing: 12) {
                Spacer()
                Text("Host App Pre-Result Hook")
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                Text("Stands in for the host's own step, for example a payment.")
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundColor(EntrupyColors.subtitleText)
                Spacer()
                Button { onAnswer(true) } label: {
                    Text("Proceed")
                        .font(.system(size: 17, weight: .bold, design: .monospaced))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(RoundedRectangle(cornerRadius: 12).fill(EntrupyColors.gold))
                }
                Button { onAnswer(false) } label: {
                    Text("Cancel")
                        .font(.system(size: 17, weight: .bold, design: .monospaced))
                        .foregroundColor(EntrupyColors.gold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(EntrupyColors.gold, lineWidth: 1.5))
                }
            }
            .multilineTextAlignment(.center)
            .padding(24)

            Button { onAnswer(false) } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(EntrupyColors.fieldText)
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel("Close")
            .padding(.trailing, 12)
        }
    }
}
