module Examples.Power where

open import Utility
open import Environment

import TDPE.Smart.Type as T
import TDPE.Smart.HOAS as H
import TDPE.Smart.NBE  as NBE

-- Set of base types
data χ : Set where
  ℤₚ : χ
  ℚₚ : χ
  𝕊ₚ : χ

-- equality for base types
setoidₚ : Setoid χ
setoidₚ = record {_≈_ = eqlₚ}
  where
   eqlₚ : (x : χ) → (y : χ) → Dec (x ≡ y)
   eqlₚ ℤₚ ℤₚ = yes refl
   eqlₚ ℤₚ ℚₚ = no (λ ())
   eqlₚ ℤₚ 𝕊ₚ = no (λ ())
   eqlₚ ℚₚ ℤₚ = no (λ ())
   eqlₚ ℚₚ ℚₚ = yes refl
   eqlₚ ℚₚ 𝕊ₚ = no (λ ())
   eqlₚ 𝕊ₚ ℤₚ = no (λ ())
   eqlₚ 𝕊ₚ ℚₚ = no (λ ())
   eqlₚ 𝕊ₚ 𝕊ₚ = yes refl

module TypeM_ = T χ {{setoidₚ}}
open TypeM_

 -- set of literals
Ξ : χ → Set
Ξ ℤₚ = ℤ
Ξ ℚₚ = ℚ
Ξ 𝕊ₚ = 𝕊

 --  show for literals
show𝕃 : ∃ Ξ → 𝕊
show𝕃 (ℤₚ , i) = showℤ i
show𝕃 (ℚₚ , q) = showℚ q
show𝕃 (𝕊ₚ , s) = show𝕊 s

-- useful abbreviations
ℤₜ = 𝔹ₜ ℤₚ
ℚₜ = 𝔹ₜ ℚₚ
𝕊ₜ = 𝔹ₜ 𝕊ₚ

--------------------------------------------
-- encoding host 𝟚 as a sum (index by _ₕ)
---------------------------------------------
-- begin

𝟚ₜ : Typₜ
𝟚ₜ = 𝟙ₜ +ₜ 𝟙ₜ

𝟚ₕ = 𝟙 + 𝟙

from𝟚 : 𝟚 → 𝟚ₕ
from𝟚 false = ι₁ tt
from𝟚 true  = ι₂ tt

to𝟚 : 𝟚ₕ → 𝟚
to𝟚 (ι₁ tt) = false
to𝟚 (ι₂ tt) = true

falseₕ : 𝟚ₕ
falseₕ = from𝟚 false

trueₕ : 𝟚ₕ
trueₕ = from𝟚 true

ifₕ_thenₕ_elseₕ_ : ∀ {a : Set} → 𝟚ₕ → a → a → a
ifₕ l thenₕ m elseₕ n = if to𝟚 l then m else n

-- end
------

--------------------------------------------
-- encoding host Maybe as a sum (index by _ₕ)
---------------------------------------------
-- begin

-- notice the reverse order of unit / Nothing compared to Haskell
Maybeₜ : Typₜ → Typₜ
Maybeₜ a = a +ₜ 𝟙ₜ

Maybeₕ : Set → Set
Maybeₕ a =  a + 𝟙

fromMaybe : ∀ {a : Set} → Maybe a → Maybeₕ a
fromMaybe (just x) = ι₁ x
fromMaybe nothing  = ι₂ tt

toMaybe : ∀ {a : Set} → Maybeₕ a → Maybe a
toMaybe (ι₁ x)  = just x
toMaybe (ι₂ tt) = nothing

justₕ : ∀ {a} → a → Maybeₕ a
justₕ x = fromMaybe (just x)

nothingₕ : ∀ {a} → Maybeₕ a
nothingₕ = fromMaybe nothing

maybeₕ : ∀ {a b : Set} → (a → b) → b → Maybeₕ a → b
maybeₕ M N L = maybe M N (toMaybe L)

-- end
-------

-- signature of primitives
Σ : List (List Typₜ × Typₜ)
Σ = ((ℚₜ ∷  ℚₜ ∷ []) ↦ 𝟚ₜ) ∷ -- _==_
    ((ℚₜ ∷  ℚₜ ∷ []) ↦ ℚₜ) ∷ -- _*_
    ((ℚₜ ∷  ℚₜ ∷ []) ↦ ℚₜ) ∷ -- _/_
    []

-- openning modules specialised with parameters related to "Power" language
module NBEM = NBE χ {{setoidₚ}} Ξ Σ
open NBEM

