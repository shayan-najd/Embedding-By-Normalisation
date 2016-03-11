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
%format Mᵢ  = "\overline{M}"

\begin{spec}
χ ∈ X (set of base types)
A,B ::= ... | χ
\end{spec}

\begin{spec}
ξ ∈ Ξ (set of literals)
c ∈ Σ (singature of primitives)
L,M,N ::=  ... | ξₜ | c Mᵢ
\end{spec}

\begin{spec}
...
⟦ χ ⟧ = 𝔼 χ
\end{spec}

\begin{spec}
...
⟦ ξₜ    ⟧ Σ Γ  = ξₜ
⟦ c Mᵢ  ⟧ Σ Γ  = Σ c ⟦ Mᵢ ⟧
\end{spec}

\begin{spec}
...
↓ 𝔼ₑ V  = V

...
↑ 𝔼ₑ M  = M
\end{spec}

%% \begin{spec}
%% χ ∈ X (set of base types)
%% A,B ::= ⟨⟩ₜ | A →ₜ B | A ×ₜ B | χ
%% \end{spec}
%%
%% \begin{spec}
%% x ∈ Γ (set of variables)
%% ξ ∈ Ξ (set of literals)
%% c ∈ Σ (singature of primitives)
%% L,M,N ::=  ⟨⟩ₜ  | x | λₜ x →ₜ N | L @ₜ M
%%               | (M ,ₜ N) | π₁ₜ L | π₂ₜ L
%%               | ξₜ | c Mᵢ
%% \end{spec}
%%
%% \begin{spec}
%% ⟦ ⟨⟩ₜ     ⟧ = ⟨⟩
%% ⟦ A →ₜ B  ⟧ = ⟦ A ⟧  →  ⟦ B ⟧
%% ⟦ A ×ₜ B  ⟧ = ⟦ A ⟧  ×  ⟦ B ⟧
%% ⟦ χ       ⟧ = 𝔼 χ
%% \end{spec}
%%
%% \begin{spec}
%% ⟦ ⟨⟩ₜ        ⟧ Σ Γ  = ⟨⟩
%% ⟦ x          ⟧ Σ Γ  = Γ x
%% ⟦ λₜ x →ₜ N  ⟧ Σ Γ  = λ y → ⟦ N ⟧ Σ (Γ, x ↦ y)
%% ⟦ L @ₜ M     ⟧ Σ Γ  = (⟦ L ⟧ Σ Γ) (⟦ M ⟧ Σ Γ)
%% ⟦ (M ,ₜ N)   ⟧ Σ Γ  = (⟦ M ⟧ Σ Γ , ⟦ N ⟧ Σ Γ)
%% ⟦ π₁ₜ L      ⟧ Σ Γ  = π₁ (⟦ L ⟧ Σ Γ)
%% ⟦ π₂ₜ L      ⟧ Σ Γ  = π₂ (⟦ L ⟧ Σ Γ)
%% ⟦ ξₜ         ⟧ Σ Γ  = ξₜ
%% ⟦ c Mᵢ       ⟧ Σ Γ  = Σ c ⟦ Mᵢ ⟧
%% \end{spec}
%%
%% \begin{spec}
%% ↓ ⟨⟩ₑ       V  = ⟨⟩ₜ
%% ↓ (A →ₑ B)  V  = λₜ x → ↓ B (V (↑ A x ))
%% ↓ (A ×ₑ B)  V  = (↓ A (π₁ V) ,ₜ ↓ B (π₂ V))
%% ↓ 𝔼ₑ        V  = V
%% ↑ ⟨⟩ₑ       M  = ⟨⟩
%% ↑ (A →ₑ B)  M  = λ x → ↑ B (M $ₜ (↓ A x))
%% ↑ (A ×ₑ B)  M  = (↑ A (π₁ₜ M) , ↑ B (π₂ₜ M))
%% ↑ 𝔼ₑ        M  = M
%% \end{spec}
