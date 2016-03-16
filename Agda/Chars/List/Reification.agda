module Chars.List.Reification where

open import Utility
open import Chars.HOAS
open import Chars.List.Syntax
open import Chars.List.Semantic

open module CharsM {ε : Set} {{d : CharsD ε}} = CharsD d

↓ : Sem → Syn
↓ []       = ε₀
↓ (n ∷ ns) = chr n ∙ ↓ ns
