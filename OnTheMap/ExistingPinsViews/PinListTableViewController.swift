//
//  PinListTableViewController.swift
//  OnTheMap
//
//  Created by Mahesh Adhikari

import UIKit

class PinListTableViewController: UITableViewController {

    var locations = [LocationResults]()
    var networkActivity = UIActivityIndicatorView()
    
    //MARK: Loading functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addActivityIndicator()
        if MapPins.mapPins.isEmpty {
            self.loadMapData()
        }
        self.locations = MapPins.mapPins
    }
    
    func addActivityIndicator() {
        self.networkActivity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        self.networkActivity.style = UIActivityIndicatorView.Style.medium
        self.networkActivity.center = self.view.center
        self.networkActivity.hidesWhenStopped = true
        self.view.addSubview(self.networkActivity)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    func loadMapData() {
        self.networkActivity.startAnimating()
        UdacityAPI.getMapDataRequest(completion: { (studentLocationsArray, error) in
            if error != nil {
                self.showDownloadFailure(error?.localizedDescription ?? "")
            } else {
                MapPins.mapPins = studentLocationsArray
            }
            self.networkActivity.stopAnimating()
        })
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MapPinCell", for: indexPath)
        cell.textLabel?.text = "\(self.locations[indexPath.row].firstName) \(self.locations[indexPath.row].lastName)"
        cell.detailTextLabel?.text = "\(self.locations[indexPath.row].mediaURL)"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let urlToOpen = URL(string: self.locations[indexPath.row].mediaURL) {
           UIApplication.shared.open(urlToOpen)
        }
    }
    
    //MARK: IBActions
    @IBAction func refreshMapData(_ sender: Any) {
        self.loadMapData()
        self.locations = MapPins.mapPins
        self.tableView.reloadData()
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
