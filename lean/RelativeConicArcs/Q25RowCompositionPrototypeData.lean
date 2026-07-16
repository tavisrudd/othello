import RelativeConicArcs.Q25LineMaskComposition

/-!
# Generated C151 row-composition prototype data

DO NOT EDIT: proposal data for canonical row `(5,58,169)`, generated from
`notes/2026-07-15-c151-shared-line-composition.py`.

* generator SHA256: `ee8c47c66f49d5a0829c4730bce06e4f83760ec1a0357e09efebdeecd38e0bf4`
* compact payload SHA256: `4a6e3451c4c92e15fd86cd7637471b343aa8809ce3bc1a173b103ae2796b0ae9`
* shared line-data SHA256: `a67b4321bce4d034630b311ec249ae5e589a62fd57b580568d38326cc956231d`

The secant tables are total.  Above the diagonal, `secantScale i j` certifies
`crossVec (configPoint i) (configPoint j)`.  Below the diagonal the scale is its negation;
diagonal entries are arbitrary because the certificate premises require distinct points.
-/

namespace RelativeConicArcs
namespace Q25RowCompositionPrototypeData

open Q25Coordinates Q25PairCertificate Q25MinimumMask FiniteFields

def orbit5 : OrbitCode := orbitCodeOfNumber ⟨5, by decide⟩
def orbit58 : OrbitCode := orbitCodeOfNumber ⟨58, by decide⟩
def orbit169 : OrbitCode := orbitCodeOfNumber ⟨169, by decide⟩

def legalMask : OrbitMask :=
  ![79529909420032, 1155454788065951744, 14699749183737857088,
    18309071988326403, 0]

def secantLineNumber : Fin 8 → Fin 8 → Fin 651 := ![
  ![0, 0, 250, 375, 525, 150, 400, 275],
  ![0, 0, 10, 15, 16, 11, 7, 22],
  ![250, 10, 0, 629, 395, 424, 568, 303],
  ![375, 15, 629, 0, 284, 255, 428, 188],
  ![525, 16, 395, 284, 0, 77, 262, 124],
  ![150, 11, 424, 255, 77, 0, 109, 392],
  ![400, 7, 568, 428, 262, 109, 0, 628],
  ![275, 22, 303, 188, 124, 392, 628, 0]
]

def secantScale : Fin 8 → Fin 8 → K25 := ![
  ![GF25.ofNat 1, GF25.ofNat 4, GF25.ofNat 20, GF25.ofNat 5,
    GF25.ofNat 24, GF25.ofNat 9, GF25.ofNat 22, GF25.ofNat 7],
  ![GF25.ofNat 1, GF25.ofNat 1, GF25.ofNat 5, GF25.ofNat 20,
    GF25.ofNat 8, GF25.ofNat 23, GF25.ofNat 19, GF25.ofNat 14],
  ![GF25.ofNat 5, GF25.ofNat 20, GF25.ofNat 1, GF25.ofNat 10,
    GF25.ofNat 10, GF25.ofNat 10, GF25.ofNat 9, GF25.ofNat 6],
  ![GF25.ofNat 20, GF25.ofNat 5, GF25.ofNat 15, GF25.ofNat 1,
    GF25.ofNat 15, GF25.ofNat 15, GF25.ofNat 21, GF25.ofNat 24],
  ![GF25.ofNat 6, GF25.ofNat 22, GF25.ofNat 15, GF25.ofNat 10,
    GF25.ofNat 1, GF25.ofNat 20, GF25.ofNat 9, GF25.ofNat 6],
  ![GF25.ofNat 21, GF25.ofNat 7, GF25.ofNat 15, GF25.ofNat 10,
    GF25.ofNat 5, GF25.ofNat 1, GF25.ofNat 21, GF25.ofNat 24],
  ![GF25.ofNat 8, GF25.ofNat 11, GF25.ofNat 21, GF25.ofNat 9,
    GF25.ofNat 21, GF25.ofNat 9, GF25.ofNat 1, GF25.ofNat 5],
  ![GF25.ofNat 23, GF25.ofNat 16, GF25.ofNat 24, GF25.ofNat 6,
    GF25.ofNat 24, GF25.ofNat 6, GF25.ofNat 20, GF25.ofNat 1]
]

end Q25RowCompositionPrototypeData
end RelativeConicArcs
