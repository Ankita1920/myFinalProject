//
//  CharacterViewController.swift
//  Ricky and Morty project
//
//  Created by Ankita Mondal on 30/01/24.
//

import UIKit

class CharacterViewController: UIViewController {


    @IBOutlet weak var mytable: UITableView!
    
    @IBOutlet weak var myCollection: UICollectionView!
    @IBOutlet weak var toggleButton: UIButton!
    
    
    var characterViewModel = CharacterViewModel()
    
    var isTableViewMode = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
              characterViewModel.fetchCharacters {
                  DispatchQueue.main.async {
                      self.mytable.reloadData()
                      self.myCollection.reloadData()
                  }
              }
          
    }
    
    
    
    @IBAction func toggleButtonPressed(_ sender: UIButton) {
        // Toggle between UITableView and UICollectionView
        isTableViewMode.toggle()

        // Reload the corresponding view
        if isTableViewMode {
            mytable.isHidden = false
            myCollection.isHidden = true
        } else {
            mytable.isHidden = true
            myCollection.isHidden = false
        }
    }

    
    
}

extension CharacterViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterViewModel.characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = mytable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //  cell?.CharacterName.text =
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
    
    
    
extension CharacterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return characterViewModel.characters.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = myCollection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! myCollectionViewCell
            
            // Assuming you have a property called "name" in your SingleCharactersDataModel
            cell.characterName2.text = characterViewModel.characters[indexPath.row].name
            
            return cell
        }
    }

