//
//  Matrice.swift
//  MyMathLibPackageDescription
//
//  Created by Yann Meurisse on 29/01/2018.
//
//  Modifié le 06/02/2018 à 16H20 depuis StatNotes
//
// Nouvelle version où les données (data) de la Matrice sont
// lues colonne par colonne

import Foundation
import Accelerate

postfix operator °

/*********************************************************/
/// Implémente la notion mathématique de Matrice (de Double)
/// avec les principales opérations classiques :
///
/// TODO: Lister les opérations
/*********************************************************/
public class Matrice<T: TypeArithmetique>: CustomStringConvertible
{
   // Tableau qui contient les composantes du vecteur
   //  ATTENTION : lues colonne par colonne !!
   var data: [T] = []
   // Dimension du vecteur.
   var (nbl, nbc) = (0,0)
   
   /********************************************************/
   /// Initialise la Matrice
   ///
   /// - parameters:
   ///   - datas: : Tableau (unidimensionnel) des T, de longueur
   ///   nbl*nbc, rangés implicitement ligne par ligne
   ///   - nbl: : Nombre de lignes
   ///   - nbc: : Nombre de colonnes
    /*********************************************************/
   public init(_ datas: [T], nbl: Int, nbc: Int)
   {
      if datas.count == nbl*nbc
      {
         for element in datas
         {
            self.data.append(element)
         }
         self.nbc = nbc
         self.nbl = nbl
      } else
      {
         print("Erreur : Nb d'éléments du tableau != nbl*nbc !!")
      }
   }
 
   /********************************************************/
   /// Initialise la Matrice
   ///
   /// - parameters:
   ///   - datas: : Tableau (unidimensionnel) des T, de longueur
   ///   nbl*nbc, rangés implicitement ligne par ligne
   ///   - nbl: : Nombre de lignes
   ///   - nbc: : Nombre de colonnes
   ///   - rangement: : si = "l" ou "L" => rangement ligne/ligne
   ///                  sinon rangement par défaut (colonne/colonne)
   /*********************************************************/
   public init(_ datas: [T], nbl: Int, nbc: Int, rangement: String)
   {
      if datas.count == nbl*nbc
      {
         if rangement == "l" || rangement == "L"
         {
            let T = (Matrice(datas, nbl: nbc,  nbc: nbl ))°
            self.data = T.data
            print(" on passe par rangement == \"l\"")
         }
         else
         {
            for element in datas
            {
               self.data.append(element)
            }
         }
         self.nbc = nbc
         self.nbl = nbl
      } else
      {
         print("Erreur : Nb d'éléments du tableau != nbl*nbc !!")
      }
   }

   public init(_ M: Matrice)
   {
      self.data = M.data
      self.nbc = M.nbc
      self.nbl = M.nbl
   }
   
   public init(nbl: Int, nbc: Int)
   {
      self.data = Array(repeating: T.init(), count: nbl*nbc)
      self.nbc = nbc
      self.nbl = nbl
   }
   
   public init(nbl: Int)
   {
      self.data = Array(repeating: T.init(), count: nbl*nbl)
      self.nbl = nbl
      self.nbc = nbl
   }
   
   
   
   /*********************************************************/
   /// Implémente la conversion en String pour "\\(Matrice)"
   /*********************************************************/
   public var description: String
   {
      var result = ""
      
      for l in 0...nbl-1
      {
         for c in 0...nbc-1
         {
            let element: T = data[c*nbl + l]
            //on envisage 2 traitements ≠ selon le type de T (Double ou Complexe)
            if let double = element as? Double // si T : Double
            {
               if double == 0.0
               {
                  result += "0.0 \t"
               }
               else if abs(double) < 1.0e-10
               {
                  result += " "+epsilonCar+" \t"
               } else
               {
                  result += String(format: "%.3f", double)+"\t"
               }
            }
            if let complexe = element as? Complexe
            {
               if complexe == Complexe.init()
               {
                  result += "0.0 \t"
               }
               else if complexe.mod < 1.0e-10
               {
                  result += " "+epsilonCar+" \t"
               } else
               {
                  result += String(form: "%.3f", complexe)+"\t"
               }
            }
         }
         result.removeLast()
         result += "\n"
      }
      return result
   }

