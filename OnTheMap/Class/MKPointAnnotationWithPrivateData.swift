//
//  MKAnnotationView+PrivateData.swift
//  OnTheMap
//
//  Created by joel.stevick on 5/8/22.
//

import UIKit
import MapKit

class MKPointAnnotationWithPrivateData: MKPointAnnotation {

    var isSignedInUser: Bool
    
    init(isSignedInUser: Bool) {
        self.isSignedInUser = isSignedInUser
    }
    
}
