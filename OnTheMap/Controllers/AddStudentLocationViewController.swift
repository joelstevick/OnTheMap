//
//  AddStudentLocationViewController.swift
//  OnTheMap
//
//  Created by joel.stevick on 5/8/22.
//

// steps in the process

enum Step: String {
    case collectMapString
    case collectLatLon
    case collectMediaURL
}

import UIKit

class AddStudentLocationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // initialize state
        State.shared.reset()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
