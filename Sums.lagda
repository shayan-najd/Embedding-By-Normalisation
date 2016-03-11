%format ⟨⟩ₜ  = "\underline{⟨⟩}"
%format ×ₜ  = "\underline{×}"
%format +ₜ  = "\underline{+}"
%format λₜ  = "\underline{λ}"
%format →ₜ  = "\underline{→}"
%format @ₜ  = "\underline{@}"
%format ,ₜ  = "\underline{,}"
%format π₁ₜ = "\underline{π₁}"
%format π₂ₜ = "\underline{π₂}"
%format ξₜ  = "\underline{ξ}"
%format ι₁ₜ = "\underline{ι₁}"
%format ι₂ₜ = "\underline{ι₂}"
%format δₜ  = "\underline{δ}"
%format ==  = "=="
%format ==ₜ = "\underline{==}"
%format *ₜ  = "\underline{*}"
%format /ₜ     = "\underline{/}"
%format q0ₜ    = "\underline{0}"
%format q1ₜ    = "\underline{1}"
%format -1ₜ    = "\underline{-1}"
%format ifₜ    = "\underline{\text{if}}"
%format thenₜ  = "\underline{\text{then}}"
%format elseₜ  = "\underline{\text{else}}"
%format trueₜ  = "\underline{\text{true}}"
%format falseₜ = "\underline{\text{false}}"
%format ℚₜ     = "\underline{ℚ}"
%format Boolₜ  = "\underline{\text{Bool}}"
%format αₜ     = "\underline{α}"

\begin{spec}
A,B ::= ... | A +ₜ B
\end{spec}

\begin{spec}
L,M,N ::=  ... | ι₁ₜ M | ι₂ₜ N | δₜ L M N
\end{spec}

\begin{spec}
...
⟦ A +ₜ B  ⟧ = ⟦ A ⟧  +  ⟦ B ⟧
\end{spec}

\begin{spec}
... (by trivial monadic lifting)
⟦ ι₁ₜ M      ⟧ Σ Γ  = ⦇ ι₁ (⟦ M ⟧ Σ Γ) ⦈
⟦ ι₂ₜ N      ⟧ Σ Γ  = ⦇ ι₂ (⟦ N ⟧ Σ Γ) ⦈
⟦ δₜ L M N   ⟧ Σ Γ  = join ⦇ δₜ (⟦ L ⟧ Σ Γ)  (⟦ M ⟧ Σ Γ)
                                             (⟦ N ⟧ Σ Γ) ⦈
\end{spec}

\begin{spec}
...
↓ (A →ₑ B)  V  = λ x → reset ⦇ ↓ B (join ⦇ V (↑ A x) ⦈) ⦈
↓ (A +ₑ B)  V  = δ V  (λ x → ι₁ₜ (↓ A x))
                      (λ y → ι₂ₜ (↓ B y))

... (by trivial monadic lifting)
↑ (A +ₑ B)  M  =  shift  (λ k →
                  δₜ M   (λ x → reset ⦇ (k ∘ ι₁) (↑ A x) ⦈)
                         (λ y → reset ⦇ (k ∘ ι₂) (↑ B y) ⦈))
\end{spec}


\begin{spec}
power n = λₜ x →ₜ
  if n < 0       then
    ifₜ x ==ₜ q0ₜ
    thenₜ q0ₜ
    elseₜ (-1ₜ /ₜ (power (- n) @ₜ x))
  else if n == 0 then
    q1ₜ
  else if even n then
    (  let  y = power (n / 2) @ₜ x
       in   y *ₜ y)
  else
    x *ₜ (power (n - 1) @ₜ x)
\end{spec}

\begin{spec}
Boolₜ   = ⟨⟩ₜ +ₜ ⟨⟩ₜ
falseₜ  = ι₁ₜ ⟨⟩ₜ
trueₜ   = ι₂ₜ ⟨⟩ₜ
ifₜ  L thenₜ M elseₜ N = δₜ L (λₜ x →ₜ N) (λₜ y →ₜ M)
\end{spec}

\begin{spec}
Ξ  = {ℚₜ ↦ ℚ}
Σ  = {  ==ₜ  : {ℚₜ , ℚₜ} ↦ Boolₜ ,
        *ₜ   : {ℚₜ , ℚₜ} ↦ ℚₜ ,
        /ₜ   : {ℚₜ , ℚₜ} ↦ ℚₜ }
\end{spec}

