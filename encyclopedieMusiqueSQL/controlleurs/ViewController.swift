//
//  ViewController.swift
//  encyclopedieMusiqueSQL
//
//  Created by patrick lanneau on 02/10/2017.
//  Copyright © 2017 patrick lanneau. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //var lesCompositeurs:[Compositeur] = []
    
    var mesDonnees:GestionAuteurs = GestionAuteurs()
    
    @IBOutlet weak var lbl_titre: UILabel!
    @IBOutlet weak var tableCompositeurs: UITableView!
    
    @IBOutlet weak var btnChangeAffichage: UISegmentedControl!
    
    // Pour la gestion des données en table
    var identSectionsCourant:[String] = []
    var tableAuteursCourante = [String: [Compositeur]]()
    
    var selectedCell = -1


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // La table des compositeurs
        tableCompositeurs.delegate = self
        tableCompositeurs.dataSource = self
        
        //image de fond de la table
        tableCompositeurs.backgroundView = UIImageView(image: UIImage(named: "livre-part1.jpg"))
        
        identSectionsCourant = mesDonnees.alphabet!
        tableAuteursCourante = mesDonnees.compositeursAlpha
        tableCompositeurs.reloadData()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        // Si on revient de la playlist
        if btnChangeAffichage.selectedSegmentIndex == 3 {
            // on initialise l'affichage à alphabétique
            btnChangeAffichage.selectedSegmentIndex = 0
            identSectionsCourant = mesDonnees.alphabet!
            tableAuteursCourante = mesDonnees.compositeursAlpha
            tableCompositeurs.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func choixTri(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            // Alpha
            identSectionsCourant = mesDonnees.alphabet!
            tableAuteursCourante = mesDonnees.compositeursAlpha
            tableCompositeurs.reloadData()
        case 1:
            // naissance
            identSectionsCourant = mesDonnees.anneesNaissance
            tableAuteursCourante = mesDonnees.compositeursNaissance
            tableCompositeurs.reloadData()
        case 2:
            // Nation
            identSectionsCourant = mesDonnees.nationalites
            tableAuteursCourante = mesDonnees.compositeursNations
            tableCompositeurs.reloadData()
        case 3:
            // Playlist
            if mesDonnees.playlist.count > 0 {
                performSegue(withIdentifier: "versPlaylist", sender: self)
                /*
                 DispatchQueue.main.async(){
                 self.performSegue(withIdentifier: "versPlaylist", sender: nil)
                 }*/
            } else {
                sender.selectedSegmentIndex = 0
                // Alpha
                identSectionsCourant = mesDonnees.alphabet!
                tableAuteursCourante = mesDonnees.compositeursAlpha
                tableCompositeurs.reloadData()
            }
            
            break
        default:
            break
        }
    }
    
    // MARK segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "voir_compositeur" {
            let vc = segue.destination as! CompositeurViewController
            let clef = identSectionsCourant[ (tableCompositeurs.indexPathForSelectedRow?.section)!]
            if clef != "" {
                //vc.unAuteur = lesCompositeurs[(tableCompositeurs.indexPathForSelectedRow?.row)!]
                vc.unAuteur = (tableAuteursCourante[clef]?[(tableCompositeurs.indexPathForSelectedRow?.row)!])!
                vc.baseDonnees = mesDonnees
            }
        }
        if segue.identifier == "versPlaylist"{
            let vc = segue.destination as! PlaylistViewController
            vc.mesDonnees = mesDonnees
            
        }
        if segue.identifier == "voir_about"{
            // Rien à faire
            let vc = segue.destination as! aboutViewController
            vc.compositeurs = mesDonnees.lesCompositeurs
        }
        
    }
    
    // MARK gestion tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        //return 1
        return identSectionsCourant.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return lesCompositeurs.count
        //return lesCompositeurs.count
        return (tableAuteursCourante[identSectionsCourant[section]]?.count)!
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return identSectionsCourant
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return identSectionsCourant[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "cell_compositeur", for: indexPath)
        
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell_compositeur")
        }
        // avec des cellules transparentes
        cell?.backgroundColor = UIColor.clear
        
        let clef = identSectionsCourant[ indexPath.section]
        let compositeur = tableAuteursCourante[clef]?[indexPath.row]
        cell?.textLabel?.text = compositeur?.nom//"Compositeur \(indexPath.row)"
        //print("Compositeur \(indexPath.row)")
        var mort = compositeur!.dateMort
        if mort != "" {
            mort = NSLocalizedString(", died in ", comment: ", mort en ") + mort!//", mort en " + mort
        }
        cell?.detailTextLabel?.text = "\(String(describing: compositeur!.nationalite)), " + NSLocalizedString("Born in ", comment: "Né en") + "\(String(describing: compositeur!.dateNaissance))\(String(describing: mort))"
        return cell!
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //NSLog("You selected cell number: \(indexPath.row)!")
        //let fromSection = indexPath.section
        //let fromRow = indexPath.row
        selectedCell = indexPath.row
        //self.performSegueWithIdentifier("yourIdentifier", sender: self)
    }
    
    // La ligne d'index est plus haute !
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    // Image de fond sur les lignes de section
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = .boldSystemFont(ofSize: 40)
        let headerImage = UIImage(named: "lully-l1.png")
        let headerImageView = UIImageView(image: headerImage)
        header.backgroundView = headerImageView
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

