//
//  GestionAuteurs.swift
//  encyclopedieMusique
//
//  Created by patrick lanneau on 26/08/2017.
//  Copyright © 2017 patrick lanneau. All rights reserved.
//

import UIKit

import  CoreData

class GestionAuteurs: NSObject {
    var lesCompositeurs:[Compositeur] = []
    
    
    var compositeursAlpha = [String: [Compositeur]]()
    //la liste des noms de sections alphabet
    var alphabet:[String]?
    
    // Par année de naissance
    var compositeursNaissance = [String: [Compositeur]]()
    //la liste des noms de sections dates de naissances
    //var anneesNaissance:[String]?
    var anneesNaissance = ["-1200", "1200-1250","1250-1300","1300-1350","1350-1400", "1400-1450","1450-1500","1500-1550","1550-1600","1600-1650","1650-1700", "1700-1750","1750-1800","1800-1850","1850-1900","1900-1950","1950-2000","2000-2050"," - "]
    
    // Par nationalités
    var compositeursNations = [String: [Compositeur]]()
    //var nationalites: [String]?
    var nationalites = ["AT","BE","CH","CY","DE","ES","FR","GR","IE","IT","MT","NL","PT","UK","AFR","AM-LAT","AM-NORD","ASIE-PAC","BALK","EUR-NORD","EUR-EST","EX-URSS","MOY-OR","?"]

    // La playlist ;-)
    var playlist:[Oeuvre] = []
    
    //Gestion core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override init() {
        super.init()
        //On vérifie si on a déjà chargé la ressource dans la base
        let requete:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Compositeur")
        do {
            lesCompositeurs = try context.fetch(requete) as! [Compositeur]
        } catch {
            print("erreur")
        }
        if lesCompositeurs.count == 0 {
            // On récupère les données
            print("Pas encore de compositeurs, on lit à partir du fichier")
            lectureFichierCompositeurs(nomfic: "baseOeuvre6")
        }
        
        // Tri par noms
        triParNoms()
        //print("les compositeurs : \(compositeursAlpha)")
        // Tri par années de naissance
        triParAnneeNaissance()
        
