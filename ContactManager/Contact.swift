//
//  Contact.swift
//  ContactManager
//
//  Created by Alexander on 22.11.2024.
//

import Foundation

struct Contact {
    let firstName: String
    let lastName: String
    let phoneNumber: String
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
}
