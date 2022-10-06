//
//  SDKAuthorization.swift
//  Sneaker Authentication Demo
//
//  Created by Muhammad Waqas on 31/08/2022.
//

import Foundation
import EntrupySDK

struct API {
     static let PARTNER_SDK_URL: String = "https://sample-partner-sdk-server.entrupy.com"
 }


typealias Completion = ((Bool, (errorCode: EntrupyErrorCode?, description: String?)?) -> Void)
/*
 Add this Singleton class to handle entrupy SDK Authorization.
 */
class SDKAuthorization: NSObject {
    
    static let sharedInstance = SDKAuthorization()
    
    private let entrupyApp = EntrupyApp.sharedInstance()
    private var completion: Completion?
    
    private override init() {
        
    }
    
    //It is recommended that you refresh the Authorization some minutes before expiry to avoid latencies
    func isAboutToExpire() -> Bool {
        let defaults = UserDefaults.standard
        if let expiryTime = defaults.object(forKey: "EntrupySDKAuthorizationExpirationTime") {
            return Date().timeIntervalSince1970 >= (expiryTime as! TimeInterval - (30 * 60))
        }
        return true
    }
    
    func isExpired() -> Bool {
        let defaults = UserDefaults.standard
        if let expiryTime = defaults.object(forKey: "EntrupySDKAuthorizationExpirationTime") {
            return Date().timeIntervalSince1970 >= expiryTime as! TimeInterval
        }
        return true
    }
    
   
    func createSDKAuthorizationRequest(completion: Completion? = nil) {
        
        guard let partnerAccessToken = AppDelegate.instance.partnerAccessToken else {
            completion?(false, (EntrupyErrorCode.ErrorCodeForbiddenError, "partner login token can not be empty"))
            return
        }
        let sdkAuthorizationRequest = self.entrupyApp.generateSDKAuthorizationRequest()
        
        self.completion = completion
        
        let jsonObject = ["sdk_authorization_request": sdkAuthorizationRequest]
        
        let JSONData = try? JSONSerialization.data(
            withJSONObject: jsonObject,
            options: [])
        
        //Replace with your backend's URL
        let url = URL(string: API.PARTNER_SDK_URL + "/authorize-entrupy-sdk-user")!
        
        var request = URLRequest(url: url)
        request.setValue("Token \(partnerAccessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = JSONData
        
        //Send a request to your backend
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            var errorMessage: String?
            guard let self = self else { return }
            
            if let error = error {
                errorMessage = "Error: " + error.localizedDescription
            }
            else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                {
                    print("\(jsonObject)")
                    if let signedRequest = jsonObject["signed_authorization_request"] as? String {
                        
                        self.entrupyApp.loginDelegate = self
                        
                        //Log In to the SDK with the returned signed authorization request
                        self.entrupyApp.loginUser(withSignedRequest: signedRequest)
                    }
                    else {
                        errorMessage = "Error: No signed request in the response"
                    }
                    
                } else {
                    errorMessage = "Error: Invalid response"
                }
            }
            else {
                errorMessage = "Error: " + response!.description
            }
            
            if errorMessage != nil {
                self.completion?(false, (nil, errorMessage))
            }
        }
        task.resume()
    }
    
}

extension SDKAuthorization: EntrupyLoginDelegate {
    
    func didLoginUserSuccessfully(_ expirationTime: TimeInterval) {
        print("didLoginUserSuccessfully: User Log In successful")
        
        let defaults = UserDefaults.standard
        defaults.set(expirationTime, forKey: "EntrupySDKAuthorizationExpirationTime")
        
        completion?(true, nil)
    }
    func didLoginUserFailWithError(_ errorCode: EntrupyErrorCode, description: String, localizedDescription: String) {
        switch (errorCode){
        case .ErrorCodeOfflineAccess,
                .ErrorCodeBadRequest,
                .ErrorCodeUnauthorizedAccess,
                .ErrorCodeForbiddenError,
                .ErrorCodeInternalServerError,
                .ErrorCodeRequestTimeoutError,
                .ErrorCodeServerTimeoutError,
                .ErrorCodeTooManyRequests,
                .ErrorCodeUnknownError:
            fallthrough
        default:
            completion?(false, (errorCode, localizedDescription))
        }
    }
}
