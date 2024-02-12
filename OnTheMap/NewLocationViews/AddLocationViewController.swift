//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Mahesh Adhikari

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController, UITextFieldDelegate {
    
    let confirmMapLocationSegueId = "confirmMapLocationSegue"
    var newLocation = CLLocationCoordinate2D()
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var errorLabelView: UILabel!
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.errorLabelView.isHidden = true
        self.locationTextField.delegate = self
        self.urlTextField.delegate = self
        
    }
    
    //MARK: Location Button Pressed
    @IBAction func findLocationRequest(_ sender: Any) {
        guard let urlText = self.urlTextField.text, !urlText.isEmpty else {
            self.showErrorAlert("Please provide a URL for this location.")
            return
        }
        
        // Show activity indicator
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        //self.view.addSubview(activityIndicator)
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(self.locationTextField.text ?? "") { (placemark, error) in
            // Hide activity indicator
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            
            if error != nil {
                self.showErrorAlert(error!.localizedDescription)
            } else {
                if let newPlacemark = placemark?.first, let newLoc = newPlacemark.location?.coordinate {
                    self.newLocation = newLoc
                    self.performSegue(withIdentifier: self.confirmMapLocationSegueId, sender: self)
                } else {
                    print("Error in digging for Coordinate!")
                }
            }
        }
        
    }
    //MARK: cancel
    @IBAction func cancelNewLocation(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
    
    //MARK: Error Alert
    func showErrorAlert(_ message: String) {
        self.errorLabelView.text = "ERROR: \(message)"
        self.errorLabelView.isHidden = false
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.confirmMapLocationSegueId {
            
            let controller = segue.destination as! ConfirmLocationViewController
            controller.newLocation = self.newLocation
            controller.newLocationString = self.locationTextField.text ?? ""
            controller.newLocationURL = URL(string: self.urlTextField.text ?? "")
        }
    }
    
}
