//
//  TableViewController.swift
//  imageGallery
//
//  Created by Ryan Brazones on 12/5/18.
//  Copyright © 2018 greenred. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    struct DataSource {
        var name: String = "untitled"
        var storedImages = [URL]()
    }
    
    @IBAction func addAnotherGalleryItem(_ sender: UIBarButtonItem) {
        let name = generateUniqueName(basedOn: "Untitled", withRespectTo: storedImages)
        //let name = "Untitled2"
        let newData = DataSource(name: name, storedImages: [URL]())
        storedImages += [newData]
        tableView.reloadData()
    }
    
    var storedImages = [DataSource(name: "Untitled", storedImages: [URL]())]
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if splitViewController?.preferredDisplayMode != .primaryOverlay {
            splitViewController?.preferredDisplayMode = .primaryOverlay
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // I want to select an item by default?
        let initialIndexPath = IndexPath(row: 0, section: 0)
        self.tableView.selectRow(at: initialIndexPath, animated: true, scrollPosition: UITableViewScrollPosition.none)
        
        // assuming we are ipad
        performSegue(withIdentifier: "GallerySegue", sender: tableView.cellForRow(at: initialIndexPath))
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return storedImages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        cell.textLabel?.text = storedImages[indexPath.row].name
        return cell
    }
 
    private func generateUniqueName(basedOn StringVal: String ,withRespectTo otherObjects: [DataSource]) -> String {
        var names = [String]()
        var workingString = StringVal
        for object in otherObjects {
            names += [object.name]
        }
        var uniqueNumber = 1
        while names.contains(workingString){
            workingString = StringVal + "\(uniqueNumber)"
            uniqueNumber += 1
        }
        return workingString
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GallerySegue", sender: tableView.cellForRow(at: indexPath))
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "GallerySegue" {
            
            guard let destVC = (segue.destination.contents as? ImageGalleryViewController) else { return }
            guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else { return }
            
            print("Preparing for GallerySegue")
            
            destVC.imageURLS = storedImages[indexPath.row].storedImages
            destVC.title = storedImages[indexPath.row].name
            
            
        }
    }
}



