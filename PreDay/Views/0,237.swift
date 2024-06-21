import SwiftUI

struct PreDayItemView: View {
    let item: ToDoListItem
    @StateObject var viewModel = PreDayItemViewViewModel()
    @StateObject var viewModel2: PreDayViewViewModel
    @State var isShowingDetail = false  // Zustand für das neue Fenster
    @State private var titleFieldInput = ""  // Zustand für das Textfeld
    @State private var detailsFieldInput = ""  // Zustand für das Textfeld
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.title3)
                    .bold()
                
                Text(item.details)
                    .font(.body)
                Text("\(Date(timeIntervalSince1970: item.dueDate).formatted(date: .abbreviated, time: .shortened))")
                    .font(.footnote)
                    .foregroundColor(Color(.secondaryLabel))
            }
            .padding()
            
            //.padding(.right, 5)
            Spacer()
            Button {
                viewModel.toggleIsDone(item: item)
            } label: {
                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(Color.blue)
                    .font(.title)
            }
            .padding()
        }
        .background(
                Color("Purple")
        )
        .cornerRadius(10.0)
        .contentShape(Rectangle())  // Macht das gesamte HStack klickbar
        .onTapGesture {
            isShowingDetail = true
        }
        .sheet(isPresented: $isShowingDetail) {
            DetailView(item: item, viewModel2: viewModel2, titleFieldInput: $titleFieldInput ,detailsFieldInput: $detailsFieldInput, isShowingDetail: $isShowingDetail)  // Neue Ansicht mit Textfeldbindung
        }
    }
}

struct DetailView: View {
    let item: ToDoListItem
    @StateObject var viewModel = PreDayItemViewViewModel()
    @StateObject var viewModel2: PreDayViewViewModel
    @Binding var titleFieldInput: String // Binding für das Textfeld
    @Binding var detailsFieldInput: String // Binding für das Textfeld
    @Binding var isShowingDetail: Bool
    
    var body: some View {
        VStack {
            TextField("", text: $titleFieldInput)
                .frame(minHeight: 30, maxHeight: 50)
                .textFieldStyle(DefaultTextFieldStyle())
                .multilineTextAlignment(.center)
                .font(.title)
                .background(Color("Purple"))
                .cornerRadius(20)
                
            Text("Due date: \(Date(timeIntervalSince1970: item.dueDate).formatted(date: .abbreviated, time: .shortened))")
                .padding()
            Text("Detail:").bold().multilineTextAlignment(.trailing)
        Spacer()
            TextEditor(text: $detailsFieldInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color("Purple"))
               
                
                
            Button {
                // Hier aktualisierst du den Wert des ViewModels

                viewModel2.updateItem(id: item.id, newTitle: titleFieldInput, newDetails: detailsFieldInput)
                /*changeItemModel.title = titleFieldInput
                changeItemModel.details = detailsFieldInput
                viewModel2.updateItem(id: item.id, newTitle: changeItemModel.title, newDetails: changeItemModel.details)*/
                isShowingDetail = false
            } label: {
                Text("Save")
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .background(Color(.blue), in: Capsule())
            }
            .padding(.horizontal)
            .padding(.top, 10)
            .foregroundColor(.white)
            
            

            Spacer()
            Button {
                viewModel.toggleIsDone(item: item)
            } label: {
                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(Color.blue)
                    .font(.system(size: 50))
            }
            .padding()
            Text("date of creation: \(Date(timeIntervalSince1970: item.createdDate).formatted(date: .abbreviated, time: .shortened))")
            Button("Delete") {
                isShowingDetail = false
                viewModel2.delete(id: item.id)
            }                    
            .fontWeight(.bold)
            .padding(.vertical)
            .frame(maxWidth: 100)
            .background(Color(.red), in: Capsule())
            .tint(.white)
            .padding()
        }
        .padding()
        .onAppear(){
            titleFieldInput = item.title
            detailsFieldInput = item.details
        }
    }
}

#Preview {
    PreDayItemView(item: .init(id: "123", title: "Get milk", details: "Non dairy milk, because I'm lactose intolerant", dueDate: Date().timeIntervalSince1970, createdDate: Date().timeIntervalSince1970, isDone: false), viewModel2: PreDayViewViewModel(userId: "Y5I6fGpxWPcJUBBkzfVUDg7TjhE2"))
}
