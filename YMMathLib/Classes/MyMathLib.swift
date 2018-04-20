import Foundation
import CoreGraphics



let epsilonCar = "\u{03B5}"

postfix operator °

/*===========================================================================
 Extension de String pour les sous-chaines
 https://stackoverflow.com/questions/32305891/index-of-a-substring-in-a-string-with-swift
 ===========================================================================*/
public extension String
{
   public func index(of string: String, options: CompareOptions = .literal) -> Index?
   {
      return range(of: string, options: options)?.lowerBound
   }
   
   public func endIndex(of string: String, options: CompareOptions = .literal) -> Index?
   {
      return range(of: string, options: options)?.upperBound
   }
   
   public func indexes(of string: String, options: CompareOptions = .literal) -> [Index]
   {
      var result: [Index] = []
      var start = startIndex
      while let range = range(of: string, options: options, range: start..<endIndex) {
         result.append(range.lowerBound)
         start = range.lowerBound < range.upperBound ? range.upperBound : index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
      }
      return result
   }
   
   public func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>]
   {
      var result: [Range<Index>] = []
      var start = startIndex
      while let range = range(of: string, options: options, range: start..<endIndex)
      {
         result.append(range)
         start = range.lowerBound < range.upperBound ? range.upperBound : index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
      }
      return result
   }
   /*------------------------------------------------------------------------------------
    Retourne la sous-chaine comprise entre la chaineG(auche) et la chaineD(roite)
    TODO : ajouter un reour nil possible -> String?
   ------------------------------------------------------------------------------------*/
   public func substringWithStringBounds(de chaineG: String, a chaineD: String) -> String
   {
      var result = ""
      if let lowerBound = self.range(of: chaineG)?.upperBound,let upperBound = self.range(of: chaineD)?.lowerBound
      {
         result = String(self[lowerBound..<upperBound])
      } else
      {
         print(" Pb dans 'substringWithStringBounds' ")
      }
      
      return result
   }
}
/*===========================================================================*/

/******************************************************************
 
      Extension du type générique Range pour les Double
 
 ******************************************************************/
public protocol _Double {}
extension Double: _Double {}

public extension Range where Bound: _Double
{
   /*********************************************************
    Implémente le "+" d'un Range<Double> et d'un Double
    ("shift" le Range)
    *********************************************************/
   public static func +(lhs: Range, rhs: Bound) -> Range
   {
      let lowerB:Double = lhs.lowerBound as! Double
      let upperB:Double = lhs.upperBound as! Double
      let shift:Double = rhs as! Double
      var result: Range = lowerB + shift  ..< upperB + shift as! Range<Bound>
      return result
   }
}

/******************************************************************
 Dans MyMathLib
 Extension du type générique Dictionary pour retrouver une Key
 à partir d'une Value (si le Dictionary est bijectif)
 https://stackoverflow.com/questions/27218669/swift-dictionary-get-key-for-value
 ******************************************************************/

public extension Dictionary where Value: Equatable
{
   public func someKey(forValue val: Value) -> Key?
   {
      return first(where: { $1 == val })?.key
   }
}
/*-------------------------------
Example usage:

let dict: [Int: String] = [1: "one", 2: "two", 4: "four"]

if let key = dict.someKey(forValue: "two") {
   print(key)
} // 2
-------------------------------*/


/******************************************************************
 
         Extension des types Int, Float, Double
 pour la génération de nombres aléatoires
 
 ******************************************************************/

/********************************************************************
// MARK: Int Extension
********************************************************************/
public extension Int
{
   
   /// Returns a random Int point number between 0 and Int.max.
   public static var random: Int
   {
      return Int.random(n: Int.max)
   }
   
   /// Random integer between 0 and n-1.
   ///
   /// - Parameter n:  Interval max
   /// - Returns:      Returns a random Int point number between 0 and n max
   public static func random(n: Int) -> Int
   {
      return Int(arc4random_uniform(UInt32(n)))
   }
   
   ///  Random integer between min and max
   ///
   /// - Parameters:
   ///   - min:    Interval minimun
   ///   - max:    Interval max
   /// - Returns:  Returns a random Int point number between 0 and n max
   public static func random(min: Int, max: Int) -> Int
   {
      return Int.random(n: max - min + 1) + min
   }
   
   /*----------------------------------------------------------------
    Retourne un tirage d'une variable aléatoire N entière, 0≤N<n
    dont la distribution de probabilté est donnée par un tableau
    ordonné de n "Double" représentant les Pr(N=i) 0≤i<n
    TODO: Gérer les erreurs de dim. éventuelles
   ----------------------------------------------------------------*/
   public static func random(proba: [Double]) -> Int
   {
      // --- on génère n Range partitionnant le Range 0..<1 selon la distrib. de proba.
      var lesProbas = proba
      let nbPoints = lesProbas.count
      var intCourant:Range = 0.0..<lesProbas[0]
      var lesIntervalles:[Range<Double>] = [intCourant]
      var shift = lesProbas[0]
      //lesProbas.remove(at: 0)
      for i in 1..<nbPoints
      {
         intCourant = (0.0..<lesProbas[i]) + shift
         lesIntervalles.append(intCourant)
         shift += lesProbas[i]
      }
      // --- on a notre tableau de n Range
      // on tire un nb au hasard entre 0..<1
      let alea = Double.random
      // --- on regarde dans quel intervalle tombe ce nb tiré au hasard
      for i in 0..<nbPoints
      {
         if lesIntervalles[i].contains(alea)
         {
            return i
         }
      }
      
      // --- normalement on devtait être sorti avant !!
      return 0
   }
}

