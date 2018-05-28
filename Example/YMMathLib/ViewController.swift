//
//  ViewController.swift
//  YMMathLib
//
//  Created by PaulHaus on 04/19/2018.
//  Copyright (c) 2018 PaulHaus. All rights reserved.
//

import Cocoa
import YMMathLib

prefix operator ¡

class ViewController: NSViewController {

  override func viewDidLoad()
  {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
   let nombres1 = [3,5,7,15]
   let nombres2 = [8,6,5,2]


   var maMat1T = Matrice([8.0,1,6,3,5,7,4,9,2],nbl: 3,nbc: 3,rangement: "l")
   print("maMat1T l/l : \n\(maMat1T)")
   var maMat1 = Matrice([8.0,1,6,3,5,7,4,9,2],nbl: 3,nbc: 3)
   print("maMat1 c/c : \n\(maMat1)")
   print("maMat1.stochastique() : \n\(maMat1.stochastique())")

   print("maMat1.ligne(0) :\n\(maMat1.ligne(0))")
   print("maMat1T.colonne(0) : \n\(maMat1T.colonne(0))")
   
   
   print("maMat1 * maMat1° : \n\((maMat1 * maMat1°)!)")
   print("inv(maMat1) :\n\(inv(maMat1)))")
   
   /*
    // Vérification svd
   maMat1 = Matrice([8.0,4,5,3,1,9],nbl: 3,nbc: 2)
   print("maMat1 : \n\(maMat1)")
   
   let Results = svd(maMat1)
   let UU = Results.U
   let D = Results.D
   let VV = Results.V
   
   print("UU :\n\(UU)")
   print("D :\n\(D)")
   print("VV :\n\(VV)")
     
   let X = (UU*D)!*(VV°)
   print("X :\n\(X)")
  */
   
   let z0 = Complexe(re: 1.0 ,im: 1.0)
   print("z0 = \(z0)")
   print("abs(z0) = \(abs(z0))")
   print("z0==z0 = \(z0==z0))")
   let maMat2 = Matrice([8.0 + ¡2 , Complexe(1.0)  , 6 + ¡1,
                         2 + ¡3 , 1.0 + ¡5 , 7 + ¡7 ,
                         4 + ¡4 , 9.0 + ¡9  , 2 + ¡2.0] ,nbl: 3,nbc: 3)
   print("maMat2  : \n\(maMat2)")
   print("inv(maMat2)  : \n\(inv(maMat2))")
   print("maMat2 * inv(maMat2)  : \n\(maMat2 * inv(maMat2))")
   
   let v = Vecteur([2, 4, 8])
   print("v =\n\(v)")
   print("v°*v =\n \(v° * v)")
   
}

  override var representedObject: Any? {
    didSet {
    // Update the view, if already loaded.
    }
  }


}

