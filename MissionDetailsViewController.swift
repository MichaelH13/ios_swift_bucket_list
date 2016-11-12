//
//  MissionDetailsViewController.swift
//  bucket_list
//
//  Created by Erik Clineschmidt on 11/9/16.
//  Copyright © 2016 Erik Clineschmidt. All rights reserved.
//

import UIKit

class MissionDetailsViewController: UITableViewController {
    
    var missionToEdit: String?
    var missionToEditIndexPath: Int?
    
    @IBOutlet weak var newMissionTextField: UITextField!
    
    @IBAction func CancelButtonPressed(_ sender: UIBarButtonItem) {
        cancelButtonDelegate?.cancelButtonPressedFrom(controller: self)
    }
    
    @IBAction func doneBarButtonPressed(_ sender: UIBarButtonItem) {
        if var mission = missionToEdit {
            mission = newMissionTextField.text!
            delegate?.missionDetailsViewController(controller: self, didFinishEditingMission: mission, atIndexPath: missionToEditIndexPath!)
        } else {
            // we are adding so run the "didFinishAddingMission" method
            // in the bucketlist controller
            let mission = newMissionTextField.text!
            delegate?.missionDetailsViewController(controller: self, didFinishAddingMission: mission)
        }
    }
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!

    weak var cancelButtonDelegate: CancelButtonDelegate?
    weak var delegate: MissionDetailsViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            print("mission to edit",missionToEdit as Any)
        
        if let thetext = missionToEdit {
            newMissionTextField.text = thetext
        }

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
        return 1
    }


}
