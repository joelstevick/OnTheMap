//
//  MapViewController.swift
//  OnTheMap
//
//  Created by joel.stevick on 5/5/22.
//

import UIKit

class MapViewController: UIViewController {

    var studentLocations: [StudentLocation]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // initialize navigation bar
        navigationItem.hidesBackButton = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem()
        navigationItem.leftBarButtonItem?.title = "Pin"
        
       
        navigationItem.rightBarButtonItem = UIBarButtonItem()
        navigationItem.rightBarButtonItem?.title = "Refresh"
        
        // initialize
        Task {
            await getStudentLocations()
        }
    }
    
    func getStudentLocations() async {
        
        studentLocations = await UdacityApi.shared.getStudentLocations()
       
    }
}
