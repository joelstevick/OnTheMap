//
//  MapViewController.swift
//  OnTheMap
//
//  Created by joel.stevick on 5/5/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Properties
    var studentLocations: [StudentLocation]?
    var signedInUserLocation: StudentLocation?
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        // initialize navigation bar
        navigationItem.hidesBackButton = true
        
        // initialize
        reload()
        
        
        // listen for changes
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: Notification.Name(StateChanges.signedInStudentLocation.rawValue), object: nil)
    }
    
    // MARK: - Signed in student location change event handler
    @objc func refresh() {
        studentLocations = nil
        
        reload()
    }
    func reload() {
        
        Task {
            await loadStudentLocations()
            
            await loadMapView()
        }
    }
    // MARK: - Utility functions
    func loadStudentLocations() async {
        
        if studentLocations == nil {
            studentLocations = await UdacityApi.shared.getStudentLocations(refresh: true)
            
            signedInUserLocation = await UdacityApi.shared.getSignedInStudentLocation()
            
            if let signedInUserLocation = signedInUserLocation {
                studentLocations?.append(signedInUserLocation)
            }
        }
        
    }
    
    func makeAnnotation(_ studentLocation: StudentLocation) -> MKPointAnnotationWithPrivateData {
        // Notice that the float values are being used to create CLLocationDegree values.
        // This is a version of the Double type.
        let lat = CLLocationDegrees(studentLocation.latitude)
        let long = CLLocationDegrees(studentLocation.longitude)
        
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let first = studentLocation.firstName
        let last = studentLocation.lastName
        let mediaURL = studentLocation.mediaURL
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotationWithPrivateData(isSignedInUser: studentLocation.uniqueKey == signedInUserLocation?.uniqueKey)
        
        annotation.coordinate = coordinate
        annotation.title = "\(first) \(last)"
        annotation.subtitle = mediaURL
        
        return annotation
    }
    
    func loadMapView() async {
        var annotations = [MKPointAnnotationWithPrivateData]()
        
        if let studentLocations = studentLocations {
            for studentLocation in studentLocations {
                // Place the annotation in an array of annotations.
                annotations.append(makeAnnotation(studentLocation))
            }
            
            // When the array is complete, we add the annotations to the map.
            self.mapView.addAnnotations(annotations)
        }
        
    }
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            
            // signed-in user gets blue pin
            let annotationWithPrivateData = annotation as! MKPointAnnotationWithPrivateData
            
            pinView!.pinTintColor = annotationWithPrivateData.isSignedInUser ? .blue : .red
            
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
}
