//
//  CharactersTableViewController.swift
//  rickmorty
//
//  Created by Usuario on 14/08/2019.
//  Copyright © 2019 Antonio. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class CharactersTableViewController: UITableViewController {
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        return activityIndicator
    }()
    var userLoginName = Auth.auth().currentUser?.email!
    //let usersRef = Database.database().reference(withPath: "online")
    
    var presenter: CharacterPresenter = CharacterPresenter(characterService: CharactersController())
    var characterPagedData: PagedInfo<Character>?
    var charactersArray: [Character] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.setViewDelegate(delegate: self)
        
        //antes de nada se establece la conexion con la database de firebase; ref es como la referencia al directorio raiz de la database
        let ref = Database.database().reference()
        
        tableView.backgroundView = activityIndicator
        
        let alert = UIAlertController(title: "Login correcto", message: "Bienvenido: \(userLoginName!)", preferredStyle: .alert)
        
        let comfirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
            //aqui se crea el usuario en la database; usersRef es un hijo de la raiz y userRef es una instancia dentro del conjunto de users
            ref.setValue("HOLA")
            let usersRef = ref.child("users")
            let usersOnline = ref.child("online-now")

            let userOnline = usersOnline.child(Auth.auth().currentUser!.uid)
            userOnline.setValue(["name": self.userLoginName!, "password": "PRUEBA"])

            let userRef = usersRef.child(Auth.auth().currentUser!.uid)
            userRef.setValue(["name": self.userLoginName!, "password": "PRUEBA"])
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(comfirmAction)
        self.present(alert, animated: true, completion: nil)

        presenter.loadCharacters()
        //fecthCurrentCharacters()
    }
    
    //version para arquitectura MVC
   /* func fecthCurrentCharacters() {
        self.activityIndicator.startAnimating()
        
        characterController.fetchMultipleCharacters(url: characterPagedData?.meta.next) { (characterPagedData) in
            
            self.characterPagedData = characterPagedData
            if let characterArray = characterPagedData?.results {
                
                for character in characterArray {
                    if !self.charactersArray.contains(character) {
                        self.charactersArray.append(character)
                    }
                }
                
                //self.charactersArray = characterPagedData?.results ?? []
                
                DispatchQueue.main.async {
                    
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    func nextPage() {
        fecthCurrentCharacters()
    }*/
    
    @IBAction func logOutTapped(_ sender: UIBarButtonItem) {
        try? Auth.auth().signOut()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let window = appDelegate.window
        window?.rootViewController = UIStoryboard(name: "LoginPage", bundle: nil).instantiateViewController(withIdentifier: "loginMainController")
        window?.makeKeyAndVisible()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return charactersArray.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (charactersArray.count - 1) {
            //nextPage()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as! CharacterViewCell

        let characterInfo = charactersArray[indexPath.row]
        cell.configure(for: characterInfo)

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seeCharacter" {
            let destination = segue.destination as! CharacterDetailTableViewController
            
            if let selectedIndex = tableView.indexPathForSelectedRow {
                destination.characterDetail = charactersArray[selectedIndex.row]
            }
        }
    }

}

extension CharactersTableViewController: CharacterViewDelegate {
    func displayCharacters(characterList: [Character]) {
        self.charactersArray = characterList
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
}
