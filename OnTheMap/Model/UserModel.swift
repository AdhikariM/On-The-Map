//
//  UserModel.swift
//  OnTheMap
//
//  Created by Mahesh Adhikari

import Foundation


//MARK: User Info
struct UserSession {
    static var userId: String = ""
    static var firstName: String = ""
    static var lastName: String = ""
    static var nickname: String = ""
}

//MARK: Map Locations
struct MapPins {
    static var mapPins = [LocationResults]()
}
