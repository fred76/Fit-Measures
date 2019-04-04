//
//  ProductListSearchedByName.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 04/04/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import UIKit

class ProductListSearchedByName: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
          //DownloadManager.shared.topChartController = self
    }

    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    // MARK: - Table view data source
 
    override func numberOfSections(in tableView: UITableView) -> Int {
        // una sola sezione basta per quest'App
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // leggiamo il numero di var nell'array, direttamente dal DownloadManager!
        return DownloadManager.shared.storage.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
        
    }
    var uno : Int = 1
    @IBAction func more(_ sender: Any) {
        uno += 1
        let t = String(uno)
        let url = "https://world.openfoodfacts.org/cgi/search.pl?action=process&search_terms=spaghetti&sort_by=unique_scans_n&page_size=20&page=\(t)&json=1"
               
        print(url)
        DownloadManager.shared.downloadJSON(url)
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // questo è il codice standard che fa andare le celle, notare come usiamo ChartCell e non quella normale
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductSearched", for: indexPath) as! ProductCellForSearched
        
        // impostiamo un'immagine base per per ogni cella
        cell.imageProduct.image = UIImage(named: "Camera")
        
        // arrotondiamo i bordi per dare l'effetto icona iOS
        cell.imageProduct.layer.cornerRadius = 12
        
        // ci facciamo dare dal DownloadManager la var corrispondente alla cella che la table sta creando grazie a questo metodo
        let app = DownloadManager.shared.storage[indexPath.row]
        
        // scriviamo il nome dell'App e lo sviluppatore nelle due label
        cell.productName.text = app.productName
        cell.brand.text = app.brand
        cell.quantity.text = app.quantity
        cell.ingredient.text = app.ingredientList
       
        cell.richiesta = request(app.image, method: .get).responseData { rispostaServer in
            
            // controlliamo che non ci sia errore e che l'immagine sia arrivata
            if rispostaServer.response != nil {
                // questo controllo serve per mettere l'icona giusta nella cella giusta
                // ricordati che le celle vengono "riciclate" dalla table
                // quindi bisogna assicurarsi che metta le immagini al posto giusto
                if rispostaServer.request?.url?.absoluteString ==
                    cell.richiesta?.request?.url?.absoluteString {
                    
                    // mettiamo l'immagine nella cella
                    if let icona = rispostaServer.data {
                        cell.imageProduct.image = UIImage(data: icona)
                    }
                }
            } else {
                // altrimenti c'è un errore e lo stampiamo in console
                print("errore")
            }
        }
        
        return cell
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
