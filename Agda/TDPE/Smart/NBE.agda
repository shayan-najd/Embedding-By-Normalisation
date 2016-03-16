--------------------------------------------------------------------------------
-- Imports and Modules
--------------------------------------------------------------------------------
open import Utility
import TDPE.Smart.Type as T

module TDPE.Smart.NBE
       (χ : Set) {{d : Setoid χ}} (Ξ : χ → Set)
       (Σ : List (List (T.Typₜ χ) × (T.Typₜ χ))) where

open import Environment
open import NBE

module TypeM = T χ
open TypeM

import TDPE.Smart.HOAS as H
module HOASM = H χ Ξ Σ
open HOASM

import TDPE.Smart.Evaluation as E
module EM = E χ {{d}} Ξ Σ
open EM

import TDPE.Smart.Reification as R
module RM = R χ {{d}} Ξ Σ
open RM

import TDPE.Smart.Syntax as Syntax
module SyntaxMM = Syntax χ {{d}} Ξ Σ
open SyntaxMM

import TDPE.Smart.Semantic as Semantic
module SemanticMM = Semantic χ {{d}} Ξ Σ
open SemanticMM

open module TrmMM {ε : Typₜ → Set} {{d : Trm ε}} = Trm d

--------------------------------------------------------------------------------
-- Full TDPE is NBE!
--------------------------------------------------------------------------------
Sem : Typₜ → Set₁
Sem a = ∀ {ε} {{d : Trm ε}} → SemBy ε a (InterpBy' ε a)

-- Infering the relationship between the output of the evaluator and
-- the semantic (it is used in match to conver former to the latter)

match' : ∀ {ε} {{d : Trm ε}} →
         (p : 𝟚) → (a : Typₜ) → ε ﹔ p ⊢ₑ (InterpBy' ε a) ~ a
match' _     𝟙ₜ       = 𝟙ₑ
match' true  (𝔹ₜ _)   = 𝔼ₑ ⇖ₑ (λ m → δ m lₜ id)
match' false (𝔹ₜ _)   = 𝔼ₑ ⇗ₑ ι₂
match' p     (a →ₜ b) = match' (not p) a →ₑ match' p b
match' p     (a ×ₜ b) = match' p       a ×ₑ match' p b
match' p     (a +ₜ b) = match' p       a +ₑ match' p b

match : ∀ {a} → Interp a → Sem a
match {a} x = (match' true a , x)

-- Ugly! Thanks to a bug in Agda.
-- It should have been
--     match ∘ evalBy Σ
uglyEval : ∀ {a} → InterpEnv → Syn a → Sem a
uglyEval Σ M {{d}} = match (λ {{d}} →
                            evalBy (λ {{d}} → Σ {{d}})
                                   (λ {{d}} → M {{d}}) {{d}}) {{d}}

TDPESmartisNBE : InterpEnv → TypedNBE Typₜ
TDPESmartisNBE Σ = record
                  { Syn = Syn;
                    Sem = Sem;
                    ⟦_⟧  = uglyEval Σ;
                    ↓   = ↓p InterpBy' }

--------------------------------------------------------------------------------
-- Some Helper Functions
--------------------------------------------------------------------------------
SynPrmBy : (Typₜ → Set) → List Typₜ × Typₜ → Set
SynPrmBy ε ([]    , b) = SynBy ε b
SynPrmBy ε (a ∷ Δ , b) = SynBy ε a → SynPrmBy ε (Δ , b)

SynPrm : List Typₜ × Typₜ → Set₁
SynPrm (Δ , b) = ∀ {ε} {{d : Trm ε}} → SynPrmBy ε (Δ , b)


Interp'PrmBy : (Typₜ → Set) → List Typₜ × Typₜ → Set
Interp'PrmBy ε ([]    , b) = InterpBy  ε b
Interp'PrmBy ε (a ∷ Δ , b) = InterpBy' ε a → Interp'PrmBy ε (Δ , b)

Interp'Prm : List Typₜ × Typₜ → Set₁
Interp'Prm (Δ , b) = ∀ {ε} {{d : Trm ε}} → Interp'PrmBy ε (Δ , b)
-- InterpPrmBy ε (Δ , b) = foldr (λ x xs → Interp'By ε x → xs) (InterpOf ε b) Δ

InterpPrmBy : (Typₜ → Set) → List Typₜ × Typₜ → Set
InterpPrmBy ε ([]    , b) = InterpBy ε b
InterpPrmBy ε (a ∷ Δ , b) = InterpBy ε a → InterpPrmBy ε (Δ , b)

InterpPrm : List Typₜ × Typₜ → Set₁
InterpPrm (Δ , b) = ∀ {ε} {{d : Trm ε}} → InterpPrmBy ε (Δ , b)
-- InterpPrmBy ε (Δ , b) = foldr (λ x xs → InterpBy ε x → xs) (InterpOf ε b) Δ

Prms : Set₁
Prms = ∀ {ε} {{d : Trm ε}} → All (InterpPrmBy ε) Σ

toEnv : Prms → InterpEnv
toEnv ps {ε} {{d}} = toEnvOf (ps {ε} {{d}})
  where
    toAll : ∀ {ε} {Δ : List Typₜ} {b} →
            InterpPrmBy ε (Δ , b) → All (InterpBy ε) Δ → InterpBy ε b
    toAll f emp        = f
    toAll f (ext x ps) = toAll (f x) ps

    toEnvOf : ∀ {ε Σ} → All (InterpPrmBy ε) Σ → EnvOf (InterpBy ε) Σ
    toEnvOf emp        = emp
    toEnvOf (ext p ps) = ext (toAll p) (toEnvOf ps)

eval : ∀ {a} → Prms → Syn a → Sem a
eval  Σ = TypedNBE.⟦_⟧ (TDPESmartisNBE (toEnv Σ))

nbe : ∀ {a} → Prms → Syn a → Syn a
nbe Σ = TypedNBE.normalise (TDPESmartisNBE (toEnv Σ))

----------------------------------------------------------------
-- An alternative way to formulate match
---------------------------------------------------------------
aInterpBy : (Typₜ → Set) → Typₜ → Set
aInterpBy ε 𝟙ₜ       = 𝟙
aInterpBy ε (𝔹ₜ a)   = ε (𝔹ₜ a)
aInterpBy ε (a →ₜ b) = aInterpBy ε a → Cont ε (aInterpBy ε b)
aInterpBy ε (a ×ₜ b) = aInterpBy ε a × aInterpBy ε b
aInterpBy ε (a +ₜ b) = aInterpBy ε a + aInterpBy ε b

aSem : Typₜ → Set₁
aSem a = ∀ {ε} {{d : Trm ε}} → (SemBy ε a (aInterpBy ε a))

mutual
  unLiftedBase : ∀ {ε} {{d : Trm ε}} → (a : Typₜ) → InterpBy' ε a → aInterpBy ε a
  unLiftedBase  𝟙ₜ       L = tt
  unLiftedBase  (𝔹ₜ _)   L = δ L lₜ id
  unLiftedBase  (a →ₜ b) L = λ x → unLiftedBase b <$> (L (unLiftedBase' a x))
  unLiftedBase  (a ×ₜ b) L = (unLiftedBase a (π₁ L) , unLiftedBase b (π₂ L))
  unLiftedBase  (a +ₜ b) L = δ L (ι₁ ∘ unLiftedBase a) (ι₂ ∘ unLiftedBase b)

  unLiftedBase' : ∀ {ε} {{d : Trm ε}} → (a : Typₜ) → aInterpBy ε a → InterpBy' ε a
  unLiftedBase' 𝟙ₜ       L = tt
  unLiftedBase' (𝔹ₜ _)   L = ι₂ L
  unLiftedBase' (a →ₜ b) L = λ x → unLiftedBase' b <$> (L (unLiftedBase a x))
  unLiftedBase' (a ×ₜ b) L = (unLiftedBase' a (π₁ L) , unLiftedBase' b (π₂ L))
  unLiftedBase' (a +ₜ b) L = δ L (ι₁ ∘ unLiftedBase' a) (ι₂ ∘ unLiftedBase' b)

aMatch' : ∀ {ε} {{d : Trm ε}} → (p : 𝟚) (a : Typₜ) → (ε ﹔ p ⊢ₑ(aInterpBy ε a) ~ a)
aMatch' p 𝟙ₜ       = 𝟙ₑ
aMatch' p (𝔹ₜ _)   = 𝔼ₑ
aMatch' p (a →ₜ b) = aMatch' (not p) a →ₑ aMatch' p b
aMatch' p (a ×ₜ b) = aMatch' p a ×ₑ aMatch' p b
aMatch' p (a +ₜ b) = aMatch' p a +ₑ aMatch' p b

aMatch : ∀ a → Interp a → SemP aInterpBy a
aMatch a M {ε} {{d}}  = (aMatch' {{d}} true  a , unLiftedBase a <$> (M {{d}}))

uglyEval' : ∀ {a} → InterpEnv → Syn a → aSem a
uglyEval' {a} Σ M {{d}} = aMatch a (λ {{d}} →
                          evalBy {a} (λ {{d}} → Σ {{d}})
                                 (λ {{d}} → M {{d}}) {{d}}) {{d}}


aTDPEPrimitivesisNBE : InterpEnv → TypedNBE Typₜ
aTDPEPrimitivesisNBE Σ = record
                            { Syn = Syn;
                              Sem = aSem;
                              ⟦_⟧  = uglyEval' Σ;
                              ↓   = ↓p aInterpBy}
