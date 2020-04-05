//
//  PlaylistViewController.swift
//  encyclopedieMusique
//
//  Created by patrick lanneau on 27/09/2017.
//  Copyright © 2017 patrick lanneau. All rights reserved.
//

import UIKit

class PlaylistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tablePlaylist: UITableView!
    
    @IBOutlet weak var boutonEdit: UIButton!
    var mesDonnees:GestionAuteurs?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tablePlaylist.delegate = self
        tablePlaylist.dataSource = self
        //tablePlaylist.setEditing(true, animated: true)
        // Bouton edit
        boutonEdit.isHighlighted = false
        tablePlaylist.isEditing = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editTable(_ sender: UIButton) {
        if tablePlaylist.isEditing {
            tablePlaylist.isEditing = !tablePlaylist.isEditing
            sender.isHighlighted = false
        } else {
            tablePlaylist.isEditing = !tablePlaylist.isEditing
            sender.isHighlighted = true
        }
        
    }
    
    // MARK gestion tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        //return 1
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return lesCompositeurs.count
        //return lesCompositeurs.count
        return mesDonnees!.playlist.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "playlistCell", for: indexPath)
        
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "playlistCell")
        }
        let aEcouter = mesDonnees?.playlist[indexPath.row]
        cell?.textLabel?.text = aEcouter?.titre
        cell?.detailTextLabel?.text = aEcouter?.complement
        
        return cell!
    }
    
    // Pouvoir détruire un élément
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            //tablePlaylist[indexPath.row]
            mesDonnees?.deleteFromPlaylist(oeuvre: (mesDonnees?.playlist[indexPath.row])!)
            tablePlaylist.reloadData()
        } else if editingStyle == .insert {
            
        }
        
    }
    // Edition
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var aMouvoir = mesDonnees?.playlist[sourceIndexPath.row]
        mesDonnees?.moveInPlaylist(fromIndex: sourceIndexPath.row, atIndex: destinationIndexPath.row)
        tablePlaylist.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "versYoutube"{
            let vc = segue.destination as! OeuvreViewController
            vc.uneOeuvre = mesDonnees?.playlist[(tablePlaylist.indexPathForSelectedRow?.row)!]
            vc.addPlaylistIsVisible = false
            vc.baseDonnees = mesDonnees
        }
    }

}
