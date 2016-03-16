open import Utility
import TDPE.Sums.Type as T

module TDPE.Sums.Semantic
       (χ : Set) {{d : Setoid χ}} (Ξ : χ → Set)
       (Σ : List (List (T.Typₜ χ) × (T.Typₜ χ))) where

module TypeM = T χ
open TypeM

import TDPE.Sums.HOAS as H
module HOASM = H χ Ξ Σ
open HOASM

-- Relation between types in semantic and in syntax
data _⊢ₑ_~_ (ε : Typₜ → Set) : Set → Typₜ → Set₁ where
 𝔼ₑ   : ∀ {a} → (ε ⊢ₑ (ε a) ~ a)
 𝟙ₑ   : (ε ⊢ₑ 𝟙 ~ 𝟙ₜ)
 _→ₑ_ : ∀ {a a' b b'} → (ε ⊢ₑ a ~ a') → (ε ⊢ₑ b ~ b') →
        (ε ⊢ₑ (a → Cont ε b) ~ (a' →ₜ b'))
 _×ₑ_ : ∀ {a a' b b'} → (ε ⊢ₑ a ~ a') → (ε ⊢ₑ b ~ b') →
        (ε ⊢ₑ (a × b) ~ (a' ×ₜ b'))
 _+ₑ_ : ∀ {a a' b b'} → (ε ⊢ₑ a ~ a') → (ε ⊢ₑ b ~ b') →
        (ε ⊢ₑ (a + b) ~ (a' +ₜ b'))

SemBy : (Typₜ → Set) → Typₜ → Set → Set₁
SemBy ε a aₛ = (ε ⊢ₑ aₛ ~ a) × Cont ε aₛ

SemP : ((Typₜ → Set) → Typₜ → Set) → Typₜ → Set₁
SemP p a = ∀ {ε} {{d : Trm ε}} → SemBy ε a (p ε a)
