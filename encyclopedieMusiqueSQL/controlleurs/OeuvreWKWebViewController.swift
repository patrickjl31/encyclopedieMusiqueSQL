//
//  OeuvreWKWebViewController.swift
//  encyclopedieMusiqueSQL
//
//  Created by patrick lanneau on 04/11/2019.
//  Copyright © 2019 patrick lanneau. All rights reserved.
//

import UIKit
import WebKit

import  MessageUI

class OeuvreWKWebViewController: UIViewController, WKNavigationDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var lbl_titre: UILabel!
    @IBOutlet weak var boiteMessage: UILabel!
    @IBOutlet weak var webYoutube: WKWebView!
    @IBOutlet weak var btnAddToPlaylist: UIButton!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var baseDonnees:GestionAuteurs?
    var uneOeuvre:Oeuvre?
    var addPlaylistIsVisible = true
    
    // pour envoyer les notifications d'erreur
    let composeVC = MFMailComposeViewController()
    
    /*
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webYoutube = WKWebView(frame: .zero, configuration: webConfiguration)
        webYoutube.uiDelegate = self
    }
*/
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webYoutube.navigationDelegate = self
        
        if let leTitre = uneOeuvre?.titre {
            lbl_titre.text = leTitre
        }
        boiteMessage.isHidden = true
        if !addPlaylistIsVisible {
            btnAddToPlaylist.isHidden = false
        }
        // On vérifie l'accès au réseau
        activity.isHidden = false
        activity.startAnimating()
       if Reachability.isConnectedToNetwork() {
        if let oeuvre = uneOeuvre, (oeuvre.lien?.contains("http"))!{
            accesVideo(adresse: oeuvre)

       } else {
           // Pas d'accès réseau, on avertit...
           // Message d'avertissement
           let t1 = NSLocalizedString("Sorry", comment: "Désolé")//
           let t2 = NSLocalizedString("No access to Web", comment: "Désolé")//"No access to Web"
           boiteMessage.text = t1 + "\n" + t2
           boiteMessage.isHidden = false
       }
        //activity.stopAnimating()
        //activity.isHidden = true

    }
    }
    
    @IBAction func addToPlaylist(_ sender: UIButton) {
           baseDonnees!.addToPlaylist(oeuvre: uneOeuvre!)
           btnAddToPlaylist.isHidden = true
       }
       
    func sendMessageToEditor(titre:String, content:Oeuvre){
        //Alerte.shared.erreur(message: "EncyclopédieMusique, page Youtube non trouvée", controller: self)
        if MFMailComposeViewController.canSendMail(){
            //let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients([MAIL_EDITOR, MAIL_EDITOR2])
            composeVC.setSubject(titre)
            var titre = ""
            var auteur = ""
            var lien = ""
            if let auth = content.auteur?.nom, let nom = content.titre, let url = content.lien  {
                auteur = auth
                titre = nom
                lien = url
            }
            
            let message = "La video recherchée: \(String(describing: titre)), composée par \(auteur), (adresse youtube : \(lien)) n'est plus disponible"
            composeVC.setMessageBody(message, isHTML: false)
            self.present(composeVC, animated: true, completion: nil)
        }
    }
     
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    

    
    func accesVideo(adresse:Oeuvre) {
        //activity.isHidden = false
        //activity.startAnimating()
        //var retour = true
        if var adr = adresse.lien {
            if let stop = adr.firstIndex(of: "#") {
                adr = String(adr.prefix(upTo: stop))
            }
            let urlAdr = adr.replacingOccurrences(of: "https://www.youtube.com/watch?v=", with: "https://img.youtube.com/vi/") + "/0.jpg"
            if let url = URL(string: urlAdr) {
                //let requete = URLRequest(url: url)
                let session = URLSession.shared
                let task = session.dataTask(with: url) { (data, response, error) in
                    if let data = data {DispatchQueue.main.async {
                        let httpResponse = response as! HTTPURLResponse
                        let statuscode = httpResponse.statusCode
                        if statuscode == 200 {
                            self.chargeVideo(val: adr)
                        } else {if statuscode == 404 {
                                self.sendMessageToEditor(titre: "EncyclopédieMusique, page Youtube non trouvée", content: adresse)
                            }
                        }
                        }
                    }
                    }
                task.resume()
            }
        }
        activity.stopAnimating()
        activity.isHidden = true
    }
    
    func chargeVideo(val:String){
        if let url = URL(string: val){
            let requete = URLRequest(url: url)
            // On charge dans la page
            webYoutube.load(requete)
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
    //MARK:- WKNavigationDelegate
      
      private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
          print(error.localizedDescription)
      }
      private func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
          print("Start to load")
      }
      private func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
          print("finish to load")
      }
      

}
