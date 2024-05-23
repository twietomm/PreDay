//
//  HeaderView.swift
//  PreDay
//
//  Created by Tom Herrmann on 12.05.24.
//

import SwiftUI
//Color(red: 0.04, green: 0.18392, blue: 0.5)
struct HeaderView: View {
    let title: String
    let subtitle: String
    let angle: Double
    let background: Color
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(background)
                .rotationEffect(Angle(degrees: angle))
                                
            VStack{
                Text(title)
                    .font(.system(size: 50))
                    .foregroundColor(Color.white)
                    .bold()
                
                Text(subtitle)
                    .font(.system(size: 30))
                    .foregroundColor(Color.white)
            }
            .padding(.top, 100)
        }

        .frame(width: UIScreen.main.bounds.width * 3,
               height: 350)
        .offset(y: -150)

    }
}

#Preview {
    HeaderView(title: "PreDay", subtitle: "Ai Powered", angle: 15.0, background: Color(red: 0.04, green: 0.18392, blue: 0.5))
}