module HM = H χ {{setoidₚ}} Ξ Σ
open HM

import TDPE.Smart.Evaluation as E
module EM_ = E χ {{setoidₚ}} Ξ Σ
open EM_

import TDPE.Smart.Reification as R
module RM_ = R χ {{setoidₚ}} Ξ Σ
open RM_

import TDPE.Smart.Syntax as Syntax
module SyntaxMM_ = Syntax χ {{setoidₚ}} Ξ Σ
open SyntaxMM_

import TDPE.Smart.Semantic as Semantic
module SemanticMM_ = Semantic χ {{setoidₚ}} Ξ Σ
open SemanticMM_

open module Trm_ {ε : Typₜ → Set} {{d : Trm ε}} = Trm d

--------------------------------------------------------------------------------
-- The following can be generated automatically based on signature etc
--------------------------------------------------------------------------------
-- begin

Pow = Trm
--------------------------------------------------------------------------------
-- Term-Based (Syntax-Based) Domain-Specific Constructs (indexed by _ₜ)
-- The following can be generated automatically based on signature etc.
--------------------------------------------------------------------------------


      -- Odd issue with universe polymorphism
      -- otherwise the type should have been
      --   ℤ → Syn ℤₜ instead of
lℤₜ : ∀ {ε} {{d : Pow ε}} → ℤ → ε ℤₜ
lℤₜ = lₜ
      -- Odd issue with universe polymorphism
      -- otherwise the type should have been
      --   ℚ → Syn ℚₜ instead of
lℚₜ : ∀ {ε} {{d : Pow ε}} → ℚ → ε ℚₜ
lℚₜ = lₜ
      -- Odd issue with universe polymorphism
      -- otherwise the type should have been
      --   𝕊 → Syn 𝕊ₜ instead of
l𝕊ₜ : ∀ {ε} {{d : Pow ε}} → 𝕊 → ε 𝕊ₜ
l𝕊ₜ = lₜ

falseₜ : Syn 𝟚ₜ
falseₜ = ι₁ₜ 1ₜ

trueₜ : Syn 𝟚ₜ
trueₜ  = ι₂ₜ 1ₜ

ifₜ_thenₜ_elseₜ_ : ∀ {a} → SynPrm ((𝟚ₜ ∷ a ∷ a ∷ []) ↦ a)
ifₜ l thenₜ m elseₜ n = δₜ l (λₜ (\ _ -> n)) (λₜ (\ _ -> m))

justₜ : ∀ {a} → SynPrm ((a ∷ []) ↦ Maybeₜ a)
justₜ x = ι₁ₜ x

nothingₜ : ∀ {a} → Syn (Maybeₜ a)
nothingₜ = ι₂ₜ 1ₜ

maybeₜ : ∀ {a b} → SynPrm (((a →ₜ b) ∷ b ∷ Maybeₜ a ∷ []) ↦ b)
maybeₜ M N L = δₜ L (λₜ (λ x → M $ₜ x)) (λₜ (λ _ → N))

_==ℚₜ_ : SynPrm ((ℚₜ ∷ ℚₜ ∷ []) ↦ 𝟚ₜ)
x ==ℚₜ y = pₜ zro (ext x (ext y emp))

_*ℚₜ_ : SynPrm ((ℚₜ ∷ ℚₜ ∷ []) ↦ ℚₜ)
x *ℚₜ y = pₜ (suc zro) (ext x (ext y emp))

_/ℚₜ_ : SynPrm ((ℚₜ ∷ ℚₜ ∷ []) ↦ ℚₜ)
x /ℚₜ y = pₜ (suc (suc zro)) (ext x (ext y emp))

-1ℚₜ : Syn ℚₜ
-1ℚₜ = lℚₜ -1ℚ

0ℚₜ  : Syn ℚₜ
0ℚₜ  = lℚₜ  0ℚ

1ℚₜ  : Syn ℚₜ
1ℚₜ  = lℚₜ  1ℚ

_<$>ₜ_ : ∀ {a b} → SynPrm (((a →ₜ b) ∷ (Maybeₜ a) ∷ []) ↦ Maybeₜ b)
f <$>ₜ m = maybeₜ (λₜ (λ x → justₜ (f $ₜ x))) nothingₜ m

-- end
------
--------------------------------------------------------------------------------
-- Interp'-Based (Interp without outer monad)
--    Domain-Specific Constructs (indexed by _ᵢ)
--------------------------------------------------------------------------------
lℤᵢ : ℤ → Interp' ℤₜ
lℤᵢ i = ι₁ i

