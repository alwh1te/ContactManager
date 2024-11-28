//
//  ViewController.swift
//  ContactManager
//
//  Created by Alexander on 22.11.2024.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var contacts: [Contact] = []
    private let contactManager = ContactManager.shared
    
    private lazy var editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector (editContactButton))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Contacts"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ContactCell.self, forCellReuseIdentifier: ContactCell.reuseIdentifier)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector (addContactButton))
        navigationItem.rightBarButtonItem = addButton
        
        navigationItem.leftBarButtonItem = editButton
        
        contacts = contactManager.loadContacts()
    }
}

// MARK: - Table view extensions
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        openContact(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.reuseIdentifier, for: indexPath)
        
        var config = cell.defaultContentConfiguration()
        let contact = contacts[indexPath.row]
        config.text = contact.fullName
        
        cell.contentConfiguration = config
        
        return cell
    }
    
    // MARK: - Context menu
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let actionProvider : UIContextMenuActionProvider = { _ in
            let moreMenu = UIMenu(title: "More", children: [
                UIAction(title: "Duplicate") { [weak self] _ in
                    guard let self else {return}
                    self.duplicate(at: indexPath)
                }
            ])
            return UIMenu(title: "Options", children: [
                UIAction(title: "Delete") { [weak self] _ in
                    self?.removeContact(at: indexPath)
                },
                moreMenu
            ])
        }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: actionProvider)
    }
    
    // MARK: - move rows
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        contacts.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
    
    // MARK: - delete row
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeContact(at: indexPath)
        }
    }
}


// MARK: - contact manage
extension ViewController {
    
    func openContact(at indexPath: IndexPath) {
        let contact = contacts[indexPath.row]
        let contactView = EditContactView(contact: contact) { [weak self] contact in
            self?.editContact(contact: contact, at: indexPath)
        }
        
        let hostingController = UIHostingController(rootView: contactView)
        present(hostingController, animated: true)
    }
    
    @objc
    func addContactButton() {
        let editContactView = EditContactView() { [weak self] contact in
            self?.contacts.append(contact)
            self?.tableView.reloadData()
        }
        let hostingViewController = UIHostingController(rootView: editContactView)
        present(hostingViewController, animated: true)
    }
    
    func addContact(contact: Contact) {
        contacts.append(contact)
        
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: contacts.count - 1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    func duplicate(at indexPath: IndexPath) {
        contacts.insert(contacts[indexPath.row], at: indexPath.row + 1)
        
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: indexPath.row + 1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    func editContact(contact: Contact, at indexPath: IndexPath) {
        contacts[indexPath.row] = contact
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.endUpdates()
    }
    
    func removeContact(at indexPath: IndexPath) {
        contacts.remove(at: indexPath.row)
         
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
    
    @objc
    func editContactButton() {
        tableView.isEditing.toggle()
        editButton.title = tableView?.isEditing ?? false ? "Done" : "Edit"
    }
}

final class ContactCell: UITableViewCell {
    static let reuseIdentifier: String = "ContactCell"
}
