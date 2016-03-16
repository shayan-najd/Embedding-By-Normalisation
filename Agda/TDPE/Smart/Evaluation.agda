--------------------------------------------------------------------------------
-- Imports and Headers
--------------------------------------------------------------------------------
open import Utility
import TDPE.Smart.Type as T

module TDPE.Smart.Evaluation
       (χ : Set) {{d : Setoid χ}} (Ξ : χ → Set)
       (Σ : List (List (T.Typₜ χ) × (T.Typₜ χ))) where

open import Environment

module TypeM = T χ
open TypeM

import TDPE.Smart.HOAS as H
module HOASM = H χ Ξ Σ
open HOASM

import TDPE.Smart.Syntax as S
module SM = S χ Ξ Σ
open SM

open module TrmM {ε : Typₜ → Set} {{d : Trm ε}} = Trm d

-- interpretation of types
InterpBy' : (Typₜ → Set) → Typₜ → Set
InterpBy' ε 𝟙ₜ       = 𝟙
InterpBy' ε (𝔹ₜ a)   = Ξ a + ε (𝔹ₜ a)
InterpBy' ε (a →ₜ b) = InterpBy' ε a → Cont ε (InterpBy' ε b)
InterpBy' ε (a ×ₜ b) = InterpBy' ε a × InterpBy' ε b
InterpBy' ε (a +ₜ b) = InterpBy' ε a + InterpBy' ε b

InterpBy : (Typₜ → Set) → Typₜ → Set
InterpBy ε a = Cont ε (InterpBy' ε a)

evalD : ∀ {ε} {{d : Trm ε}} → EnvOf (InterpBy ε) Σ → Trm (InterpBy ε)
evalD Σ =
     record
      { 1ₜ   = return tt;
        lₜ   = λ l     → return (ι₁ l);
        pₜ   = λ x ms  → lookUpIn Σ x ms;
        λₜ   = λ n     → return (λ x → n (return x));
        _$ₜ_ = λ l m   → do (u ← l ﹔
                             v ← m ﹔
                             (u $ v));
        _,ₜ_ = λ m n   → do (v ← m ﹔
                             w ← n ﹔
                             return (v , w));
        π₁ₜ  = λ l     → do (u ← l ﹔
                             return (π₁ u));
        π₂ₜ  = λ l     → do (u ← l ﹔
                             return (π₂ u));
        ι₁ₜ  = λ m     → do (v ← m ﹔
                             return (ι₁ v));
        ι₂ₜ  = λ n     → do (w ← n ﹔
                             return (ι₂ w));
        δₜ   = λ l m n → do (u ← l ﹔
                             v ← m ﹔
                             w ← n ﹔
                             δ u v w)}

InterpEnv : Set₁
InterpEnv = ∀ {ε} {{d : Trm ε}} → EnvOf (InterpBy ε) Σ

Interp' : Typₜ → Set₁
Interp' a = ∀ {ε} {{d : Trm ε}} → InterpBy' ε a

Interp : Typₜ → Set₁
Interp a = ∀ {ε} {{d : Trm ε}} → InterpBy ε a

-- evaluator
evalBy : ∀ {a} → InterpEnv → Syn a → Interp a
evalBy Σ m {{d}} = m {{d = evalD {{d}} (Σ {{d}})}}
