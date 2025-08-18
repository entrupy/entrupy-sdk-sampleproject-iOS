//
//  AuthenticationRow.swift
//  Sneaker Authentication Demo
//
//  Created by abdul on 08/02/24.
//

import SwiftUI

struct AuthenticationRow: View {
    
    @Binding var data:Authentications
    var flagAction: () -> Void
    
    @State var showLoader:Bool = false
    let flagManager:FlagManager
    
    var didTapRow: () -> Void
    
    var status:String {
        let flagStatusId = data.authItem.status.flag.id
        let authenticationStatus = data.authItem.status.result.display.header
        if flagStatusId == .none {
            return "\(authenticationStatus)"
        }else {
            return "\(authenticationStatus) (\(flagStatusId.description))"
        }

    }
    
    var body: some View {
        Button(action: {
            didTapRow()
        }, label:{
            HStack {
                VStack(alignment: .leading) {
                    Text(data.authItem.authentication_id)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    
                    Text(status)
                        .foregroundColor(.gray)
                        .font(.caption)
                }
                Spacer()

                let isFlaggable = data.authItem.status.flag.is_flaggable
                let isFlagged = data.authItem.status.flag.isFlagged
                /*
                Note: Flag details can be retrieved by implementing the `getFlagDetailsForResult` method.
                This method provides the flag status and eligibility for a result assigned to a specific item.
                For more details, refer to the documentation.
                 */
                
                if isFlaggable  {
                    Button(action: {
                        showLoader = true
                        flagAction()
                    }) {
                        if showLoader {
                            ProgressView()
                        }else {
                            Text(isFlagged ? "Clear Flag" : "Flag Result")
                                .foregroundColor(.blue).font(.system(size: 14))
                        }
                    }
                    .buttonStyle(.plain)
                    .onChange(of: flagManager.flagResult) { _ in
                        showLoader = false
                    }
                }
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
        })

    }
}
