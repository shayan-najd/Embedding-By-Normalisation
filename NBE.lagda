%if False
\begin{code}
open import Relation.Binary.PropositionalEquality
   using (_≡_;cong;sym;trans;refl;cong₂;subst)
open import Data.Product
open import Function
\end{code}
%endif

Normalisation-by-Evaluation (NBE) is the process of deriving normal
form of terms with respect to an equational theory. NBE dates back to
\citet{MartinLof}, where he used similar technique, although not by its
current name, for normalising terms in type theory.
\citet{Berger} introduced NBE as an efficient normalisation technique.
In the context of proof theory, they observed that the round trip of
first evaluating terms, and then applying an inverse of the evaluation
function, results in normalises the terms. Following \citet{Berger},
\citet{TDPE} used NBE to implement an offline partial evaluator
that only required types of terms to partially evaluate them.

\todo{}{mention reduction-based and reduction free normalisation}


Nbe constitutes of four components:
\begin{description}
\item [syntactic domain]
Abstract syntax of terms.

\todo{}{...}

\item [semantic domain] ...

\todo{}{...}


\item [evaluation]:
The process of mapping terms in the syntactic domain to the
corresponding elements in the semantic domain. Despite the name,
the evaluation process in NBE is often quite different from the one in the
standard evaluators.
Although it is not necessarily required, the evaluation process in NBE
is often denotational (compositional).

\item [reification]:
The process of mapping (back) elements of semantic domain to the
corresponding terms in the syntactic domain.

\end{description}

Formally, NBE can be defined as follows:
\begin{code}

record NBE : Set₁ where
   field
    Syn  :  Set
    Sem  :  Set
    ⟦_⟧   :  Syn → Sem
    ↓    :  Sem → Syn

   normalise : Syn → Syn
   normalise m = ↓ ⟦ m ⟧

\end{code}

% --    _≜_  : Syn → Syn → Set
% --    soundness   : ∀ {a b} → a ≜ b → ↓ ⟦ a ⟧ ≜ b
% --    canonicity  : ∀ {a} → ↓ ⟦ ↓ ⟦ a ⟧ ⟧ ≡ ↓ ⟦ a ⟧
% --   infix 4 _≜_

Additionally, above should guarantee that, (a) |normalise| preserves
the intended meaning of the terms, and (b) |normalise| produces terms
in a normal form with respect to the intended equational theory.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Chars lists
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\subsection{A First Example}
\label{sec:CharsLists}
%if False
\begin{code}
module NBEExamle where
 open import Data.Nat
 open import Data.List
 infix 4 _≜c_
\end{code}
%endif

Consider terms of the following grammar:
\begin{code}
 data Chars : Set where
    ε₀   : Chars
    chr  : ℕ     → Chars
    _∙_  : Chars → Chars → Chars
\end{code}

\todo{}{Explain the intended use of above as regex for lexing and parsing.}

with the following equational theory:
%% \begin{code}
%%  data _≜c_ : Chars → Chars → Set where
%%     refl≜c          :  ∀ {a}          → a ≜c a
%%     sym≜c           :  ∀ {a b}        → a ≜c b  → b ≜c a
%%     trans≜c         :  ∀ {a b c}      → a ≜c b  → b ≜c c → a ≜c c
%%     cong∙           :  ∀ {a b a' b'}  → a ≜c a' → b ≜c b' → a ∙ b ≜c a' ∙ b'
%%     idᵣ∙            :  ∀ {a}          → ε₀ ∙ a ≜c a
%%     idₗ∙            :  ∀ {a}          → a ∙ ε₀ ≜c a
%%     assoc∙          :  ∀ {a b c}      → (a ∙ b) ∙ c ≜c a ∙ (b ∙ c)
%% \end{code}

%if False
\begin{code}
 module CharsList where

\end{code}
%endif

The corresponding NBE is as follows:
\begin{code}
  flatten : Chars → List ℕ
  flatten ε₀         = []
  flatten (chr x)    = [ x ]
  flatten (xs ∙ ys)  = flatten xs ++ flatten ys

  roughen : List ℕ → Chars
  roughen []        = ε₀
  roughen (n ∷ ns)  = chr n ∙ roughen ns

  nbe-Chars : NBE
  nbe-Chars  =
   record
      { Syn  = Chars;
        Sem  = List ℕ;
        ⟦_⟧   = flatten;
        ↓    = roughen
      }
\end{code}
It is easy to prove that normalisation above respects the two properties:

%if False
\begin{code}
  open NBE nbe-Chars
\end{code}
%endif

% \begin{code}
%
% -- preservation : ∀ {a b : Chars} → a ≜c b → normalise a ≜c b
% -- preservation p = {!!}
%
% -- normalisation : ∀ {a} → normalise (normalise a) ≡ normalise a
% -- normalisation = {!!}
% \end{code}

\todo{prove it, but consider taking out of the paper}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Chars Hughes Lists
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\subsection{A Second Example}
\label{sec:CharsHughes}
%if False
\begin{code}
 module CharsHughes where

\end{code}
%endif

%if False
\begin{code}
  flatten : Chars → (Chars → Chars)
  flatten ε₀         = id
  flatten (chr x)    = λ xs → (chr x) ∙ xs
  flatten (xs ∙ ys)  = flatten xs ∘ flatten ys

  roughen : (Chars → Chars) → Chars
  roughen f  = f ε₀

  nbe-Chars : NBE
  nbe-Chars  =
   record
      { Syn  = Chars;
        Sem  = Chars → Chars;
        ⟦_⟧   = flatten;
        ↓    = roughen
      }
\end{code}
%endif
