//
//  ViewController.swift
//  LocationMapApp
//
//  Created by alejandro on 17/01/23.
//

import UIKit
import SnapKit
import MapKit

class ViewController: UIViewController {

    let mapView = MKMapView()
    let locationManager = LocationManager()
    var currentUserLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        makeConstraints()
        mapView.delegate = self
        mapView.register(AnnotationView.self, forAnnotationViewWithReuseIdentifier: "annotationView")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.validateStatusAuthorization()
        locationManager.delegate = self
    }
    
    func makeConstraints() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func showLocation(location: CLLocation, placeMark: CLPlacemark) {
        guard location.coordinate.longitude != mapView.annotations.first?.coordinate.longitude, location.coordinate.latitude != mapView.annotations.first?.coordinate.latitude else {
            return
        }
        guard placeMark.name != mapView.annotations.last?.title , let area = placeMark.administrativeArea, let city = placeMark.locality, let country = placeMark.country, let address = placeMark.name else {
            return
        }
        mapView.removeAnnotations(mapView.annotations)
        mapView.setCenter(location.coordinate, animated: true)
        let annotation =  CustomAnnotation(
            coordinate: location.coordinate,
            title: address,
            subtitle: "\(city), \(area), \(country)"
        )
        createAnnTest()
        mapView.addAnnotation(annotation)
    }
    func createAnnTest() {
        let addressTest = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 10.996129, longitude: -74.813374), title: "test", subtitle: "test")
        mapView.addAnnotation(addressTest)
    }
}
extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "annotationView"
        guard let annotation = annotation as? CustomAnnotation else {
          return nil
        }
        var view: MKAnnotationView?
        if let dequeueView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            dequeueView.annotation = annotation
            view = dequeueView
        } else {
            view = AnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        return view
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotationCoordinate = view.annotation?.coordinate, let currentLocation = currentUserLocation?.coordinate else {
            return
        }
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: currentLocation))
        directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: annotationCoordinate))
        directionRequest.transportType = .automobile
        directionRequest.requestsAlternateRoutes = true
        let direction = MKDirections(request: directionRequest)
        direction.calculate { [weak self] direction, error in
            guard let direction = direction else {
                print(error ?? "error")
                return
            }
            for route in  direction.routes {
                self?.mapView.addOverlay(route.polyline)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyLine = overlay
        let polyLineRenderer = MKPolylineRenderer(overlay: polyLine)
        polyLineRenderer.strokeColor = UIColor.blue
        polyLineRenderer.lineWidth = 2.0
        return polyLineRenderer
    }

}
extension ViewController: LocationManagerDelegate {
    func currentLocation(location: CLLocation, placeMark: CLPlacemark) {
        showLocation(location: location, placeMark: placeMark)
        currentUserLocation = location
    }
}

