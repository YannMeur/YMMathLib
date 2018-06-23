//
//  Vecteur.swift
//  Pods-YMMathLib_Example
//
//  Created by Yann Meurisse on 21/04/2018.
//

import Foundation

postfix operator °


public class Vecteur<T: TypeArithmetique>: Matrice<T>
{
   // T est de type Double ou Complexe
   // Tableau qui contient les composantes du vecteur
   // TODO : rendre data non public en créant public func array() -> [Double]
   //public var data: [T] = []
   // Dimension du vecteur. Par défaut vecteur colonne, nbc=1
   //var (nbl, nbc) = (0,1)

   
   /// Initialisation du Vecteur à partir d'un tableau de Double ou Complexe.
   ///
   /// Par défaut le Vecteur est colonne (nbc=1)
   /// - parameters:
   ///     - datas: : Le tableau de Double ou Complexe.
   public init(_ datas: [T])
   {
      let nbli = datas.count
      super.init(datas, nbl: nbli, nbc: 1)
      self.nbc = 1
      self.nbl = nbli
   }
   
   
   /// Initialisation du Vecteur à partir d'un autre Vecteur.
   ///
   /// - parameters:
   ///   - vec: : Le Vecteur copié.

   public init(_ vec: Vecteur)
   {
      super.init(vec.data, nbl: vec.nbl, nbc: 1)
   }
   
   /**
    Implémente la notion d'indice (subscript) pour "\(Vecteur)"
    - parameters:
      - vec: : Le Vecteur copié.
    */
   public subscript(x: Int) -> T
   {
      get {
         return self.data[x]
      }
      set {
         self.data[x] = newValue
      }
   }
   
   /**
    Implémente la conversion en String pour "\(Vecteur)"
    */
   override public var description: String
   {
      var result = ""
      if nbc == 1
      {
         for element in self.data
         {
            result += "|\(element)|\n"
         }
      } else
      {
         result = "["
         for element in self.data
         {
            result += "\(element),"
         }
         result.removeLast()
         result += "]"
      }
      return result
   }
   
   /*********************************************************
    Implémente le "==" de 2 vecteurs (égalité stricte)
    (pour se conformer au protocole Equatable)
    TODO : Traiter cas de vecteurs "vides"
    *********************************************************/
   public static func == (lhs: Vecteur, rhs: Vecteur) -> Bool
   {
      var result = (lhs.nbl == rhs.nbl) && (lhs.nbc == rhs.nbc)
      
      for i in 0..<lhs.data.count
      {
         result = result && (lhs.data[i] == rhs.data[i])
      }
      return result
   }

   /**
    Compare 2 Vecteur<Complexe> avec une certaine précision :
    Egalité si la distance entre chaque terme est inférieure
    à une certaine "précision"
    
    TODO : Traiter cas de vecteurs "vides"
    */
   public static func compare(lhs: Vecteur<Complexe>, rhs: Vecteur<Complexe>, precision: Double) -> Bool
   {
      var result = (lhs.nbl == rhs.nbl) && (lhs.nbc == rhs.nbc)
      
      if result
      {
         for i in 0..<lhs.data.count
         {
            result = result && (abs(lhs.data[i] - rhs.data[i]) < precision)
         }
      }
      return result
   }
   /**
    Compare 2 Vecteur<Double> avec une certaine précision :
    Egalité si la distance entre chaque terme est inférieure
    à une certaine "précision"
    
    TODO : Traiter cas de vecteurs "vides"
    */
   public static func compare(lhs: Vecteur<Double>, rhs: Vecteur<Double>, precision: Double) -> Bool
   {
      var result = (lhs.nbl == rhs.nbl) && (lhs.nbc == rhs.nbc)
      
      if result
      {
         for i in 0..<lhs.data.count
         {
            result = result && (abs(lhs.data[i] - rhs.data[i]) < precision)
         }
      }
      return result
   }

