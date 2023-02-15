//
//  CustonAnnotation.swift
//  LocationMapApp
//
//  Created by alejandro on 18/01/23.
//

import Foundation
import CoreLocation
import MapKit
import Contacts

//protocol CustomAnnotationProtocol {
//    func mapItem() -> MKMapItem?
//}

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
//extension CustomAnnotation: CustomAnnotationProtocol {
//    func mapItem() -> MKMapItem? {
//        guard let title = title else {
//            return nil
//        }
//        let address = [CNPostalAddressStreetKey: title]
//        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: address)
//        let mapItem = MKMapItem(placemark: placemark)
//        mapItem.name = title
//        return mapItem
//    }
//}

