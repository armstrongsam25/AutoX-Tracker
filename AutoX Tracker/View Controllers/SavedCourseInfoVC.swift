//
//  SavedCourseInfo.swift
//  AutoX Tracker
//
//  Created by Sam Armstrong on 1/5/20.
//  Copyright © 2020 Samuel Armstrong. All rights reserved.
//

import UIKit
import MapKit

class SavedCourseInfo: UIViewController {
    @IBOutlet weak var infoMap: MKMapView!
    var savedLats: [Double] = []
    var savedLons: [Double] = []
    var viewTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createInfoPolyline(mapView: infoMap)
        infoMap.delegate = self
        self.navigationItem.title = viewTitle
        
        infoMap.showsCompass = false        //remove default compass
        //creating new compass
        let compassButton = MKCompassButton(mapView: infoMap)
        compassButton.compassVisibility = .visible
        infoMap.addSubview(compassButton)
        compassButton.translatesAutoresizingMaskIntoConstraints = false
        compassButton.trailingAnchor.constraint(equalTo: infoMap.trailingAnchor, constant: -12).isActive = true
        compassButton.topAnchor.constraint(equalTo: infoMap.topAnchor, constant: 12).isActive = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        infoMap.removeOverlay(self.geodesic)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

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
} // End of MapVC Delegate