lℚᵢ : ℚ → Interp' ℚₜ
lℚᵢ r = ι₁ r

l𝕊ᵢ : 𝕊 → Interp' 𝕊ₜ
l𝕊ᵢ s = ι₁ s

falseᵢ : Interp' 𝟚ₜ
falseᵢ = falseₕ

trueᵢ : Interp' 𝟚ₜ
trueᵢ = trueₕ

ifᵢ_thenᵢ_elseᵢ_ : ∀ {a} → Interp'Prm ((𝟚ₜ ∷ a ∷ a ∷ []) ↦ a)
ifᵢ l thenᵢ m elseᵢ n = return (ifₕ l thenₕ m elseₕ n)

justᵢ : ∀ {a} → Interp'Prm ((a ∷ []) ↦ Maybeₜ a)
justᵢ x = return (justₕ x)

nothingᵢ : ∀ {a} → Interp' (Maybeₜ a)
nothingᵢ = nothingₕ

maybeᵢ : ∀ {a b} → Interp'Prm (((a →ₜ b) ∷ b ∷ Maybeₜ a ∷ []) ↦ b)
maybeᵢ M N L = maybeₕ M (return N) L

-- These {{d}}s everywhere are due to a bug / weakness in Agda
_==ℚᵢ_ : Interp'Prm ((ℚₜ ∷ ℚₜ ∷ []) ↦ 𝟚ₜ)
_==ℚᵢ_       (ι₁ x₁) (ι₁ y₁) = return  (from𝟚     (x₁       ==ℚ  y₁))
_==ℚᵢ_ {{d}} (ι₁ x₁) (ι₂ y₂) = ↑ {{d}} (𝟙ₑ +ₑ 𝟙ₑ) ((lℚₜ x₁) ==ℚₜ y₂)
_==ℚᵢ_ {{d}} (ι₂ x₂) (ι₁ y₁) = ↑ {{d}} (𝟙ₑ +ₑ 𝟙ₑ) (x₂       ==ℚₜ (lℚₜ y₁))
_==ℚᵢ_ {{d}} (ι₂ x₂) (ι₂ y₂) = ↑ {{d}} (𝟙ₑ +ₑ 𝟙ₑ) (x₂       ==ℚₜ y₂)

_*ℚᵢ_ : Interp'Prm ((ℚₜ ∷ ℚₜ ∷ []) ↦ ℚₜ)
ι₁ x₁ *ℚᵢ ι₁ y₁ = return (ι₁       (x₁       *ℚ  y₁))
ι₁ x₁ *ℚᵢ ι₂ y₂ = return (ι₂ (if x₁ ==ℚ 1ℚ
                               then y₂
                               else (lℚₜ x₁) *ℚₜ y₂))
ι₂ x₂ *ℚᵢ ι₁ y₁ = return (ι₂ (if y₁ ==ℚ 1ℚ
                               then x₂
                               else x₂       *ℚₜ (lℚₜ y₁)))
ι₂ x₂ *ℚᵢ ι₂ y₂ = return (ι₂       (x₂       *ℚₜ y₂))

_/ℚᵢ_ : Interp'Prm ((ℚₜ ∷ ℚₜ ∷ []) ↦ ℚₜ)
-- ι₁ x₁ /ℚᵢ ι₁ y₁ = return (ι₁ (x₁      ℚ/ y₁)) -- since Agda has issues
ι₁ x₁ /ℚᵢ ι₁ y₁ = return (ι₂ ((lℚₜ x₁) /ℚₜ (lℚₜ y₁)))
ι₁ x₁ /ℚᵢ ι₂ y₂ = return (ι₂ ((lℚₜ x₁) /ℚₜ y₂))
ι₂ x₂ /ℚᵢ ι₁ y₁ = return (ι₂ (x₂       /ℚₜ (lℚₜ y₁)))
ι₂ x₂ /ℚᵢ ι₂ y₂ = return (ι₂ (x₂       /ℚₜ y₂))

-1ℚᵢ : Interp' ℚₜ
-1ℚᵢ = lℚᵢ -1ℚ

0ℚᵢ  : Interp' ℚₜ
0ℚᵢ  = lℚᵢ 0ℚ

