//
//  RegisterView.swift
//  PreDay
//
//  Created by Tom Herrmann on 12.05.24.
//

import SwiftUI

struct RegisterView: View {

   // @State var passwordConfirmed = ""   //to be implemented
    @StateObject var viewModel = RegisterViewViewModel()
    var body: some View {
        NavigationView{
            VStack{
                //Header
                HeaderView(title: "PreDay", subtitle: "Register", angle: -15, background: Color(red: 0.04, green: 0.18392, blue: 0.5))
                
                // Login Form
                Text("Registration")
                    .font(.system(size: 25))
                    .foregroundColor(Color("BlackWhite_Text"))
                    
                Form{
                    TextField("Full Name", text: $viewModel.name)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocorrectionDisabled()
                    TextField("Email Address", text: $viewModel.email)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .autocorrectionDisabled()
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(DefaultTextFieldStyle())
                    
                    PDButton(title: "Create Account", background: .green){
                        // Attempt registration
                        viewModel.register()
                        
                    }
                }
                .offset(y: -50)
                Spacer()
            }
        }
    }
}

#Preview {
    RegisterView()
}
