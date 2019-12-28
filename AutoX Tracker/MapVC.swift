//
//  ViewController.swift
//  AutoX Tracker
//
//  Created by Sam Armstrong on 12/28/19.
//  Copyright © 2019 Samuel Armstrong. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var locationMgr: CLLocationManager?
    var initialLocation: CLLocation?
    var regionRadius: CLLocationDistance?
    var didAllowLocation: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationMgr = CLLocationManager()
        locationMgr?.delegate = self
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            locationMgr!.startUpdatingLocation()
        }else{
            locationMgr!.requestWhenInUseAuthorization()
        }
    }
    

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius!, longitudinalMeters: regionRadius!)
      mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("her")
            let locValue: CLLocationCoordinate2D = manager.location!.coordinate
            initialLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
            regionRadius = 100
            centerMapOnLocation(location: initialLocation!)
    }
}

