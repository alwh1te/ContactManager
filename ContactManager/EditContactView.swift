//
//  AddContactView.swift
//  ContactManager
//
//  Created by Alexander on 23.11.2024.
//

import SwiftUI

struct EditContactView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var phoneNumber: String = ""
    
    @State var phoneNumberError = false
    
    let onSave: (Contact) -> Void
    
    init(firstName: String = "", lastName: String = "", phoneNumber: String = "", onSave: @escaping (Contact) -> Void) {
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.onSave = onSave
    }
    
    init (contact: Contact, onSave: @escaping (Contact) -> Void) {
        self.firstName = contact.firstName
        self.lastName = contact.lastName
        self.phoneNumber = contact.phoneNumber
        self.onSave = onSave
    }
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    ContactField(label: "First Name", text: $firstName)
                    ContactField(label: "Last Name", text: $lastName)
                    ContactField(label: "Phone Number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                }
                Spacer()
                Button("Save Contact") {
                    saveContact()
                }
                .disabled(firstName.isEmpty || lastName.isEmpty || phoneNumber.isEmpty)
                .alert(isPresented: $phoneNumberError) {
                    Alert(title: Text("Invalid Phone Number"), message: Text("Please enter a valid phone number."), dismissButton: .default(Text("OK")))
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("New Contact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    func saveContact() {
        
        let textFormatter = format(with: "+X (XXX) XXX-XXXX", phone: phoneNumber)
        
        guard !textFormatter.isEmpty else {
            phoneNumberError = true
            return
        }
        
        let contact = Contact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
        onSave(contact)
        dismiss()
    }
    
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
}

struct ContactField: View {
    let label: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            TextField("", text: $text).multilineTextAlignment(.trailing)
        }
    }
}
