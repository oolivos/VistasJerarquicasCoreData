//
//  TableViewController.swift
//  VistasJerarquicas
//
//  Created by Oscar Javier Olivos on 13/12/16.
//  Copyright © 2016 Oscar Javier Olivos. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController, LibrosDelegate {

    //private var libros: Array<Array<String>> = Array<Array<String>>()
    var contexto: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var libross : [NSManagedObject] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        //contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        showData()
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func showData (){
        let request = NSFetchRequest<NSManagedObject>(entityName: "Libros")
        do{
            libross = try contexto.fetch(request)
            
        }catch let error as NSError {
            let errorDialog = UIAlertController(title: "Error!", message: "Failed to save! \(error): \(error.userInfo)", preferredStyle: .alert)
            errorDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(errorDialog, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return libross.count
    }
    
    func addLibro(titulo: String, isbn: String, portada : Data?, autores : String) {
        //libros.append([titulo,isbn])
        let entityLibro = NSEntityDescription.entity(forEntityName: "Libros", in: contexto)
        let libroInsert = NSManagedObject(entity: entityLibro!, insertInto: contexto)
        libroInsert.setValue(titulo, forKey: "titulo")
        libroInsert.setValue(isbn, forKey: "isbn")
        libroInsert.setValue(portada, forKey: "portada")
        libroInsert.setValue(autores, forKey: "autores")
        do{
            try contexto.save()
        }catch let error as NSError{
            let errorDialog = UIAlertController(title: "Error!", message: "Failed to save! \(error): \(error.userInfo)", preferredStyle: .alert)
            errorDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(errorDialog, animated: true)
        }
        showData()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)

        // Configure the cell...
        let libro = libross[indexPath.row]
        cell.textLabel?.text = (libro.value(forKey: "titulo") as! String?)! + " (" + (libro.value(forKey: "isbn") as! String?)! + ")"
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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

    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSegue" {
            let add = segue.destination as! AgregarLibroController
            add.delegado = self
        }
            
        
        if (segue.identifier == "tableSegue") {
            let detalle  = segue.destination as! DetalleController
            let index = self.tableView.indexPathForSelectedRow
            detalle.libro = (libross[(index?.row)!])
        }
        
    }
    

}
