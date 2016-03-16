open import Utility
import TDPE.Sums.Type as T

module TDPE.Sums.Syntax
       (χ : Set) {{d : Setoid χ}} (Ξ : χ → Set)
       (Σ : List (List (T.Typₜ χ) × (T.Typₜ χ))) where

module TypeM = T χ
open TypeM

import TDPE.Sums.HOAS as H
module HOASM = H χ Ξ Σ
open HOASM

SynBy : (Typₜ → Set) → Typₜ → Set
SynBy ε a = ε a

Syn : Typₜ → Set₁
Syn a = ∀ {ε} {{d : Trm ε}} → SynBy ε a
