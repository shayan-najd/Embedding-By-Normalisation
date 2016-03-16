--------------------------------------------------------------------------------
-- Imports and Modules
--------------------------------------------------------------------------------
open import Utility
import TDPE.Sums.Type as T

module TDPE.Sums.NBE
       (χ : Set) {{d : Setoid χ}} (Ξ : χ → Set)
       (Σ : List (List (T.Typₜ χ) × (T.Typₜ χ))) where

open import Environment
open import NBE

module TypeM = T χ
open TypeM

import TDPE.Sums.HOAS as H
module HOASM = H χ Ξ Σ
open HOASM

import TDPE.Sums.Evaluation as E
module EM = E χ {{d}} Ξ Σ
open EM

import TDPE.Sums.Reification as R
module RM = R χ {{d}} Ξ Σ
open RM

import TDPE.Sums.Syntax as Syntax
module SyntaxMM = Syntax χ {{d}} Ξ Σ
open SyntaxMM

import TDPE.Sums.Semantic as Semantic
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
         (a : Typₜ) → ε ⊢ₑ (InterpBy' ε a) ~ a
match' 𝟙ₜ       = 𝟙ₑ
match' (𝔹ₜ _)   = 𝔼ₑ
match' (a →ₜ b) = match' a →ₑ match' b
match' (a ×ₜ b) = match' a ×ₑ match' b
match' (a +ₜ b) = match' a +ₑ match' b

match : ∀ {a} → Interp a → Sem a
match {a} x = (match' a , x)

-- Ugly! Thanks to a bug in Agda.
-- It should have been
--     match ∘ evalBy Σ
uglyEval : ∀ {a} → InterpEnv → Syn a → Sem a
uglyEval Σ M {{d}} = match (λ {{d}} →
                            evalBy (λ {{d}} → Σ {{d}})
                                   (λ {{d}} → M {{d}}) {{d}}) {{d}}

TDPESumsisNBE : InterpEnv → TypedNBE Typₜ
TDPESumsisNBE Σ = record
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
eval  Σ = TypedNBE.⟦_⟧ (TDPESumsisNBE (toEnv Σ))

nbe : ∀ {a} → Prms → Syn a → Syn a
nbe Σ = TypedNBE.normalise (TDPESumsisNBE (toEnv Σ))
