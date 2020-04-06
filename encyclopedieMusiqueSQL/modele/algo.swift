//
//  algo.swift
//  encyclopedieMusiqueSQL
//
//  Created by patrick lanneau on 06/04/2020.
//  Copyright © 2020 patrick lanneau. All rights reserved.
//

//import Foundation

/*
 struct ObjetJson: codable{
    var n : String
    var nom : String
    var lien  : String
    var dn : String
    var duree : String
    var titre : String
 }
 
 */

/*
 Algorithme
 
 (automate :    1-{2}-
                1-3-{4}
                
 
 LECTUREFICHIERJSON
 lire le fichier json
 on obtient un tableau d'ObjetJson
    var compositeurCourant, titreGeneral , nAttendu = [1]
 Pour chaque ObjetJson J
    lire n
    si !nAttendu.contain(n) -> Erreur
    selon n
        1:  si cc = compositeurCourant -> enregistrer(compositeurCourant)
            compositeurCourant = OBTENIRCOMPOSITEUR(J)
            titreGeneral = ""
            nAttendu = [1,2,3]
        2:  nAttendu = [1,2]
            newOeuvre = OBTENIROEUVRE(J)
            enregistrer(newOeuvre)
            compositeurCourant.lesOeuvres.append(newOeuvre)
        3:  nAttendu = [4]
            titreGeneral = J.nom
        4:  nAttendu = [1,4]
            newOeuvre = OBTENIROEUVRE(J)
            calculer titre (titreGeneral + J.nom)
            enregistrer(newOeuvre)
            compositeurCourant.lesOeuvres.append(newOeuvre)
            
 
 OBTENIRCOMPOSITEUR
 
 
 OBTENIROEUVRE
 
 OBTENIROEUVREMULTIPLE
 
 
 
 
 
 
 
 
 */
