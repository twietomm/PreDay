//
//  PreDayItemViewViewModel.swift
//  PreDay
//
//  Created by Tom Herrmann on 12.05.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
///ViewModel for a single toDoList item view (each row in items list)
///
class PreDayItemViewViewModel: ObservableObject{
    init(){
        
    }
    func toggleIsDone(item: ToDoListItem){
        var itemCopy = item
        itemCopy.setDone(!item.isDone)
        
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let db = Firestore.firestore()
        db.collection("users")
            .document(uid)
            .collection("todos")
            .document(itemCopy.id)
            .setData(itemCopy.asDictionary())
    }
}
