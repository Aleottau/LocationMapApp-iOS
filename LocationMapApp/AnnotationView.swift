//
//  AnnotationView.swift
//  LocationMapApp
//
//  Created by alejandro on 23/01/23.
//

import Foundation
import MapKit

class AnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUpView() {
        self.canShowCallout = true
        self.calloutOffset = CGPoint(x: -5, y: 5)
        self.rightCalloutAccessoryView = UIButton(type: .contactAdd)
        self.image = UIImage(systemName: "car.fill")
    }
}
