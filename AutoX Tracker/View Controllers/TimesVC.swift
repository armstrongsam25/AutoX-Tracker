//
//  TimesVC.swift
//  AutoX Tracker
//
//  Created by Samuel Armstrong on 1/10/20.
//  Copyright © 2020 Samuel Armstrong. All rights reserved.
//

import UIKit

// MARK: Global Variables
var savedTimes: [[String]] = []

// MARK: TimesVC Class
class TimesVC: UITableViewController {
    var indexOfCourse: Int = -1 // For use with TimesVC
    @IBOutlet weak var timeLabel: UILabel!
    
    // MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        let editButton = self.editButtonItem
        editButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Futura", size: 19)!], for: UIControl.State.normal)
        self.navigationItem.rightBarButtonItem = editButton
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
        // #warning Incomplete implementation, return the number of rows
        return savedTimes[indexOfCourse].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lapTimes", for: indexPath) as! TimesCell
        cell.lapTime?.text = "\(savedTimes[indexOfCourse][indexPath.row])"
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
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
        // Return false if you do not want the item to be re-orderable.
        return true
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

// MARK: Custom Tableview Cell
class TimesCell: UITableViewCell {
    @IBOutlet weak var lapTime: UILabel!
}
