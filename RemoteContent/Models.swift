//
//  Models.swift
//  RemoteContent
//
//  Created by Ibrahim Kteish on 10/30/16.
//  Copyright © 2016 Ibrahim Kteish. All rights reserved.
//

import Foundation

let gameOfThronesURL = URL(string: "http://www.omdbapi.com/?t=Game%20of%20Thrones&Season=1")!

protocol initableFromJSON {
    
    init(fromJSON dictionary: JSON)
}

struct Episode {
    
    var episode : String!
    var released : String!
    var title : String!
    var imdbID : String!
    var imdbRating : String!
}

extension Episode: initableFromJSON {
    
    init(fromJSON dictionary: JSON) {
    
        episode = dictionary["Episode"] as? String
        released = dictionary["Released"] as? String
        title = dictionary["Title"] as? String
        imdbID = dictionary["imdbID"] as? String
        imdbRating = dictionary["imdbRating"] as? String
    }
}

struct Series {
    
    var episodes : [Episode]!
    var response : Bool!
    var season : String!
    var title : String!
    var totalSeasons : String!
}

extension Series: initableFromJSON {
    
    init(fromJSON dictionary: JSON) {
    
        episodes = [Episode]()
        if let episodesArray = dictionary["Episodes"] as? [JSON] {
            episodes = episodesArray.map { Episode.init(fromJSON: $0) }
        }
        response = dictionary["Response"] as? Bool
        season = dictionary["Season"] as? String
        title = dictionary["Title"] as? String
        totalSeasons = dictionary["totalSeasons"] as? String
    }
}


extension Series {
    static let all = Resource<Series>(url: gameOfThronesURL, parseJSON: { json in
        guard let dictionary = json as? JSON else { return nil }
        return Series(fromJSON : dictionary)
    })
}