   /*********************************************************
    Implémente le "+" de 2 vecteurs
    *********************************************************/
   public static func +(lhs: Vecteur, rhs: Vecteur) -> Vecteur?
   {
      if (lhs.nbc == rhs.nbc && lhs.nbl == rhs.nbl)
      {
         let result = Vecteur(lhs)
         
         for ind in 0...max(lhs.nbc,lhs.nbl)-1
         {
            result[ind] = result[ind] + rhs[ind]
         }
         return result
      } else
      {
         print("Dimensions incompatibles pour l'addition de 2 Vecteurs!")
         return nil
      }
   }
   
   /*********************************************************
    Implémente le "-" de 2 vecteurs
    *********************************************************/
   public static func -(lhs: Vecteur, rhs: Vecteur) -> Vecteur?
   {
      if (lhs.nbc == rhs.nbc && lhs.nbl == rhs.nbl)
      {
         let result = Vecteur(lhs)
         
         for ind in 0...max(lhs.nbc,lhs.nbl)-1
         {
            result[ind] = result[ind] - rhs[ind]
         }
         return result
      } else
      {
         print("Dimensions incompatibles pour l'addition de 2 Vecteurs!")
         return nil
      }
   }
   
   
   /*********************************************************
    Implémente le "*" d'1 Double et d'1 Vecteur
    TODO : vérifier compatibilité des dimensions
    *********************************************************/
   public static func *(lhs: Double, rhs: Vecteur) -> Vecteur
   {
      let result = rhs
      var ind = 0
      for _ in rhs.data
      {
         result[ind] = result[ind] * lhs
         ind += 1
      }
      return result
   }
   
   /*********************************************************/
   ///
   ///Implémente la transposition d'un vecteur
   ///
   ///Retourne le transposé du Vecteur
   /*********************************************************/
   public func transpose() -> Vecteur
   {
      let result = Vecteur(self)
      
      result.nbl = self.nbc
      result.nbc = self.nbl
      return result
   }
   /*********************************************************
    Implémente la transposition d'un vecteur à l'aide d'un
    opérateur postfixé "°"
    Retourne le transposé du Vecteur
    *********************************************************/
   public static postfix func °(v: Vecteur) -> Vecteur
   {
      let result = Vecteur(v)
      
      result.nbl = v.nbc
      result.nbc = v.nbl
      return result
   }
   
   /*********************************************************/
   /// Retourne la somme des éléments du Vecteur
   /*********************************************************/
   public func somme() -> T
   {
      var result = T.init()
      for element in self.data
      {
         result += element
      }
      return result
   }
   
   /*********************************************************/
    /// Retourne le Vecteur sous forme d'un Array de Double (self.data)
   /*********************************************************/
   public func array() -> [T]
   {
      return self.data
   }
   
}
/*===================FIN DEFINITION CLASS=============================================*/

/*********************************************************
 Implémente le "*" de 2 vecteurs (de même nature)
 TODO : vérifier compatibilité des dimensions
 ********************************************************
public func *<T: TypeArithmetique>(lhs: Vecteur<T>, rhs: Vecteur<T>) -> Any?
{
   print(" on passe dans le * de 2 Vecteur")
   if (lhs.nbl == 1 && lhs.nbc == rhs.nbl && rhs.nbc == 1)  // produit scalaire
   {
      if lhs.nbc > 0
      {
         var result = lhs[0] * rhs[0]
         for ind in 1...lhs.nbc-1
         {
            result = result + lhs[ind] * rhs[ind]
         }
         return result as T
      } else
      {
         print("Vecteurs vides !")
         return nil
      }
   }
   else if (lhs.nbc == rhs.nbl)     // l'autre produit
   {
      if lhs.nbc > 0
      {
         var data: [T] = Array(repeating: T.init(), count: 0)
         for c in 0...rhs.nbc-1
         {
            for l in 0...lhs.nbl-1
            {
               data.append(lhs[l]*rhs[c])
            }
         }
         
         print("data : \(data)")
         
         return Matrice(data, nbl: lhs.nbl, nbc: rhs.nbc)
      } else
      {
         print("Vecteurs vides !")
         return nil
      }
   }
   else
   {
      print("Dimensions incompatibes pour * de 2 Vecteurs!")
      return nil
   }
}
*/

