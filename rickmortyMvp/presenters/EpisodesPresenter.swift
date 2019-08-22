//
//  EpisodesPresenter.swift
//  rickmortyMvp
//
//  Created by Antonio Gabriel Marín on 22/08/2019.
//  Copyright © 2019 Antonio. All rights reserved.
//

import Foundation

protocol EpisodeViewDelegate: NSObjectProtocol {
    func displayEpisodes(episodeList: [Episode])
}

class EpisodePresenter {
    weak private var delegate: EpisodeViewDelegate?
    private var episodeService: EpisodesController
    
    init(episodeService: EpisodesController) {
        self.episodeService = episodeService
    }
    
    func setViewDelegate(delegate: EpisodeViewDelegate) {
        self.delegate = delegate
    }
    
    func loadCharacters() {
        episodeService.fetchMultipleEpisodes(queries: nil) { [weak self] (episode) in
            
            guard let strongSelf = self else { return }
            
            if let episode = episode {
                strongSelf.delegate?.displayEpisodes(episodeList: episode)
            }
        }
    }
}
