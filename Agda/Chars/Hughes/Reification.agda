module Chars.Hughes.Reification where

open import Utility
open import Chars.HOAS
open import Chars.Hughes.Syntax
open import Chars.Hughes.Semantic

open module CharsM {i} {ε : Set i} {{d : CharsD {i} ε}} = CharsD d

↓ : Sem → Syn
↓ V {{d}} = (V {{d}}) ε₀