%% \begin{spec}
%% χ ∈ X (set of base types)
%% A,B ::= ⟨⟩ₜ | A →ₜ B | A ×ₜ B | χ | A +ₜ B
%% \end{spec}

%% \begin{spec}
%% x ∈ Γ (set of variables)
%% ξ ∈ Ξ (set of literals)
%% c ∈ Σ (signature of primitives)
%% L,M,N ::=  ⟨⟩ₜ  | x | λₜ x →ₜ N | L @ₜ M
%%               | (M ,ₜ N) | π₁ₜ L | π₂ₜ L
%%               | ξₜ | c Mᵢ
%%               | ι₁ₜ M | ι₂ₜ N | δₜ L M N
%% \end{spec}

%% \begin{spec}
%% ⟦ ⟨⟩ₜ     ⟧ = ⟨⟩
%% ⟦ A →ₜ B  ⟧ = ⟦ A ⟧  ↝  ⟦ B ⟧
%% ⟦ A ×ₜ B  ⟧ = ⟦ A ⟧  ×  ⟦ B ⟧
%% ⟦ χ       ⟧ = 𝔼 χ
%% ⟦ A +ₜ B  ⟧ = ⟦ A ⟧  +  ⟦ B ⟧
%% \end{spec}

%% \begin{spec}
%% ⟦ ⟨⟩ₜ        ⟧ Σ Γ  = ⦇ ⟨⟩ ⦈
%% ⟦ x          ⟧ Σ Γ  = Γ x
%% ⟦ λₜ x →ₜ N  ⟧ Σ Γ  = ⦇ λ y → ⟦ N ⟧ Σ (Γ, x ↦ ⦇ y ⦈) ⦈
%% ⟦ L @ₜ M     ⟧ Σ Γ  = join ⦇ (⟦ L ⟧ Σ Γ) (⟦ M ⟧ Σ Γ) ⦈
%% ⟦ (M ,ₜ N)   ⟧ Σ Γ  = ⦇ (⟦ M ⟧ Σ Γ , ⟦ N ⟧ Σ Γ) ⦈
%% ⟦ π₁ₜ L      ⟧ Σ Γ  = ⦇ π₁ (⟦ L ⟧ Σ Γ) ⦈
%% ⟦ π₂ₜ L      ⟧ Σ Γ  = ⦇ π₂ (⟦ L ⟧ Σ Γ) ⦈
%% ⟦ ξₜ         ⟧ Σ Γ  = ⦇ ξₜ ⦈
%% ⟦ c Mᵢ       ⟧ Σ Γ  = Σ c ⟦ Mᵢ ⟧
%% ⟦ ι₁ₜ M      ⟧ Σ Γ  = ⦇ ι₁ (⟦ M ⟧ Σ Γ) ⦈
%% ⟦ ι₂ₜ N      ⟧ Σ Γ  = ⦇ ι₂ (⟦ N ⟧ Σ Γ) ⦈
%% ⟦ δₜ L M N   ⟧ Σ Γ  = join ⦇ δₜ (⟦ L ⟧ Σ Γ)  (⟦ M ⟧ Σ Γ)
%%                                           (⟦ N ⟧ Σ Γ) ⦈
%% \end{spec}

%% \begin{spec}
%% ↓ ⟨⟩ₑ       V  = ⟨⟩ₜ
%% ↓ (A →ₑ B)  V  = λₜ x → reset ⦇ ↓ B (join ⦇ V (↑ A x) ⦈) ⦈
%% ↓ (A ×ₑ B)  V  = (↓ A (π₁ V) ,ₜ ↓ B (π₂ V))
%% ↓ 𝔼ₑ        V  = V
%% ↓ (A +ₑ B)  V  = δ V  (λ x → ι₁ₜ (↓ A x))
%%                       (λ y → ι₂ₜ (↓ B y))

%% ↑ ⟨⟩ₑ       M  = ⦇ ⟨⟩ ⦈
%% ↑ (A →ₑ B)  M  = ⦇ λ x → ↑ B (M @ₜ (↓ A x)) ⦈
%% ↑ (A ×ₑ B)  M  = ⦇ (↑ A (π₁ₜ M) , ↑ B (π₂ₜ M)) ⦈
%% ↑ 𝔼ₑ        M  = ⦇ M ⦈
%% ↑ (A +ₑ B)  M  =  shift  (λ k →
%%                   δₜ M   (λ x → reset ⦇ (k ∘ ι₁) (↑ A x) ⦈)
%%                          (λ y → reset ⦇ (k ∘ ι₂) (↑ B y) ⦈))
%% \end{spec}
