//
//  LoginView.swift
//  Sneaker Authentication Demo
//
//  Created by Muhammad Waqas on 22/08/2022.
//

import SwiftUI
import EntrupySDK

struct LoginView: View {
    
    @StateObject var viewModel: LoginViewModel
    @SwiftUI.State private var showAlert = false
    @SwiftUI.State private var alertData = AlertData.empty

    var body: some View {
        
        if viewModel.isShowHome {
            homeView
        } else {
            loginView
        }
    }
    
    private var loginView: some View {
        ZStack {
            VStack {
                Text("Entrupy SDK Demo")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 50)
                
                TextField("Username", text: $viewModel.username)
                    .padding()
                    .background(viewModel.lightGreyColor)
                    .cornerRadius(5.0)
                    .padding(.all, 20)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(viewModel.lightGreyColor)
                    .cornerRadius(5.0)
                    .padding([.leading, .trailing, .bottom], 20)
                
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    viewModel.login()
                }) {
                    HStack {
                        Spacer()
                        Text("Login")
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .padding()
                }
                .contentShape(Rectangle())
                
            }
            .disabled(viewModel.isLoading)
            
            if viewModel.isLoading {
                ProgressView().progressViewStyle(.automatic)
            }
        }
        .padding(.bottom, 60)
        .onAppear(){
            
            
            
        }
        .onReceive(NotificationCenter.default.publisher(for: .showAlert)) { notif in
            if let data = notif.object as? AlertData {
                alertData = data
                showAlert = true
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: alertData.title,
                  message: alertData.message,
                  dismissButton: .default(Text("OK")))
        }
    }
    
    private var homeView: some View {
        BottomTab(showHome: $viewModel.isShowHome)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
