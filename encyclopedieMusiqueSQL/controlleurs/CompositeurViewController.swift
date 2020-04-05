//
//  CompositeurViewController.swift
//  encyclopedieMusique
//
//  Created by patrick lanneau on 25/08/2017.
//  Copyright © 2017 patrick lanneau. All rights reserved.
//

import UIKit

import WebKit

class CompositeurViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate {

    @IBOutlet weak var ui_titre: UILabel!
    
    //@IBOutlet weak var ui_webPage: UIWebView!
    @IBOutlet weak var ui_webPage: WKWebView!
    
    @IBOutlet weak var tableOeuvres: UITableView!
    
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var boiteMessage: UILabel!
    
    //-----------
    
    var unAuteur:Compositeur = Compositeur()
    var baseDonnees:GestionAuteurs?
    
    var selectedOeuvre : Int = -1
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //ui_webPage.delegate = self
        /*
        func webViewDidStartLoad(_ webView: UIWebView) {
            myActivityIndicator.startAnimating()
        }
        func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        }
        func webViewDidFinishLoad(_ webView: UIWebView)
        {
            myActivityIndicator.stopAnimating()
        }
        */
        
        ui_webPage.navigationDelegate = self
        
        boiteMessage.isHidden = true
        
        ui_titre.text = unAuteur.nom
        
        //spinner
        //myActivityIndicator.isHidden = false
        myActivityIndicator.startAnimating()
        // Pas de page wiki ?
        
        // On vérifie l'accès au réseau
        if Reachability.isConnectedToNetwork() {
            if (unAuteur.wiki?.contains("http"))!{
                //let url = NSURL(string: (unAuteur.wiki)!)
                let url = URL(string: (unAuteur.wiki)!)
            //let requete = NSURLRequest(url:url as! URL)
            if url != nil{
                //let requete = NSURLRequest(url: url! as URL)
                //ui_webPage.load(requete as URLRequest)
                ui_webPage.load(URLRequest(url: url!))
                //webView.allowsBackForwardNavigationGestures = true
            } else {
                // Pase de page wikipedia
                let t1 = NSLocalizedString("Sorry", comment: "Désolé")//
                let t2 = NSLocalizedString("No biographical page for", comment: "Désolé")//"No biographocal page for"
                boiteMessage.text = t1 + "\n" + t2 + "\n" + unAuteur.nom!
                boiteMessage.isHidden = false
                }
            }
        } else {
            // Pas d'accès réseau, on avertit...
            // Message d'avertissement
            let t1 = NSLocalizedString("Sorry", comment: "Désolé")//
            let t2 = NSLocalizedString("No access to Web", comment: "Désolé")//"No access to Web"
            boiteMessage.text = t1 + "\n" + t2
            boiteMessage.isHidden = false
        }
       
        tableOeuvres.delegate = self
        tableOeuvres.dataSource = self
        
        //image de fond de la table
        tableOeuvres.backgroundView = UIImageView(image: UIImage(named: "livre-part1.jpg"))
        //spinner
        myActivityIndicator.stopAnimating()
        //myActivityIndicator.isHidden = true
    }
    /*
    func webViewDidStartLoad(_ webView: UIWebView) {
        myActivityIndicator.startAnimating()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
    }
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        myActivityIndicator.stopAnimating()
    }
    */
    override func viewDidAppear(_ animated: Bool) {
        ui_titre.text = unAuteur.nom
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "voir_oeuvre" {
            let vc = segue.destination as! OeuvreWKWebViewController
            let desOeuvres = unAuteur.lesOeuvres!
            let tabOeuvres = Array(desOeuvres) as! [Oeuvre]
            vc.uneOeuvre = tabOeuvres[(tableOeuvres.indexPathForSelectedRow?.row)!]
            vc.baseDonnees = baseDonnees!
            vc.addPlaylistIsVisible = true
        }
    }
    
    // MARK gestion tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 0
        return (unAuteur.lesOeuvres?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "cell_oeuvre", for: indexPath)
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell_oeuvre")
        }
        //let oeuvreChoisie = unAuteur.lesOeuvres
        let sesOeuvres = Array(unAuteur.lesOeuvres!)
        let oeuvreChoisie = sesOeuvres[indexPath.row] as! Oeuvre
        
        cell?.textLabel?.text = oeuvreChoisie.titre //.lesOeuvre[indexPath.row].titre
        //print("Compositeur \(indexPath.row)")
        let suite = oeuvreChoisie.complement
        
        
        cell?.detailTextLabel?.text = "\(suite ?? " ")"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedOeuvre = indexPath.row
    }
    
    
    //MARK:- WKNavigationDelegate
    
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        //print(error.localizedDescription)
    }
    private func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //print("Start to load")
    }
    private func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        //print("finish to load")
    }
    
}
