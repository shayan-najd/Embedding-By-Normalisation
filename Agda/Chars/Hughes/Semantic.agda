module Chars.Hughes.Semantic where

open import Utility
open import Chars.HOAS
open import Chars.Hughes.Syntax

SemBy : Set → Set
SemBy ε = ε → ε

Sem : Set₁
Sem = ∀ {ε} {{d : CharsD ε}} → SemBy ε
