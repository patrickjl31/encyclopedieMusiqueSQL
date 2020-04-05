//
//  Alerte.swift
//  encyclopedieMusiqueSQL
//
//  Created by patrick lanneau on 09/11/2019.
//  Copyright © 2019 patrick lanneau. All rights reserved.
//

import UIKit
class Alerte {
    
    static let shared = Alerte()
    
    func erreur(message: String, controller: UIViewController) {
        messageSimple(titre: "Erreur", message: message, controller: controller)
    }
    
    
    func messageSimple(titre: String, message: String, controller: UIViewController) {
        let alerte = UIAlertController(title: titre, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alerte.addAction(ok)
        controller.present(alerte, animated: true, completion: nil)
    }
    func messageOuiOuNon(titre: String, message: String, controller: UIViewController)->Bool {
        let alerte = UIAlertController(title: titre, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: {action in return true})
        let cancel = UIAlertAction(title: "Annuler", style: .cancel, handler: {action in return true})
        alerte.addAction(ok)
        alerte.addAction(cancel)
        controller.present(alerte, animated: true, completion: nil)
        return false
    }
    
}
