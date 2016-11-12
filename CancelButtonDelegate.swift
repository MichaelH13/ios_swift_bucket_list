//
//  CancelButtonDelegate.swift
//  bucket_list
//
//  Created by Erik Clineschmidt on 11/9/16.
//  Copyright © 2016 Erik Clineschmidt. All rights reserved.
//

import Foundation

import UIKit
protocol CancelButtonDelegate: class {
    func cancelButtonPressedFrom(controller: UIViewController)
}
