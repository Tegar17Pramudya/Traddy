//
//  WelcomeScreen.swift
//  MC2
//
//  Created by I Nyoman Tegar Pramudya on 03/06/23.
//

//import SwiftUI
//
//struct WelcomeScreen: View {
//    @State private var tripName = ""
//    @State private var startLocation = ""
//    @State private var selectedDate = Date()
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                TextField("Your Trip Name", text: $tripName)
//                    .padding()
//                
//                TextField("Your Start Location", text: $startLocation)
//                    .padding()
//                
//                NavigationLink(destination: MapScreen(location: startLocation)) {
//                    Text("Show on Map")
//                        .font(.headline)
//                        .foregroundColor(.blue)
//                }
//                .padding()
//                
//                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
//                    .padding()
//                
//                Spacer()
//            }
//            .padding()
//            .navigationTitle("Welcome")
//        }
//    }
//}
//
//struct WelcomeScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        WelcomeScreen()
//    }
//}

