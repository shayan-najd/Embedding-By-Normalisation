module Chars.List.Syntax where

open import Utility
open import Chars.HOAS

SynBy : Set → Set
SynBy ε = ε

Syn : Set₁
Syn = ∀ {ε} {{d : CharsD ε}} → SynBy ε
