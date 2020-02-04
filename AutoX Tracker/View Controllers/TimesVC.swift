//
//  TimesVC.swift
//  AutoX Tracker
//
//  Created by Samuel Armstrong on 1/10/20.
//  Copyright © 2020 Samuel Armstrong. All rights reserved.
//

import UIKit
import GoogleMobileAds

// MARK: Global Variables
var savedTimes: [[String]] = []

// MARK: TimesVC Class
class TimesVC: UITableViewController {
    var indexOfCourse: Int = -1 // For use with TimesVC
    @IBOutlet weak var timeLabel: UILabel!
    var adBanner: GADBannerView!
    
    // MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        tableView.allowsSelection = false
        let editButton = self.editButtonItem
        editButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Futura", size: 19)!], for: UIControl.State.normal)
        self.navigationItem.rightBarButtonItem = editButton
        
        //ad setup
        adBanner = GADBannerView(adSize: kGADAdSizeBanner )
        addBannerViewToView(adBanner)
        adBanner.adUnitID = "ca-app-pub-3940256099942544/2934735716" // TESTING
        //adBanner.adUnitID = "ca-app-pub-4895210659623653/2815181432" // ACTUAL
        adBanner.rootViewController = self
        adBanner.load(GADRequest())
    }

    
    // MARK: Adding Ad to bottom of screen
    func addBannerViewToView(_ bannerView: GADBannerView) {
     bannerView.translatesAutoresizingMaskIntoConstraints = false
     view.addSubview(bannerView)
     view.addConstraints(
       [NSLayoutConstraint(item: bannerView,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: view.safeAreaLayoutGuide,
                           attribute: .bottom,
                           multiplier: 1,
                           constant: 0),
        NSLayoutConstraint(item: bannerView,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .centerX,
                           multiplier: 1,
                           constant: 0)
       ])
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if savedTimes[indexOfCourse].count != 0 {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
        }
        else {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "No Saved Times.\n Press \"Start Timing\" to start saving."
            noDataLabel.textColor = UIColor.black
            noDataLabel.font = UIFont(name: "Futura", size: 19)
            noDataLabel.textAlignment = .center
            noDataLabel.numberOfLines = 2
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
        }
        return 1
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedTimes[indexOfCourse].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lapTimes", for: indexPath) as! TimesCell
        cell.lapTime?.text = "\(savedTimes[indexOfCourse][indexPath.row])"
        return cell
    }
    

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            savedTimes[indexOfCourse].remove(at: indexPath.row)
            saveTimesToUserDefaults(times: savedTimes)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let temp = savedTimes[indexOfCourse][fromIndexPath.row]
        savedTimes[indexOfCourse][fromIndexPath.row] = savedTimes[indexOfCourse][to.row]
        savedTimes[indexOfCourse][to.row] = temp
        saveTimesToUserDefaults(times: savedTimes)
    }

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
} // End of TimesVC class

// MARK: Custom Tableview Cell
class TimesCell: UITableViewCell {
    @IBOutlet weak var lapTime: UILabel!
}