   /*********************************************************/
   /// Retourne la dim. de la matrice sous forme de String
   /*********************************************************/
   public func dim() -> String
   {
      return "\(self.nbl)X\(self.nbc)"
   }

   /*********************************************************
    Implémente la notion d'indice (subscript) pour "\(Matrice)"
    *********************************************************/
   public subscript(_ x: Int,_ y: Int) -> T
   {
      get {
         return self.data[y*self.nbl + x]
      }
      set {
         self.data[y*self.nbl + x] = newValue
      }
   }
   
   /*********************************************************/
   /// Implémente la transposition d'une Matrice à l'aide d'un
   /// opérateur postfixé "°"
   /// Retourne la transposée de la Matrice
   /*********************************************************/
   public static postfix func °(m: Matrice) -> Matrice
   {
      var data: [T] = []
      
      for i in 0...m.nbl-1
      {
         for j in 0...m.nbc-1
         {
            data.append(m[i,j])
         }
      }
      
      return Matrice(data,nbl: m.nbc,nbc: m.nbl)
   }
   
   /*********************************************************
    Implémente le "*" de 2 Matrices
    TODO : vérifier compatibilité des dimensions
    *********************************************************/
   public static func *(lhs: Matrice, rhs: Matrice) -> Matrice?
   {
      if (lhs.nbc != rhs.nbl)
      {
         print("Dimensions incompatibles !")
         return nil
      } else
      {
         var data: [T] = []
         for i in 0...rhs.nbc-1
         {
            for j in 0...lhs.nbl-1
            {
               data.append((lhs.ligne(j)*rhs.colonne(i))!)
            }
         }
         return Matrice(data,nbl: lhs.nbl,nbc: rhs.nbc)
      }
   }
   
   /*********************************************************
    Implémente le "*" d'un scalaire et d'une Matrice
    *********************************************************/
   public static func *(lhs: T,rhs: Matrice) -> Matrice?
   {
      var data: [T] = []
      for elem in rhs.data
      {
         data.append(lhs*elem)
      }
      return Matrice(data,nbl: rhs.nbl,nbc: rhs.nbc)
   }
   /*********************************************************
    Implémente le "/" d'une Matrice et d'un scalaire (Double)
    TODO : gérer diviseur = 0.0
    (sans doute peux mieux faire avec func generic)
    *********************************************************/
   public static func /(lhs: Matrice, rhs: T) -> Matrice?
   {
      var data: [T] = []
      for elem in lhs.data
      {
         data.append(elem/rhs)
      }
      return Matrice(data,nbl: lhs.nbl,nbc: lhs.nbc)
   }
   /*********************************************************
    Implémente le "/" d'une Matrice et d'un scalaire (Int)
    TODO : gérer diviseur = 0.0
    (sans doute peux mieux faire avec func generic)
    ********************************************************
   public static func /(lhs: Matrice, rhs: Int) -> Matrice?
   {
      var data: [Double] = []
      for elem in lhs.data
      {
         data.append(elem/Double(rhs))
      }
      return Matrice(data,nbl: lhs.nbl,nbc: lhs.nbc)
   }
    */

   /*********************************************************/
   /// Fonction qui retourne une ligne, sous forme d'un Vecteur,
   /// de la matrice.
   ///
   /// TODO: Gérer les erreurs d'indice
   /// - parameters:
   ///   - ind: : Indice de la ligne à retourner 0 ≤ .. < nbl
   /*********************************************************/
   public func ligne(_ ind: Int) -> Vecteur<T>
   {
      var tempArray: [T] = []
      
      for i in stride(from: ind, to: ind+(self.nbl)*(self.nbc), by: self.nbl)
      {
         tempArray.append(self.data[i])
      }
      return Vecteur(tempArray).transpose()

   }
   