1ℚᵢ  : Interp' ℚₜ
1ℚᵢ  = lℚᵢ 1ℚ
--------------------------------------------------------------------------------
-- Interp-Based Domain-Specific Constructs (indexed by _ₛ)
--------------------------------------------------------------------------------
lℤₛ : ℤ → Interp ℤₜ
lℤₛ i = return (lℤᵢ i)

lℚₛ : ℚ → Interp ℚₜ
lℚₛ r = return (lℚᵢ r)

l𝕊ₛ : 𝕊 → Interp 𝕊ₜ
l𝕊ₛ s = return (l𝕊ᵢ s)

falseₛ : Interp 𝟚ₜ
falseₛ {{d}} = return (falseᵢ {{d}})

trueₛ : Interp 𝟚ₜ
trueₛ {{d}} = return (trueᵢ {{d}})

ifₛ_thenₛ_elseₛ_ : ∀ {a} → InterpPrm ((𝟚ₜ ∷ a ∷ a ∷ []) ↦ a)
ifₛ_thenₛ_elseₛ_ {a} l m n = do (z ← l ﹔
                                 x ← m ﹔
                                 y ← n ﹔
                                 (ifᵢ_thenᵢ_elseᵢ_ {a} z x y))

justₛ : ∀ {a} → InterpPrm ((a ∷ []) ↦ Maybeₜ a)
justₛ {a} m = do (x ← m ﹔
                  (justᵢ {a} x))

nothingₛ : ∀ {a} → Interp (Maybeₜ a)
nothingₛ {a} = return (nothingᵢ {a})

maybeₛ : ∀ {a b} → InterpPrm (((a →ₜ b) ∷ b ∷ Maybeₜ a ∷ []) ↦ b)
maybeₛ {a} {b} M N L = do (x ← M ﹔
                           y ← N ﹔
                           z ← L ﹔
                           maybeᵢ {a} {b} x y z)

_==ℚₛ_ : InterpPrm ((ℚₜ ∷ ℚₜ ∷ []) ↦ 𝟚ₜ)
m ==ℚₛ n = do (x ← m ﹔
               y ← n ﹔
               (x ==ℚᵢ y))

_*ℚₛ_ : InterpPrm ((ℚₜ ∷ ℚₜ ∷ []) ↦ ℚₜ)
m *ℚₛ n = do (x ← m ﹔
              y ← n ﹔
              (x *ℚᵢ y))

_/ℚₛ_ : InterpPrm ((ℚₜ ∷ ℚₜ ∷ []) ↦ ℚₜ)
m /ℚₛ n = do (x ← m ﹔
              y ← n ﹔
              (x /ℚᵢ y))

-1ℚₛ : Interp ℚₜ
-1ℚₛ = lℚₛ -1ℚ

0ℚₛ  : Interp ℚₜ
0ℚₛ  = lℚₛ  0ℚ

1ℚₛ  : Interp ℚₜ
1ℚₛ  = lℚₛ  1ℚ

_<$>ₛ_ : ∀ {a b} → InterpPrm (((a →ₜ b) ∷ (Maybeₜ a) ∷ []) ↦ Maybeₜ b)
_<$>ₛ_ {a} {b} f m = maybeₛ {a} {Maybeₜ b}
                     (λₛ (λ x → justₛ {b} (f $ₛ x)))
                     (nothingₛ {b}) m
 where
 -- same as the ones in the evaluator or prelude up there
  -- due to an issue in Agda I should specialise the type
  λₛ : ∀ {ε} → (InterpBy ε a → InterpBy ε (Maybeₜ b)) →
       InterpBy ε (a →ₜ (Maybeₜ b))
  λₛ n = return (λ x → n (return x))
  _$ₛ_ : ∀ {ε} → InterpBy ε (a →ₜ b) → InterpBy ε a → InterpBy ε b
  l $ₛ m = do (u ← l ﹔
               v ← m ﹔
               u v)

--------------------------------------------------------------------------------
-- Specialised Main Functions
--------------------------------------------------------------------------------
prms : Prms
prms = ext _==ℚₛ_ (ext _*ℚₛ_ (ext _/ℚₛ_ emp))

⟦_⟧ₚ : ∀ {a} → Syn a → Sem a
⟦_⟧ₚ = eval prms

↓ₚ : ∀ {a} {ε} {{d : Pow ε}} → InterpBy' ε a → ε a
↓ₚ {a} M = ↓' (match' true a) M

nbeₚ : ∀ {a} → Syn a → Syn a
nbeₚ = nbe prms

