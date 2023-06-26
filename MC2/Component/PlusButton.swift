//
//  PlusButton.swift
//  Traddy
//
//  Created by Hafidz Ismail Hidayat on 06/06/23.
//

import SwiftUI

struct PlusButton: View {
    var action: () -> Void
    
    var body: some View {
        VStack (alignment: .leading) {
            Spacer()
            ZStack{
                Circle()
                    .frame(width: 60, height: 60)
                    .foregroundColor(Color("Button"))
                    .shadow(radius: 4, x:0, y: 2)

                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 20)
            }
            .offset(x: 140, y: -40)
            
            .onTapGesture {
                action()
            }
//            Image(systemName: "plus.circle.fill")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 60, height: 60)
//                .shadow(radius: 4, x: 0, y:2)
//                .foregroundColor(Color("Button"))
//                .offset(x: 140, y: -40)
//                .onTapGesture {
//                    action()
//                }
        }.ignoresSafeArea()
    }
}

struct PlusButton_Previews: PreviewProvider {
    static var previews: some View {
        PlusButton() {
            print("asu")
        }
    }
}
