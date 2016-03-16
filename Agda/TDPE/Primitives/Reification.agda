open import Utility
import TDPE.Primitives.Type as T

module TDPE.Primitives.Reification
       (χ : Set) {{d : Setoid χ}} (Ξ : χ → Set)
       (Σ : List (List (T.Typₜ χ) × (T.Typₜ χ))) where

open import Environment

module TypeM = T χ
open TypeM

import TDPE.Primitives.HOAS as H
module HOASM = H χ Ξ Σ
open HOASM

import TDPE.Primitives.Syntax as Syntax
module SyntaxM = Syntax χ Ξ Σ
open SyntaxM

import TDPE.Primitives.Semantic as Semantic
module SemanticM = Semantic χ Ξ Σ
open SemanticM

open module TrmM {ε : Typₜ → Set} {{d : Trm ε}} = Trm d

mutual
 -- reification
 ↓' : ∀ {ε} {{d : Trm ε}} {a a'} → ε ⊢ₑ a ~ a' → a → ε a'
 ↓' 𝔼ₑ       l = l
 ↓' 𝟙ₑ       l = 1ₜ
 ↓' (a →ₑ b) l = λₜ (λ m → ↓' b (l (↑ a m )))
 ↓' (a ×ₑ b) l = ↓' a (π₁ l) ,ₜ ↓' b (π₂ l)

 -- reflection
 ↑ : ∀ {ε} {{d : Trm ε}} {a a'} → (ε ⊢ₑ a ~ a') → ε a' → a
 ↑ 𝔼ₑ       l = l
 ↑ 𝟙ₑ       l = tt
 ↑ (a →ₑ b) l = λ m → ↑ b (l $ₜ ↓' a m)
 ↑ (a ×ₑ b) l = (↑ a (π₁ₜ l) , ↑ b (π₂ₜ l))

↓p : ∀ {a} p → SemP p a → Syn a
↓p p V {{d}} = let (p , M) = V {{d}}
               in   ↓' p M
