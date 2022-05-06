//
//  MapViewController.swift
//  OnTheMap
//
//  Created by joel.stevick on 5/5/22.
//

import UIKit

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // initialize navigation bar
        navigationItem.hidesBackButton = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem()
        navigationItem.leftBarButtonItem?.title = "Pin"
        
    }
}
