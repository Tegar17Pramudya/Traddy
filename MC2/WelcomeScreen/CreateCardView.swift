//
//  CreateCardView.swift
//  Traddy
//
//  Created by Hafidz Ismail Hidayat on 11/06/23.
//

import SwiftUI
import MapKit
import CoreLocation

struct CreateCardView: View {
    @Binding var isCreatingCard: Bool
    @Binding var cards: [Card]
    @State var text: String = ""
    @State var searchQuery: String = ""
    @State private var searchResults: [MKMapItem] = []
    @State private var selectedLocation: CLLocationCoordinate2D?
    @State private var date = Date()
    @State private var useCurrentLocation = false
    @ObservedObject private var locationManagerDelegate = LocationManagerDelegate()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Your Trip's Name")
                        .foregroundColor(Color("Text"))
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    TextField("Ex: Trip Malang", text: $text)
                        .foregroundColor(.black)
                        .background(Color("Field"))
                        .padding(.horizontal)
                        .frame(height: 32)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 0))
                        .background(Color("Field"))
                        .cornerRadius(15)
                        .padding(.top, -10)
                    
                    if useCurrentLocation {
                        Map(coordinateRegion: .constant(getCoordinateRegion()), showsUserLocation: true)
                            .frame(height: 200)
                            .cornerRadius(10)
                    } else {
                        Text("Your Start Location")
                            .foregroundColor(Color("Text"))
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        TextField("Location", text: $searchQuery) { isEditing in
                            if isEditing {
                                searchResults = []
                            }
                        } onCommit: {
                            searchLocations()
                        }
                        .foregroundColor(.black)
                        .background(Color("Field"))
                        .padding(.horizontal)
                        .frame(height: 32)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 0))
                        .background(Color("Field"))
                        .cornerRadius(15)
                        .padding(.top, -10)
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            useCurrentLocation.toggle()
                        }) {
                            Text(useCurrentLocation ? "Enter a location" : "Use my current location")
                                .font(.caption)
                                .foregroundColor(Color("Text"))
                        }
                    }
                    .padding(.top, -10)
                    
                    ScrollView(.vertical) {
                        ForEach(searchResults, id: \.self) { item in
                            Button(action: {
                                selectLocation(item.placemark)
                            }) {
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Color("Field"))
                                    VStack(alignment: .leading) {
                                        Text(item.name ?? "")
                                            .font(.headline)
                                        Text(formatAddress(item.placemark))
                                            .font(.subheadline)
                                    }
                                    .padding()
                                    .foregroundColor(.black)
                                }
                            }
                        }
                    }
                    
                    RoundedButton(title: "Add Trip", action: {
                        createCard()
                    })
                }
                .padding([.top, .horizontal], 20)
            }
            .padding(.horizontal, 20)
            .background(Color.white)
            .navigationTitle("Create New Trip")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isCreatingCard = false
                    }) {
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(Color(.red))
                    }
                }
            }
        }
        .onAppear {
            locationManagerDelegate.startUpdatingLocation()
        }
        .onDisappear {
            locationManagerDelegate.stopUpdatingLocation()
        }
    }
    
    func searchLocations() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchQuery
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let response = response {
                searchResults = response.mapItems
            }
        }
    }
    
    func selectLocation(_ placemark: MKPlacemark) {
        selectedLocation = placemark.coordinate
        searchQuery = formatAddress(placemark)
    }
    
    func formatAddress(_ placemark: MKPlacemark) -> String {
        let addressComponents = [placemark.subThoroughfare, placemark.thoroughfare, placemark.locality, placemark.administrativeArea, placemark.postalCode, placemark.country]
            .compactMap { $0 }
        return addressComponents.joined(separator: ", ")
    }
    
    func createCard() {
        let newCard = Card(text: text, location: selectedLocation, imageName: getImageName())
        cards.append(newCard)
        isCreatingCard = false
    }
    
    private func getImageName() -> String? {
        let imageNames = ["pic3", "pic4", "pic2"]
        
        let index = cards.count % imageNames.count
        return imageNames[index]
    }
    
    private func getCoordinateRegion() -> MKCoordinateRegion {
        if let location = locationManagerDelegate.location {
            return MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        }
        return MKCoordinateRegion()
    }
}

class LocationManagerDelegate: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        self.location = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
    }
}
