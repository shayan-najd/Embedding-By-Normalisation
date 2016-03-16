--------------------------------------------------------------------------------
-- Imports and Headers
--------------------------------------------------------------------------------
open import Utility
import TDPE.Primitives.Type as T

module TDPE.Primitives.Evaluation
       (χ : Set) {{d : Setoid χ}} (Ξ : χ → Set)
       (Σ : List (List (T.Typₜ χ) × (T.Typₜ χ))) where

open import Environment

module TypeM = T χ
open TypeM

import TDPE.Primitives.HOAS as H
module HOASM = H χ Ξ Σ
open HOASM

import TDPE.Primitives.Syntax as S
module SM = S χ Ξ Σ
open SM

open module TrmM {ε : Typₜ → Set} {{d : Trm ε}} = Trm d

-- interpretation
InterpBy : (Typₜ → Set) → Typₜ → Set
InterpBy ε 𝟙ₜ       = 𝟙
InterpBy ε (𝔹ₜ a)   = ε (𝔹ₜ a)
InterpBy ε (a →ₜ b) = InterpBy ε a → InterpBy ε b
InterpBy ε (a ×ₜ b) = InterpBy ε a × InterpBy ε b

evalD : ∀ {ε} {{d : Trm ε}} → EnvOf (InterpBy ε) Σ → Trm (InterpBy ε)
evalD Σ =
     record
      { 1ₜ   = tt;
        lₜ   = lₜ;
        pₜ   = lookUpIn Σ;
        λₜ   = id;
        _$ₜ_ = _$_;
        _,ₜ_ = _,_;
        π₁ₜ  = π₁;
        π₂ₜ  = π₂ }

InterpEnv : Set₁
InterpEnv = ∀ {ε} {{d : Trm ε}} → EnvOf (InterpBy ε) Σ

Interp : Typₜ → Set₁
Interp a = ∀ {ε} {{d : Trm ε}} → InterpBy ε a

-- evaluator
evalBy : ∀ {a} → InterpEnv → Syn a → Interp a
evalBy Σ m {{d}} = m {{d = evalD {{d}} (Σ {{d}})}}
