module Chars.List.NBE where

open import Utility
open import NBE

open import Chars.HOAS
open import Chars.List.Syntax
open import Chars.List.Semantic
open import Chars.List.Evaluation
open import Chars.List.Reification

CharsWithListsisNBE : NBE
CharsWithListsisNBE = record
                      { Syn = Syn;
                        Sem = Sem;
                        ⟦_⟧  = ⟦_⟧;
                        ↓   = ↓}

module HOASNBEProof where
  open module CharsM_ {ε : Set} {{d : CharsD ε}} = CharsD d

  infix 4 _≜c_
  data _≜c_ {ε : Set} {{d : CharsD ε}} : ε → ε → Set where
    refl≜c          :  ∀ {a}          → a ≜c a
    sym≜c           :  ∀ {a b}        → a ≜c b  → b ≜c a
    trans≜c         :  ∀ {a b c}      → a ≜c b  → b ≜c c → a ≜c c
    cong∙           :  ∀ {a b a' b'}  → a ≜c a' → b ≜c b' → a ∙ b ≜c a' ∙ b'
    idᵣ∙            :  ∀ {a}          → ε₀ ∙ a ≜c a
    idₗ∙            :  ∀ {a}          → a ∙ ε₀ ≜c a
    assoc∙          :  ∀ {a b c}      → (a ∙ b) ∙ c ≜c a ∙ (b ∙ c)

open import Chars.FOAS as F
open import Chars.Conversion

⟦_⟧f : F.Chars → Sem
⟦ M ⟧f =  ⟦ FOAStoHOAS M ⟧

↓f : Sem → F.Chars
↓f V = HOAStoFOAS (↓ V)

normf : F.Chars → F.Chars
normf M  = ↓f ⟦ M ⟧f

infix 4 _≜f_
data _≜f_ : F.Chars → F.Chars → Set where
  refl≜f   :  ∀ {a}          → a ≜f a
  sym≜f    :  ∀ {a b}        → a ≜f b  → b ≜f a
  trans≜f  :  ∀ {a b c}      → a ≜f b  → b ≜f c → a ≜f c
  cong∙    :  ∀ {a b a' b'}  → a ≜f a' → b ≜f b' → a ∙ b ≜f a' ∙ b'
  idᵣ∙     :  ∀ {a}          → ε₀ ∙ a ≜f a
  idₗ∙     :  ∀ {a}          → a ∙ ε₀ ≜f a
  assoc∙   :  ∀ {a b c}      → (a ∙ b) ∙ c ≜f a ∙ (b ∙ c)

++-assoc : ∀ {k : Set} {b c} → (a : List k) → (a ++ b) ++ c ≡ a ++ (b ++ c)
++-assoc []       = refl
++-assoc (x ∷ as) = cong (x ∷_) (++-assoc as)

++-idᵣ : (M : F.Chars) → ⟦ M ⟧f ++ [] ≡ ⟦ M ⟧f
++-idᵣ ε₀      = refl
++-idᵣ (chr _) = refl
++-idᵣ (M ∙ N) = trans (++-assoc (⟦ M ⟧f)) (cong (⟦ M ⟧f ++_) (++-idᵣ N))

-- Lindley calls it soundness
soundnessLem : ∀ {M N} → M ≜f N → ⟦ M ⟧f ≡ ⟦ N ⟧f
soundnessLem refl≜f          = refl
soundnessLem (sym≜f p)       = sym   (soundnessLem p)
soundnessLem (trans≜f p₁ p₂) = trans (soundnessLem p₁) (soundnessLem p₂)
soundnessLem (cong∙ p₁ p₂)   = cong₂ (_++_) (soundnessLem p₁) (soundnessLem p₂)
soundnessLem idᵣ∙            = refl
soundnessLem (idₗ∙ {M})      = ++-idᵣ M
soundnessLem (assoc∙ {a})    = ++-assoc (⟦ a ⟧f)

consistencyLemma : (M : _) → (N : _) →
                   normf M ∙ normf N ≜f ↓f (⟦ M ⟧f ++ ⟦ N ⟧f)
consistencyLemma ε₀       _ = idᵣ∙
consistencyLemma (chr _)  _ = cong∙ idₗ∙ refl≜f
consistencyLemma (L ∙ M)  N = let p x = ((normf L ∙ normf M) ∙ normf N) ≜f ↓f x
                                  l   = sym (++-assoc ⟦ L ⟧f)
                                  k   = trans≜f assoc∙ (trans≜f (cong∙ refl≜f
                                        (consistencyLemma M N))
                                        (consistencyLemma L (M ∙ N)))
                              in  trans≜f (cong∙ (sym≜f (consistencyLemma L M))
                                                 refl≜f)
                                  (subst p l k)

-- Altenkirch calls it completeness, or stability
--    when embedding normal forms into syntax is id
-- Lindley calls it consistency
consistency : ∀ M → M ≜f normf M
consistency ε₀      = refl≜f
consistency (chr _) = sym≜f idₗ∙
consistency (M ∙ N) = trans≜f (cong∙ (consistency _) (consistency _))
                               (consistencyLemma M N)

-- Abel calls it completeness
dybjerA : ∀ {M N} → M ≜f N → normf M ≡ normf N
dybjerA p = cong ↓f (soundnessLem p)

dybjerB : ∀ {M N} → normf M ≡ normf N → M ≜f N
dybjerB p = trans≜f (subst (_ ≜f_) p (consistency _))
                    (sym≜f (consistency _))

-- denotee domain (semantic) should have equality defined for it
-- we use ≡ for it for now
-- begin
abelSoundnessA-meaningPres : ∀ M → ⟦ normf M ⟧f ≡ ⟦ M ⟧f
abelSoundnessA-meaningPres M = soundnessLem (sym≜f (consistency M))

abelCompleteness : ∀ M N → ⟦ M ⟧f ≡ ⟦ N ⟧f → normf M ≡ normf N
abelCompleteness M N p = dybjerA {M} {N} (dybjerB (cong ↓f p))

abelSoundnessB-idemp : ∀ M → normf (normf M) ≡ normf M
abelSoundnessB-idemp M = sym (dybjerA {M} {normf M} (consistency _))

najdSoundnessC : ∀ {M N} → M ≜f N → normf M ≜f N
najdSoundnessC p = subst id (sym (cong (_≜f _) (dybjerA p)))
                         (sym≜f (consistency _))

altenkirchSoundnessC : ∀ M N → M ≜f N → normf M ≜f normf N
altenkirchSoundnessC M N p =
  subst (normf M ≜f_) (dybjerA p) (refl≜f {a = normf M})

najdCanonicityC : (a : _) → normf (normf a) ≡ normf a
najdCanonicityC = abelSoundnessB-idemp

lindleyExistenceProof : {isNorm : F.Chars → Set} →
                        (∀ {M N} → M ≜f N → ⟦ M ⟧f ≡ ⟦ N ⟧f) ×
                        ((M : F.Chars) → ∃ (λ V → isNorm V × V ≜f M)) ×
                        (∀ {V : F.Chars} → isNorm V → V ≡ normf V) →
                        ∀ M → normf M ≜f M
lindleyExistenceProof (p₁ , p₂ , p₃) M =
 let (_ , b , c) = p₂ M
 in subst id (cong (_≜f M) (trans (p₃ b) (cong ↓f (p₁ c)))) c
