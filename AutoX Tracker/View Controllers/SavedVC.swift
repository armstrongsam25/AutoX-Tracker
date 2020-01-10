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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
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
            savedTracks.remove(at: indexPath.row)
            saveToUserDefaults(tracks: savedTracks)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let temp: TrackModel = savedTracks[fromIndexPath.row]
        savedTracks[fromIndexPath.row] = savedTracks[to.row]
        savedTracks[to.row] = temp
        saveToUserDefaults(tracks: savedTracks)
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
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! SavedCourseInfo
                controller.savedLats = savedTracks[indexPath.row].latArray
                controller.savedLons = savedTracks[indexPath.row].lonArray
                controller.viewTitle = savedTracks[indexPath.row].title
            }
        }
    }
}

class SavedCell: UITableViewCell {
    @IBOutlet weak var textLabel1: UILabel!
    @IBOutlet weak var textLabel2: UILabel!
    @IBOutlet weak var courseImage: UIImageView!
}
