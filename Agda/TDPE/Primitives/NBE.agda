--------------------------------------------------------------------------------
-- Imports and Modules
--------------------------------------------------------------------------------
open import Utility
import TDPE.Primitives.Type as T

module TDPE.Primitives.NBE
       (χ : Set) {{d : Setoid χ}} (Ξ : χ → Set)
       (Σ : List (List (T.Typₜ χ) × (T.Typₜ χ))) where

open import Environment
open import NBE

module TypeM = T χ
open TypeM

import TDPE.Primitives.HOAS as H
module HOASM = H χ {{d}} Ξ Σ
open HOASM

import TDPE.Primitives.Evaluation as E
module EM = E χ {{d}} Ξ Σ
open EM

import TDPE.Primitives.Reification as R
module RM = R χ {{d}} Ξ Σ
open RM

import TDPE.Primitives.Syntax as Syntax
module SyntaxMM = Syntax χ {{d}} Ξ Σ
open SyntaxMM

import TDPE.Primitives.Semantic as Semantic
module SemanticMM = Semantic χ {{d}} Ξ Σ
open SemanticMM

open module TrmMM {ε : Typₜ → Set} {{d : Trm ε}} = Trm d

--------------------------------------------------------------------------------
-- Implicational TDPE is NBE!
--------------------------------------------------------------------------------
Sem : Typₜ → Set₁
Sem a = ∀ {ε} {{d : Trm ε}} → (SemBy ε a (InterpBy ε a))

-- Infering the relationship between the output of the evaluator and
-- the semantic (it is used in match to conver former to the latter)
match' : ∀ {ε} {{d : Trm ε}} → (a : Typₜ) → ε ⊢ₑ (InterpBy ε a) ~ a
match' 𝟙ₜ       = 𝟙ₑ
match' (𝔹ₜ _)   = 𝔼ₑ
match' (a →ₜ b) = match' a →ₑ match' b
match' (a ×ₜ b) = match' a ×ₑ match' b

match : ∀ a → Interp a → Sem a
match a x = (match' a , x)

-- Thanks to a bug in Agda!
-- It should have been
--     match ∘ evalBy Σ
uglyEval : ∀ {a} → InterpEnv → Syn a → Sem a
uglyEval {a} Σ M {{d}} = match a (λ {{d}} →
                         evalBy (λ {{d}} → Σ {{d}})
                                (λ {{d}} → M {{d}}) {{d}}) {{d}}

TDPEPrimitivesisNBE : InterpEnv → TypedNBE Typₜ
TDPEPrimitivesisNBE Σ = record
                           { Syn = Syn;
                             Sem = Sem;
                             ⟦_⟧  = uglyEval Σ;
                             ↓   = ↓p InterpBy}
