//
//  InventoryRow.swift
//  Sneaker Authentication Demo
//
//  Created by Dharini Raghavan on 6/17/22.
//

import SwiftUI
import EntrupySDK

struct InventoryRow: View {
    
    var sneaker: Sneaker
    weak var captureDelegate: EntrupyCaptureDelegate?
        
    private let entrupyApp = EntrupyApp.sharedInstance()
    private let rootViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController
    
    var body: some View {
        HStack {
            Image(String("sneaker"))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100.0, height: 70.0)
                .clipShape(Rectangle())
                .overlay(
                    Rectangle().stroke(.white, lineWidth: 4)
                )
                .shadow(radius: 7)
            
            VStack(alignment: .leading) {
                Text(sneaker.brand)
                    .fontWeight(.bold)
                Text(sneaker.style)
                    .foregroundColor(.gray)
                    .font(.caption)
                Text("US " + sneaker.USSize).foregroundColor(.gray)
                    .font(.caption2)
            }.padding()
            
            Spacer()
            Button(action: {
                let input: Dictionary = [
                    "brand": sneaker.brand,
                    "style_name": sneaker.style,
                    "us_size": sneaker.USSize,
                    "style_code": sneaker.styleCode,
                    "upc": sneaker.UPC,
                    "customer_item_id": sneaker.customerItemID
                ]
                
                if entrupyApp.isAuthorizationValid(), let vc = self.rootViewController {

                    entrupyApp.captureDelegate = captureDelegate
                    
                    //Entrupy's capture workflow will launch modally
                    entrupyApp.startCapture(forItem: input as [AnyHashable : Any], viewController: vc)
                }
                else {
                    //Re-authorize and call startCapture again
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
                            entrupyApp.captureDelegate = captureDelegate
                            
                            if let vc = self.rootViewController {
                                //Entrupy's capture workflow will launch modally
                                entrupyApp.startCapture(forItem: input as [AnyHashable : Any], viewController: vc)
                            }

                        }
                    }
                }
                
            }, label: {
                Text("Authenticate")
                    .foregroundColor(Color.blue)
            })

        }
    }
}
