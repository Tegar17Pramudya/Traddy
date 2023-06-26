//
//  MainView.swift
//  Traddy
//
//  Created by Stiven on 02/06/23.
//

import SwiftUI
import MapKit

struct MainView: View {
    @State private var isCreatingCard = false
    @State private var cards: [Card] = []
    @State private var currentPage = 0
    @Binding var searchQuery: String

    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.white)
                VStack (alignment: .center) {
                    Spacer()
                    if cards.isEmpty {
                        VStack {
                            Text("Welcome to Traddy!")
                                .foregroundColor(Color("Text"))
                                .fontWeight(.semibold)
                                .font(.title)
                                .multilineTextAlignment(.center)

                            Image("home")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 225)
                        }
                    } else {
                        PagerView(pageCount: cards.count, currentIndex: $currentPage) {
//                            Spacer()
                            ForEach(cards) { card in
                                CardView(card: card, cards: $cards, searchQuery: $searchQuery)
                            }
//                            Spacer()

                        }

//                        .padding(.top, 10)
                    }
                    Spacer()
                }
                .background(.white)



                PlusButton(action: {
                    isCreatingCard = true
                })
                .sheet(isPresented: $isCreatingCard) {
                    CreateCardView(isCreatingCard: $isCreatingCard, cards: $cards)
                }

            }
            .ignoresSafeArea()
            .navigationBarTitle("My Trip", displayMode: .large)
//            .toolbarColorScheme(.light, for: .navigationBar)
//            .toolbarBackground(
//                            Color.white,
//                            for: .navigationBar)
//                        .toolbarBackground(.visible, for: .navigationBar)

//            .background(NavigationConfigurator { nc in
//                nc.navigationBar.barTintColor = .black
//                nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
//            })

        }

    }
}

struct PagerView<Content: View>: View {
    let pageCount: Int
    @Binding var currentIndex: Int
    let content: Content
    
    init(pageCount: Int, currentIndex: Binding<Int>, @ViewBuilder content: () -> Content) {
        self.pageCount = pageCount
        self._currentIndex = currentIndex
        self.content = content()
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    content
                        .frame(width: geometry.size.width, height: nil)
                }
            }
            .content.offset(x: CGFloat(currentIndex) * -geometry.size.width)
            .frame(width: geometry.size.width, alignment: .leading)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.width < 0 {
                            currentIndex = min(currentIndex + 1, pageCount - 1)
                        } else if value.translation.width > 0 {
                            currentIndex = max(currentIndex - 1, 0)
                        }
                    }
            )
        }
    }
}

struct WelcomeMapView: UIViewRepresentable {
    let coordinate: CLLocationCoordinate2D
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        uiView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        uiView.setRegion(region, animated: true)
    }
}

struct Card: Identifiable {
    let id = UUID()
    var text: String
    var location: CLLocationCoordinate2D?
    var imageName: String?
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(searchQuery: .constant("")).preferredColorScheme(.light)
    }
}

