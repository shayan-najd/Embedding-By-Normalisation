module Chars.Hughes.Evaluation where

open import Utility
open import Chars.HOAS
open import Chars.Hughes.Syntax
open import Chars.Hughes.Semantic

open module CharsM {ε : Set} {{d : CharsD ε}} = CharsD d

⟦_⟧' : ∀ {ε} {{d : CharsD ε}} → CharsD (SemBy ε)
⟦_⟧' = record {
      ε₀   = id;
      chr  = λ i m → (chr i) ∙ m;
      _∙_  = λ m n → m ∘ n}

⟦_⟧ : Syn → Sem
⟦ m ⟧ {{d}} = m {{d = ⟦_⟧' {{d}}}}
