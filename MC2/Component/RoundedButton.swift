//
//  RoundedButton.swift
//  Traddy
//
//  Created by Hafidz Ismail Hidayat on 06/06/23.
//

import SwiftUI

struct RoundedButton: View {        
        var title: String
        var action: () -> Void

        var body: some View {
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 310, height: 40)
                    .foregroundColor(Color("Button"))
                Text(title)
                    .foregroundColor(Color(.white))
                    .fontWeight(.semibold)
            }
            .offset(x: 0, y: -40)
            
            .onTapGesture {
                action()
            }


    }
}

//struct RoundedButton_Previews: PreviewProvider {
//    static var previews: some View {
//        RoundedButton()
//    }
//}
