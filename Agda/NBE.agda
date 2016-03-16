module NBE where
open import Utility

record NBE {i j} : Set (lsuc (lsuc (i ⊔ j))) where
   field
    Syn  :  Set i
    Sem  :  Set j
    ⟦_⟧   :  Syn → Sem
    ↓    :  Sem → Syn

   normalise : Syn → Syn
   normalise m = ↓ ⟦ m ⟧

record TypedNBE (a : Set) : Set₂ where
   field
    Syn  : a → Set₁
    Sem  : a → Set₁
    ⟦_⟧   : ∀ {a} → Syn a → Sem a
    ↓    : ∀ {a} → Sem a → Syn a

   normalise : ∀ {a} → Syn a → Syn a
   normalise m = ↓ ⟦ m ⟧
