//
//  AuthenticationRow.swift
//  Sneaker Authentication Demo
//
//  Created by abdul on 08/02/24.
//

import SwiftUI

struct AuthenticationRow: View {
    
    @Binding var data:Authentications
    
    let flagManager:FlagManager
    var flagAction: () -> Void
    
    let retakeViewHandler: RetakeViewHandler
    var retakeAction: () -> Void
    
    let marketEdgeViewHandler: MarketEdgeViewHandler
    var marketEdgeAction: () -> Void
    
    var didTapRow: () -> Void
    
    var flagStatus:String {
        let flagStatusId = data.authItem.status.flag.id
        let authenticationStatus = data.authItem.status.result.display.header
        if flagStatusId == .none {
            return "\(authenticationStatus)"
        }else {
            return "\(authenticationStatus) (\(flagStatusId.description))"
        }
    }
    
    var hasRetake:Bool {
        if let customerState = data.authItem.batch_request?.customer_state, customerState == "batch_open" {
            return true
        }
        return false
    }

    var isMarketEdgeEnabledForItem:Bool {
        if let marketEdgeEnable = data.authItem.more_details?.catalog_insights?.supported {
            return marketEdgeEnable
        }
        return false
    }
    
    var showFlagLoader: Bool {
        flagManager.isLoading && flagManager.loadingEntrupyID == data.authItem.authentication_id
    }
    
    var showRetakeLoader: Bool {
        retakeViewHandler.isLoading && retakeViewHandler.loadingEntrupyID == data.authItem.authentication_id
    }
    
    var showMarketEdgeLoader: Bool {
        marketEdgeViewHandler.isLoading && marketEdgeViewHandler.loadingEntrupyID == data.authItem.authentication_id
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
                    
                    Text(flagStatus)
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
                        flagAction()
                    }) {
                        if showFlagLoader {
                            ProgressView()
                        }else {
                            Text(isFlagged ? "Clear Flag" : "Flag Result")
                                .foregroundColor(.blue).font(.system(size: 14))
                        }
                    }
                    .buttonStyle(.plain)
                }
                
                if isFlaggable && hasRetake {
                    Divider()
                }
                
                //Note: Refer to the SDK documentation to learn about other ways of knowing if an item has an open retake request.
                if hasRetake  {
                    Button(action: {
                        retakeAction()
                    }) {
                        if showRetakeLoader {
                            ProgressView()
                        }else {
                            Text("Retake")
                                .foregroundColor(.blue).font(.system(size: 14))
                        }
                    }
                    .buttonStyle(.plain)
                }
                
                if isFlaggable && isMarketEdgeEnabledForItem {
                    Divider()
                }
                
                if isMarketEdgeEnabledForItem  {
                    Button(action: {
                        marketEdgeAction()
                    }) {
                        if showMarketEdgeLoader {
                            ProgressView()
                        }else {
                            Text("MarketEdge")
                                .foregroundColor(.blue).font(.system(size: 14))
                        }
                    }
                }
                
                
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
        })

    }
}
