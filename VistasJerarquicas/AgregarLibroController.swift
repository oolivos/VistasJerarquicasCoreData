//
//  AgregarLibroController.swift
//  VistasJerarquicas
//
//  Created by Oscar Javier Olivos on 13/12/16.
//  Copyright © 2016 Oscar Javier Olivos. All rights reserved.
//

import UIKit
import CoreData

class AgregarLibroController: UIViewController {

    var delegado : LibrosDelegate?
    var isbn : String=""
    let url = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
    var urlFull : URL?
    var portadaData: Data?
    var authors : String = ""
    var contexto: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    @IBOutlet var txtISBNSearch: UITextField!
    @IBOutlet var txtTitulo: UILabel!
    @IBOutlet var txtAutor: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func buscarButtonClick(_ sender: Any) {
        isbn = txtISBNSearch.text!
        urlFull = URL(string: url + isbn)
        do{
            let datos = try Data(contentsOf: urlFull!)
            let jsonResponde = try JSONSerialization.jsonObject(with: datos, options: JSONSerialization.ReadingOptions.allowFragments)
            
            let result = jsonResponde as! [String: AnyObject]
            if((result.count) > 0){
                guard let titulo = result["ISBN:"+isbn]?["title"] as? String,
                    let portada = result["ISBN:"+isbn]?["cover"] as? AnyObject,
                    let autores = result["ISBN:"+isbn]?["authors"] as? [[String: AnyObject]]
                    else {return}
                
                
                for autor in autores {
                    authors =  authors + "," + (autor["name"]! as! String) + " "
                }
                authors.remove(at: authors.startIndex)
                if portada.count != nil {
                    let urlportada = portada["large"] as? String
                    let urlImage = URL(string: urlportada!)
                     portadaData = try Data(contentsOf: urlImage!)
                    
                }
                
                txtTitulo.text = titulo
                txtAutor.text = authors
                txtTitulo.isHidden = false
                txtAutor.isHidden = false
                
            }else{
                print("No Found!!")
                txtTitulo.isHidden = false
                txtAutor.isHidden = true
                txtAutor.text = ""
                txtTitulo.text = "No encontrado!!"
                isbn = ""
            }
            
            
            
            
            //print(jsonResponde["title"] as! String )
        }catch  {
            print("Error")
        }
        
    }
    

    @IBAction func saveButtonClick(_ sender: Any) {
        
        //delegado?.addLibro!(titulo: txtTitulo.text!, isbn: txtAutor.text!)
        
        
        
        
        if !txtAutor.isHidden {
            
            let request = NSFetchRequest<NSManagedObject>(entityName: "Libros")
            let predicado = NSPredicate(format: "isbn == %@", isbn)
            request.predicate = predicado
            do{
                let libro = try contexto.fetch(request)
                if libro.count <= 0{
                    delegado?.addLibro!(titulo: txtTitulo.text!, isbn: isbn, portada: portadaData, autores : authors)
                    self.dismiss(animated: true, completion: nil)
                }else{
                    let errorDialog = UIAlertController(title: "Error!", message: "El libro ya se encuentra registrado!!", preferredStyle: .alert)
                    errorDialog.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
                    present(errorDialog, animated: true)
                }
                
            }catch let error as NSError {
                let errorDialog = UIAlertController(title: "Error!", message: "Failed to save! \(error): \(error.userInfo)", preferredStyle: .alert)
                errorDialog.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
                present(errorDialog, animated: true)
            }
            
            

        }else{
            let alert = UIAlertController(title: "OpenLibrary", message: "No se ha encontrado el libro, no se puede agregar", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.self.present(alert,animated: true, completion: nil)
        }
    }
    @IBAction func cancelButtonclick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
