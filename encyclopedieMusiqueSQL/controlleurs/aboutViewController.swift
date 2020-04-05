//
//  aboutViewController.swift
//  encyclopedieMusique
//
//  Created by patrick lanneau on 11/09/2017.
//  Copyright © 2017 patrick lanneau. All rights reserved.
//

import UIKit

class aboutViewController: UIViewController {

    var compositeurs : [Compositeur]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchDeadLinks", let musiciens = compositeurs {
            let vc = segue.destination as! SearchDeadLinksController
            vc.compositeurs = musiciens
        }
    }
    

}
