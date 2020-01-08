//
//  SavedCourseInfo.swift
//  AutoX Tracker
//
//  Created by Sam Armstrong on 1/5/20.
//  Copyright © 2020 Samuel Armstrong. All rights reserved.
//

import UIKit
import MapKit

class SavedCourseInfo: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var infoMap: MKMapView!
    var infoMapMgr: CLLocationManager?
    var savedLats: [Double] = []
    var savedLons: [Double] = []
    var viewTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createInfoPolyline(mapView: infoMap)
        infoMapMgr = CLLocationManager()
        infoMapMgr?.delegate = self
        infoMap.delegate = self
        infoMap.showsUserLocation = true
        infoMap.showsCompass = false        //remove default compass
        infoMap.showsPointsOfInterest = false
        self.navigationItem.title = viewTitle
        
        //Creating location tracking button
        let buttonItem = MKUserTrackingButton(mapView: infoMap)
        infoMap.addSubview(buttonItem)
        buttonItem.translatesAutoresizingMaskIntoConstraints = false
        buttonItem.trailingAnchor.constraint(equalTo: infoMap.trailingAnchor, constant: -12).isActive = true
        buttonItem.topAnchor.constraint(equalTo: infoMap.topAnchor, constant: 55).isActive = true
        buttonItem.backgroundColor = UIColor.black
        buttonItem.layer.cornerRadius = buttonItem.frame.width/8.0
        buttonItem.layer.masksToBounds = true
        
        //creating new compass button
        let compassButton = MKCompassButton(mapView: infoMap)
        compassButton.compassVisibility = .visible
        infoMap.addSubview(compassButton)
        compassButton.translatesAutoresizingMaskIntoConstraints = false
        compassButton.trailingAnchor.constraint(equalTo: infoMap.trailingAnchor, constant: -12).isActive = true
        compassButton.topAnchor.constraint(equalTo: infoMap.topAnchor, constant: 12).isActive = true
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            infoMapMgr!.startUpdatingLocation()
        } else {
            infoMapMgr!.requestWhenInUseAuthorization()
        }
        
        //Mask for rounded corners on timer label
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.TimerLabel.frame
        rectShape.position = self.TimerLabel.center
        rectShape.path = UIBezierPath(roundedRect: self.TimerLabel.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath

         self.TimerLabel.layer.backgroundColor = UIColor.green.cgColor
        //Here I'm masking the textView's layer with rectShape layer
         self.TimerLabel.layer.mask = rectShape
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        infoMap.removeOverlay(self.geodesic)
        infoMapMgr!.stopUpdatingLocation()
    }
    
    // MARK: createInfoPolyline
    var geodesic = MKGeodesicPolyline()
    func createInfoPolyline(mapView: MKMapView) {
        var points: [CLLocationCoordinate2D] = []
        var index: Int = 0
        let count: Int = savedLats.count
        while index < count {
            let point = CLLocationCoordinate2DMake(savedLats[index], savedLons[index])
            points.append(point)
            index += 1
        }
        
        geodesic = MKGeodesicPolyline(coordinates: points, count: points.count)
        mapView.addOverlay(geodesic)

        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            let span = MKCoordinateSpan(latitudeDelta: 0.0000000001, longitudeDelta: 0.0000000001)
            let region1 = MKCoordinateRegion(center: points[0], span: span)
            mapView.setRegion(region1, animated: true)
        })
    }
    
    // MARK: didUpdateLocations
    var isFirstUpdate = true
    var regionRadius: Double = 100
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if isFirstUpdate {
            let locValue: CLLocationCoordinate2D = manager.location!.coordinate
            let initialLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
            centerMapOnLocation(location: initialLocation)
            isFirstUpdate = false
        }
    }
    
    // MARK: centerMapOnLocation
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
      infoMap.setRegion(coordinateRegion, animated: true)
    }
    

    // MARK: lapTimer
    var seconds: Float = 00.00
    var minutes: Int = 0
    var timer = Timer()
    var isTiming = false
    @IBOutlet weak var StartStopTimerAttrs: UIButton!
    @IBAction func StartStopTimer(_ sender: Any) {
        if isTiming {
            isTiming = false
            StartStopTimerAttrs.backgroundColor = UIColor.systemGreen
            StartStopTimerAttrs.setTitle("Start Timer", for: .normal)
            timer.invalidate()
        }
        else {
            isTiming = true
            StartStopTimerAttrs.backgroundColor = UIColor.red
            StartStopTimerAttrs.setTitle("Stop Timer", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        }
    }
    
    // MARK: lapTimer Stop/Start Func and Attrs
    @IBOutlet weak var TimerLabel: UILabel!
    @objc func UpdateTimer() {
        seconds += 0.01
        if seconds >= 60 {
            minutes += 1
            seconds = 00.00
        }
        var min: String = String(minutes)
        var sec: String = String(format: "%.2f", seconds)
        if minutes < 10 {
            min = "0\(min)"
        }
        if seconds < 10 {
            sec = "0\(sec)"
        }
        TimerLabel.text = "\(min):\(sec)" //String(format: "%.2f", seconds)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

// MARK: MapView Delegate
extension SavedCourseInfo: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = .systemRed
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return MKPolylineRenderer(overlay: overlay)
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        mapView.setUserTrackingMode(.followWithHeading, animated: true)
    }
} // End of MapVC Delegate
