module Utility where
open import Agda.Primitive
  using (lzero;lsuc;_⊔_) public
open import Rat
 using ()
 renaming(_ℚ*_ to _*ℚ_;_ℚ/_ to _/ℚ_;ℚR to Rℚ) public
open import Agda.Primitive public
open import Data.Char
  using ()
  renaming (Char to ℂ ;show to showℂ) public
open import Data.Nat
  using (ℕ;zero;suc;⌊_/2⌋)
  renaming (_*_ to _*ℕ_; _∸_ to _∸ℕ_) public
open import Data.Integer
  using (ℤ;-[1+_];+_;-_;_-_)
  renaming (_≟_ to _≟ℤ_ ; _≤?_ to _≤?ₙ_; show to showℤ;_*_ to _*ℤ_
           ;_+_ to _+ℤ_) public
open import Data.Unit
   using (tt)
   renaming(⊤ to 𝟙) public
open import Data.Rational
  using (ℚ;_÷_)
  renaming (_≟_ to _≟ℚ_) public
open ℚ public
open import Data.String
  renaming (_≟_ to _≟𝕊_; show to show𝕊; String to 𝕊;_++_ to _⊕_) public
open import Data.Product
  using (∃;_×_;_,_)
  renaming(proj₁ to π₁;proj₂ to π₂)  public
open import Data.Maybe
  using (Maybe;nothing;just;maybe) public
open import Data.Sum
  using ()
  renaming (_⊎_ to _+_;inj₁ to ι₁;inj₂ to ι₂) public
open import Data.List
  using (List;[];_∷_;[_];map;foldr;_++_) public
open import Relation.Binary.PropositionalEquality
  using (_≡_;refl;cong;sym;trans;cong₂;subst) public
open import Relation.Nullary
  using (Dec;yes;no) public
infixr 6 _∧_
infix  0 if_then_else_

data 𝟚 : Set  where
  true  : 𝟚
  false : 𝟚

not : 𝟚 → 𝟚
not true  = false
not false = true

if_then_else_ : ∀ {a} {A : Set a} → 𝟚 → A → A → A
if true  then t else f = t
if false then t else f = f

δ : ∀ {a b c : Set} → a + b → (a → c) → (b → c) → c
δ (ι₁ x) m _ = m x
δ (ι₂ y) _ n = n y

_∧_ : 𝟚 → 𝟚 → 𝟚
true  ∧ b = b
false ∧ b = false

⌊_⌋ : ∀ {p} {P : Set p} → Dec P → 𝟚
⌊ yes _ ⌋ = true
⌊ no  _ ⌋ = false

_∘_ : ∀ {n} {a b c : Set n} → (b → c) → (a → b) → (a → c)
g ∘ f = λ x → g (f x)

id : ∀ {n} {a : Set n} → a → a
id x = x

_$_ : ∀ {n} {a b : Set n} → (a → b) → a → b
f $ x = f x

data Cont {k : Set} (c : k → Set) (b : Set) : Set where
  cont : (∀ {a : k} → (b → c a) → c a) → Cont c b

runCont : ∀ {k b} {c : k → Set} → Cont c b → (∀ {a : k} → (b → c a) → c a)
runCont (cont k) = k

shift : ∀ {k : Set} {c b} →
        (∀ {a : k} → (b → c a) → c a) → Cont c b
shift = cont

reset : ∀ {k} {c : k → Set} {a} → Cont c (c a) → c a
reset m = runCont m id

return : ∀ {k} {c : k → Set} {a} → a → Cont c a
return x = cont (λ k → k x)

_>>=_ : ∀ {k} {a b} {c : k → Set} → Cont c a → (a → Cont c b) → Cont c b
m >>= f = cont (λ k → runCont m (λ x → runCont (f x) k))

_=<<_ : ∀ {k} {c : k → Set} {a b} → (a → Cont c b) → Cont c a → Cont c b
f =<< m = m >>= f

join : ∀ {k} {c : k → Set} {a} → Cont c (Cont c a) → Cont c a
join m = m >>= id

_<$>_ : ∀ {k} {c : k → Set} {a b} → (a → b) → Cont c a → Cont c b
f <$> m = m >>= (λ x →  return (f x))

