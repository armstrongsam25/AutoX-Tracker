//
//  TrackModel.swift
//  AutoX Tracker
//
//  Created by Samuel Armstrong on 12/31/19.
//  Copyright © 2020 Samuel Armstrong. All rights reserved.
//

import UIKit
import CoreLocation

public class TrackModel {

    // MARK: Properties
    public var image: UIImage? = UIImage(named: "SavedTrackImage.png")
    public var title: String
    public var dateCreated: String
    public var latArray: [Double]
    public var lonArray: [Double]
    
    // MARK: Initialization
    init(title: String, lat: [Double], lon: [Double]){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        self.title = title
        self.dateCreated = formatter.string(from: date)
        self.latArray = lat
        self.lonArray = lon
    }
    
    init(title: String, date: String, lat: [Double], lon: [Double]){
        self.title = title
        self.dateCreated = date
        self.latArray = lat
        self.lonArray = lon
    }
    
    init(){
        self.title = ""
        self.dateCreated = ""
        self.latArray = []
        self.lonArray = []
    }
}
