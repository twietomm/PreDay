//
//  MainViewViewModel.swift
//  PreDay
//
//  Created by Tom Herrmann on 12.05.24.
//

import Foundation
import FirebaseAuth

class MainViewViewModel: ObservableObject{
    @Published var currentUserId: String = ""
    private var handler: AuthStateDidChangeListenerHandle?
    
    init(){
        let handler = Auth.auth().addStateDidChangeListener{[weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUserId = user?.uid ?? ""
            }
        }
    }
    
    public var isSignedIn: Bool{
        return Auth.auth().currentUser != nil
    }
}
