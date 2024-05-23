//
//  NewItemViewViewModel.swift
//  PreDay
//
//  Created by Tom Herrmann on 12.05.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
class NewItemViewViewModel: ObservableObject{
    @Published var title = ""
    @Published var dueDate = Date()
    @Published var showAlert = false
    
    init(){
        
    }
    func save(){
        guard canSave else{
            return
        }
        // get current user id
        guard let uId = Auth.auth().currentUser?.uid else{
            return
        }
        //Create model
        let newId = UUID().uuidString
        let newItem = ToDoListItem(id: newId,
                                   title: title,
                                   dueDate: dueDate.timeIntervalSince1970,
                                   createdDate: Date().timeIntervalSince1970,
                                   isDone: false)
        // Save Model
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(uId)
            .collection("todos")
            .document(newId)
            .setData(newItem.asDictionary())
    }
    func save1(){
        
        // get current user id
        guard let uId = Auth.auth().currentUser?.uid else{
            return
        }
        //Create model
        let newId = UUID().uuidString
        let newItem = ToDoListItem(id: newId,
                                   title: title,
                                   dueDate: dueDate.timeIntervalSince1970,
                                   createdDate: Date().timeIntervalSince1970,
                                   isDone: false)
        // Save Model
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(uId)
            .collection("todos")
            .document(newId)
            .setData(newItem.asDictionary())
    }
    var canSave: Bool{
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else{
            return false
        }
        guard dueDate >= Date().addingTimeInterval(-86400) else{
            return false
        }
        return true
    }
    func setDueDate(from dateString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        if let date = formatter.date(from: dateString) {
            dueDate = date
        } else {
            print("Invalid date format")
        }
    }
    func setTitle(titleString: String){
        title = titleString
    }
}
