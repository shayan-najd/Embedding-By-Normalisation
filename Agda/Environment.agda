module Environment where

open import Utility

data _∈_ {k : Set} (a : k) : List k → Set where
  zro : ∀ {Γ}   → a ∈ (a ∷ Γ)
  suc : ∀ {b Γ} → a ∈ Γ → a ∈ (b ∷ Γ)

data All {k : Set} (f : k → Set) : List k → Set where
  emp : All f []
  ext : ∀ {a Γ} → f a → All f Γ → All f (a ∷ Γ)

syntax All (\ aᵢ → f) Δ =  f , aᵢ ∈ Δ

_↦_ : {a b : Set} → a → b → a × b
_↦_ = _,_


EnvOf : ∀ {k} → (k → Set) → List ((List k) × k) → Set
EnvOf ε Σ = All (λ {(Δ , b) → All ε Δ → ε b}) Σ


lookUp : ∀ {k : Set} {a : k} {Γ f} → a ∈ Γ → All f Γ → f a
lookUp zro     (ext x _)  = x
lookUp (suc v) (ext _ xs) = lookUp v xs

lookUpIn : ∀ {k : Set} {a : k} {Γ f} → All f Γ → a ∈ Γ → f a
lookUpIn Γ x = lookUp x Γ

sequence : ∀ {k} {c : k → Set} {f : k → Set} {as} →
           All (λ a → Cont c (f a)) as  →
           Cont c (All f as)
sequence emp        = return emp
sequence (ext x xs) = (ext <$> x) <*> sequence xs

sequenceₙ : ∀ {k} {f : k → Set} {as} →
            All (λ a → NameMonad (f a)) as  →
            NameMonad (All f as)
sequenceₙ emp        = returnₙ emp
sequenceₙ (ext x xs) = do (x'  ←ₙ x  ﹔
                           xs' ←ₙ sequenceₙ xs ﹔
                           returnₙ (ext x' xs'))


mapAll : ∀ {k} {f g : k → Set} {as : List k} →
         (∀ {a : k} → f a → g a) →
         All f as → All g as
mapAll _ emp        = emp
mapAll f (ext x xs) = ext (f x) (mapAll f xs)


mapM : ∀ {k} {f g c : k → Set} {as : List k} →
       (∀ {a : k} → f a → Cont c (g a)) →
       All f as → Cont c (All g as)
mapM _ emp        = return emp
mapM f (ext x xs) = (ext <$> f x) <*> (mapM f xs)

zip : ∀ {k} {f g : k → Set} {as} →
      All f as → All g as → All (\ a → f a × g a) as
zip emp        emp        = emp
zip (ext x xs) (ext y ys) = ext (x , y) (zip xs ys)

showAll : ∀ {k Δ f} → (∀ {a : k} → f a → 𝕊) → All f Δ → 𝕊
showAll show𝔼 emp        = "emp"
showAll show𝔼 (ext x xs) = "ext (" ⊕ show𝔼 x ⊕ ") ("
                            ⊕ showAll show𝔼 xs  ⊕ ")"

showVar : ∀ {k : Set} {Γ} {a : k} →  a ∈ Γ → 𝕊
showVar zro     = "zro"
showVar (suc x) = "suc (" ⊕ showVar x ⊕ ")"
