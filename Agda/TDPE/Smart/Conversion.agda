open import Utility
import TDPE.Smart.Type as T

module TDPE.Smart.Conversion
       (χ : Set) {{d : Setoid χ}} (Ξ : χ → Set)
       (Σ : List (List (T.Typₜ χ) × (T.Typₜ χ))) where

module TypeM = T χ {{d}}
open TypeM

import TDPE.Smart.FOAS
module F = TDPE.Smart.FOAS χ {{d}} Ξ Σ
open F
 using (_⊢_)

import TDPE.Smart.HOAS
module H = TDPE.Smart.HOAS χ {{d}} Ξ Σ
open H

open import Environment

postulate
  impossible₁ : ∀ Γ → (a : Typₜ) → a ∈ Γ
  impossible₂ : ∀ Γ → (a : Typₜ) → a ∈ Γ

len : List Typₜ → ℕ
len []       = 0
len (_ ∷ xs) = suc (len xs)

cnvVar : (a : Typₜ) → List Typₜ → (Γ : List Typₜ) → a ∈ Γ
cnvVar a _  []      = impossible₁ [] a
cnvVar a Γ' (y ∷ Δ') with (len Δ' ∸ℕ len Γ')
cnvVar a Γ' (y ∷ Δ') | zero with eql a y
cnvVar a Γ' (_ ∷ Δ') | zero | yes refl = zro
cnvVar a Γ' (y ∷ Δ') | zero | no ¬p    = impossible₂ (y ∷ Δ') a
cnvVar a Γ' (y ∷ Δ') | suc d           = suc (cnvVar a Γ' Δ')

HOAStoFOAS' : H.Trm (λ a → (Γ : List Typₜ) → Γ ⊢ a)
HOAStoFOAS' = record {
      1ₜ     = λ _     → F.1ₜ;
      lₜ     = λ i     → λ _ → F.lₜ i;
      pₜ     = λ x ms  → λ Γ → F.pₜ x (mapAll (λ f → f Γ) ms);
      λₜ     = λ {a} n → λ Γ →
               F.λₜ (n (λ Δ → F.vₜ (cnvVar a Γ Δ)) (a ∷ Γ));
      _$ₜ_   = λ l m   → λ Γ → (l Γ) F.$ₜ (m Γ);
      _,ₜ_   = λ m n   → λ Γ → (m Γ) F.,ₜ (n Γ);
      π₁ₜ    = λ l     → λ Γ → F.π₁ₜ (l Γ);
      π₂ₜ    = λ l     → λ Γ → F.π₂ₜ (l Γ);
      ι₁ₜ    = λ m     → λ Γ → F.ι₁ₜ (m Γ);
      ι₂ₜ    = λ n     → λ Γ → F.ι₂ₜ (n Γ);
      δₜ     = λ l m n → λ Γ → F.δₜ (l Γ) (m Γ) (n Γ)}

HOAStoFOAS : ∀ {a} → Term a → F.Term a
HOAStoFOAS m =  m {{dict = HOAStoFOAS'}} []

{-# TERMINATING #-}
FOAStoHOAS : ∀ {a} → F.Term a → Term a
FOAStoHOAS m = FOAStoHOAS' emp m
  where
   open module TrmM {ε : Typₜ → Set} {{d : Trm ε}} = H.Trm d

   FOAStoHOAS' : ∀ {Γ ε a} →
                 All ε Γ → Γ ⊢ a → {{d : H.Trm ε}} → ε a
   FOAStoHOAS' Γ F.1ₜ             = 1ₜ
   FOAStoHOAS' Γ (F.lₜ i)         = lₜ i
   FOAStoHOAS' Γ (F.pₜ x ms)      = pₜ x (mapAll (λ m → FOAStoHOAS' Γ m) ms)
   FOAStoHOAS' Γ (F.vₜ x)         = lookUp x Γ
   FOAStoHOAS' Γ (F.λₜ n)         = λₜ (λ x → FOAStoHOAS' (ext x Γ) n)
   FOAStoHOAS' Γ (l F.$ₜ m)       = FOAStoHOAS' Γ l $ₜ FOAStoHOAS' Γ m
   FOAStoHOAS' Γ (m F.,ₜ n)       = FOAStoHOAS' Γ m ,ₜ FOAStoHOAS' Γ n
   FOAStoHOAS' Γ (F.π₁ₜ l)        = π₁ₜ (FOAStoHOAS' Γ l)
   FOAStoHOAS' Γ (F.π₂ₜ l)        = π₂ₜ (FOAStoHOAS' Γ l)
   FOAStoHOAS' Γ (F.ι₁ₜ m)        = ι₁ₜ (FOAStoHOAS' Γ m)
   FOAStoHOAS' Γ (F.ι₂ₜ n)        = ι₂ₜ (FOAStoHOAS' Γ n)
   FOAStoHOAS' Γ (F.δₜ l m n)     = δₜ  (FOAStoHOAS' Γ l) (FOAStoHOAS' Γ m)
                                        (FOAStoHOAS' Γ n)
