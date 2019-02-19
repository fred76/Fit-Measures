//
//  LanguageController.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 07/01/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import UIKit

class LanguageController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        englCheck.isHidden = true
        itCheck.isHidden = true
        
        if let lang = Bundle.main.preferredLocalizations.first {
            if lang == "en" {
                englCheck.isHidden = false
            }
            if lang == "it" {
                itCheck.isHidden = false
            }
        }
        tableView.rowHeight = 44
    }

    @IBOutlet var englCheck: UIImageView!
    @IBOutlet var itCheck: UIImageView!
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        englCheck.isHidden = true
        itCheck.isHidden = true
        if indexPath.row == 0{
            englCheck.isHidden = false
            changeToLanguage("en")
            
        }
        if indexPath.row == 1 {
            itCheck.isHidden = false
            changeToLanguage("it")
            
        }
         
        
    }
    private func changeToLanguage(_ langCode: String) {
        if Bundle.main.preferredLocalizations.first != langCode {
            let message = loc("LOCALmsg")
            let confirmAlertCtrl = UIAlertController(title: loc("LOCALTitle"), message: message, preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: loc("LOCALOK"), style: .destructive) { _ in
                UserDefaults.standard.set([langCode], forKey: "AppleLanguages")
                UserDefaults.standard.synchronize()
                exit(EXIT_SUCCESS)
            }
            confirmAlertCtrl.addAction(confirmAction)
            
            let cancelAction = UIAlertAction(title: loc("LOCALCancel"), style: .cancel, handler: nil)
            confirmAlertCtrl.addAction(cancelAction)
            
            present(confirmAlertCtrl, animated: true, completion: nil)
        }
    }
    
    // MARK: - Memory management
    
     

}
