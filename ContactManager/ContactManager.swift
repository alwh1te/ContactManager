//
//  ContactManager.swift
//  ContactManager
//
//  Created by Alexander on 23.11.2024.
//

final class ContactManager {
    static let shared = ContactManager()
    
    private init() {}
    
    func loadContacts() -> [Contact] {
        return [Contact(firstName: "A", lastName: "B", phoneNumber: "8"), Contact(firstName: "C", lastName: "D", phoneNumber: "9"), Contact(firstName: "E", lastName: "F", phoneNumber: "10")];
    }
}
