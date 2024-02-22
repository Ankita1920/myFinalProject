//
//  CharacterViewController.swift
//  Ricky and Morty project
//
//  Created by Ankita Mondal on 30/01/24.
//

import UIKit
import AlamofireImage


class CharacterViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var mytable: UITableView!
    
    @IBOutlet weak var myCollection: UICollectionView!
    @IBOutlet weak var toggleButton: UIButton!
    
    
    var characterViewModel = CharacterViewModel()
    
    var isTableViewMode = true
    var isCollectionViewMode = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Character"
        
        showTitle()
        
        mytable.isHidden = false
        myCollection.isHidden = true
        
        
        characterViewModel.fetchCharacters { result in
            switch result {
            case .success:
                OperationQueue.main.addOperation{
                   
                    self.mytable.reloadData()
                  //  self.myCollection.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch characters: \(error)")
            }
        }
    }
    
    func showTitle(){
        
        if isCollectionViewMode {
            title = "Collection View"
        } else {
            title = "Table View"
        }
        
    }
    @IBAction func toggleButtonPressed(_ sender: UIButton) {
  
        showActionSheet()
        
        }
    
   
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if mytable.isHidden {
            actionSheet.addAction(UIAlertAction(title: "Do you want to change to Table View?", style: .default, handler: { [weak self] _ in
                self?.showChangeToTableViewAlert()
                
            }))
            
        }
        if myCollection.isHidden {
            actionSheet.addAction(UIAlertAction(title: "Do you want to change to CollectionView?", style: .default, handler: { [weak self] _ in
                self?.showChangeToCollectionViewAlert()
            }))
        }
                
        
       
        actionSheet.addAction(UIAlertAction(title: "Show Saved Data", style: .default, handler: { [weak self] _ in
                if let saveDataVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SaveDataViewController") as? SaveDataViewController {
                   
                    self?.navigationController?.pushViewController(saveDataVC, animated: true)
                }
            }))
            //  self?.showChangeToCollectionViewAle
        present(actionSheet, animated: true)
    }
    
    func showChangeToTableViewAlert() {
        let alertController = UIAlertController(
            title: "Change to Table View",
            message: "Do you want to change to Table View?",
            preferredStyle: .alert
        )
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            self?.switchToTableView()
          
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel) { _ in
            // Handle 'No' button action (e.g., do nothing)
        }
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        present(alertController, animated: true)
    }
    
    func showChangeToCollectionViewAlert() {
        let alertController = UIAlertController(
            title: "Change to Collection View",
            message: "Do you want to change to Collection View?",
            preferredStyle: .alert
        )
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            self?.switchToCollectionView()
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel) { _ in
            // Handle 'No' button action (e.g., do nothing)
        }
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        present(alertController, animated: true)
    }
    
    private func switchToTableView() {
        // Handle the logic to switch to a table view controller
        isTableViewMode = true
        isCollectionViewMode = false
        mytable.isHidden = false
        myCollection.isHidden = true
        showTitle()
        mytable.reloadData()
        
    }
    private func switchToCollectionView(){
        isCollectionViewMode = true
        isTableViewMode = false
        myCollection.isHidden = false
        mytable.isHidden = true
        
        showTitle()
        myCollection.reloadData()
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
                 
                tableView.deselectRow(at: indexPath, animated: true)
                let character = characterViewModel.characters[indexPath.row]
                vc.characterDetails = character
                self.navigationController?.pushViewController(vc, animated: true)
//                present(vc, animated: true)
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
                 //self.navigationController?.pushViewController(vc, animated: true)
                let character = characterViewModel.characters[indexPath.row]
                
                vc.characterDetails = character
       
                
                 self.navigationController?.pushViewController(vc, animated: true)
                collectionView.deselectItem(at: indexPath, animated: true)
               
            }
        }
        
    }
    

