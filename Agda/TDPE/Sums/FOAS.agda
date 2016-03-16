open import Utility
import TDPE.Sums.Type as T

module TDPE.Sums.FOAS
       (χ : Set) {{d : Setoid χ}} (Ξ : χ → Set)
       (Σ : List (List (T.Typₜ χ) × (T.Typₜ χ))) where

module TypeM = T χ
open TypeM

open import Environment

data _⊢_ : List Typₜ →  Typₜ → Set where
  lₜ   : ∀ {Γ a}     → Ξ a → Γ ⊢ 𝔹ₜ a
  pₜ   : ∀ {Γ Δ b}   → (Δ ↦ b) ∈ Σ  → All (Γ ⊢_) Δ → Γ ⊢ b
  1ₜ   : ∀ {Γ}       → Γ ⊢ 𝟙ₜ
  vₜ   : ∀ {Γ a}     → a ∈ Γ → Γ ⊢ a
  λₜ   : ∀ {Γ a b}   → (a ∷ Γ) ⊢ b  → Γ ⊢ (a →ₜ b)
  _$ₜ_ : ∀ {Γ a b}   → Γ ⊢ (a →ₜ b) → Γ ⊢ a → Γ ⊢ b
  _,ₜ_ : ∀ {Γ a b}   → Γ ⊢ a → Γ ⊢ b → Γ ⊢ (a ×ₜ b)
  π₁ₜ  : ∀ {Γ a b}   → Γ ⊢ (a ×ₜ b) → Γ ⊢ a
  π₂ₜ  : ∀ {Γ a b}   → Γ ⊢ (a ×ₜ b) → Γ ⊢ b
  ι₁ₜ  : ∀ {Γ a b}   → Γ ⊢ a → Γ ⊢ (a +ₜ b)
  ι₂ₜ  : ∀ {Γ a b}   → Γ ⊢ b → Γ ⊢ (a +ₜ b)
  δₜ   : ∀ {Γ a b c} → Γ ⊢ (a +ₜ b) →
         Γ ⊢ (a →ₜ c) → Γ ⊢ (b →ₜ c) → Γ ⊢ c

Term : Typₜ → Set
Term a =  [] ⊢ a

{-# TERMINATING #-}
show𝔼 : ∀ {Γ a} → (∃ Ξ → 𝕊) → Γ ⊢ a → 𝕊
show𝔼 show𝕃 (lₜ l)         = "lₜ (" ⊕ show𝕃  (_ , l) ⊕ ")"
show𝔼 show𝕃 (pₜ x ms)      = "pₜ (" ⊕ showVar x ⊕ ") ("
                              ⊕ showAll (show𝔼 show𝕃) ms ⊕ ")"
show𝔼 show𝕃 1ₜ             = "1ₜ"
show𝔼 show𝕃 (vₜ x)         = "vₜ (" ⊕ showVar x ⊕ ")"
show𝔼 show𝕃 (λₜ n)         = "λₜ (" ⊕ show𝔼 show𝕃 n ⊕  ")"
show𝔼 show𝕃 (l $ₜ m)       = "(" ⊕ show𝔼 show𝕃 l ⊕ ") $ₜ ("
                                 ⊕ show𝔼 show𝕃 m ⊕ ")"
show𝔼 show𝕃 (m ,ₜ n)       = "(" ⊕ show𝔼 show𝕃 m ⊕ ") ,ₜ ("
                                 ⊕ show𝔼 show𝕃 n ⊕ ")"
show𝔼 show𝕃 (π₁ₜ l)        = "π₁ₜ (" ⊕ show𝔼 show𝕃 l ⊕ ")"
show𝔼 show𝕃 (π₂ₜ l)        = "π₂ₜ (" ⊕ show𝔼 show𝕃 l ⊕ ")"
show𝔼 show𝕃 (ι₁ₜ m)        = "ι₁ₜ (" ⊕ show𝔼 show𝕃 m ⊕ ")"
show𝔼 show𝕃 (ι₂ₜ n)        = "ι₂ₜ (" ⊕ show𝔼 show𝕃 n ⊕ ")"
show𝔼 show𝕃 (δₜ l m n )    = "δₜ (" ⊕ show𝔼 show𝕃 l ⊕ ") ("
                                    ⊕ show𝔼 show𝕃 m ⊕ ") ("
                                    ⊕ show𝔼 show𝕃 n ⊕ ")"
