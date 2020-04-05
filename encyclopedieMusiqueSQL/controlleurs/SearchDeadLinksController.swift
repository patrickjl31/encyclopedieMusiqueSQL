//
//  SearchDeadLinksController.swift
//  encyclopedieMusiqueSQL
//
//  Created by patrick lanneau on 13/01/2020.
//  Copyright © 2020 patrick lanneau. All rights reserved.
//

import UIKit

class SearchDeadLinksController: UIViewController {

    @IBOutlet weak var exportBtn: UIButton!
    @IBOutlet weak var deadLinksLbl: UITextView!
    @IBOutlet weak var currentLbl: UILabel!
    
    var compositeurs:[Compositeur]?
    var urlTest: [String] = []
    
    var numCompositeur = 0
    var numOeuvreCourante = 0
    var bloc = 1
    var resultat = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        currentLbl.text = "\(compositeurs!.count) compositeurs : \(compositeurs![0].nom)"
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        numCompositeur = 0
        numOeuvreCourante = 0
        urlTest = []
        deadLinksLbl.text = ""
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        //numCompositeur = 0
        //numOeuvreCourante = 0
        //testUnitaire()
        genererUrlTest()
        numCompositeur += bloc
        
    }
    
    @IBAction func exportPressed(_ sender: Any) {
        if let resultat = deadLinksLbl.text , resultat != "" {
            let controlleur = UIActivityViewController(activityItems: [resultat], applicationActivities: nil)
            self.present(controlleur, animated: true, completion: nil)
        }
    }
    
    func  testUnitaire()  {
        guard let auteurs = compositeurs else {return}
        let nbCompositeurs = auteurs.count
        if nbCompositeurs > 0, numCompositeur < nbCompositeurs{
            let encours = auteurs[numCompositeur].nom! + " -> " + String(numOeuvreCourante)
            currentLbl.text = encours
            let oeuvres = auteurs[numCompositeur].lesOeuvres
            if numOeuvreCourante < oeuvres!.count {
                //let oeuvreChoisie = unAuteur.lesOeuvres
                let sesOeuvres = Array<Any>(oeuvres!)
                let oeuvreChoisie = sesOeuvres[numOeuvreCourante] as! Oeuvre
                if let url = oeuvreChoisie.lien {
                    existeSurYoutube(lien: url)
                    
                }
                //numOeuvreCourante += 1
                
            } else {
                numCompositeur += 1
                numOeuvreCourante = 0
            }
            //testUnitaire()
        }
    }
    
    func  existeSurYoutube(lien:String) {
        let urlAdr = lien.replacingOccurrences(of: "https://www.youtube.com/watch?v=", with: "https://img.youtube.com/vi/") + "/0.jpg"
        guard let url = URL(string: urlAdr) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let erreur = error{
                print(erreur.localizedDescription)
            }
            if let rep = response {
                let reponse = rep as! HTTPURLResponse
                let statusCode = reponse.statusCode
                if statusCode == 404 {
                    self.resultat += "-> \(lien)\n"
                    self.deadLinksLbl.text = self.resultat
                }
                self.numOeuvreCourante += 1
                self.testUnitaire()
            }
        }.resume()
    }
    
    func existeImage(lien:String) -> Bool {
        var existe = true
        guard let url = URL(string: lien) else {return false}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {return}
            if let erreur = error{
                print(erreur.localizedDescription)
            }
            if let rep = response {
                let reponse = rep as! HTTPURLResponse
                let statusCode = reponse.statusCode
                if statusCode == 404 {
                    self.resultat += "-> \(lien)\n"
                    self.deadLinksLbl.text = self.resultat
                    existe = false
                } else {
                    existe = true
                }
                self.numOeuvreCourante += 1
            }
        }.resume()
        
        return existe
    }
    
    func genererUrlTest(){
        //deadLinksLbl.text = ""
        if let musiciens = compositeurs {
            for i in 0..<bloc{
                let compositeur = musiciens[numCompositeur + i]
                let oeuvres = compositeur.lesOeuvres
                currentLbl.text = compositeur.nom
                let sesOeuvres = Array<Any>(oeuvres!)
                for oeuvre in sesOeuvres  {
                    let musique = oeuvre as! Oeuvre
                    let lien = musique.lien
                    let urlAdr = lien!.replacingOccurrences(of: "https://www.youtube.com/watch?v=", with: "https://img.youtube.com/vi/") + "/0.jpg"
                    if existeImage(lien: urlAdr){
                        urlTest.append(urlAdr)
                        //deadLinksLbl.text += urlAdr + "\n"
                    }
                    
                }
            }
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
