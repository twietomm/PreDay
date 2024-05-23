//
//  NewItemView.swift
//  PreDay
//
//  Created by Tom Herrmann on 12.05.24.
//

import SwiftUI

struct NewItemView: View {
    @StateObject var viewModel = NewItemViewViewModel()
    @Binding var newItemPresented : Bool
    
    var body: some View {
        VStack{
            Text("New Item")
                .font(.system(size: 32))
                .bold()
                .padding(.top, 80)
            
            Form{
                //Title
                TextField("Title", text: $viewModel.title)
                    .textFieldStyle(DefaultTextFieldStyle())
                // Due Date
                DatePicker("Due Date", selection: $viewModel.dueDate)
                    .datePickerStyle(GraphicalDatePickerStyle())
                // Button
                PDButton(title: "Save", background: Color.pink){
                    //Trigger
                    if viewModel.canSave{
                        viewModel.save()
                        newItemPresented = false
                    }else{
                        viewModel.showAlert = true
                    }
                }
                .padding()
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"),
                      message: Text( "Please fill in all fields and select due date that is today or newer."))
            }
        }
    }
}

#Preview {
    NewItemView(newItemPresented: Binding(get: {
        return true
    }, set: {
        _ in
    }))
}
