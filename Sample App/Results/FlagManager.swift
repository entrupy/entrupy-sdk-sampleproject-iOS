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
    
    override init() {
        super.init()
        entrupyApp.flagDelegate = self
    }
    
    func flagResult(with entrupyID:String, flag:Bool) {
        //entrupyID ==  authenticationId
        entrupyApp.setFlag(flag, forResultWithEntrupyID: entrupyID)
    }
}

//MARK: - Flag Delegates
extension FlagManager : EntrupyFlagDelegate {
    func didFlagResultSuccessfully(forEntrupyID entrupyID: String, forRequestedFlag flag: Bool) {
        debugPrint("didFlagResultSuccessfully for entrupyID - \(entrupyID) forRequestedFlagSetting isFlagged: \(flag)")
        DispatchQueue.main.async {
            self.flagResult = FlagResult(authenticationId: entrupyID, flagStatus: flag)
        }
    }
    
    func didFlagResultFailWithError(_ errorCode: EntrupyErrorCode, description: String, localizedDescription: String, forEntrupyID entrupyID: String, forRequestedFlag flag: Bool) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .showAlert,
                                            object: AlertData(title: Text("didFlagResultFailWithError"),
                                                              message: Text(localizedDescription),
                                                              dismissButton: .default(Text("OK"))))
        }

    }
}
