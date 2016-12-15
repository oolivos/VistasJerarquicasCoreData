//
//  DetalleController.swift
//  VistasJerarquicas
//
//  Created by Oscar Javier Olivos on 13/12/16.
//  Copyright © 2016 Oscar Javier Olivos. All rights reserved.
//

import UIKit
import CoreData

class DetalleController: UIViewController {

    var libro : NSManagedObject? = nil
    @IBOutlet var imgPortada: UIImageView!
    @IBOutlet var txtTitulo: UILabel!
    @IBOutlet var txtAutor: UILabel!
    
    @IBOutlet var txtPortadaNoDisponible: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

            txtTitulo.text = libro?.value(forKey: "titulo") as! String?
            txtAutor.text = libro?.value(forKey: "autores") as! String?
            if libro?.value(forKey: "portada") != nil{
                imgPortada.image = UIImage(data: libro?.value(forKey: "portada") as! Data)
                txtPortadaNoDisponible.isHidden = true
        }

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

}
