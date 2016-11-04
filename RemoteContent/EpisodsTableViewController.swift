//
//  EpisodsTableViewController.swift
//  RemoteContent
//
//  Created by Ibrahim Kteish on 10/30/16.
//  Copyright © 2016 Ibrahim Kteish. All rights reserved.
//

import UIKit

class EpisodsTableViewController: UITableViewController {

    var episodes = [Episode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        Webservice().load(resource: Series.all) { [weak self] result in
            
            OperationQueue.main.addOperation({
                
                if let result = result {
                    self?.episodes = result.episodes
                    self?.tableView.reloadData()
                }
            })
        }
        
        let barButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(EpisodsTableViewController.simulate))
        
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func simulate() {
        
        let eps = Episode.seasonOneEpisodeFive
        
        let detail = DetailsCoordinator(loadingState: .network(eps))
        
        let remote = RemoteContentContainerViewController(coordinator: detail)
        
        self.navigationController?.pushViewController(remote, animated: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel?.text = episodes[indexPath.row].title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        self.performSegue(withIdentifier: "showDetails", sender: episodes[indexPath.row])
    
        let selected = episodes[indexPath.row]
        let detail = DetailsCoordinator(loadingState: .local(selected))        
        let remote = RemoteContentContainerViewController(coordinator: detail)
        self.navigationController?.pushViewController(remote, animated: true)
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "showDetails" {
            
            let detailsVC = segue.destination as! DetailsViewController
            detailsVC.selectedEpisode = sender as! Episode
        }
    }
 

}
