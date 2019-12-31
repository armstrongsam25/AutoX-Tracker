//
//  ViewController.swift
//  AutoX Tracker
//
//  Created by Samuel Armstrong on 12/28/19.
//  Copyright © 2019 Samuel Armstrong. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// MARK: GLOBAL DECLARATIONS
var capturedTracks = [[CLLocation]]()
var coordinantsForTracks = [CLLocationCoordinate2D]()

class MapVC: UIViewController, CLLocationManagerDelegate {
    // MARK: CLASS VARIABLES
    @IBOutlet weak var mapView: MKMapView!  // Linking MapView
    var locationMgr: CLLocationManager?
    var initialLocation: CLLocation?
    var regionRadius: CLLocationDistance?
    var didAllowLocation: Bool?
    
    // MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationMgr = CLLocationManager()
        locationMgr?.delegate = self
        mapView.delegate = self
        mapView.showsUserLocation = true    //Add user location
        mapView.showsCompass = false        //remove default compass
        
        //creating new compass
        let compassButton = MKCompassButton(mapView: mapView)
        compassButton.compassVisibility = .visible
        mapView.addSubview(compassButton)
        compassButton.translatesAutoresizingMaskIntoConstraints = false
        compassButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -12).isActive = true
        compassButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 12).isActive = true
        
        // If user location is already authorized, start tracking. Else request to track location
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationMgr!.startUpdatingLocation()
        } else {
            locationMgr!.requestWhenInUseAuthorization()
        }
    }
    
    // MARK: didChangeAuthorization
    //0 == nonDetermined, 1 == restricted, 2 == denied, authorizedAlways == 3, authorizedwheninuse == 4
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //Allow Once and Allow while using both use this
        if status == .authorizedWhenInUse {
            didAllowLocation = true;
            manager.startUpdatingLocation()
        }
        else if status == .notDetermined {
            didAllowLocation = false
        }
        else {
            didAllowLocation = false
            let alert = UIAlertController(title: "Location Required!", message: "This app REQUIRES your location to function properly. Please allow location access in the settings app.", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            alert.addAction(settingsAction)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    // MARK: centerMapOnLocation
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius!, longitudinalMeters: regionRadius!)
      mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK: CONNECTING BUTTONS (Presses, Attributes)
    @IBOutlet weak var TrackingButtonAttrs: UIButton!
    // Start/stop tracking button
    var isTracking: Bool = false
    @IBAction func TrackingButton(_ sender: Any) {
        if isTracking == false {
            isTracking = true
            locationMgr?.distanceFilter = 1
            TrackingButtonAttrs.backgroundColor = UIColor.red
            TrackingButtonAttrs.setTitle("Stop Tracking Location", for: .normal)
        }
        else if isTracking == true {
            isTracking = false
            locationMgr?.distanceFilter = 10
            TrackingButtonAttrs.backgroundColor = UIColor.systemGreen
            TrackingButtonAttrs.setTitle("Start Tracking Location", for: .normal)
            for capturedTrack in capturedTracks {
                coordinantsForTracks.append(capturedTrack[0].coordinate)
            }
            createPolyline(mapView: mapView)
        }
    }
    
    // MARK: didUpdateLocations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //append locations to list here
        if isTracking {
            capturedTracks.append(locations)
        }

            let locValue: CLLocationCoordinate2D = manager.location!.coordinate
            initialLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
            regionRadius = 100
            centerMapOnLocation(location: initialLocation!)
    }
    
    // MARK: createPolyline()
    func createPolyline(mapView: MKMapView) {
        var points: [CLLocationCoordinate2D] = []
        if coordinantsForTracks.count > 0 {
            for coord in coordinantsForTracks {
                let point = CLLocationCoordinate2DMake(coord.latitude, coord.longitude)
                points.append(point)
            }
        }
        else {
            let alert = UIAlertController(title: "Not Enough Coordinants", message: "You did not move enough to record a track. Try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }

        let geodesic = MKGeodesicPolyline(coordinates: points, count: points.count)
        mapView.addOverlay(geodesic)

        UIView.animate(withDuration: 1.5, animations: { () -> Void in
            let span = MKCoordinateSpan(latitudeDelta: 0.0000000001, longitudeDelta: 0.0000000001)
            let region1 = MKCoordinateRegion(center: points[0], span: span)
            self.mapView.setRegion(region1, animated: true)
        })
    }
} // End of MapVC Class

// MARK: MapVC Delegate
extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = .systemRed
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        /*else if overlay is MKPolygon {
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.fillColor = .systemBlue
            return polygonView
        }*/
        return MKPolylineRenderer(overlay: overlay)
    }
} // End of MapVC Delegate
