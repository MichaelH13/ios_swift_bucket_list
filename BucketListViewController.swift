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
    
    var missions = ["Missinog","dkdkdk"]
    var missionsTwo = [Mission]()
    
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
                controller.missionToEdit = missionsTwo[indexPath.row].details
                // this is the index in our array of that mission object, for use in the controller
                controller.missionToEditIndexPath = indexPath.row
            }
        }
    }

    
    // Create
    func missionDetailsViewController(controller: MissionDetailsViewController, didFinishAddingMission mission: String) {
        dismiss(animated: true, completion: nil)
        
        missions.append(mission)
        
        let saveableMission = Mission(context: context)
        saveableMission.details = mission
        contextSave()
        
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
        
        missionsTwo = retrieval()
        
        dismiss(animated: true, completion: nil)
        
        missions[indexPath] = mission
        missionsTwo[indexPath].details = mission
        contextSave()
        
        tableView.reloadData()
    }
    // Delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        missions.remove(at: indexPath.row)
        
        // del
        context.delete(missionsTwo[indexPath.row])
        contextSave()
        
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
        
        missionsTwo = retrieval()
        
        missions = []
        for mission in missionsTwo {
            missions.append(mission.details!)
        }
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

        cell.textLabel?.text = missions[indexPath.row]
        return cell
    }

    
}
