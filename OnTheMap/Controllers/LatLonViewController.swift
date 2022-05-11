//
//  CollectLatLonViewController.swift
//  OnTheMap
//
//  Created by joel.stevick on 5/10/22.
//

import UIKit
import CoreLocation
import MapKit

class LatLonViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // get coordinates from previous step
        let coordinate = State.shared.getState(key: StateKey.coordinate.rawValue) as! CLLocationCoordinate2D
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
      
        mapView.addAnnotation(annotation)
    }
    
    // MARK: - Actions
    @IBAction func cancelBtnPressed(_ sender: Any) {
        if let presentingViewController1 = presentingViewController {
            if let presentingViewController2 = presentingViewController1.presentingViewController {
                print("Should pop")
                presentingViewController2.dismiss(animated: true)
            } else {
                print("No presenting view controller")
            }
        } else {
            print("No presenting view controller")
        }
       
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func continueBtnPressed(_ sender: Any) {

        
        // next step
        self.performSegue(withIdentifier: "CollectMediaURL", sender: self)
    }
    
}