   /*********************************************************/
   /// Fonction qui retourne une colonne, sous forme d'un Vecteur,
   /// de la matrice
   ///
   /// TODO: Gérer les erreurs d'indice
   /// - parameters:
   ///   - ind: : Indice de la ligne à retourner 0 ≤ .. < nbc
   /*********************************************************/
   public func colonne(_ ind: Int) -> Vecteur<T>
   {
      return (Vecteur(Array(self.data[ind*self.nbc...(ind+1)*self.nbc - 1])))
   }
   
   /*******************************************************************/
   /// Retourne une matrice Identité de même dimension
   
   /********************************************************************/
   public func eye() -> Matrice
   {
      let zeros = Array(repeating: T.init(), count: self.nbl*self.nbc)
      let I = Matrice(zeros,nbl: self.nbl, nbc: self.nbc)
      for i in 0...self.nbc-1
      {
         I[i,i] = T.init(1.0)
      }
      return I
   }
 
   /*******************************************************************/
   /// Retourne la matrice "stochastique" associée :
   /// somme des éléments de chaque lignes (tous≥0) = 1
   /// TODO: à adapter au fait que cette fonction n'est valable que pour T = Double
   /*******************************************************************
   public func stochastique() -> Matrice?
   {
      let result = Matrice(self)
      for x in 0...self.nbl-1
      {
         let coef = (self.ligne(x)).somme()
         if coef != 0.0
         {
            for y in 0...self.nbc-1
            {
               result[x,y] /= coef
            }
         }
         /*
         else
         {
            print("Pb : somme d'une ligne = 0")
            return nil
         }
          */
      }
      return result
   }
   */
   
   /*******************************************************************/
   /// Fonction qui retourne une Matrice trangulaire sup. "équivalente"
   /// à la Matrice (carrée) fournie.
   ///
   /// Fonction utilisée pour l'inversion par pivot de Gauss
   ///
   /// TODO: Gérer les erreurs d'indice
   ///
   /// En principe : plus utile !?!
   /******************************************************************
   public func triangSup(_ A: Matrice) -> Matrice
   {
      let B: Matrice = Matrice(A)
      let n = A.nbc
      
      for j in 0...n-2
      {
         // On trouve i entre j et n-1 tel que |A(i,j)| soit maximal
         var indTrouve = j
         var absAijCourant: Double = abs(A[indTrouve,j] )
         
         for i in j+1...n-1
         {
            if abs(A[i,j]) > absAijCourant
            {
               indTrouve = i
               absAijCourant = abs(A[i,j])
            }
         }
         // On échange Ligne(indTrouve) et Ligne(j)
         let tempo = B.data[indTrouve*n...(indTrouve+1)*n-1]
         B.data[indTrouve*n...(indTrouve+1)*n-1] = B.data[j*n...(j+1)*n-1]
         B.data[j*n...(j+1)*n-1] = tempo
         
         // on fait apparaitre les "0" sous la diagonale
         for i in j+1...n-1
         {
            let ligneTempo = B.ligne(i) - (B[i,j]/B[j,j]) * B.ligne(j)
            B.data[i*n...(i+1)*n-1] = (ligneTempo?.data[0...n-1])!
         }
      }
      return B
   }
   */

}
/*=========================================================================*/
//   Fin de la définition de la class Matrice
/*=========================================================================*/


/*********************************************************/
/// Retourne une matrice diagonale à partir d'un Vecteur
/*********************************************************/
public func diag<T: TypeArithmetique> (v: Vecteur<T>) -> Matrice<T>
{
   let nbElem = max(v.nbl,v.nbc)
   let result: Matrice<T> = Matrice(nbl: nbElem, nbc: nbElem)
   for i in 0...nbElem-1
   {
      result[i,i]  = v[i]
   }
   return result
}

/*********************************************************/
/// Retourne une matrice diagonale de "nbl" lignes et
/// "nbc" colonnes à partir d'un Vecteur
/// à faire : vérifier compatibilité des nombres
/*********************************************************/
public func diag<T: TypeArithmetique>(v: Vecteur<T>, nl: Int, nc: Int) -> Matrice<T>
{
   let nbElem = max(v.nbl,v.nbc)
   let result: Matrice<T> = Matrice(nbl: nl, nbc: nc)
   for i in 0...nbElem-1
   {
      result[i,i]  = v[i]
   }
   return result
}



