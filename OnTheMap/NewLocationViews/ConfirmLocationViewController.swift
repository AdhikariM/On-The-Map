//
//  ConfirmLocationViewController.swift
//  OnTheMap
//
//  Created by Mahesh Adhikari

import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: Map Data
    var newLocation = CLLocationCoordinate2D()
    var newLocationString = ""
    var newLocationURL = URL(string: "")
    var proposedAnnotation = MKPointAnnotation()
    
    //MARK: Outlets
    @IBOutlet weak var confirmMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set delegate
        
        
        self.confirmMapView.delegate = self
        //build annotation
        self.proposedAnnotation.coordinate = self.newLocation
        self.proposedAnnotation.title = newLocationString
        self.proposedAnnotation.subtitle = newLocationURL?.absoluteString
        //set annotation on map view
        self.confirmMapView.centerCoordinate = self.newLocation
        self.confirmMapView.addAnnotations([proposedAnnotation])
        let region = MKCoordinateRegion(center: self.newLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
        self.confirmMapView.setRegion(region, animated: true)
    }
    
    
    @IBAction func finishAndPost(_ sender: Any) {
        // post new student location
        UdacityAPI.postNewStudentLocation(newLatitude: self.newLocation.latitude, newLongitude: self.newLocation.longitude, locationString: self.newLocationString, locationMediaURL: self.newLocationURL?.absoluteString ?? "",  completion: {(results, error) in
            if let error = error {
                // handle error
                DispatchQueue.main.async {
                    self.presentErrorAlert(message: error.localizedDescription)
                }
            } else {
                // handle results
                self.presentSuccessAlert(message: "Results processed successfully")
                
                // update map data
                UdacityAPI.getMapDataRequest(completion: { (studentLocationsArray, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        MapPins.mapPins = studentLocationsArray
                    }
                    
                    // go back to existing pin view after post and map update
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: {})
                    }
                })
            }
        })
    }
    
    func presentErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentSuccessAlert(message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
