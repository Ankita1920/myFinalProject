//
//  CharacterViewController.swift
//  Ricky and Morty project
//
//  Created by Ankita Mondal on 30/01/24.
//

import UIKit
import AlamofireImage

class CharacterViewController: UIViewController {


    @IBOutlet weak var mytable: UITableView!
    
    @IBOutlet weak var myCollection: UICollectionView!
    @IBOutlet weak var toggleButton: UIButton!
    
    
    var characterViewModel = CharacterViewModel()
    
    var isTableViewMode = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Character"
       // mytable.isHidden = true
       //  myCollection.isHidden = false
       
      characterViewModel.fetchCharacters { result in
         switch result {
         case .success:
             OperationQueue.main.addOperation{
            //DispatchQueue.main.async {
                 self.mytable.reloadData()
                 self.myCollection.reloadData()
             }
         case .failure(let error):
             print("Failed to fetch characters: \(error)")
         }
         }
     }
    
    
    
    
  
    
    @IBAction func toggleButtonPressed(_ sender: UIButton) {
       // toggleButton.isUserInteractionEnabled = true
        
        isTableViewMode.toggle()

  
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
        
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! myTableViewCell
       
        guard indexPath.row < characterViewModel.characters.count else {
            return cell
            
        }
        let character = characterViewModel.characters[indexPath.row]
        cell.CharacterName.text = character.name
        cell.CharacterStatus.text = character.status
        
        if let url = URL(string: character.image) {
            cell.characterImage.af.setImage(withURL:url)
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
          self.navigationController?.pushViewController(vc, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
            
            let character = characterViewModel.characters[indexPath.row]
            vc.characterDetails = character
       // self.navigationController?.pushViewController(vc, animated: true)
           
//            vc.DetailImage.image = UIImage(named: character.image)
//            
           //present(vc, animated: true)
            }
            
        }
    }

    
    
    
extension CharacterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characterViewModel.characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! myCollectionViewCell
        
        
        let character = characterViewModel.characters[indexPath.row]
           cell.characterName2.text = character.name
        cell.characterStatus.text = character.status
//        cell.collectionImage.layer.cornerRadius = 8
//        cell.collectionImage.layer.masksToBounds = true
//        
        if let url = URL(string: character.image) {
                  cell.collectionImage.af.setImage(withURL: url)
              }

        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
           // self.navigationController?.pushViewController(vc, animated: true)
            let character = characterViewModel.characters[indexPath.row]
          
            vc.characterDetails = character
        self.navigationController?.pushViewController(vc, animated: true)
            collectionView.deselectItem(at: indexPath, animated: true)
            
           // present(vc, animated: true)
        }
    }

}
