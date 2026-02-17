//
//  Configuration.swift
//  SwiftUITemplate
//
//  Created by Baidetskyi Yurii on 23.05.2025.
//

import Foundation

final class Configuration {
    
    // MARK: - Properties
    private let config: NSDictionary
    
    // MARK: - Init methods
    init(dictionary: NSDictionary) {
        config = dictionary
    }
    
    convenience init() {
        let bundle = Bundle.main
        let configPath = bundle.path(forResource: "Configuration", ofType: "plist")!
        let config = NSDictionary(contentsOfFile: configPath)!
        
        let dict = NSMutableDictionary()
        if let configs = config[Bundle.main.infoDictionary?["Configuration"] ?? ""] as? [AnyHashable: Any] {
            dict.addEntries(from: configs)
        }
        
        self.init(dictionary: dict)
    }
}

extension Configuration {
    var environment: String {
        return config["environment"] as! String
    }
    
    var apiURL: String {
        return config["apiURL"] as! String
    }
}
