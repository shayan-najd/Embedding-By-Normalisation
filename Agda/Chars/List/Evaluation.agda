module Chars.List.Evaluation where

open import Utility
open import Chars.HOAS
open import Chars.List.Syntax
open import Chars.List.Semantic

open module CharsM {ε : Set} {{d : CharsD ε}} = CharsD d

⟦_⟧' : CharsD Sem
⟦_⟧' = record {
      ε₀   = [];
      chr  = [_];
      _∙_  = _++_}

⟦_⟧ : Syn → Sem
⟦ m ⟧ = m {{d = ⟦_⟧'}}
