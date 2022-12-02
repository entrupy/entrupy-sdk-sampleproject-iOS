//
//  LoginViewModel.swift
//  Sneaker Authentication Demo
//
//  Created by Muhammad Waqas on 22/08/2022.
//

import Foundation
import SwiftUI
import EntrupySDK

class LoginViewModel: NSObject, ObservableObject {
    
    @Published var username = ""
    @Published var password = ""

    @Published var isLoading = false
    @Published var isShowHome = isPartnerAccessTokenPresent()

    let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    
    //This code mocks the login code of your app
    func login() {
        
        guard isFormComplete().0 else {
            DispatchQueue.main.async {
                self.isLoading = false
                NotificationCenter.default.post(name: .showAlert,
                                                object: AlertData(title: Text("Error"),
                                                                  message: Text(self.isFormComplete().1 ?? ""),
                                                                  dismissButton: .default(Text("OK"))))
            }
            return
        }
        
        isLoading = true
        
        let jsonObject = ["username": username, "password": password]
        
        let JSONData = try? JSONSerialization.data(
            withJSONObject: jsonObject,
            options: [])
        
        let url = URL(string: API.PARTNER_SDK_URL + "/login")!
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = JSONData
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.timeoutInterval = 30
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            var errorMessage: String?
            guard let self = self else { return }
            
            if let error = error {
                errorMessage = "Login Error: " + error.localizedDescription
            }
            else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                {
                    print("\(jsonObject)")
                    
                    //The token your backend returns
                    if let partnerAccessToken = jsonObject["token"] as? String {
                        
                    
                        do {
                            _ = try KeychainUtility.updateKeychain(password: Data(partnerAccessToken.utf8), service: Bundle.main.bundleIdentifier!, account: "kPartnerAccessToken")
                        }
                        catch {
                            print("Unable to save access token in keychain\n")
                        }

                        AppDelegate.instance.partnerAccessToken = partnerAccessToken
                        
                        //Add this code to create an Entrupy SDK Authorization request
                        //Your app neeeds to maintain a valid authorization token in order to use the Entrupy SDK
                        SDKAuthorization.sharedInstance.createSDKAuthorizationRequest { [weak self] (success, error) in
                            guard let self = self else { return }
                            guard error == nil else {
                                
                                DispatchQueue.main.async {
                                    self.isLoading = false
                                    NotificationCenter.default.post(name: .showAlert,
                                                                    object: AlertData(title: Text("Error"),
                                                                                      message: Text(error?.description ?? ""),
                                                                                      dismissButton: .default(Text("OK"))))
                                }
                                
                                return
                            }
                            if success {
                                DispatchQueue.main.async {
                                    self.username = ""
                                    self.password = ""
                                    self.isLoading = false
                                    self.isShowHome = true
                                }
                            }
                        }
                    }
                    else {
                        errorMessage = "Login Error: No authorization token in the response"
                    }
                    
                } else {
                    errorMessage = "Login Error: Invalid response"
                }
            } else if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                errorMessage = "Login Error: " + "unauthorized access."
            } else {
                errorMessage = "Login Error: " + response!.description
            }
            
            if errorMessage != nil {
                DispatchQueue.main.async {
                    self.isLoading = false
                    NotificationCenter.default.post(name: .showAlert,
                                                    object: AlertData(title: Text("Error"),
                                                                      message: Text(errorMessage!),
                                                                      dismissButton: .default(Text("OK"))))
                }
            }
        }
        task.resume()
    }
    
    private func isFormComplete() -> (Bool, String?) {
        
        if username == "" {
            return (false, "Enter Username")
        }
        if password == "" {
            return (false, "Enter Password")
        }
        
        return (true, nil)
    }
    
    static func isPartnerAccessTokenPresent() -> Bool {
            do {
                AppDelegate.instance.partnerAccessToken = try KeychainUtility.readFromKeychain(service: Bundle.main.bundleIdentifier!, account: "kPartnerAccessToken")

                return true
            }
            catch {
                print("Unable to fetch partner access token from keychain")
                return false
            }
    }
    
}
