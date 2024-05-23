//
//  LoginView.swift
//  PreDay
//
//  Created by Tom Herrmann on 12.05.24.
//

import SwiftUI

struct LoginView: View {
    
@StateObject var viewModel = LoginViewViewModel()
    var body: some View {
        NavigationView{
            VStack{
                //Header
                HeaderView(title: "PreDay", subtitle: "Log in", angle: 15, background: Color(red: 0.04, green: 0.18392, blue: 0.5))
                
                // Login Form

                Form{
                    if !viewModel.errorMessage.isEmpty{
                        Text(viewModel.errorMessage)
                            .foregroundColor(Color.red)
                    }
                    TextField("Email Address", text: $viewModel.email)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .autocorrectionDisabled()
                    
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(DefaultTextFieldStyle())
                    
                    PDButton(title: "Log In", background: .blue){
                        // Attempt log in
                        viewModel.login()
                    }
                    
                }
                

                .offset(y: -50)
                // Create Account
                VStack {
                    Text("New around here?")
                    
                    NavigationLink("Create an account", destination: RegisterView())
                }
                .padding(.bottom, 05)
                Spacer()
            }
        }
    }
}

#Preview {
    LoginView()
}
