//
//  PreDayItemView.swift
//  PreDay
//
//  Created by Tom Herrmann on 12.05.24.
//

import SwiftUI

struct PreDayItemView: View {
    let item: ToDoListItem
    @StateObject var viewModel = PreDayItemViewViewModel()
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(item.title)
                    .font(.body)
                Text("\(Date(timeIntervalSince1970: item.dueDate).formatted(date: .abbreviated, time: .shortened))")
                    .font(.footnote)
                    .foregroundColor(Color(.secondaryLabel))
            }
            .padding(.top, 5)
            .padding(.bottom, 5)
            Spacer()
            Button{
                viewModel.toggleIsDone(item: item)
            } label: {
                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(Color.blue)
            }
        }
    }
}

#Preview {
    PreDayItemView(item: .init(id: "123", title: "Get milk", dueDate: Date().timeIntervalSince1970, createdDate: Date().timeIntervalSince1970, isDone: false))
}
