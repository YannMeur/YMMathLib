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
   let nombres1 = [3,5,7,15]
   let nombres2 = [8,6,5,2]


   var monVect1 = Vecteur(nombres1)
   let monVect2 = Vecteur(nombres2)
   print(monVect1)
   print(monVect2)
   print("monVect2[2] : \(monVect2[2])")
   let monVect4 = monVect1.transpose()
   let monVect5 = monVect2.transpose()
   print("monVect5 :\n\(monVect5)")
   print("monVect4+monVect5 :\n\((monVect4+monVect5)!)")
   var monVect3 = 3*monVect2
   print(monVect3.transpose())
   print(monVect3.transpose()*monVect1)
   //var monVect4 = monVect3.transpose()*monVect1
   var maMat1 = Matrice([8.0,1,6,3,5,7,4,9,2],nbl: 3,nbc: 3)
   print("maMat1 : \n\(maMat1)")
   print("maMat1[2,1] :\n\(maMat1[2,1])")
   print("maMat1° : \n\(maMat1°)")
   print("maMat1 * maMat1° : \n\((maMat1 * maMat1°)!)")
   print("maMat1.triangSup(maMat1) :\n\(maMat1.triangSup(maMat1))")
   var B = maMat1.inv()
   print("inv(maMat1) :\n\(B))")
   print("maMat1*B :\n\(String(describing: maMat1*B)))")
   print("maMat1.dim() :\n\(maMat1.dim())")

   
   print("inv(B) :\n\(inv(B))")
   print("invert(B) :\n\(invert(B))")
   
   var start = CACurrentMediaTime()
   for i in 0...1000
   {
      let IB = inv(B)
   }
   var end = CACurrentMediaTime()
   print("Durée d'execution de inv() = \(end-start)")

   start = CACurrentMediaTime()
   for i in 0...1000
   {
      let IB = invert(B)
   }
   end = CACurrentMediaTime()
   print("Durée d'execution de invert() = \(end-start)")

   // Vérification svd
   maMat1 = Matrice([8.0,1,3,5,4,9],nbl: 3,nbc: 2,rangement: "c")
   print("maMat1 c/c : \n\(maMat1)")
   maMat1 = Matrice([8.0,1,3,5,4,9],nbl: 3,nbc: 2)
   print("maMat1 l/l : \n\(maMat1)")

   let Results = svd(maMat1)
   let UU = Results.U
   let D = Results.D
   let VV = Results.V
   
   print("UU.dim() :\n\(UU.dim())")
   print("D.dim() :\n\(D.dim())")
   print("VV.dim() :\n\(VV.dim())")
   
   print("UU :\n\(UU)")
   print("D :\n\(D)")
   print("VV :\n\(VV)")
   
   let X = (UU*D)!*(VV°)
   print("X :\n\(X)")
 
   
   
}

  override var representedObject: Any? {
    didSet {
    // Update the view, if already loaded.
    }
  }


}