_<*>_ : ∀ {k} {c : k → Set} {a b} → Cont c (a → b) → Cont c a → Cont c b
f <*> x =  f >>= (λ f' →
           x >>= (λ x' →
           return (f' x')))

liftA₀ : ∀ {k} {c : k → Set} {a} → a → Cont c a
liftA₀ = return

liftA₁ : ∀ {k} {c : k → Set} {a b} → (a → b) → Cont c a → Cont c b
liftA₁ f m = f <$> m

liftA₂ : ∀ {k} {c : k → Set} {a b d} →
        (a → b → d) → Cont c a → Cont c b → Cont c d
liftA₂ f m n = (f <$> m) <*> n

liftA₃ : ∀ {k} {c : k → Set} {a b d e} →
        (a → b → d → e) → Cont c a → Cont c b → Cont c d → Cont c e
liftA₃ f l m n = ((f <$> l) <*> m) <*> n

_==ℤ_ : ℤ → ℤ → 𝟚
a ==ℤ b = ⌊ a ≟ℤ b ⌋

_==ℚ_ : ℚ → ℚ → 𝟚
a ==ℚ b = ⌊ a ≟ℚ b ⌋

_==𝕊_ : 𝕊 → 𝕊 → 𝟚
a ==𝕊 b = ⌊ a ≟𝕊 b ⌋

_<ℤ_ : ℤ → ℤ → 𝟚
a <ℤ b = ⌊ a ≤?ₙ b ⌋ ∧ (not (a ==ℤ b))

returnₘ : ∀ {a : Set} → a → Maybe a
returnₘ x  = just x

_>>=ₘ_ : ∀ {n} {a b : Set n} → Maybe a → (a → Maybe b) → Maybe b
m >>=ₘ f = maybe (λ x → f x) nothing  m

mutual
 evenℕ : ℕ → 𝟚
 evenℕ zero    = true
 evenℕ (suc n) = oddℕ n

 oddℕ : ℕ → 𝟚
 oddℕ zero    = false
 oddℕ (suc n) = evenℕ n

even : ℤ → 𝟚
even -[1+ n ] = oddℕ n
even (+ n) = evenℕ n

_/2 : ℤ → ℤ
_/2 -[1+ n ] with ⌊ suc n /2⌋
...| zero  = + zero
...| suc m = -[1+ m ]
_/2 (+ n) = + ⌊ n /2⌋


bind : ∀ {k} {a b} {c : k → Set} → Cont c a → (a → Cont c b) → Cont c b
bind = _>>=_
syntax bind m (\ x → c) = x ← m ﹔ c

do : ∀ {n} {a : Set n} → a → a
do = id

{-
bindₘ = _>>=ₘ_
syntax bindₘ m (\ x → c) = x ←ₘ m ﹔ c
-}

record Setoid (a : Set) : Set where
 field
   _≈_ : (x : a) → (y : a) → Dec (x ≡ y)

open Setoid {{...}} public

showℕ : ℕ → 𝕊
showℕ zero    = "zero"
showℕ (suc n) = "suc (" ⊕ showℕ n ⊕ ")"

showℚ : ℚ → 𝕊
showℚ record { numerator = i ; denominator-1 = j ; isCoprime = isCoprime } =
  "(" ⊕ showℤ i ⊕ ") ÷ (" ⊕ showℕ (suc j) ⊕ ")"

NameMonad : Set → Set
NameMonad a = ℕ → (a × ℕ)

returnₙ : ∀ {a} → a → NameMonad a
returnₙ x n = (x , n)

bindₙ : ∀ {a b} → NameMonad a → (a → NameMonad b) → NameMonad b
bindₙ m f = λ n → let (x , n') =  m n
                  in  f x n'

syntax bindₙ m (\ x → c) = x ←ₙ m ﹔ c

newName : NameMonad 𝕊
newName n = ("x" ⊕ showℤ (+ n) , suc n )

0ℤ : ℤ
0ℤ = + 0

1ℤ : ℤ
1ℤ = + 1

-1ℤ : ℤ
-1ℤ = -[1+ 0 ]

0ℚ : ℚ
0ℚ = 0ℤ ÷ 1

1ℚ : ℚ
1ℚ = 1ℤ ÷ 1

-1ℚ : ℚ
-1ℚ = -1ℤ ÷ 1