/*******************************************************************/
/// Fonction qui retourne l'inverse d'une Matrice carrée
///
///Utilise Lapack
///
///      let A = Matrice([8.0,1,6,3,5,7,4,9,2],nbl: 3,nbc: 3)
///      let B = invert(A)
///
/// TODO: Gérer les erreurs d'indice
/// TODO: Gérer les matrices non inversibles
/*******************************************************************/
public func inv(_ x: Matrice<Double>) -> Matrice<Double>
{
   
   let nbl = x.nbl
   let nbc = x.nbc
   
   var inMatrix: [Double] = x.data
   var N = __CLPK_integer(sqrt(Double(inMatrix.count)))
   var pivots = [__CLPK_integer](repeating: 0, count: Int(N))
   var workspace = [Double](repeating: 0.0, count: Int(N))
   var error : __CLPK_integer = 0
   
   withUnsafeMutablePointer(to: &N)
   {
      dgetrf_($0, $0, &inMatrix, $0, &pivots, &error)
      dgetri_($0, &inMatrix, $0, &pivots, &workspace, $0, &error)
   }
   let y = Matrice(inMatrix,nbl: nbl,nbc: nbc)
   return y
}

/*******************************************************************/
/// Décomposition en valeurs singulières,
/// retourne un tuple
///
/// Utilise Lapack
///
/// A = U * SIGMA * V^t
///
///      let A = Matrice([8.0,1,6,3,5,7,4,9,2],nbl: 3,nbc: 3)
///      let Results = svd(A)
///      let UU = Results.U
///      let D = Results.D
///      let VV = Results.V
///
/// TODO: Gérer les erreurs d'indice
///
/// Rem: Attention avec Lapack les éléments d'une matrice sont lus
/// colonne par colonne !!
/*******************************************************************/
public func svd(_ x: Matrice<Double>) -> (U: Matrice<Double>, D: Matrice<Double>, V: Matrice<Double>)
{
   let nbl = x.nbl
   let nbc = x.nbc
   
   let resU: Matrice<Double>
   let resD: Matrice<Double>
   let resV: Matrice<Double>


   var singleChar = "G"
   var JOBA = Int8(UInt8(ascii: singleChar.unicodeScalars[singleChar.startIndex]))
   singleChar = "U"
   var JOBU = Int8(UInt8(ascii: singleChar.unicodeScalars[singleChar.startIndex]))
   singleChar = "V"
   var JOBV = Int8(UInt8(ascii: singleChar.unicodeScalars[singleChar.startIndex]))

   //let JOBA = "G"
   //let JOBU = "U"
   //let JOBV = "V"
   var M = __CLPK_integer(nbl)
   var N = __CLPK_integer(nbc)
   var A: [Double] = (x).data      // Au retour : colonnes orthogonales de la matrice U
   var LDA = __CLPK_integer(nbl)
   var SVA = [Double](repeating: 0.0, count: Int(N))  // Les valeurs singulières de A
   var MV : __CLPK_integer = 0
   //var V: [[Double]] = Array(repeating: Array(repeating: 0.0, count: nbc), count: nbc)
   var V = [Double](repeating: 0.0, count: Int(N*N))  // Vecteurs singuliers à droite
   var LDV = __CLPK_integer(nbc)
   
   let lwork = max(6,nbl+nbc)
   var WORK = [Double](repeating: 0.0, count: lwork)
   var LWORK = __CLPK_integer(lwork)
   
   var INFO : __CLPK_integer = 0
   
   dgesvj_(&JOBA,&JOBU,&JOBV,&M,&N,&A,&LDA,&SVA,&MV,&V,&LDV,&WORK,&LWORK,&INFO)
      
   resU = Matrice(A,nbl: nbl,nbc: nbc)
   resD = diag(v: Vecteur(SVA))
   resV = Matrice(V,nbl: nbc,nbc: nbc)
   
   return(resU,resD,resV)
}

