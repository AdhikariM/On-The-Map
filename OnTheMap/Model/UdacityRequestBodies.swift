//
//  UdacityRequestBodies.swift
//  OnTheMap
//
//  Created by Mahesh Adhikari

import Foundation

// MARK: Outgoing Body Items
//For Log-in
struct LogInStruct: Codable{
    var udacity: Udacity
}
struct Udacity: Codable {
    var username: String
    var password: String
}

//For Posting New Location
struct StudentLocation: Codable {
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longitude: Double
}