code : ∀ {a} → Syn a → 𝕊
code M = π₁ (M {{d = show𝔼' show𝕃}} 0)

--------------------------------------------------------------------------------
-- Example
--------------------------------------------------------------------------------

-------------------------------------------------
-- Power using _ₜ indexed terms (Syntactic terms)
-------------------------------------------------
-- begin

{-# TERMINATING #-}
powerₜ : ℤ → Syn (ℚₜ →ₜ ℚₜ)
powerₜ n = λₜ (λ x →
  if n <ℤ 0ℤ       then
    ifₜ x ==ℚₜ 0ℚₜ
    thenₜ 0ℚₜ
    elseₜ (-1ℚₜ /ℚₜ (powerₜ (- n) $ₜ x))
  else if n ==ℤ 0ℤ then
    1ℚₜ
  else if even n    then
    (let y = powerₜ (n /2) $ₜ x
     in  y *ℚₜ y)
  else
    x *ℚₜ (powerₜ (n - 1ℤ) $ₜ x))

{-# TERMINATING #-}
powerₜ' : ℤ → Syn (ℚₜ →ₜ (Maybeₜ ℚₜ))
powerₜ' n = λₜ (λ x →
  if n <ℤ 0ℤ       then
    ifₜ x ==ℚₜ 0ℚₜ
    thenₜ nothingₜ
    elseₜ ((λₜ (λ y → -1ℚₜ /ℚₜ y))
           <$>ₜ (powerₜ' (- n) $ₜ x))
  else if n ==ℤ 0ℤ then
    justₜ 1ℚₜ
  else if even n    then
    ((λₜ (λ y → y *ℚₜ y))
     <$>ₜ (powerₜ' (n /2) $ₜ x))
  else
    ((λₜ (λ y → x *ℚₜ y))
    <$>ₜ (powerₜ' (n - 1ℤ) $ₜ x)))

powerₜ'' : ℤ → Syn (ℚₜ →ₜ ℚₜ)
powerₜ'' n = λₜ (λ x → maybeₜ (λₜ (λ z → z)) 0ℚₜ (powerₜ' n $ₜ x))

powerₜMinus6Obj : Syn (ℚₜ →ₜ ℚₜ)
powerₜMinus6Obj = nbeₚ (powerₜ (-[1+ 5 ]))

powerₜ''Minus6Obj : Syn (ℚₜ →ₜ ℚₜ)
powerₜ''Minus6Obj = nbeₚ (powerₜ'' (-[1+ 5 ]))

powerₜMinus6Code : 𝕊
powerₜMinus6Code = code powerₜMinus6Obj

powerₜ''Minus6Code : 𝕊
powerₜ''Minus6Code = code powerₜ''Minus6Obj

testₜ₁ : 𝟚
testₜ₁ = powerₜMinus6Code
         ==𝕊
        "λₜ (λ x0 → δₜ (pₜ (zro) (ext (x0) (ext (lₜ ((0) ÷ (suc (zero)))) (emp)))) (λₜ (λ x1 → pₜ (suc (suc (zro))) (ext (lₜ ((-1) ÷ (suc (zero)))) (ext (pₜ (suc (zro)) (ext (pₜ (suc (zro)) (ext (x0) (ext (pₜ (suc (zro)) (ext (x0) (ext (x0) (emp)))) (emp)))) (ext (pₜ (suc (zro)) (ext (x0) (ext (pₜ (suc (zro)) (ext (x0) (ext (x0) (emp)))) (emp)))) (emp)))) (emp))))) (λₜ (λ x2 → lₜ ((0) ÷ (suc (zero))))))"

testₜ₂ : 𝟚
testₜ₂ = powerₜMinus6Code
         ==𝕊
         powerₜ''Minus6Code

powerSimpMinus6Obj : Syn (ℚₜ →ₜ ℚₜ)
powerSimpMinus6Obj {ε} =
  λₜ (λ x0 →
        ifₜ (x0 ==ℚₜ 0ℚₜ)
        thenₜ 0ℚₜ
        elseₜ (-1ℚₜ /ℚₜ ((x0 *ℚₜ (x0 *ℚₜ x0)) *ℚₜ (x0 *ℚₜ (x0 *ℚₜ x0)))))

powerSimpMinus6Code : 𝕊
powerSimpMinus6Code = code powerSimpMinus6Obj

testₜ₃ : 𝟚
testₜ₃ = powerₜMinus6Code
        ==𝕊
        powerSimpMinus6Code

testₜ : 𝟚
testₜ = testₜ₁ ∧ testₜ₂ ∧ testₜ₃

-- end
