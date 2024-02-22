//
//  DetailsViewController.swift
//  Ricky and Morty project
//
//  Created by Ankita Mondal on 31/01/24.
//

import UIKit
import CouchbaseLiteSwift

enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}
class DetailsViewController: UIViewController {
    
    @IBOutlet weak var DetailImage: UIImageView!
    
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var statusValue: UILabel!
    
    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var GenderName: UILabel!
    
    @IBOutlet weak var Typevalue: UILabel!
    
    @IBOutlet weak var type: UILabel!
    
    @IBOutlet weak var species: UILabel!
    
    @IBOutlet weak var speciesValue: UILabel!
    
    
    
    @IBOutlet weak var genderValue: UILabel!
    
    var characterDetails: Character?
    var isDataSaved: Bool = false
    
    
    
    var database: Database!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let characterDetails = characterDetails {
            // Example: Populate your UI elements
            statusValue.text = characterDetails.status
            GenderName.text = characterDetails.gender
            Typevalue.text = "None"
            species.text = characterDetails.species
            
            if let imageUrl = URL(string: characterDetails.image) {
                // Download and set the image using AlamofireImage
                DetailImage.af.setImage(withURL: imageUrl)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let query = QueryBuilder.select(SelectResult.all(), SelectResult.expression(Meta.id))
            .from(DataSource.database(DatabaseAccess.shared.database))
        
        do {
            for result in try query.execute() {
                let resultDict = result.dictionary(forKey: "SingleCharacterDataModel")
                let characterDict = (resultDict?.toDictionary()) ?? [:]
                
                // Assuming 'id' is a unique identifier for your character
                if let characterId = characterDetails?.id,
                   let savedCharacterId = characterDict["id"] as? Int, characterId == savedCharacterId {
                    // Character is saved, update UI
                    updateSaveButtonUI(isSaved: true)
                    return // Exit early once the character is found
                }
            }
        } catch {
            print("Error executing query: \(error)")
        }
        
        // If execution reaches here, character is not saved
        updateSaveButtonUI(isSaved: false)
    }
    
    //
    func checkIfCharacterIsSaved(isSaved: Bool) {
        let database = DatabaseAccess.shared.database
        
        guard let id = characterDetails?.id else {
            // Handle the case where characterName is nil (e.g., disable save button)
            saveButton.isEnabled = false
            return
        }
        
        // Query the database using the character's name
        if database.document(withID: String(id)) != nil {
            // Character is saved, update UI
            updateSaveButtonUI(isSaved: isSaved)
        } else {
            // Character is not saved, update UI accordingly
            updateSaveButtonUI(isSaved: isSaved)
        }
    }
    
    @IBAction func SaveButtonPressed(_ sender: UIButton) {
        
        let dataBase = DatabaseAccess.shared.database
        let mut = MutableDocument()
        
        
        // Set the document ID using the character's name
        if let characterName = characterDetails?.name {
            mut.setString(characterName, forKey: "name")
            
        }
        
        let detailsString = characterDetails?.convertToString ?? ""
        let detailsDict = converstion().convertToDictionaryValue(text: detailsString) ?? [:]
        
        mut.setData(detailsDict)
        
        do {
            try dataBase.defaultCollection().save(document: mut)
            print("Document saved successfully.")
            // Update the UI to indicate that the character is saved
            updateSaveButtonUI(isSaved: true)
        } catch {
            print("Error in saving the document: \(error)")
        }
    }
    func updateSaveButtonUI(isSaved: Bool) {
        // Use the nil-coalescing operator to provide a default value if characterDetails is nil
        let characterName = characterDetails?.name ?? "save"
        
        if isSaved || characterName == "save" {
            saveButton.setTitle("Saved", for: .normal)
            saveButton.isEnabled = false // Optional: Disable the button after saving
        } else {
            saveButton.setTitle("Save", for: .normal)
            saveButton.isEnabled = true
        }
    }
    @IBAction func DeleteButtonPressed(_ sender: UIButton) {
     

        guard let characterId = characterDetails?.id else {
               // Handle the case where characterDetails is nil or doesn't have an id
               return
           }

           let database = DatabaseAccess.shared.database

           do {
               // Create a query to find the document with the specified ID
               let query = QueryBuilder.select(SelectResult.expression(Meta.id))
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

                       if let saveDataViewController = self.navigationController?.viewControllers.first(where: { $0 is SaveDataViewController }) as? SaveDataViewController,
                           let index = saveDataViewController.savedData.firstIndex(where: { $0.id == characterId }) {
                           saveDataViewController.savedData.remove(at: index)
                           saveDataViewController.SaveTable.reloadData()
                       }
                   } else {
                       print("Error: Document not found.")
                   }
               }
           } catch {
               print("Error executing query or deleting document: \(error)")
           }
       }

    func fetchData(completion: @escaping (Result<[Character], Error>) -> Void) {
        let query = QueryBuilder.select(SelectResult.all(), SelectResult.expression(Meta.id))
            .from(DataSource.database(DatabaseAccess.shared.database))
        
        var fetchedData: [Character] = []
        
        do {
            for result in try query.execute() {
                let resultDict = result.dictionary(forKey: "SingleCharacterDataModel")
                let characterDict = (resultDict?.toDictionary()) ?? [:]
                
                if let characterData = try? JSONSerialization.data(withJSONObject: characterDict),
                   let character = try? JSONDecoder().decode(Character.self, from: characterData) {
                    
                    // Add the character to the fetched data
                    fetchedData.append(character)
                   
                }
            }
            completion(.success(fetchedData))
        } catch {
            print("Error in fetching the query: \(error)")
            completion(.failure(error))
        }
    }
}
