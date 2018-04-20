//
//  ViewController.swift
//  YMMathLib
//
//  Created by PaulHaus on 04/19/2018.
//  Copyright (c) 2018 PaulHaus. All rights reserved.
//

import Cocoa
import YMMathLib

class ViewController: NSViewController {

  override func viewDidLoad()
  {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
   var maMatrice = Matrice([1 ,0 ,0 ,1],nbl: 2,nbc: 2)
   maMatrice = Matrice(nbl: 2)
   print("maMatrice \(maMatrice.dim()) :\n\(maMatrice)")

  }

  override var representedObject: Any? {
    didSet {
    // Update the view, if already loaded.
    }
  }


}

