//
//  TrackModel.swift
//  AutoX Tracker
//
//  Created by Sam Armstrong on 12/31/19.
//  Copyright © 2019 Samuel Armstrong. All rights reserved.
//

import UIKit
import CoreLocation

class TrackModel {

    // MARK: Properties
    var image: UIImage?
    var title: String
    var dateCreated: String
    var coordinants: [CLLocationCoordinate2D]
    
    // MARK: Initialization
    init(title: String, coordinants: [CLLocationCoordinate2D]){
        if title == "" {
            //set date as title
        }
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        self.image = UIImage(named: "SavedTrackImage.png") // TODO: set to static image
        self.title = title
        self.dateCreated = formatter.string(from: date)
        self.coordinants = coordinants
    }
    
    init(){
        self.image = UIImage(named: "SavedTrackImage.png")
        self.title = ""
        self.dateCreated = ""
        self.coordinants = [CLLocationCoordinate2D]()
    }
}
