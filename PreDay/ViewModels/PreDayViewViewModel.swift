//
//  PreDayViewViewModel.swift
//  PreDay
//
//  Created by Tom Herrmann on 12.05.24.
//
import FirebaseFirestore
import Foundation

///ViewModel for list of items view
///Primary tab
class PreDayViewViewModel: ObservableObject{
    @Published var showingNewItemView = false
    
    private let userId: String
    init(userId: String){
        self.userId = userId
    }
    ///Delete to do list item
    /// - Parameter id: Item to delete
    func delete(id: String){
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
            .collection("todos")
            .document(id)
            .delete()
    }
}
