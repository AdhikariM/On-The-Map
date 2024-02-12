//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Mahesh Adhikari

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    //MARK: Map Data Variables
    var locations = [LocationResults]()
    var annotations = [MKPointAnnotation]()
    let annotationReuseId = "pin"
    
    //MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var networkBusy: UIActivityIndicatorView!
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        if MapPins.mapPins.isEmpty {
            self.loadMapData()
        }
        self.locations = MapPins.mapPins
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mapView.addAnnotations(self.annotations)
        
    }
    
    //MARK: MapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: self.annotationReuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: self.annotationReuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .blue
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let urlToOpen = URL(string: view.annotation?.subtitle! ?? "") {
               UIApplication.shared.open(urlToOpen)
            }
        }
    }
    
    
    //MARK: Displaying Map Data
    func translateDictionaryToAnnotations(){
        for loc in locations {
            let lat = CLLocationDegrees(loc.latitude)
            let long = CLLocationDegrees(loc.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

            // Create the annotation; setting coordiates, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(loc.firstName) \(loc.lastName)"
            annotation.subtitle = loc.mediaURL
            
            annotations.append(annotation)
        }
    }
    
    func loadMapData() {
        self.networkBusy.startAnimating()
        UdacityAPI.getMapDataRequest(completion: { (studentLocationsArray, error) in
            if error != nil {
                self.showDownloadFailure(error?.localizedDescription ?? "")
            } else {
                MapPins.mapPins = studentLocationsArray
                self.locations = MapPins.mapPins
                self.translateDictionaryToAnnotations()
            }
            self.networkBusy.stopAnimating()
        })
    }
    
    //MARK: Actions
    @IBAction func refreshDataFromNetwork(_ sender: Any) {
        self.loadMapData()
        self.mapView.addAnnotations(self.annotations)
    }
    
    @IBAction func logout(_ sender: Any) {
        // perform network logout
        UdacityAPI.deleteSessionRequest()
        // dismiss view
        self.dismiss(animated: true, completion: {})
    }
    

    //MARK: Error Handling
    func showDownloadFailure(_ message: String) {
        let alertVC = UIAlertController(title: "Download Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
