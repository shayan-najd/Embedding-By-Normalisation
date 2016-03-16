module Chars.FOAS where

open import Utility

data Chars : Set where
  ε₀   : Chars
  chr  : ℂ     → Chars
  _∙_  : Chars → Chars → Chars

show𝔼 : Chars → 𝕊
show𝔼 ε₀        = "ε₀"
show𝔼 (chr c)   = "chr " ⊕ showℂ c
show𝔼 (c₀ ∙ c₁) = "(" ⊕ show𝔼 c₀ ⊕ ") ∙ (" ⊕  show𝔼 c₁ ⊕ ")"
