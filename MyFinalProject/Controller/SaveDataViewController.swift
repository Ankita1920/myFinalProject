//
//  SaveDataViewController.swift
//  MyFinalProject
//
//  Created by Ankita Mondal on 13/02/24.
//

import UIKit
import CouchbaseLiteSwift

class SaveDataViewController: UIViewController {
    
    
    @IBOutlet weak var SaveTable: UITableView!
    
    @IBOutlet weak var EditButton: UIBarButtonItem!
    
    var savedData: [Character] = []
   
    var characterDetails: Character?
    var detailsViewController: DetailsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the detailsViewController property from the navigation controller's view controllers
        SaveTable.delegate = self
        SaveTable.dataSource = self
      
        fetchDataFromSaveVC()
    }
    
    @IBAction func EditButtonClicked(_ sender: Any) {
        SaveTable.isEditing = !SaveTable.isEditing

        if SaveTable.isEditing {
            EditButton.title = "Done"
        } else {
            EditButton.title = "Edit"
        }
    }

    func fetchDataFromSaveVC() {
        if let characterDetails = characterDetails {
            addUniqueCharacter(characterDetails)
        }

        DetailsViewController().fetchData { [weak self] result in
            switch result {
            case .success(let data):
                for character in data {
                    self?.addUniqueCharacter(character)
                }
                DispatchQueue.main.async {
                    self?.SaveTable.reloadData()
                }

            case .failure(let error):
                print("Error fetching data: \(error)")
               
            }
        }
    }
    private func addUniqueCharacter(_ character: Character) {
   
        if !savedData.contains(where: { $0.id == character.id }) {
            savedData.append(character)
        }
    }
}

extension SaveDataViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SaveDataTableViewCell
        let character = savedData[indexPath.row]
        cell.Name?.text = character.name
        
        cell.Status?.text = character.status
        cell.Gender?.text = character.gender
        cell.Species?.text = character.species
        cell.Type?.text = "None"
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let selectedItem = savedData[sourceIndexPath.row]
        savedData.remove(at: sourceIndexPath.row)
        //        savedData.insert(selectedItem, at: destinationIndexPath.row)
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard indexPath.row < savedData.count else {
            print("Index out of range")
            return
        }
        
        let deletedCharacter = savedData.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        // Delete corresponding document from CouchDB
        deleteCharacterFromCouchDB(character: deletedCharacter)
    }
    
    func deleteCharacterFromCouchDB(character: Character) {
        let characterId = character.id
        
        let database = DatabaseAccess.shared.database
        
        do {
            // Create a query to find the document with the specified ID
            let query = QueryBuilder
                .select([SelectResult.expression(Meta.id)])
                .from(DataSource.database(database))
                .where(Expression.property("id").equalTo(Expression.int(characterId)))
            
            for result in try query.execute() {
                guard let documentId = result.string(forKey: "id") else {
                    print("Error: Missing document ID.")
                    continue
                }
                
                // Retrieve the document using its ID
                if let document = database.document(withID: documentId) {
                    // Delete the document
                    try database.deleteDocument(document)
                    
                    print("Document with ID \(documentId) deleted successfully.")
                } else {
                    print("Error: Document not found.")
                }
            }
        } catch {
            print("Error executing query or deleting document: \(error)")
        }
    }
}
