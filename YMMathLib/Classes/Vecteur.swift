//
//  Vecteur.swift
//  Pods-YMMathLib_Example
//
//  Created by Yann Meurisse on 21/04/2018.
//

import Foundation

postfix operator °

public class Vecteur: CustomStringConvertible, Equatable
{
   
   // Tableau qui contient les composantes du vecteur
   // TODO : rendre data non public en créant public func array() -> [Double]
   public var data: [Double] = []
   // Dimension du vecteur. Par défaut vecteur colonne, nbc=1
   var (nbl, nbc) = (0,1)
   
   /// Initialisation du Vecteur à partir d'un tableau de Double.
   ///
   /// Par défaut le Vecteur est colonne (nbc=1)
   /// - parameters:
   ///   - datas: : Le tableau de Double.
   public init(_ datas: [Double])
   {
      for element in datas
      {
         self.data.append(element)
      }
      self.nbc = 1
      self.nbl = data.count
   }
   
   /// Initialisation du Vecteur à partir d'un tableau d'Int.
   ///
   /// Par défaut le Vecteur est colonne (nbc=1)
   /// - parameters:
   ///   - datas: : Le tableau d'Int.
   public init(_ datas: [Int])
   {
      for element in datas
      {
         self.data.append(Double(element))
      }
      self.nbc = 1
      self.nbl = data.count
   }
   
   /// Initialisation du Vecteur à partir d'un autre Vecteur.
   ///
   /// - parameters:
   ///   - vec: : Le Vecteur copié.

   public init(_ vec: Vecteur)
   {
      self.data = vec.data
      self.nbc = vec.nbc
      self.nbl = vec.nbl
   }
   
   /**
    Implémente la notion d'indice (subscript) pour "\(Vecteur)"
    - parameters:
      - vec: : Le Vecteur copié.
    */
   public subscript(x: Int) -> Double
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
   public var description: String
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
    Implémente le "==" de 2 vecteurs
    (pour se conformer au protocole Equatable)
    TODO : Traiter cas de vecteurs "vides"
    *********************************************************/
      public static func ==(lhs: Vecteur, rhs: Vecteur) -> Bool
   {
      var result = (lhs.nbl == rhs.nbl) && (lhs.nbc == rhs.nbc)
      
      for i in 0..<lhs.data.count
      {
         result = result && (lhs.data[i] == rhs.data[i])
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
         var result = Vecteur(lhs)
         
         for ind in 0...max(lhs.nbc,lhs.nbl)-1
         {
            result[ind] = result[ind] + rhs[ind]
         }
         return result
      } else
      {
         print("Dimensions incompatibes pour l'addition de 2 Vecteurs!")
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
         var result = Vecteur(lhs)
         
         for ind in 0...max(lhs.nbc,lhs.nbl)-1
         {
            result[ind] = result[ind] - rhs[ind]
         }
         return result
      } else
      {
         print("Dimensions incompatibes pour l'addition de 2 Vecteurs!")
         return nil
      }
   }
   
   /*********************************************************
    Implémente le "*" de 2 vecteurs
    TODO : vérifier compatibilité des dimensions
    *********************************************************/
   public static func *(lhs: Vecteur, rhs: Vecteur) -> Double?
   {
      
      if (lhs.nbl == 1 && lhs.nbc == rhs.nbl && rhs.nbc == 1)
      {
         if lhs.nbc > 0
         {
            var result = lhs[0] * rhs[0]
            for ind in 1...lhs.nbc-1
            {
               result = result + lhs[ind] * rhs[ind]
               //ind += 1
            }
            return result
         } else
         {
            print("Vecteurs vides !")
            return nil
         }
      } else
      {
         print("Dimensions incompatibes pour * de 2 Vecteurs!")
         return nil
      }
   }
   
   /*********************************************************
    Implémente le "*" d'1 Double et d'1 Vecteur
    TODO : vérifier compatibilité des dimensions
    *********************************************************/
   public static func *(lhs: Double, rhs: Vecteur) -> Vecteur
   {
      var result = rhs
      var ind = 0
      for elem in rhs.data
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
      var result = Vecteur(self)
      
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
      var result = Vecteur(v)
      
      result.nbl = v.nbc
      result.nbc = v.nbl
      return result
   }
   
   /*********************************************************/
   /// Retourne la somme des éléments du Vecteur
   /*********************************************************/
   public func somme() -> Double
   {
      var result = 0.0
      for element in self.data
      {
         result += element
      }
      return result
   }
   
   /*********************************************************/
    /// Retourne le Vecteur sous forme d'un Array de Double (self.data)
   /*********************************************************/
   public func array() -> [Double]
   {
      return self.data
   }
   
}
/*===================================================================*/

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
