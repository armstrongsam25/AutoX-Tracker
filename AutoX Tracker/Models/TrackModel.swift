//
//  TrackModel.swift
//  AutoX Tracker
//
//  Created by Sam Armstrong on 12/31/19.
//  Copyright © 2019 Samuel Armstrong. All rights reserved.
//

import UIKit
import CoreLocation

public class TrackModel {

    // MARK: Properties
    public var image: UIImage?
    public var title: String
    public var dateCreated: String
    //var coordinants: [CLLocationCoordinate2D]
    public var latArray: [Double]
    public var lonArray: [Double]
    
    // MARK: Initialization
    init(title: String, lat: [Double], lon: [Double]){
        if title == "" {
            //set date as title
        }
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        self.image = UIImage(named: "SavedTrackImage.png") // TODO: set to static image
        self.title = title
        self.dateCreated = formatter.string(from: date)
        self.latArray = lat
        self.lonArray = lon
    }
    
    init(title: String, date: String, lat: [Double], lon: [Double]){
        self.image = UIImage(named: "SavedTrackImage.png") // TODO: set to static image
        self.title = title
        self.dateCreated = date
        self.latArray = lat
        self.lonArray = lon
    }
    
    init(){
        self.image = UIImage(named: "SavedTrackImage.png")
        self.title = ""
        self.dateCreated = ""
        self.latArray = []
        self.lonArray = []
    }
}