/********************************************************************
// MARK: Double Extension
 ********************************************************************/
public extension Double
{
   
   /// Returns a random floating point number between 0.0 and 1.0, inclusive.
   /// (maintenant 1.0 exclu)
   public static var random: Double
   {
      var result = Double(arc4random()) / 0xFFFFFFFF
      while result == 1.0
      {
         result = Double.random
      }
      return result
   }
   
   /// Random double between 0 and n-1.
   ///
   /// - Parameter n:  Interval max
   /// - Returns:      Returns a random double point number between 0 and n max
   public static func random(min: Double, max: Double) -> Double
   {
      return Double.random * (max - min) + min
   }
}

/********************************************************************
// MARK: Float Extension
 ********************************************************************/
public extension Float
{
   
   /// Returns a random floating point number between 0.0 and 1.0, inclusive.
   public static var random: Float
   {
      return Float(arc4random()) / 0xFFFFFFFF
   }
   
   /// Random float between 0 and n-1.
   ///
   /// - Parameter n:  Interval max
   /// - Returns:      Returns a random float point number between 0 and n max
   public static func random(min: Float, max: Float) -> Float
   {
      return Float.random * (max - min) + min
   }
}

/********************************************************************
// MARK: CGFloat Extension
 ********************************************************************/
public extension CGFloat
{
   
   /// Randomly returns either 1.0 or -1.0.
   public static var randomSign: CGFloat
   {
      return (arc4random_uniform(2) == 0) ? 1.0 : -1.0
   }
   
   /// Returns a random floating point number between 0.0 and 1.0, inclusive.
   public static var random: CGFloat
   {
      return CGFloat(Float.random)
   }
   
   /// Random CGFloat between 0 and n-1.
   ///
   /// - Parameter n:  Interval max
   /// - Returns:      Returns a random CGFloat point number between 0 and n max
   public static func random(min: CGFloat, max: CGFloat) -> CGFloat
   {
      return CGFloat.random * (max - min) + min
   }
}

/*????????????????????? Usage ???????????????????????????????
 
 let randomNumDouble  = Double.random(min: 0.00, max: 23.50)
 let randomNumInt     = Int.random(min: 56, max: 992)
 let randomNumFloat   = Float.random(min: 6.98, max: 923.09)
 let randomNumCGFloat = CGFloat.random(min: 6.98, max: 923.09)
 
????????????????????????????????????????????????????????????*/


public class Vecteur: CustomStringConvertible, Equatable
{
   
   // Tableau qui contient les composantes du vecteur
   // TODO : rendre data non public en créant public func array() -> [Double]
   public var data: [Double] = []
   // Dimension du vecteur. Par défaut vecteur colonne, nbc=1
   var (nbl, nbc) = (0,1)
   
   
   public init(_ datas: [Double])
   {
      for element in datas
      {
         self.data.append(element)
      }
      self.nbc = 1
      self.nbl = data.count
   }
   
   public init(_ datas: [Int])
   {
      for element in datas
      {
         self.data.append(Double(element))
      }
      self.nbc = 1
      self.nbl = data.count
   }
   
   public init(_ vec: Vecteur)
   {
      self.data = vec.data
      self.nbc = vec.nbc
      self.nbl = vec.nbl
   }
   
   /*********************************************************
    Implémente la notion d'indice (subscript) pour "\(Vecteur)"
    *********************************************************/
   public subscript(x: Int) -> Double
   {
      get {
         return self.data[x]
      }
      set {
         self.data[x] = newValue
      }
   }
   
   /*********************************************************
    Implémente la conversion en String pour "\(Vecteur)"
    *********************************************************/
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
   
   /*********************************************************
    Implémente la transposition d'un vecteur
    Retourne le transposé du Vecteur
    *********************************************************/
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
   
   /*********************************************************
    Retourne la somme des éléments du Vecteur
    *********************************************************/
   public func somme() -> Double
   {
      var result = 0.0
      for element in self.data
      {
         result += element
      }
      return result
   }
   
   /*********************************************************
    Retourne le Vecteur sous forme d'un Array de Double (self.data)
    *********************************************************/
   public func array() -> [Double]
   {
      return self.data
   }

}



/***********************************************************
 Pour pouvoir manipuler des tableaux de (Int,Int)
 grâce au protocole Hashable
 ***********************************************************/
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
   /*********************************************************
    Implémente le "==" de 2 CoupleInt
    (pour se conformer au protocole Equatable)
    *********************************************************/
   public static func ==(lhs: CoupleInt, rhs: CoupleInt) -> Bool
   {
      return (lhs.nb1 == rhs.nb1) && (lhs.nb2 == rhs.nb2)
   }
   /*********************************************************
    Implémente la conversion en String pour "\(CoupleInt)"
    *********************************************************/
   public var description: String
      //public func description() -> String
   {
      return "("+String(self.nb1)+","+String(self.nb2)+")"
   }
}

