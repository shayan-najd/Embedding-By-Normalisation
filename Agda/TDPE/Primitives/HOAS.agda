open import Utility
import TDPE.Primitives.Type as T

module TDPE.Primitives.HOAS (χ : Set) {{d : Setoid χ}} (Ξ : χ → Set)
                          (Σ : List (List (T.Typₜ χ) × (T.Typₜ χ))) where

module TypeM = T χ
open TypeM

open import Environment

record Trm (ε : Typₜ → Set) : Set where
 field
        lₜ     : ∀ {a}     → Ξ a → ε (𝔹ₜ a)
        pₜ     : ∀ {Δ b}   → (Δ ↦ b) ∈ Σ  → All ε Δ → ε b
        1ₜ     : ε 𝟙ₜ
        λₜ     : ∀ {a b}   → (ε a → ε b) → ε (a →ₜ b)
        _$ₜ_   : ∀ {a b}   → ε (a →ₜ b) → ε a → ε b
        _,ₜ_   : ∀ {a b}   → ε a → ε b → ε (a ×ₜ b)
        π₁ₜ    : ∀ {a b}   → ε (a ×ₜ b) → ε a
        π₂ₜ    : ∀ {a b}   → ε (a ×ₜ b) → ε b

show𝔼' : (∃ Ξ → 𝕊) → Trm (λ _ → NameMonad 𝕊)
show𝔼' show𝕃 = record {
        lₜ   = λ l → returnₙ ("lₜ (" ⊕  show𝕃 (_ , l) ⊕ ")");
        pₜ   = λ x ms → do (ms' ←ₙ sequenceₙ ms ﹔
                            returnₙ ("pₜ (" ⊕ showVar x ⊕ ") ("
                                            ⊕ showAll id ms'  ⊕ ")"));
        1ₜ   = returnₙ "1ₜ" ;
        λₜ   = λ n     → do (x ←ₙ newName ﹔
                             w ←ₙ n (returnₙ x) ﹔
                             returnₙ ("λₜ (λ " ⊕ x ⊕ " → "
                                      ⊕ w ⊕ ")"));
        _$ₜ_ = λ l m   → do (u ←ₙ l ﹔
                             v ←ₙ m ﹔
                             returnₙ ("(" ⊕ u ⊕ ") $ₜ ("
                                     ⊕ v ⊕ ")"));
        _,ₜ_ = λ m n   → do (v ←ₙ m ﹔
                             w ←ₙ n ﹔
                             returnₙ ("(" ⊕ v ⊕ ") ,ₜ ("
                                 ⊕ w ⊕ ")"));
        π₁ₜ  = λ l     → do (u ←ₙ l ﹔
                             returnₙ ("π₁ₜ (" ⊕ u ⊕ ")"));
        π₂ₜ  = λ l     → do (u ←ₙ l ﹔
                             returnₙ ("π₂ₜ (" ⊕ u ⊕ ")"))}

Term : Typₜ → Set₁
Term a = ∀ {ε} {{dict : Trm ε}} → ε a

show𝔼 : ∀ {a} → (∃ Ξ → 𝕊) → Term a → 𝕊
show𝔼 show𝕃 m = π₁ (m {{dict = show𝔼' show𝕃}} 0)
