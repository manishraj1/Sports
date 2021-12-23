//
//  ViewController.swift
//  Sports2
//
//  Created by Manish raj(MR) on 23/12/21.
//

import Foundation
import UIKit
import MapKit

class PinViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var annotations: [MKPointAnnotation] = [MKPointAnnotation]()
    let locationManager = CLLocationManager()
    var pins = [StadiumDetails]()
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        pins = Coredata.shared.savedStadiumObjects
        pinStadiumsFromCoreData()
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 55.0, longitudeDelta: 55.0)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
    
//    func pinStadiumsOnMap() {
//        annotations = []
//        mapView.removeAnnotations(mapView.annotations)
//
//        for stadium in StadiumArray.stadiums {
//            let annotation: MKPointAnnotation = MKPointAnnotation()
//            if let lat = CLLocationDegrees(exactly: stadium.geoLat), let lon = CLLocationDegrees(exactly: stadium.geoLon) {
//                let coordinateLocation = CLLocationCoordinate2DMake(lat, lon)
//                annotation.coordinate = coordinateLocation
//                annotation.title = stadium.name
//                annotation.subtitle = stadium.city
//                annotations.append(annotation)
//            }
//        }
//        mapView.addAnnotations(annotations)
//    }
    
    func pinStadiumsFromCoreData() {
        annotations = []
        mapView.removeAnnotations(mapView.annotations)
        for pin in pins {
            let annotation: MKPointAnnotation = MKPointAnnotation()
            if let lat = CLLocationDegrees(exactly: pin.latitude), let lon = CLLocationDegrees(exactly: pin.longitude) {
                let coordinateLocation = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                annotation.coordinate = coordinateLocation
                annotation.title = pin.name
                annotation.subtitle = pin.city
                annotations.append(annotation)
            }
        }
        mapView.addAnnotations(annotations)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "idForView"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view!.canShowCallout = true
            view!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return view
        } else {
            view!.annotation = annotation
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let vc = storyboard?.instantiateViewController(identifier: "DetailsViewController") as! InfoViewController
        let pin = view.annotation as? MKPointAnnotation
        
        for stadiumDetail in pins {
            if stadiumDetail.latitude == pin?.coordinate.latitude &&
            stadiumDetail.longitude == pin?.coordinate.longitude {
                vc.currentStadiumName = stadiumDetail.name
                vc.currentCityName = stadiumDetail.city
                vc.currentStateName = stadiumDetail.state
                vc.stadiumDetail = stadiumDetail
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
