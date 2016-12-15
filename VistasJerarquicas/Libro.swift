//
//  Libro.swift
//  VistasJerarquicas
//
//  Created by Oscar Javier Olivos on 14/12/16.
//  Copyright © 2016 Oscar Javier Olivos. All rights reserved.
//

import Foundation

class Libro {
    var isbn: String
    var titulo: String
    var portada : Data
    
    init(isbn : String, titulo: String, portada : Data) {
        self.isbn = isbn
        self.titulo = titulo
        self.portada = portada
    }
    
}
