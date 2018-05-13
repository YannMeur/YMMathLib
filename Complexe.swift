//
//  Complexe.swift
//  Pods-YMMathLib_Example
//
//  Created by Yann Meurisse on 13/05/2018.
//

import Foundation


/*============================================================
/// protocol TypeArithmetique
/// doit implémenter :
/// - la somme de 2 élements
/// - le produit de 2 élements
/// - le quotient de 2 élements
///
/// Rem: Je pense que Self désigne le Type (la Class) respectant
/// ce protocol
/*============================================================*/
public protocol TypeArithmetique: Equatable
{
   //associatedtype leType
   // Operations (predefined)
   prefix static func + (_: Self)->Self
   prefix static func - (_: Self)->Self
   init()
   init(_: Double)
   static func + (_: Self, _: Self)->Self
   static func - (_: Self, _: Self)->Self
   static func * (_: Self, _: Self)->Self
   static func * (_: Self, _: Double)->Self
   static func * (_: Double, _: Self)->Self
   static func / (_: Self, _: Self)->Self
   static func += (_: inout Self, _: Self)
   //static func == (_: Self, _: Self)->Bool
   //static func abs (_: Self)->Double
}
*/

/*============================================================*/
public struct Complexe: CustomStringConvertible,TypeArithmetique
{
   
   public var (re, im): (Double, Double)
   public var mod: Double
   {
      get
      {
         return sqrt(self.re*self.re + self.im*self.im)
      }
   }
   public var arg: Double
   {
      get
      {
         return atan(self.im/self.re)
      }
   }
   public var conj: Complexe
   {
      get
      {
         return Complexe(re: self.re,im: -self.im)
      }
   }
   
   /*********************************************************
    Implémente la transformation d'un Double en Complexe
    par .i
    *********************************************************/
   public var i: Complexe
   {
      get
      {
         return Complexe(re: -self.im, im: self.re)
      }
   }
   
   public init()
   {
      (re, im) = (0.0, 0.0)
   }
   
   public init(_ re: Double )
   {
      (self.re, self.im) = (re, 0.0)
   }

   public init(re: Double,im: Double )
   {
      (self.re, self.im) = (re, im)
   }
   
   
   /**
    /// Implémente la conversion en String pour "\(Complexe)"
    */
   public var description: String
   {
      let threshold: Double = 0.00000001
      
      if fabs(re) > threshold && fabs(im) > threshold
      {
         return "\(re) + \(im)i"
      }
      else if fabs(im) > threshold
      {
         return "\(im)i"
      }
      else {
         return "\(re) + 0i"
         //return "\(re)"
      }
   }
   
   /// pour respecter le protocol TypeArithmetique
   public prefix static func + (_ z: Complexe) -> Complexe
   {
      return z
   }
   public prefix static func - (_ z: Complexe) -> Complexe
   {
      return Complexe(re: -z.re,im: -z.im)
   }
   
