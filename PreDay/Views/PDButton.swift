//
//  PDButton.swift
//  PreDay
//
//  Created by Tom Herrmann on 13.05.24.
//

import SwiftUI

struct PDButton: View {
    let title: String
    let background: Color
    let action:() -> Void
    
    var body: some View {
        Button{
            action()
            
        } label: {
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(background)
                
                Text(title)
                    .foregroundColor(Color.white)
                    .bold()
            }
        }
        .padding()
    }
}

#Preview {
    PDButton(title: "Value", background: .pink) {
        // Hello
    }
}
