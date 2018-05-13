import Foundation
import CoreGraphics



let epsilonCar = "\u{03B5}"

postfix operator °


/*============================================================*/
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


/*===========================================================================
 Extension de String pour les sous-chaines
 https://stackoverflow.com/questions/32305891/index-of-a-substring-in-a-string-with-swift
 ===========================================================================*/
public extension String
{
   init(form: String, _ z: Complexe)
   {
      let result: String = String(format: form,z.re)+" + "+String(format: form,z.im)+"i"
      self = result
   }

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
    TODO : ajouter un retour nil possible -> String?
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
      let result: Range = lowerB + shift  ..< upperB + shift as! Range<Bound>
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

/********************************************************************/
// MARK: Int Extension
/********************************************************************/
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
 extension Double: TypeArithmetique
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


/******************************************************************
 
   ?
 

 
 ******************************************************************/

public func typeDe<T>(_ x: T)
{
   if x is Int
   {
      print("x est un Int")
   } else
      if x is Matrice<Double>
   {
         print("x est une Matrice de Double")
   } else
      if x is Vecteur<Double>
      {
         print("x est un Vecteur de Double")
   } else
   {
         print("x est de type inconnu !")
   }
   

}

