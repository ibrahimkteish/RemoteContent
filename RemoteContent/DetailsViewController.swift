//
//  DetailsViewController.swift
//  RemoteContent
//
//  Created by Ibrahim Kteish on 10/30/16.
//  Copyright © 2016 Ibrahim Kteish. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var episodeTitle: UILabel!
    @IBOutlet weak var imdbRating: UILabel!
    @IBOutlet weak var released: UILabel!
    @IBOutlet weak var episode: UILabel!
  
    var selectedEpisode: Episode!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.episodeTitle.text = "Title : " + selectedEpisode.title
        self.imdbRating.text   = "ImdbRating : " + selectedEpisode.imdbRating
        self.released.text     = "Release date : " + selectedEpisode.released
        self.episode.text      = "Episode : " + selectedEpisode.episode

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
