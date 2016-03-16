open import Utility

module TDPE.Smart.Type (χ : Set) {{d : Setoid χ}} where

data Typₜ : Set where
 𝟙ₜ   : Typₜ
 𝔹ₜ   : χ  → Typₜ
 _→ₜ_ : Typₜ → Typₜ → Typₜ
 _×ₜ_ : Typₜ → Typₜ → Typₜ
 _+ₜ_ : Typₜ → Typₜ → Typₜ

inj𝔹ₜ : ∀ {x y : χ} → 𝔹ₜ x ≡ 𝔹ₜ y → (x ≡ y)
inj𝔹ₜ refl = refl

injₐₜₗ : ∀ {a b a' b' : Typₜ} → a →ₜ b ≡ a' →ₜ b' → (a ≡ a')
injₐₜₗ {a = 𝟙ₜ}     refl = refl
injₐₜₗ {a = 𝔹ₜ _}   refl = refl
injₐₜₗ {a = a →ₜ b} refl = refl
injₐₜₗ {a = a ×ₜ b} refl = refl
injₐₜₗ {a = a +ₜ b} refl = refl

injₐₜᵣ : ∀ {b a a' b' : Typₜ} → a →ₜ b ≡ a' →ₜ b' → (b ≡ b')
injₐₜᵣ {a = 𝟙ₜ}     refl = refl
injₐₜᵣ {a = 𝔹ₜ _}   refl = refl
injₐₜᵣ {a = a →ₜ b} refl = refl
injₐₜᵣ {a = a ×ₜ b} refl = refl
injₐₜᵣ {a = a +ₜ b} refl = refl

injₓₜₗ : ∀ {a b a' b' : Typₜ} → a ×ₜ b ≡ a' ×ₜ b' → (a ≡ a')
injₓₜₗ {a = 𝟙ₜ}     refl = refl
injₓₜₗ {a = 𝔹ₜ _}   refl = refl
injₓₜₗ {a = a →ₜ b} refl = refl
injₓₜₗ {a = a ×ₜ b} refl = refl
injₓₜₗ {a = a +ₜ b} refl = refl

injₓₜᵣ : ∀ {b a a' b' : Typₜ} → a ×ₜ b ≡ a' ×ₜ b' → (b ≡ b')
injₓₜᵣ {a = 𝟙ₜ}     refl = refl
injₓₜᵣ {a = 𝔹ₜ _}   refl = refl
injₓₜᵣ {a = a →ₜ b} refl = refl
injₓₜᵣ {a = a ×ₜ b} refl = refl
injₓₜᵣ {a = a +ₜ b} refl = refl

inj₊ₜₗ : ∀ {a b a' b' : Typₜ} → a +ₜ b ≡ a' +ₜ b' → (a ≡ a')
inj₊ₜₗ {a = 𝟙ₜ}     refl = refl
inj₊ₜₗ {a = 𝔹ₜ _}   refl = refl
inj₊ₜₗ {a = a →ₜ b} refl = refl
inj₊ₜₗ {a = a ×ₜ b} refl = refl
inj₊ₜₗ {a = a +ₜ b} refl = refl

inj₊ₜᵣ : ∀ {b a a' b' : Typₜ} → a +ₜ b ≡ a' +ₜ b' → (b ≡ b')
inj₊ₜᵣ {a = 𝟙ₜ}     refl = refl
inj₊ₜᵣ {a = 𝔹ₜ _}   refl = refl
inj₊ₜᵣ {a = a →ₜ b} refl = refl
inj₊ₜᵣ {a = a ×ₜ b} refl = refl
inj₊ₜᵣ {a = a +ₜ b} refl = refl

eql : (a : Typₜ) → (b : Typₜ) → Dec (a ≡ b)
eql 𝟙ₜ 𝟙ₜ = yes refl
eql 𝟙ₜ (𝔹ₜ _) = no (λ ())
eql 𝟙ₜ (a' →ₜ b') = no (λ ())
eql 𝟙ₜ (a' ×ₜ b') = no (λ ())
eql 𝟙ₜ (a' +ₜ b') = no (λ ())
eql (𝔹ₜ _) 𝟙ₜ = no (λ ())
eql (𝔹ₜ x) (𝔹ₜ y) with x ≈ y
eql (𝔹ₜ x) (𝔹ₜ .x) | yes refl = yes refl
eql (𝔹ₜ x) (𝔹ₜ y) | no ¬p = no (λ x → ¬p (inj𝔹ₜ x))
eql (𝔹ₜ _) (a' →ₜ b') = no (λ ())
eql (𝔹ₜ _) (a' ×ₜ b') = no (λ ())
eql (𝔹ₜ _) (a' +ₜ b') = no (λ ())
eql (a →ₜ b) 𝟙ₜ = no (λ ())
eql (a →ₜ b) (𝔹ₜ _) = no (λ ())
eql (a →ₜ b) (a' →ₜ b') with eql a a' | eql b b'
eql (a →ₜ b) (a' →ₜ b') | yes p | yes p₁ = yes (cong₂ _→ₜ_ p p₁)
eql (a →ₜ b) (a' →ₜ b') | yes p | no ¬p = no (λ x → ¬p (injₐₜᵣ x))
eql (a →ₜ b) (a' →ₜ b') | no ¬p | p' = no (λ x → ¬p (injₐₜₗ x))
eql (a →ₜ b) (a' ×ₜ b') = no (λ ())
eql (a →ₜ b) (a' +ₜ b') = no (λ ())
eql (a ×ₜ b) 𝟙ₜ = no (λ ())
eql (a ×ₜ b) (𝔹ₜ _) = no (λ ())
eql (a ×ₜ b) (a' →ₜ b') = no (λ ())
eql (a ×ₜ b) (a' ×ₜ b') with eql a a' | eql b b'
eql (a ×ₜ b) (a' ×ₜ b') | yes p | yes p₁ = yes (cong₂ _×ₜ_ p p₁)
eql (a ×ₜ b) (a' ×ₜ b') | yes p | no ¬p = no (λ x → ¬p (injₓₜᵣ x))
eql (a ×ₜ b) (a' ×ₜ b') | no ¬p | p' = no (λ x → ¬p (injₓₜₗ x))
eql (a ×ₜ b) (a' +ₜ b') = no (λ ())
eql (a +ₜ b) 𝟙ₜ = no (λ ())
eql (a +ₜ b) (𝔹ₜ _) = no (λ ())
eql (a +ₜ b) (a' →ₜ b') = no (λ ())
eql (a +ₜ b) (a' ×ₜ b') = no (λ ())
eql (a +ₜ b) (a' +ₜ b') with eql a a' | eql b b'
eql (a +ₜ b) (a' +ₜ b') | yes p | yes p₁ = yes (cong₂ _+ₜ_ p p₁)
eql (a +ₜ b) (a' +ₜ b') | yes p | no ¬p = no (λ x → ¬p (inj₊ₜᵣ x))
eql (a +ₜ b) (a' +ₜ b') | no ¬p | p' = no (λ x → ¬p (inj₊ₜₗ x))
