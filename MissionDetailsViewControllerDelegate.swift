//
//  MissionDetailsViewControllerDelegate.swift
//  bucket_list
//
//  Created by Erik Clineschmidt on 11/9/16.
//  Copyright © 2016 Erik Clineschmidt. All rights reserved.
//

import Foundation


protocol MissionDetailsViewControllerDelegate: class {
    func missionDetailsViewController(controller: MissionDetailsViewController, didFinishAddingMission mission: String)
    func missionDetailsViewController(controller: MissionDetailsViewController, didFinishEditingMission mission: String, atIndexPath indexPath: Int)
}
