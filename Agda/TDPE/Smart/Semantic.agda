open import Utility
import TDPE.Smart.Type as T

module TDPE.Smart.Semantic
       (χ : Set) {{d : Setoid χ}} (Ξ : χ → Set)
       (Σ : List (List (T.Typₜ χ) × (T.Typₜ χ))) where

module TypeM = T χ
open TypeM

import TDPE.Smart.HOAS as H
module HOASM = H χ Ξ Σ
open HOASM

-- Relation between types in semantic and in syntax
data _﹔_⊢ₑ_~_ (ε : Typₜ → Set) : 𝟚 → Set → Typₜ → Set₁ where
 _⇗ₑ_ : ∀ {a b a'} → (ε ﹔ false ⊢ₑ a ~ a') → (a → b) →
        (ε ﹔ false ⊢ₑ b ~ a')
 _⇖ₑ_ : ∀ {a b a'} → (ε ﹔ true ⊢ₑ b ~ a') → (a → b) →
        (ε ﹔ true ⊢ₑ a ~ a')
 𝔼ₑ   : ∀ {a p} → (ε ﹔ p ⊢ₑ (ε a) ~ a)
 𝟙ₑ   : ∀ {p}   → (ε ﹔ p ⊢ₑ 𝟙 ~ 𝟙ₜ)
 _→ₑ_ : ∀ {a a' b b' p} → (ε ﹔ (not p) ⊢ₑ a ~ a') → (ε ﹔ p ⊢ₑ b ~ b') →
        (ε ﹔ p ⊢ₑ (a → Cont ε b) ~ (a' →ₜ b'))
 _×ₑ_ : ∀ {a a' b b' p} → (ε ﹔ p ⊢ₑ a ~ a') → (ε ﹔ p ⊢ₑ b ~ b') →
        (ε ﹔ p ⊢ₑ (a × b) ~ (a' ×ₜ b'))
 _+ₑ_ : ∀ {a a' b b' p} → (ε ﹔ p ⊢ₑ a ~ a') → (ε ﹔ p ⊢ₑ b ~ b') →
        (ε ﹔ p ⊢ₑ (a + b) ~ (a' +ₜ b'))

SemBy : (Typₜ → Set) → Typₜ → Set → Set₁
SemBy ε a aₛ = (ε ﹔ true ⊢ₑ aₛ ~ a) × Cont ε aₛ

SemP : ((Typₜ → Set) → Typₜ → Set) → Typₜ → Set₁
SemP p a = ∀ {ε} {{d : Trm ε}} → SemBy ε a (p ε a)
