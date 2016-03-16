open import Utility
import TDPE.Sums.Type as T

module TDPE.Sums.Reification
       (χ : Set) {{d : Setoid χ}} (Ξ : χ → Set)
       (Σ : List (List (T.Typₜ χ) × (T.Typₜ χ))) where

open import Environment

module TypeM = T χ
open TypeM

import TDPE.Sums.HOAS as H
module HOASM = H χ Ξ Σ
open HOASM

import TDPE.Sums.Syntax as Syntax
module SyntaxM = Syntax χ Ξ Σ
open SyntaxM

import TDPE.Sums.Semantic as Semantic
module SemanticM = Semantic χ Ξ Σ
open SemanticM

open module TrmM {ε : Typₜ → Set} {{d : Trm ε}} = Trm d

mutual
 -- reification
 ↓' : ∀ {ε} {{d : Trm ε}} {a a'} → ε ⊢ₑ a ~ a' → a → ε a'
 ↓' 𝔼ₑ       l = l
 ↓' 𝟙ₑ       l = 1ₜ
 ↓' (a →ₑ b) l = λₜ (λ m → reset (do (x ← ↑ a m ﹔
                                      v ← l x ﹔
                                      return (↓' b v))))
 ↓' (a ×ₑ b) l = ↓' a (π₁ l) ,ₜ ↓' b (π₂ l)
 ↓' (a +ₑ b) l = δ l (λ x → ι₁ₜ (↓' a x)) (λ y → ι₂ₜ (↓' b y))

 -- reflection
 ↑ : ∀ {ε} {{d : Trm ε}} {a a'} → ε ⊢ₑ a ~ a' → ε a' → Cont ε a
 ↑ 𝔼ₑ       l = return l
 ↑ 𝟙ₑ       _ = return tt
 ↑ (a →ₑ b) l = return (λ m → ↑ b (l $ₜ ↓' a m))
 ↑ (a ×ₑ b) l = do (x ← ↑ a (π₁ₜ l) ﹔
                    y ← ↑ b (π₂ₜ l) ﹔
                    return (x , y))
 ↑ (a +ₑ b) l = shift (λ k →
                δₜ l
                (λₜ (λ x → reset (do (v ← ↑ a x ﹔
                                      return (k (ι₁ v))))))
                (λₜ (λ y → reset (do (w ← ↑ b y ﹔
                                      return (k (ι₂ w)))))))

↓p : ∀ {a} p → SemP p a → Syn a
↓p p V {ε} {{d}} = let (p , M) = V {ε} {{d}}
                   in reset (↓' p <$> M)
