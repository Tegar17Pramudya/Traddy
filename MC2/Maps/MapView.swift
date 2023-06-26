import SwiftUI
import MapKit
import CoreLocation
import UserNotifications
import WatchConnectivity

struct ContentView: View {
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State private var isMonitoringLocation = false
    
    var body: some View {
        VStack {
            MapView(selectedCoordinate: $selectedCoordinate)
                .frame(height: 300)
                .onAppear {
                    isMonitoringLocation = true
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView
    
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    let searchController = UISearchController(searchResultsController: nil)
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        
        // Setup location manager
        locationManager.delegate = context.coordinator
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Set user tracking mode to show user location and zoom to it
        mapView.setUserTrackingMode(.follow, animated: true)
        
        // Add a tap gesture recognizer to handle user selection
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleMapTap(sender:)))
        mapView.addGestureRecognizer(tapGesture)
        
        // Set up search controller
        searchController.searchBar.delegate = context.coordinator
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Location"
        searchController.searchBar.autocapitalizationType = .words
        searchController.searchBar.autocorrectionType = .no
        
        let searchContainer = UIView(frame: CGRect(x: 0, y: 0, width: mapView.frame.size.width, height: 50))
        searchContainer.addSubview(searchController.searchBar)
        mapView.addSubview(searchContainer)
        
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let userLocation = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 400, longitudinalMeters: 400)
            uiView.setRegion(region, animated: true)
        }
        
        uiView.showsUserLocation = true
        
        if let coordinate = selectedCoordinate {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            uiView.addAnnotation(annotation)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        @objc func handleMapTap(sender: UITapGestureRecognizer) {
            if sender.state == .ended {
                let locationInView = sender.location(in: parent.mapView)
                let coordinate = parent.mapView.convert(locationInView, toCoordinateFrom: parent.mapView)
                parent.selectedCoordinate = coordinate
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                parent.mapView.addAnnotation(annotation)
            }
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()

            guard let searchQuery = searchBar.text else {
                return
            }

            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(searchQuery) { [weak self] placemarks, error in
                if let error = error {
                    print("Gagal melakukan pencarian lokasi: \(error.localizedDescription)")
                    return
                }

                guard let placemark = placemarks?.first, let location = placemark.location else {
                    print("Tidak ada hasil pencarian yang valid")
                    return
                }

                DispatchQueue.main.async {
                    self?.parent.selectedCoordinate = location.coordinate

                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location.coordinate
                    self?.parent.mapView.addAnnotation(annotation)

                    // Update map view's region to display the selected location
                    let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 400, longitudinalMeters: 400)
                    self?.parent.mapView.setRegion(region, animated: true)

                    // Dismiss the search bar
                    searchBar.text = nil
                    searchBar.resignFirstResponder()
                }
            }
        }

        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = nil
            searchBar.resignFirstResponder()
        }
    }
}
