//
//  BottomSheet.swift
//  Traddy
//
//  Created by Hafidz Ismail Hidayat on 13/06/23.
//

import SwiftUI

struct BottomSheet: View {
    var action: () -> Void

    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 32)
                .foregroundColor(.white)
                .frame(height: 100)
            VStack (spacing: 20){
                Text("Tap to see Details")
                    .font(.body)
                    .foregroundColor(.black)
                Image(systemName: "chevron.down")
                    .foregroundColor(.black)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .onTapGesture {
            action()
        }
    }
}
//
//struct BottomSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        BottomSheet()
//    }
//}
