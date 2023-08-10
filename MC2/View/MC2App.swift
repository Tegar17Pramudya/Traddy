//
//  MC2App.swift
//  MC2
//
//  Created by I Nyoman Tegar Pramudya on 28/05/23.
//

import SwiftUI
import CoreLocation

@main
struct MC2App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State private var selectedCoordinate: CLLocationCoordinate2D? = nil
    
    var body: some Scene {
        WindowGroup {
            
            //SummaryView(itemsCount: .constant(0), itemsCount2: .constant(0), text: .constant("")).preferredColorScheme(.light)
            MainView(searchQuery: .constant("")).preferredColorScheme(.light)
            
            //BottomSheetView()
            //ContentView()
            //MapView(selectedCoordinate: $selectedCoordinate).preferredColorScheme(.light)
            //MainView()
            //Search(text: .constant(""))
            //WelcomeScreen()
            //PetaView()
        }
    }
}
