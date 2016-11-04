//
//  Helpers.swift
//  RemoteContent
//
//  Created by Ibrahim Kteish on 10/30/16.
//  Copyright © 2016 Ibrahim Kteish. All rights reserved.
//

import UIKit


enum Result<T, E> {
    case success(T)
    case error(E)
}

enum LoadingState<T> {
    case local(T)
    case network(Resource<T>)
}

typealias Error = NSError

protocol RemoteContentCoordinator {
    
    associatedtype Content
    
    var loadingState : LoadingState<Content> { get }
    func fetchContent(completion: @escaping ( Result<Content , Error>) -> Void)
    func viewControlerForContent(result : Result<Content , Error>) -> UIViewController
}

class RemoteContentContainerViewController<T: RemoteContentCoordinator>: UIViewController {
    
    let coordinator : T
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    var childNavigationItemSetup : ((UINavigationItem) -> ())?
    
    init(coordinator : T) {
        
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        if case .network(_) = coordinator.loadingState {
            
            activityIndicator.center = self.view.center
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            activityIndicator.hidesWhenStopped = false
        }
        
        self.getData()
        
    }
    
    func  getData()  {
        
        coordinator.fetchContent { [weak self] (result) in
            
            
            if let _self = self {
                
                if case .error(_) = result {
                    return
                }
                
                if case .network(_) = _self.coordinator.loadingState {
                    
                    self?.activityIndicator.stopAnimating()
                }
                
                let viewController = _self.coordinator.viewControlerForContent(result: result)
                
                _self.IKAddChildViewController(child: viewController)
                
                guard let navItem = self?.navigationItem else { return }
                
                _self.childNavigationItemSetup?(navItem)
                
            }
        }
    }
}


struct DetailsCoordinator : RemoteContentCoordinator {

    let loadingState : LoadingState<Episode>
    
    func fetchContent(completion: @escaping (Result<Episode, Error>) -> Void) {
        
        switch loadingState {
            
        case  .local( let episode):
            completion( .success(episode) )
            
        case .network(let resource):
            
            Webservice().load(resource: resource) { episode in
                
                OperationQueue.main.addOperation {
                    
                    completion( .success(episode!) )
                }
            }
        }
    }
    
    func viewControlerForContent(result: Result<Episode, Error>) -> UIViewController {
        
        switch result {
            
        case .success(let episode):
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let controller =  sb.instantiateViewController(withIdentifier: "Details") as! DetailsViewController
            controller.selectedEpisode = episode
            return controller
        case .error(_): return UIViewController() // example
            
        }
    }
}




//MARK: UIViewController
extension UIViewController {
    
    func IKAddChildViewController(child:UIViewController) {
        
        child.willMove(toParentViewController: self)
        addChildViewController(child)
        child.beginAppearanceTransition(true, animated: true)
        view.addSubview(child.view)
        child.endAppearanceTransition()
        child.view.translatesAutoresizingMaskIntoConstraints = false
        let viewsDictionary : [String : UIView] = ["child":child.view]
        
        let child_constraint_H:Array = NSLayoutConstraint.constraints(withVisualFormat: "H:|[child]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        let child_constraint_V:Array = NSLayoutConstraint.constraints(withVisualFormat: "V:|[child]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        
        view.addConstraints(child_constraint_H)
        view.addConstraints(child_constraint_V)
        
        child.didMove(toParentViewController: self)
        
    }
    
    func IKRemoveChildViewController(child:UIViewController) {
        
        child.willMove(toParentViewController: nil)
        child.beginAppearanceTransition(false, animated: true)
        child.view.removeFromSuperview()
        child.endAppearanceTransition()
        child.removeFromParentViewController()
        child.didMove(toParentViewController: nil)
    }
}