/*********************************************************
 Implémente le "*" de 2 vecteurs (de nature différente)
 TODO : vérifier compatibilité des dimensions
 ********************************************************
public func *(lhs: Vecteur<Double>, rhs: Vecteur<Complexe>) -> Any?
{
   
   if (lhs.nbl == 1 && lhs.nbc == rhs.nbl && rhs.nbc == 1)  // produit scalaire
   {
      if lhs.nbc > 0
      {
         var result = lhs[0] * rhs[0]
         for ind in 1...lhs.nbc-1
         {
            result = result + lhs[ind] * rhs[ind]
         }
         return result as Complexe
      } else
      {
         print("Vecteurs vides !")
         return nil
      }
   }
   else if (lhs.nbc == rhs.nbl)     // l'autre produit
   {
      if lhs.nbc > 0
      {
         var data: [Complexe] = Array(repeating: Complexe.init(), count: 0)
         for c in 0...rhs.nbc-1
         {
            for l in 0...lhs.nbl-1
            {
               data.append(lhs[l]*rhs[c])
            }
         }
         
         print("data : \(data)")
         
         return Matrice(data, nbl: lhs.nbl, nbc: rhs.nbc)
      } else
      {
         print("Vecteurs vides !")
         return nil
      }
   }
   else
   {
      print("Dimensions incompatibes pour * de 2 Vecteurs!")
      return nil
   }
}
 */
/*********************************************************
 Implémente le "*" de 2 vecteurs (de nature différente)
 TODO : vérifier compatibilité des dimensions
 ********************************************************
public func *(lhs: Vecteur<Complexe>, rhs: Vecteur<Double>) -> Any?
{
   
   if (lhs.nbl == 1 && lhs.nbc == rhs.nbl && rhs.nbc == 1)  // produit scalaire
   {
      if lhs.nbc > 0
      {
         var result = lhs[0] * rhs[0]
         for ind in 1...lhs.nbc-1
         {
            result = result + lhs[ind] * rhs[ind]
         }
         return result as Complexe
      } else
      {
         print("Vecteurs vides !")
         return nil
      }
   }
   else if (lhs.nbc == rhs.nbl)     // l'autre produit
   {
      if lhs.nbc > 0
      {
         var data: [Complexe] = Array(repeating: Complexe.init(), count: 0)
         for c in 0...rhs.nbc-1
         {
            for l in 0...lhs.nbl-1
            {
               data.append(lhs[l]*rhs[c])
            }
         }
         
         print("data : \(data)")
         
         return Matrice(data, nbl: lhs.nbl, nbc: rhs.nbc)
      } else
      {
         print("Vecteurs vides !")
         return nil
      }
   }
   else
   {
      print("Dimensions incompatibes pour * de 2 Vecteurs!")
      return nil
   }
}
*/





/***********************************************************/
/// Pour pouvoir manipuler des tableaux de (Int,Int)
/// grâce au protocole Hashable
/***********************************************************/
public struct CoupleInt : Hashable
{
   var nb1: Int = 0
   var nb2: Int = 0
   
   public init(_ nombre1: Int,_ nombre2: Int)
   {
      self.nb1 = nombre1
      self.nb2 = nombre2
   }
   
   public var hashValue: Int
   {
      return nb1*10 + nb2
   }
   /*********************************************************/
    ///Implémente le "==" de 2 CoupleInt
    ///(pour se conformer au protocole Equatable)
   /*********************************************************/
   public static func ==(lhs: CoupleInt, rhs: CoupleInt) -> Bool
   {
      return (lhs.nb1 == rhs.nb1) && (lhs.nb2 == rhs.nb2)
   }
   /*********************************************************/
   /// Implémente la conversion en String pour "\\(CoupleInt)"
   /*********************************************************/
   public var description: String
      //public func description() -> String
   {
      return "("+String(self.nb1)+","+String(self.nb2)+")"
   }
}
