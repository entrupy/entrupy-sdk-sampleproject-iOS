//
//  FlagManager.swift
//  Sneaker Authentication Demo
//
//  Created by abdul on 08/02/24.
//

import Foundation
import EntrupySDK
import SwiftUI

struct FlagResult: Equatable {
    let authenticationId: String?
    let flagStatus: Bool
}

class FlagManager: NSObject, ObservableObject {
    let entrupyApp = EntrupyApp.sharedInstance()
    @Published var flagResult: FlagResult?
    @Published var isLoading: Bool = false
    @Published var loadingEntrupyID: String? = nil
    
    override init() {
        super.init()
    }
    
    func presentFlagView(for entrupyID: String) {
        isLoading = true
        loadingEntrupyID = entrupyID
        entrupyApp.flagViewDelegate = self
        entrupyApp.displayFlagViewForItem(withEntrupyID: entrupyID)
    }
    
    func clearFlag(for entrupyID: String) {
        isLoading = true
        loadingEntrupyID = entrupyID
        entrupyApp.flagDelegate = self
        entrupyApp.setFlag(false,
                           forResultWithEntrupyID: entrupyID,
                           flagReasonId: "", // flagReasonId is not required when the flag is set to false
                           message: nil)
    }
}

//MARK: - Flag Delegates
extension FlagManager : EntrupyFlagDelegate {
    func didFlagResultSuccessfully(forEntrupyID entrupyID: String, forRequestedFlag flag: Bool) {
        debugPrint("didFlagResultSuccessfully for entrupyID - \(entrupyID) forRequestedFlagSetting isFlagged: \(flag)")
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.flagResult = FlagResult(authenticationId: entrupyID, flagStatus: flag)
            self.isLoading = false
            self.loadingEntrupyID = nil
        }
    }
    
    func didFlagResultFailWithError(_ errorCode: EntrupyErrorCode, description: String, localizedDescription: String, forEntrupyID entrupyID: String, forRequestedFlag flag: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.isLoading = false
            self.loadingEntrupyID = nil
            NotificationCenter.default.post(name: .showAlert,
                                            object: AlertData(title: Text("didFlagResultFailWithError"),
                                                              message: Text(localizedDescription),
                                                              dismissButton: .default(Text("OK"))))
        }

    }
}

// MARK: - Flag View Delegate
extension FlagManager: EntrupyFlagViewDelegate {
    func didDisplayFlagViewForItem(withEntrupyID entrupyID: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.isLoading = false
            self.loadingEntrupyID = nil
        }
    }
    
    func didUserSubmitFlag(forEntrupyID entrupyID: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.flagResult = FlagResult(authenticationId: entrupyID, flagStatus: true)
            self.isLoading = false
            self.loadingEntrupyID = nil
        }
    }
    
    func didUserCancelFlagViewForItem(withEntrupyID entrupyID: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.isLoading = false
            self.loadingEntrupyID = nil
        }
    }
    
    func didDisplayFlagViewFailWithError(_ errorCode: EntrupyErrorCode,
                                         description: String,
                                         localizedDescription: String,
                                         forEntrupyID entrupyID: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.isLoading = false
            self.loadingEntrupyID = nil
            NotificationCenter.default.post(name: .showAlert,
                                            object: AlertData(title: Text("Flag View Error"),
                                                              message: Text(localizedDescription),
                                                              dismissButton: .default(Text("OK"))))
        }
    }
}
