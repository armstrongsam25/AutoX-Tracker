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
var latitudeForTracks = [Double]()
var longitudeForTracks = [Double]()
var savedTracks = [TrackModel]()

class MapVC: UIViewController, CLLocationManagerDelegate {
    // MARK: CLASS VARIABLES
    @IBOutlet weak var mapView: MKMapView!  // Linking MapView
    var locationMgr: CLLocationManager?
    var regionRadius: CLLocationDistance = 15
    var didAllowLocation: Bool?
    
    // MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationMgr = CLLocationManager()
        locationMgr?.delegate = self
        locationMgr?.desiredAccuracy = kCLLocationAccuracyBest
        self.mapView.delegate = self
        mapView.showsUserLocation = true    //Add user location
        mapView.showsCompass = false        //remove default compass
        mapView.showsPointsOfInterest = false
        
        //creating new location tracker button
        let trackingBtn = MKUserTrackingButton(mapView: mapView)
        mapView.addSubview(trackingBtn)
        trackingBtn.translatesAutoresizingMaskIntoConstraints = false
        trackingBtn.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -12).isActive = true
        trackingBtn.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 55).isActive = true
        trackingBtn.backgroundColor = UIColor.black
        trackingBtn.layer.cornerRadius = trackingBtn.frame.width/8.0
        trackingBtn.layer.masksToBounds = true
        
        //creating new compass button
        let compassButton = MKCompassButton(mapView: mapView)
        compassButton.compassVisibility = .visible
        mapView.addSubview(compassButton)
        compassButton.translatesAutoresizingMaskIntoConstraints = false
        compassButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -12).isActive = true
        compassButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 12).isActive = true
        
        // If user location is already authorized, start tracking. Else request to track location
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationMgr!.startUpdatingLocation()
        } else if CLLocationManager.authorizationStatus() == .denied{
            let alert = UIAlertController(title: "Location Required!", message: "This app requires your location to function properly. Please allow location access in Settings.", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)")
                    })
                }
            }
            alert.addAction(settingsAction)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true)
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
            let alert = UIAlertController(title: "Location Required!", message: "This app requires your location to function properly. Please allow location access in Settings.", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)")
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
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
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
            TrackingButtonAttrs.setTitle("Stop Tracking", for: .normal)
            //centerMapOnLocation(location: (locationMgr?.location)!)
            mapView.setUserTrackingMode(.follow, animated: true)
        }
        else if isTracking == true {
            isTracking = false
            locationMgr?.distanceFilter = 10
            TrackingButtonAttrs.backgroundColor = UIColor.systemGreen
            TrackingButtonAttrs.setTitle("Start Tracking", for: .normal)
            for capturedTrack in capturedTracks {
                coordinantsForTracks.append(capturedTrack[0].coordinate)
                latitudeForTracks.append(capturedTrack[0].coordinate.latitude)
                longitudeForTracks.append(capturedTrack[0].coordinate.longitude)
            }
            createPolyline(mapView: mapView)
            saveTheTrack()
        }
    }
    
    
    // MARK: didUpdateLocations
    var isFirstUpdate = true
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //append locations to list here
        if isTracking {
            capturedTracks.append(locations)
        }
        if isFirstUpdate {
//            let locValue: CLLocationCoordinate2D = manager.location!.coordinate
//            let initialLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
//            centerMapOnLocation(location: initialLocation)
            isFirstUpdate = false
        }
    }
    
    
    // MARK: createPolyline()
    var geodesic = MKGeodesicPolyline()
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

        geodesic = MKGeodesicPolyline(coordinates: points, count: points.count)
        mapView.addOverlay(geodesic)

        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
            let region = MKCoordinateRegion(center: points[0], span: span)
            self.mapView.setRegion(region, animated: true)
        })
    }
    
    
    // MARK: saveTheTrack() 
    func saveTheTrack(){
        let courseCount = savedTracks.count + 1
        //Save or Discard options
        let alert = UIAlertController(title: "Save Your Course", message: "Enter a name for your course.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Course #\(courseCount)"
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            // Call trackmodel here
            if textField!.text! == "" {
                textField!.text = "Course #\(courseCount)"
            }
            let currentTrack = TrackModel(title: textField!.text!, lat: latitudeForTracks, lon: longitudeForTracks)
            savedTracks.append(currentTrack)
            savedTimes.append([])
            saveToUserDefaults(tracks: savedTracks)
            self.mapView.removeOverlay(self.geodesic)
            capturedTracks.removeAll()
            coordinantsForTracks.removeAll()
            latitudeForTracks.removeAll()
            longitudeForTracks.removeAll()
        }))
        alert.addAction(UIAlertAction(title: "Disgard", style: .cancel, handler: { [weak alert] (_) in
            //remove polyline from screen
            self.mapView.removeOverlay(self.geodesic)
            capturedTracks.removeAll()
            coordinantsForTracks.removeAll()
        }))
        self.present(alert, animated: true, completion:  nil)
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        backItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Futura", size: 19)!], for: UIControl.State.normal)
        navigationItem.backBarButtonItem = backItem
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
        return MKPolylineRenderer(overlay: overlay)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // setting zoom
        mapView.setUserTrackingMode(.follow, animated: true)
    }
} // End of MapVC Delegate
