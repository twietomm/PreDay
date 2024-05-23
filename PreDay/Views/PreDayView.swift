//
//  PreDayView.swift
//  PreDay
//
//  Created by Tom Herrmann on 12.05.24.
//

import SwiftUI
import FirebaseFirestoreSwift

struct PreDayView: View {
    @StateObject var viewModel: PreDayViewViewModel
    @FirestoreQuery var items: [ToDoListItem]
    

    
    init(userId: String){
        self._items = FirestoreQuery(
            collectionPath: "users/\(userId)/todos")
        
        self._viewModel = StateObject(wrappedValue: PreDayViewViewModel(userId: userId))
    }
    
    var body: some View {
        NavigationView{
            VStack{
                List(items){ item in
                    PreDayItemView(item: item)
                        .swipeActions{
                            Button("Delete"){
                                //Delete
                                viewModel.delete(id: item.id)
                            }
                            .tint(.red)
                        }
                }
            }
            .navigationTitle("Prepare the day")
            .toolbar{
                Button{
                    // Action
                    viewModel.showingNewItemView = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $viewModel.showingNewItemView
            ){
                NewItemView(newItemPresented: $viewModel.showingNewItemView)
            }
        }
    }
}

#Preview {
    PreDayView(userId: "Y5I6fGpxWPcJUBBkzfVUDg7TjhE2")
}
