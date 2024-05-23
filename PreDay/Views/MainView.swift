//
//  ContentView.swift
//  PreDay
//
//  Created by Tom Herrmann on 12.05.24.
//

import SwiftUI


struct MainView: View {
    @StateObject var viewModel = MainViewViewModel()
    
    var body: some View {
        
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty{
            //signed in
            //PreDayView()
            
            accountView
            
        } else {
            LoginView()
        }
    }
    @ViewBuilder
    var accountView: some View{
        TabView{
            PreDayView(userId: viewModel.currentUserId)
                .tabItem{
                    Label("Home", systemImage: "house")
                }
            ChatView()
                .tabItem{
                    Label("Chat", systemImage: "bubble.left")
                }
            ProfileView()
                .tabItem{
                    Label("Profile", systemImage: "person.circle")
                }
        }
    }
}

#Preview {
    MainView()
}
