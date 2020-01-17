//
//  SavedVC.swift
//  AutoX Tracker
//
//  Created by Sam Armstrong on 12/31/19.
//  Copyright © 2019 Samuel Armstrong. All rights reserved.
//

import UIKit

class SavedVC: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Adding button and button style to edit button for tableview
        let editButton = self.editButtonItem
        editButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Futura", size: 19)!], for: UIControl.State.normal)
        self.navigationItem.rightBarButtonItem = editButton
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if savedTracks.count != 0 {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
        }
        else {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "No Saved Courses.\n Press \"Start Tracking\" to start saving."
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
        return savedTracks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseList", for: indexPath) as! SavedCell
        cell.courseImage?.image = savedTracks[indexPath.row].image
        cell.textLabel1?.text = savedTracks[indexPath.row].title
        cell.textLabel2?.text = "Created: \(savedTracks[indexPath.row].dateCreated)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(indexPath.row + 90)
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
            // Need to move array of tracks up when a smaller index is deleted
            savedTracks.remove(at: indexPath.row)
            saveToUserDefaults(tracks: savedTracks)
            savedTimes.remove(at: indexPath.row)
            saveTimesToUserDefaults(times: savedTimes)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let temp: TrackModel = savedTracks[fromIndexPath.row]
        savedTracks[fromIndexPath.row] = savedTracks[to.row]
        savedTracks[to.row] = temp
        saveToUserDefaults(tracks: savedTracks)
        
        let timeTemp: [String] = savedTimes[fromIndexPath.row]
        savedTimes[fromIndexPath.row] = savedTimes[to.row]
        savedTimes[to.row] = timeTemp
        saveTimesToUserDefaults(times: savedTimes)
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        backItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Futura", size: 19)!], for: UIControl.State.normal)
        navigationItem.backBarButtonItem = backItem
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! SavedCourseInfo
                controller.savedLats = savedTracks[indexPath.row].latArray
                controller.savedLons = savedTracks[indexPath.row].lonArray
                controller.viewTitle = savedTracks[indexPath.row].title
                controller.indexOfCourse = indexPath.row
            }
        }
    }
}

// Custom Tableview Cell
class SavedCell: UITableViewCell {
    @IBOutlet weak var textLabel1: UILabel!
    @IBOutlet weak var textLabel2: UILabel!
    @IBOutlet weak var courseImage: UIImageView!
}
