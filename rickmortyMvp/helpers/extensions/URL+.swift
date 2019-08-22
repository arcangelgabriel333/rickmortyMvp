//
//  URL+.swift
//  rickmorty
//
//  Created by Usuario on 14/08/2019.
//  Copyright © 2019 Antonio. All rights reserved.
//

import Foundation

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.compactMap({URLQueryItem(name: $0.key, value: $0.value)})
        
        return components?.url
    }
}

//*.local, 169.254/16, 10.*, *.redsys.*, *.chipcard-salud.es, *.sermepa.*, *.sistema_4b.*, *.iupay.es, *.iupay.com, 10.*, 172.16.*, 192.168*, 10.0.0.*, 10.253.*, 10.239.3.*, 195.79.9.*, 10.249.6.*, 10.239.9*, 10.*
