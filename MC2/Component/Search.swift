//
//  Search.swift
//  Traddy
//
//  Created by Hafidz Ismail Hidayat on 13/06/23.
//

import SwiftUI

struct Search: View {
    //nanti ini edit
    @Binding var text: String

    var body: some View {
        VStack{
            HStack{
                Spacer()
                ZStack{
                    //nanti ini edit
                    TextField("Search", text: $text)
                        .foregroundColor(.black)
                        .background(Color("Field"))
                        .padding(.horizontal)
                        .frame(width: 330, height: 32)
                        .overlay(RoundedRectangle(cornerRadius: 10) .stroke(Color.gray, lineWidth: 0))
                        .background(Color("Field"))
                        .cornerRadius(10)
                }
                Spacer()
            }
        }
    }
}
    
    struct Search_Previews: PreviewProvider {
        static var previews: some View {
            //ini edit
            Search(text: .constant(""))
        }
    }
