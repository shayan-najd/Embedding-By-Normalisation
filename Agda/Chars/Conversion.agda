module Chars.Conversion where

open import Utility
open import Environment
import Chars.FOAS as F
open import Chars.HOAS

HOAStoFOAS : Chars → F.Chars
HOAStoFOAS c = c {{d = HOAStoFOAS'}}
  where
    HOAStoFOAS' : CharsD F.Chars
    HOAStoFOAS' = record {
                  ε₀   = F.ε₀;
                  chr  = F.chr;
                  _∙_  = F._∙_}

FOAStoHOAS : F.Chars → Chars
FOAStoHOAS m {ε} = FOAStoHOAS' m
  where
    open module CharsM {ε : Set} {{d : CharsD ε}} = CharsD d

    FOAStoHOAS' : F.Chars → ε
    FOAStoHOAS' F.ε₀        = ε₀
    FOAStoHOAS' (F.chr c)   = chr c
    FOAStoHOAS' (c₀ F.∙ c₁) = FOAStoHOAS' c₀ ∙ FOAStoHOAS' c₁
