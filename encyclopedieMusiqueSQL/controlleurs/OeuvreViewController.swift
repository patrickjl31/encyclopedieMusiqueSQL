//
//  OeuvreViewController.swift
//  encyclopedieMusique
//
//  Created by patrick lanneau on 25/08/2017.
//  Copyright © 2017 patrick lanneau. All rights reserved.
//

import UIKit

import  MessageUI

class OeuvreViewController: UIViewController, UIWebViewDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var lbl_titre: UILabel!
    
    @IBOutlet weak var boiteMessage: UILabel!
    @IBOutlet weak var webYoutube: UIWebView!
    @IBOutlet weak var btnAddToPlaylist: UIButton!
    
    var baseDonnees:GestionAuteurs?
    var uneOeuvre:Oeuvre?
    var addPlaylistIsVisible = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lbl_titre.text = uneOeuvre?.titre
        boiteMessage.isHidden = true
        if !addPlaylistIsVisible {
            btnAddToPlaylist.isHidden = false
        }
        
        
        // On vérifie l'accès au réseau
//        if Reachability.isConnectedToNetwork() {
//            if (uneOeuvre!.lien?.contains("http"))!{
//                //let url = NSURL(string: (unAuteur.wiki))
//                //let requete = NSURLRequest(url:url as! URL)
//                if let url = NSURL(string: (uneOeuvre?.lien)!){
//                    let requete = NSURLRequest(url:url as URL)
//                    webYoutube.loadRequest(requete as URLRequest)
//                } else {
//                    // Pase de page wikipedia
//                    let t1 = NSLocalizedString("Sorry", comment: "Désolé")// "Sorry"
//                    let t2 = NSLocalizedString("No access to Youtube page", comment: "Désolé")//"No access to Youtube page"
//                    boiteMessage.text = t1 + "\n" + t2
//                    boiteMessage.isHidden = false
//                    sendMessageToEditor(titre: "EncyclopédieMusique, page wikipedia non trouvée", content: String(describing: uneOeuvre))
//                }
//            } else{
//                // Pase de page wikipedia
//                let t1 = NSLocalizedString("Sorry", comment: "Désolé")//
//                let t2 = NSLocalizedString("No Youtube page", comment: "Désolé")//"No Youtube page"
//                boiteMessage.text = t1 + "\n" + t2
//                boiteMessage.isHidden = false
//                sendMessageToEditor(titre: "EncyclopédieMusique, page youtube non trouvée", content: String(describing: uneOeuvre))
//            }
//        } else {
//            // Pas d'accès réseau, on avertit...
//            // Message d'avertissement
//            let t1 = NSLocalizedString("Sorry", comment: "Désolé")//
//            let t2 = NSLocalizedString("No access to Web", comment: "Désolé")//"No access to Web"
//            boiteMessage.text = t1 + "\n" + t2
//            boiteMessage.isHidden = false
//        }
//
//        if (uneOeuvre!.lien?.contains("http"))!{
//            let url = NSURL(string: (uneOeuvre?.lien)!)
//            let requete = NSURLRequest(url:url! as URL)
//            webYoutube.loadRequest(requete as URLRequest)
//        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUp()
    }
    
    func setUp()  {
         // On vérifie l'accès au réseau
       if Reachability.isConnectedToNetwork() {
           if (uneOeuvre!.lien?.contains("http"))!{
               //let url = NSURL(string: (unAuteur.wiki))
               //let requete = NSURLRequest(url:url as! URL)
               if let url = NSURL(string: (uneOeuvre?.lien)!){
                   let requete = NSURLRequest(url:url as URL)
                   webYoutube.loadRequest(requete as URLRequest)
               } else {
                   // Pase de page wikipedia
                   let t1 = NSLocalizedString("Sorry", comment: "Désolé")// "Sorry"
                   let t2 = NSLocalizedString("No access to Youtube page", comment: "Désolé")//"No access to Youtube page"
                   boiteMessage.text = t1 + "\n" + t2
                   boiteMessage.isHidden = false
                   sendMessageToEditor(titre: "EncyclopédieMusique, page wikipedia non trouvée", content: String(describing: uneOeuvre))
               }
           } else{
               // Pase de page wikipedia
               let t1 = NSLocalizedString("Sorry", comment: "Désolé")//
               let t2 = NSLocalizedString("No Youtube page", comment: "Désolé")//"No Youtube page"
               boiteMessage.text = t1 + "\n" + t2
               boiteMessage.isHidden = false
               sendMessageToEditor(titre: "EncyclopédieMusique, page youtube non trouvée", content: String(describing: uneOeuvre))
           }
       } else {
           // Pas d'accès réseau, on avertit...
           // Message d'avertissement
           let t1 = NSLocalizedString("Sorry", comment: "Désolé")//
           let t2 = NSLocalizedString("No access to Web", comment: "Désolé")//"No access to Web"
           boiteMessage.text = t1 + "\n" + t2
           boiteMessage.isHidden = false
       }

       if (uneOeuvre!.lien?.contains("http"))!{
           let url = NSURL(string: (uneOeuvre?.lien)!)
           let requete = NSURLRequest(url:url! as URL)
           webYoutube.loadRequest(requete as URLRequest)
       }
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addToPlaylist(_ sender: UIButton) {
        baseDonnees!.addToPlaylist(oeuvre: uneOeuvre!)
        btnAddToPlaylist.isHidden = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func sendMessageToEditor(titre:String, content:String){
        if MFMailComposeViewController.canSendMail(){
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients([MAIL_EDITOR])
            composeVC.setSubject(titre)
            composeVC.setMessageBody(content, isHTML: false)
            self.present(composeVC, animated: true, completion: nil)
        }
    }

}
