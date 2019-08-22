//
//  CharacterPresenter.swift
//  rickmortyMvp
//
//  Created by Antonio Gabriel Marín on 22/08/2019.
//  Copyright © 2019 Antonio. All rights reserved.
//

/*
SOLO SE HA MODIFICADO LA VISTA/CONTROLADOR DE CHARACTERS PARA CAMBIAR DE MVC A MVP
*/

import Foundation

protocol CharacterViewDelegate: NSObjectProtocol {
    func displayCharacters(characterList: [Character])
}

class CharacterPresenter {
    weak private var delegate: CharacterViewDelegate?
    private var characterService: CharactersController
    
    init(characterService: CharactersController) {
        self.characterService = characterService
    }
    
    func setViewDelegate(delegate: CharacterViewDelegate) {
        self.delegate = delegate
    }
    
    func loadCharacters() {
        characterService.fetchMultipleCharacters(url: nil, queries: nil) { [weak self] (pagedInfo) in
            
            guard let strongSelf = self else { return }
            
            if let pagedInfo = pagedInfo {
                strongSelf.delegate?.displayCharacters(characterList: pagedInfo.results)
            }
        }
    }
}
