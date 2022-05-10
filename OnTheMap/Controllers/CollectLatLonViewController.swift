//
//  CollectLatLonViewController.swift
//  OnTheMap
//
//  Created by joel.stevick on 5/10/22.
//

import UIKit
import CoreLocation
import MapKit

class CollectLatLonViewController: UIViewController {

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
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
