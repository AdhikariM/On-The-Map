//
//  ParseResponses.swift
//  OnTheMap
//
//  Created by Mahesh Adhikari

import Foundation

// MARK: - Structures for Parse Responses

struct StudentLocationResponse: Codable {
    let results: [LocationResults]
}

struct LocationResults: Codable {
    let firstName: String
    let lastName: String
    let longitude: Double
    let latitude: Double
    let mapString: String
    let mediaURL: String
    let uniqueKey: String
    let objectId: String
    let createdAt: String
    let updatedAt: String
}

struct PostLocationResponse: Codable {
    let createdAt: Date
    let objectId: String
}

struct UpdateLocationResponse: Codable {
    let updatedAt: Date
}

