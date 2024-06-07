//
//  AuthenticationsList.swift
//  Sneaker Authentication Demo
//
//  Created by Dharini Raghavan on 6/20/22.
//

import SwiftUI
import EntrupySDK

struct AuthenticationsList: View {
    
    @StateObject var authenticationData = AuthenticationData()
    @Binding var selectedTab: MenuItem
    
    private let entrupyApp = EntrupyApp.sharedInstance()
    @StateObject var flagManager = FlagManager()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(authenticationData.authentications) { authentication in
                    AuthenticationRow(data: .constant(authentication), flagAction: {
                        self.handleFlagAction(authenticationData: authentication)
                    }, flagManager: flagManager)
                }
                
                if authenticationData.listFull == false {
                    Text("Loading...")
                        .onAppear() {
                            
                            guard selectedTab == .authentications else { return }
                            
                            if SDKAuthorization.sharedInstance.isAboutToExpire() {
                                
                                SDKAuthorization.sharedInstance.createSDKAuthorizationRequest { success, error in
                                    guard error == nil else {
                                        debugPrint(error?.description ?? "")

                                        DispatchQueue.main.async {
                                        NotificationCenter.default.post(name: .showAlert,
                                                                        object: AlertData(title: Text("Error"),
                                                                                          message: Text(error?.description ?? ""),
                                                                                          dismissButton: .default(Text("OK"))))
                                        }
                                        
                                        return
                                    }
                                    if success {
                                        debugPrint("SDK Authorization completed successfully!")
                                    }
                                }
                            }
                            
                            if EntrupyApp.sharedInstance().isAuthorizationValid() {
                                authenticationData.fetchAuthentications()
                            }
                            else {
                                //Re-authorize
                                SDKAuthorization.sharedInstance.createSDKAuthorizationRequest { success, error in
                                    guard error == nil else {
                                        debugPrint(error?.description ?? "")
                                        
                                        DispatchQueue.main.async {
                                            NotificationCenter.default.post(name: .showAlert,
                                                                            object: AlertData(title: Text("Error"),
                                                                                              message: Text(error?.description ?? ""),
                                                                                              dismissButton: .default(Text("OK"))))
                                        }
                                        
                                        return
                                    }
                                    if success {
                                        debugPrint("SDK Authorization completed successfully!")
                                        authenticationData.fetchAuthentications()
                                    }
                                }
                            }
                            
                            
                        }
                }
                
            }.onAppear {
                authenticationData.listFull = false
                authenticationData.authentications = []
                authenticationData.nextPageCursor = []
            }
            .navigationBarTitle("Results")
        }
        .onChange(of: flagManager.flagResult) { newValue in
            guard let newValue = newValue, let authenticationID = newValue.authenticationId else {
                return
            }
            if let index = authenticationData.authentications.firstIndex(where: { $0.authItem.authentication_id == authenticationID }) {
                authenticationData.authentications[index].authItem.status.flag.toggle()
            }
        }
    }
    
    
    func handleFlagAction(authenticationData: Authentications) {
        let isFlagged = authenticationData.authItem.status.flag.isFlagged
        let entrupyID = authenticationData.authItem.authentication_id
        flagManager.flagResult(with: entrupyID, flag: !isFlagged)
    }
}



class AuthenticationData: NSObject, ObservableObject , EntrupySearchDelegate {
    
    @Published var authentications = [Authentications]()
    
    // Tells if all records have been loaded. (Used to hide/show activity spinner)
    var listFull = false
    // Used to load next page (current + 1)
    var nextPageCursor: [String]? = []
    // Limit of records per page.
    let perPage = 20
    let entrupyApp = EntrupyApp.sharedInstance()
    
    override init() {
        super.init()
        entrupyApp.searchDelegate = self
    }
    
    
    func didSearchSubmissionsCompleteSuccessfully(_ result: [AnyHashable : Any]) {
        do {
            let parsedData = try EntrupySearchResult(dictionary:result)
            self.nextPageCursor = parsedData.next_cursor

            parsedData.items.forEach({ [weak self] captureResult in
                guard let weakSelf = self else { return }
                DispatchQueue.main.async {
                    weakSelf.authentications.append(Authentications(authItem: captureResult))
                }
            })
        } catch {
            debugPrint("Error parsing data for search submission \(error)")
        }
                
        // last page.
        if self.nextPageCursor == nil || self.nextPageCursor?.count == 0 {
            self.listFull = true
            
        }
    }
    
    func didSearchSubmissionsFailWithError(_ errorCode: EntrupyErrorCode, description: String, localizedDescription: String) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .showAlert,
                                            object: AlertData(title: Text("didSearchSubmissionsFailWithError"),
                                                              message: Text(localizedDescription),
                                                              dismissButton: .default(Text("OK"))))
        }
    }
    
    func fetchAuthentications() {
       /*
        Filter examples
        
        1. To list all nikes with an unidentified result
        let filter:[Dictionary<String,Any>] = [["key": "properties.brand.id", "value": "nike"], ["key": "status.result.id", "value": "unknown"]]
        
        2. To list all nikes and adidas
        let filter:[Dictionary<String,Any>] = [["key": "properties.brand.id", "values":["nike", "adidas"]]]

        */

        entrupyApp.searchSubmissions(at: self.nextPageCursor ?? [], filters: [], startDate: 0, endDate: 0, paginationLimit: perPage)
    }
    
}


struct AuthenticationsList_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationsList(selectedTab: Binding.constant(.authentications))
    }
}
