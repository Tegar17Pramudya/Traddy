//
//  CardView.swift
//  Traddy
//
//  Created by Hafidz Ismail Hidayat on 11/06/23.
//

import SwiftUI
import MapKit

struct CardView: View {
    let card: Card
    @State private var isLinkActive = false
    @State private var isShowingActionSheet = false
    @Binding var cards: [Card] // Update binding for cards array
    @State private var isTracking = false
    @Binding var searchQuery: String

    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Spacer()
                if let imageName = card.imageName {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 320, height: 480)
                        .cornerRadius(32)
                        .onTapGesture {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                isLinkActive = true
                            }
                        }
                        .overlay(alignment: .bottom) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 32)
                                    .frame(width: 280, height: 160)
                                    .foregroundColor(Color.white.opacity(0.8))
                                    .padding(.bottom, 20)
                                VStack {
                                    HStack {
                                        Text("\(card.text)")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color("Text"))

                                        // Uncomment the following lines if you want to enable editing the card's text
//                                        Spacer()
//                                            .frame(width: 39)
//                                        Button(action: {}) {
//                                            Image(systemName: "pencil.circle")
//                                                .foregroundColor(Color("Text"))
//                                        }
                                    }
                                    .frame(width: 200)

                                    Text("\(searchQuery)")
                                        .font(.title)

                                    Button(action: {
                                        isTracking.toggle() // Toggle the tracking state
                                    }, label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 20)
                                                .frame(width: 150, height: 40)
                                                .foregroundColor(isTracking ? Color.red : Color.green) // Change button color based on tracking state
                                            Text(isTracking ? "Stop Tracking" : "Start Tracking") // Change button text based on tracking state
                                                .foregroundColor(Color.white)
                                        }
                                    })
                                }
                            }
                        }
                        .background(
                            NavigationLink(destination: SummaryView(itemsCount: .constant(0), itemsCount2: .constant(0), text: .constant("")), isActive: $isLinkActive) {
                                EmptyView()
                            }
                            .frame(width: 0, height: 0)
                            .opacity(0)
                            .buttonStyle(PlainButtonStyle())
                        )
                        .onLongPressGesture {
                            isShowingActionSheet = true
                        }
                        .actionSheet(isPresented: $isShowingActionSheet) {
                            ActionSheet(
                                title: Text("Delete Card"),
                                message: Text("Are you sure you want to delete this card?"),
                                buttons: [
                                    .destructive(Text("Delete"), action: {
                                        deleteCard()
                                    }),
                                    .cancel()
                                ]
                            )
                        }
                }
                Spacer()
            }
        }
    }

    private func deleteCard() {
        // Find the index of the card in the cards array
        if let index = cards.firstIndex(where: { $0.id == card.id }) {
            // Remove the card from the cards array
            cards.remove(at: index)
        }
    }
}

//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView(card: $card, cards: $cards)
//    }
//}
