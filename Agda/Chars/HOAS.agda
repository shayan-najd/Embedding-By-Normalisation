module Chars.HOAS where

open import Utility

record CharsD {i} (chars : Set i) : Set i where
  field
    ε₀   : chars
    chr  : ℂ     → chars
    _∙_  : chars → chars → chars

Chars : ∀ {i} → Set (lsuc i)
Chars {i} = ∀ {ε} {{d : CharsD {i} ε}} → ε

show𝔼 : Chars → 𝕊
show𝔼 m = m {{d = show𝔼'}}
  where
    show𝔼' : CharsD 𝕊
    show𝔼' = record {
             ε₀   = "ε₀";
             chr  = λ c → "chr " ⊕ showℂ c;
             _∙_  = λ c₀ c₁ → "(" ⊕ c₀ ⊕ ") ∙ (" ⊕ c₁ ⊕ ")"}
