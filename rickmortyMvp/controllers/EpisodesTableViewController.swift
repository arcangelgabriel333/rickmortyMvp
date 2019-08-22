//
//  EpisodesTableViewController.swift
//  rickmorty
//
//  Created by Usuario on 14/08/2019.
//  Copyright © 2019 Antonio. All rights reserved.
//

import UIKit
import FirebaseAuth

class EpisodesTableViewController: UITableViewController {
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        return activityIndicator
    }()
    
    //version MVC
    var episodeController = EpisodesController()
    //var presenter: EpisodePresenter = EpisodePresenter(episodeService: EpisodesController())
    var episodeArray: [Episode] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //presenter.setViewDelegate(delegate: self)
        
        tableView.backgroundView = activityIndicator
        self.activityIndicator.startAnimating()
        episodeController.fetchMultipleEpisodes { (episodeArray) in
            if let episodeArray = episodeArray {
                
                
                DispatchQueue.main.async {
                    
                    self.episodeArray = episodeArray
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        //presenter.loadCharacters()
    }

    @IBAction func logOutButtonTapped(_ sender: UIBarButtonItem) {
        try? Auth.auth().signOut()
            
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let window = appDelegate.window
        window?.rootViewController = UIStoryboard(name: "LoginPage", bundle: nil).instantiateViewController(withIdentifier: "loginMainController")
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return episodeArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath) as! EpisodeViewCell

        let episodeInfo = episodeArray[indexPath.row]
        cell.configureEpisode(for: episodeInfo)

        return cell
    }
}
