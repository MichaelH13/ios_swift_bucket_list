//
//  BucketLIstControllerTableViewController.swift
//  bucket_list
//
//  Created by Erik Clineschmidt on 11/8/16.
//  Copyright © 2016 Erik Clineschmidt. All rights reserved.
//

import UIKit
import CoreData

class BucketLIstControllerTableViewController: UITableViewController, CancelButtonDelegate, MissionDetailsViewControllerDelegate {
    
    var missions = [Mission]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func cancelButtonPressedFrom(controller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailsSegue", sender: tableView.cellForRow(at: indexPath))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navigationController = segue.destination as! UINavigationController
        let controller = navigationController.topViewController as! MissionDetailsViewController
        controller.cancelButtonDelegate = self
        controller.delegate = self
        
        // pass the information the next controller will need....
        
        if sender is UITableViewCell{
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
//                print("indexPath:\(indexPath)")
//                print("indexPath:\(indexPath.row)")
//                print("indexPath:\(context[indexPath.row])")
//                print(missionsTwo[indexPath.row].details!)
                
                // this is the text, used to populate the label
                controller.missionToEdit = missions[indexPath.row].details
                // this is the index in our array of that mission object, for use in the controller
                controller.missionToEditIndexPath = indexPath.row
            }
        }
    }

    // Create
    func missionDetailsViewController(controller: MissionDetailsViewController, didFinishAddingMission mission: String) {
        // remove the view
        dismiss(animated: true, completion: nil)
        // create the mission object
        let saveableMission = Mission(context: context)
        // give your new object's 'details' property
        // the string that is passed in as 'mission'
        saveableMission.details = mission
        // save
        contextSave()
        // sync with database
        missions = retrieval()
        // show updated data
        tableView.reloadData()
    }
    // Read
    func retrieval()->[Mission]{
        let missionsFetch: NSFetchRequest<Mission> = NSFetchRequest(entityName: "Mission")
        do {
            let results = try context.fetch(missionsFetch)
            return results
        }
        catch let errors as NSError{
            print("errors \(errors)")
        } // found nothing
        return([])
    }
    // Update
    func missionDetailsViewController(controller: MissionDetailsViewController, didFinishEditingMission mission: String, atIndexPath indexPath: Int){
        
        missions = retrieval()
        dismiss(animated: true, completion: nil)
        missions[indexPath].details = mission
        contextSave()
        tableView.reloadData()
    }
    // Delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        context.delete(missions[indexPath.row])
        contextSave()
        // refresh local data
        missions = retrieval()
        // show updated data
        tableView.reloadData()
    }
    // Save to Database
    func contextSave() -> Void{
        do {
            try context.save()
        }
        catch let error as NSError{
            fatalError("Unresolved error \(error)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // get your initial local copy of the data
        missions = retrieval()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBOutlet weak var accessoryButton: UITableViewCell!
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = missions[indexPath.row].details
        return cell
    }

    
}
