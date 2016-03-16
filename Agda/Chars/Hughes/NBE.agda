module Chars.Hughes.NBE where

open import Utility
open import NBE

open import Chars.HOAS
open import Chars.Hughes.Syntax
open import Chars.Hughes.Semantic
open import Chars.Hughes.Evaluation
open import Chars.Hughes.Reification

CharsWithListsisNBE : NBE
CharsWithListsisNBE = record
                      { Syn = Syn;
                        Sem = Sem;
                        ⟦_⟧  = ⟦_⟧;
                        ↓   = ↓}