   /**********************************************************************
    Implémente la somme de 2 Complexe qui retourne un Complexe
    Doit être déclaré "static" (pourquoi ?)
    **********************************************************************/
   public static func +(lhs: Complexe,rhs: Complexe) -> Complexe
   {
      return Complexe(re: lhs.re+rhs.re ,im: lhs.im+rhs.im)
   }
   /**********************************************************************
    Implémente la somme d'un Complexe et d'un Double
    **********************************************************************/
   public static func +(lhs: Complexe,rhs: Double) -> Complexe
   {
      return Complexe(re: lhs.re+rhs,im: lhs.im+rhs)
   }
   /**********************************************************************
    Implémente la somme d'un Double et d'un Complexe
    **********************************************************************/
   public static func +(lhs: Double,rhs: Complexe) -> Complexe
   {
      return Complexe(re: lhs+rhs.re ,im: lhs+rhs.im)
   }
   
   
   
   
   /**********************************************************************
    Implémente la différence de 2 Complexe qui retourne un Complexe
    Doit être déclaré "static" (pourquoi ?)
    **********************************************************************/
   public static func -(lhs: Complexe,rhs: Complexe) -> Complexe
   {
      return Complexe(re: lhs.re-rhs.re ,im: lhs.im-rhs.im)
   }
   /**********************************************************************
    Implémente la différence d'un Complexe et d'un Double
    **********************************************************************/
   public static func -(lhs: Complexe,rhs: Double) -> Complexe
   {
      return Complexe(re: lhs.re-rhs,im: lhs.im-rhs)
   }
   /**********************************************************************
    Implémente la différence d'un Double et d'un Complexe
    **********************************************************************/
   public static func -(lhs: Double,rhs: Complexe) -> Complexe
   {
      return Complexe(re: lhs-rhs.re ,im: lhs-rhs.im)
   }
   
   
   /**********************************************************************
    Implémente le produit de 2 Complexe qui retourne un Complexe
    Doit être déclaré "static" (pourquoi ?)
    **********************************************************************/
   public static func *(lhs: Complexe,rhs: Complexe) -> Complexe
   {
      return Complexe(re: lhs.re*rhs.re - lhs.im*rhs.im, im: lhs.re*rhs.im + lhs.im*rhs.re)
   }
   /**********************************************************************
    Implémente le produit d'un Double et d'un Complexe qui retourne un Complexe
    **********************************************************************/
   public static func *(lhs: Double,rhs: Complexe) -> Complexe
   {
      return Complexe(re: lhs*rhs.re, im: lhs*rhs.im)
   }
   /**********************************************************************
    Implémente le produit d'un Complexe et d'un Double qui retourne un Complexe
    **********************************************************************/
   public static func *(lhs: Complexe,rhs: Double) -> Complexe
   {
      return Complexe(re: rhs*lhs.re, im: rhs*lhs.im)
   }
   
   /**********************************************************************
    Implémente le quotient de 2 Complexe qui retourne un Complexe
    **********************************************************************/
   public static func /(lhs: Complexe,rhs: Complexe) -> Complexe
   {
      if (rhs == (0.0 + 0.0¡))
      {
         return Complexe(re: Double.infinity, im: Double.infinity)
      } else
      {
         let invDeRhs = (rhs.conj)/(rhs.mod*rhs.mod)
         return lhs * (invDeRhs)
      }
   }
   /**********************************************************************
    Implémente le quotient d'un Complexe par un Double
    **********************************************************************/
   public static func /(lhs: Complexe,rhs: Double) -> Complexe
   {
      if (rhs == 0)
      {
         return Complexe(re: Double.infinity, im: Double.infinity)
      } else
      {
         return Complexe(re: lhs.re/rhs, im: lhs.im/rhs)
      }
   }
   /**********************************************************************
    Implémente le quotient d'un Double par un Complexe
    **********************************************************************/
   public static func /(lhs: Double,rhs: Complexe) -> Complexe
   {
      if (rhs == (0 + 0¡))
      {
         return Complexe(re: Double.infinity, im: Double.infinity)
      } else
      {
         let invDeRhs = (rhs.conj)/(rhs.mod*rhs.mod)
         return lhs * (invDeRhs)
      }
   }
   
   /**********************************************************************
    Implémente le test d'égalité de 2 Complexe
    **********************************************************************/
   public static func == (lhs: Complexe,rhs: Complexe) -> Bool
   {
      return (lhs.re==rhs.re)&&(lhs.im==rhs.im)
   }
   
   public static func += (left: inout Complexe, right: Complexe)
   {
      left = left + right
   }
   
   /*********************************************************************
   /// Surcharge de la func abs(Double) dans le cas d'un Complexe
   /**********************************************************************/
   public static func abs(_ z: Complexe) -> Double
   {
      return z.mod
   }
   */
   
}
/*============================================================*/



// en fait ¡ est obtenu par option-! (i.e. alt-!)
postfix operator ¡
postfix func ¡ (x: Double) -> Complexe
{
   return Complexe(re: 0, im: x)
}
prefix operator ¡
prefix func ¡ (x: Double) -> Complexe
{
   return Complexe(re: 0, im: x)
}

