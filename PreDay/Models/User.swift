//
//  User.swift
//  PreDay
//
//  Created by Tom Herrmann on 12.05.24.
//

import Foundation

struct User: Codable{
    let id: String
    let name: String
    let email: String
    let joined: TimeInterval
}