        //On trie par nationalités
        triParNationalite()
        
    }
    
    
    // Tri par noms et initialisations
    
    func triParNoms()   {
        //Init compositeur alpha
        let alpha = "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
        alphabet = alpha.components(separatedBy: " ")
        for lettre in alphabet! {
            compositeursAlpha.updateValue([], forKey: lettre)
        }
        for compositeur in lesCompositeurs{
            let initiale = compositeur.nom!.first
            let initialeS = String(initiale!)
            //print("compositeurs : \(compositeur.nom)")
            if alpha.contains(initialeS) {
                var compositeursPourInitiale = compositeursAlpha[initialeS]
                compositeursPourInitiale?.append(compositeur)
                compositeursAlpha.updateValue(compositeursPourInitiale!, forKey: initialeS)
                //print("fait : \(compositeursAlpha[initialeS]?.last?.nom)")
            }
            
        }
    }
    
    // Création du tri par année de naissance
    func triParAnneeNaissance() {
        //anneesNaissance = ["-1200", "1200-1250","1250-1300","1300-1350","1350-1400", "1400-1450","1450-1500","1500-1550","1550-1600","1600-1650","1650-1700", "1700-1750","1750-1800","1800-1850","1850-1900","1900-1950","1950-2000","2000-2050"," - "]
        for annee in anneesNaissance {
            compositeursNaissance.updateValue([], forKey: annee)
        }
        
        for unCompositeur in lesCompositeurs {
            let neEn = unCompositeur.dateNaissance
            for fourchette in anneesNaissance {
                if verificationAnnee(averifier: neEn!, DansFourchette: fourchette){
                    var maListe = compositeursNaissance[fourchette]
                    maListe?.append(unCompositeur)
                    compositeursNaissance.updateValue(maListe!, forKey: fourchette)
                }
            }
        }
    }
    
    func verificationAnnee(averifier: String, DansFourchette: String ) -> Bool {
        var valAnnee = 0
        var deb = 0
        var fin = 0
        if let v = Int(averifier) {
            valAnnee = v
        }
        let bornes = DansFourchette.components(separatedBy: "-")
        if let v = Int(bornes[0]) {
            deb = v
        }
        if let v = Int(bornes[1]) {
            fin = v
        }
        // on teste
        if valAnnee == 0 {
            return (deb == 0) && (fin == 0)
        }
        if (valAnnee > deb) && (valAnnee <= fin){
            return true
        }
        
        return false
    }
    
    // Tri par nationalités
    func triParNationalite() {
        //nationalites = ["AT","BE","CH","CY","DE","ES","FR","GR","IE","IT","MT","NL","PT","UK","AFR","AM-LAT","AM-NORD","ASIE-PAC","BALK","EUR-NORD","EUR-EST","EX-URSS","MOY-OR","?"]
        
        for groupePays in nationalites {
            compositeursNations.updateValue([], forKey: groupePays)
        }
        // On dispache les compositeurs dans leur groupe nation
        for unCompositeur in lesCompositeurs {
            let sonPays = unCompositeur.nationalite
            let clefNation = chercherClef(nation: sonPays!)
            var maListe = compositeursNations[clefNation]
            maListe?.append(unCompositeur)
            compositeursNations.updateValue(maListe!, forKey: clefNation)
        }
    }
    
    func chercherClef(nation:String) -> String {
        let nationaliteStrictes = ["DE","AT","BE","CY","ES","FR","UK","GR","IE","IT","MT","NL","PT","CH","AFR","AM-LAT","ASIE-PAC","EX-URSS","BALK","AM-NORD","MOY-OR","EUR-NORD","EUR-EST"]
        let groupesNations = ["DE":["ALLEMAGNE"],"AT":["AUTRICHE"],"BE":["BELGIQUE","FLANDRE"],"CY":["CHYPRE"],"ES":["ESPAGNE"],"FR":["FRANCE","MONACO"],"UK":["GRANDE-BRETAGNE","ECOSSE"],"GR":["GRECE"],"IE":["IRLANDE"],"IT":["ITALIE"],"MT":["MALTE"],"NL":["PAYS-BAS"],"PT":["PORTUGAL"],"CH":["SUISSE"], "AFR":["AFRIQUE DU SUD","MAROC","TUNISIE"], "AM-LAT":["ARGENTINE","BOLIVIE","BRESIL","CHILI","COLOMBIE","CUBA","GUATEMALA","MEXIQUE","PARAGUAY","PEROU","PORTO-RICO","URUGUAY","VENEZUELA"], "ASIE-PAC":["AUSTRALIE","CHINE","COREE","JAPON","NOUVELLE-ZELANDE","PHILIPPINES","TAIWAN","VIETNAM"], "EX-URSS":["ARMENIE","AZERBAIDJAN","BIELORUSSIE","ESTONIE","GEORGIE","KAZAKHSTAN","LETTONIE","LITHUANIE","MOLDAVIE","OUZBEKISTAN","RUSSIE","TURKMENISTAN","UKRAINE","MONGOLIE"], "BALK":["BOHEME","BOSNIE","BULGARIE","CROATIE","ROUMANIE"],"AM-NORD":["ETATS-UNIS","CANADA"], "MOY-OR":["IRAN","ISRAEL","LIBAN","SYRIE","TURQUIE"], "EUR-NORD":["DANEMARK","FINLANDE","ISLANDE","NORVEGE","SUEDE"], "EUR-EST":["HONGRIE","MORAVIE","POLOGNE","REP.TCHEQUE","SERBIE","SLOVAQUIE","SLOVENIE"]]
        for laclef in nationaliteStrictes {
            if (groupesNations[laclef]?.contains(nation))!{
                return laclef
            }
        }
        
        return "?"
    }
    
    //MARK Gestion des playlist
    func addToPlaylist(oeuvre:Oeuvre) {
        if !playlist.contains(oeuvre){
            playlist.append(oeuvre)
        }
        savePlaylist()
        //print("\(playlist.count)")
    }
    
    func deleteFromPlaylist(oeuvre:Oeuvre) {
        if let index = playlist.firstIndex(of: oeuvre) {
            //on delete
            playlist.remove(at: index)
        }
        savePlaylist()
    }
    func moveInPlaylist(fromIndex:Int, atIndex:Int)  {
        let objet = playlist[fromIndex]
        playlist.remove(at: fromIndex)
        playlist.insert(objet, at: atIndex)
        savePlaylist()
    }
    
    func savePlaylist()  {
        var laListe:[Int64] = []
        for obj in playlist{
            laListe.append(obj.id)
        }
        let userDefaults = UserDefaults.standard
        //UserDefaults.set(laListe, value(forKey: "playlistSaved"))
        //userDefaults.array(forKey: "playlistSaved")
        userDefaults.register(defaults: ["playlistSaved" : laListe])
        //userDefaults.register(defaults: ["playlistSaved" : playlist])
        // On teste
        //print("\(recallPlaylist())")
    }
     /*
    func recallPlaylist() {
        let userDefaults = UserDefaults.standard
        playlist = userDefaults.array(forKey: "playlistSaved") as! [Oeuvre]
    }
     */
    func recallPlaylist() -> [Int] {
        let userDefaults = UserDefaults.standard
        if let maPlaylist = userDefaults.array(forKey: "playlistSaved") {
            return maPlaylist as! [Int]
        } else {
            return []
        }
    }
  
    
    
    //MARK Lecture du fichier JSON
    func lectureFichierCompositeurs(nomfic:String)   {
        
        if let path = Bundle.main.path(forResource: nomfic, ofType: "json"){
         
            if let data = NSData(contentsOfFile: path){
                //print("\(data)")
                
                do {
                    let objet = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments)
                    // titreGeneral stocke le nom d'une oeuvre présentée en plusieurs morceaux
                    var titreGeneral = ""
                    var compositeurCourant:Compositeur? // = Compositeur()
                    
                    // On initialise le compteur du numéro d'identification
                    var identification = 0
                    if let dictionnaire = objet as? [[String: AnyObject]]{
                        //print("\(dictionnaire.count) \n \n \(dictionnaire)")
                        for fiche in dictionnaire {
                            let num:String = fiche["n"] as! String
                            if num == "1"{
                               
                                let unCompositeur = Compositeur(context: context)
                                unCompositeur.nom = fiche["nom"] as? String
                                unCompositeur.nationalite = (fiche["titre"] as! String)
                                unCompositeur.dateNaissance = (fiche["dn"] as! String)
                                unCompositeur.dateMort = (fiche["duree"] as! String)
                                unCompositeur.wiki = (fiche["lien"] as! String)
                                titreGeneral = ""
                                compositeurCourant = unCompositeur
                                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                            } else {
                                // si c'est 3, on mémorise le titre "titreGeneral"
                                if num == "3" {
                                    titreGeneral = fiche["nom"] as! String
                                } else {
                                    // Si c'est 2, on ajoute,
                                    let uneOeuvre:Oeuvre = Oeuvre(context: context)
                                    //let uneOeuvre:Oeuvre = NSEntityDescription.insertNewObject(forEntityName: "Oeuvre", into: context)
                                    //uneOeuvre.titre = fiche["nom"] as! String
                                    var unTitre = fiche["nom"] as! String
                                     // Si c'est 4, on ajoute titreGeneral au titre et on ajoute
                                    if num == "4" {
                                        //uneOeuvre.titre = titreGeneral + " -> " + uneOeuvre.titre
                                        unTitre = titreGeneral + " -> " + unTitre
                                    }
                                    uneOeuvre.titre = unTitre
                                    
                                    uneOeuvre.complement = (fiche["titre"] as! String)
                                    uneOeuvre.duree = (fiche["duree"] as! String)
                                    uneOeuvre.lien = (fiche["lien"] as! String)
                                    uneOeuvre.dateComposition = (fiche["dn"] as! String)
                                    // Identification
                                    identification += 1
                                    //uneOeuvre.setValue(identification, forKey: "id")
                                    uneOeuvre.id = Int64(identification)
                                    uneOeuvre.auteur = compositeurCourant
                                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                                    //lesCompositeurs.last?.sesOeuvre.append(uneOeuvre)
                                    compositeurCourant?.lesOeuvres?.adding(uneOeuvre)
                                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                                }
                                
                            }
                            //print("oeuvres :\(compositeurCourant.lesOeuvres?.count)")
                        }
                        // On récupère le tableau des compositeurs
                        getCompositeurs()
                        //print("compositeurs récupérés : \(lesCompositeurs.count)")
                    }
                } catch {
                    print("erreur")
                }
            }
        }
 
    }
    
    func getCompositeurs() {
        do {
            lesCompositeurs = try context.fetch(Compositeur.fetchRequest())
        } catch{
            print( "Erreur")
        }
    }
    
    func initialisationNomFichiers(nomFichier:String) -> Any {
        //var monfic = ""
        let url = NSURL(string: "http://www.lanneau.org/patrick/serviceapplication/baseOeuvre.json")
        //let requete = NSURLRequest(url:url as! URL)
        do{
            let data = try NSString(contentsOf: url! as URL, encoding: String.Encoding.utf8.rawValue)
            //monfic = data as String
            //monfic = try JSONSerialization.jsonObject(with: data as! Data, options: .allowFragments)
            return data
        } catch {
            if let path = Bundle.main.path(forResource: nomFichier, ofType: "json")
            {
                if let data = NSData(contentsOfFile: path) {
                    return data
                }
                
            }
             return ""
            
        }
        
        
    }
    
    
    
}
