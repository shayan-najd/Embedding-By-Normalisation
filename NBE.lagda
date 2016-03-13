Normalisation-by-Evaluation (NBE) is the process of deriving canonical
form of terms with respect to an equational theory.The process of
deriving canonical forms is often refered to as normalisation, where
the canonical forms are refered to as normal forms. NBE dates back to
\citet{MartinLof}, where he used a similar technique, although not by
its current name, for normalising terms in type theory.
\citet{Berger} introduced NBE as an efficient normalisation technique.
In the context of proof theory, they observed that the round trip of
first evaluating terms, and then applying an inverse of the evaluation
function, normalises the terms. Following \citet{Berger}, \citet{TDPE}
used NBE to implement an offline partial evaluator that only required
types of terms to partially evaluate them.

There are different approaches to normalisation.  One popular approach
to normalisation is reduction-based, where a set of rewrite rules are
applied exhaustively until they can no longer be applied.  In contrast
to reduction-based approaches, NBE is defined based on a pair of
well-known program transformations, instead of rewrite rules. For this
reason, NBE is categorised as a reduction-free normalisation process.


Nbe constitutes of four components:
\begin{description}
\item [Syntactic Domain]
is the language of terms to be
normalised by a NBE algorithm.

\item [Semantic Domain]
is another language used in NBE, defining a model for
evaluting terms in the syntactic domain. Often the semantic domain
contains parts of the syntactic domain are left uninterpreted. The
unintepreted parts are refered to as the residual parts, and in their
presence the semantic model as the residualising model.

\item [Evaluation]
is the process of mapping terms in the syntactic domain to
the corresponding elements in the semantic domain. Despite the name,
the evaluation process in NBE is often quite different from the one in
the standard evaluators.  Although it is not necessarily required, the
evaluation process in NBE is often compositional.
In this paper, following the convention, evaluation functions are
denoted as |⟦_⟧|. In the typed variant of NBE, same notation is also
used to denote mapping of types in evaluation.

\item [Reification]
is the process of mapping (back) elements of semantic
domain to the corresponding terms in the syntactic domain.
In this paper, following the convention, reification functions are
denoted as |↓|.

\end{description}

More formally, an algortihm with NBE structure can be seen as an
instance of the following (dependent) record:
\begin{spec}
NBE = {  Syn  : Type ,
         Sem  : Type ,
         ⟦_⟧   : Syn → Sem ,
         ↓    : Sem → Syn }
\end{spec}

As mentioned, normalisation in NBE is the round trip of first
evaluating terms, and then reifying them back. Therefore,
normalisation in NBE is a mapping from syntactic domain
to syntactic domain:

\begin{spec}
norm : Syn → Syn
norm M = ↓ ⟦ M ⟧
\end{spec}

In a typed setting, it is expected that transformations in NBE to
preseve types of the terms. More formally, an algortihm with NBE
structure in a typed setting can be seen as an instance of the
following (dependent) record, with the following normalisation
function:
%format Typeₜ = "\underline{Type}"
\begin{spec}
TypedNBE = {  Syn  : Typeₜ → Type ,
              Sem  : Typeₜ → Type ,
              ⟦_⟧   : ∀ A. Syn A → Sem A ,
              ↓    : ∀ A. Sem A → Syn A }

norm : ∀ A. Syn A → Syn A
norm M = ↓ ⟦ M ⟧
\end{spec}

Above, |Typeₜ| denotes kind of object types. It is underlined to
contrast it with |Type| which is the kind of types in the metalanguage.

A valid NBE normalisation algorithm, both untyped and typed, should
guarantee that, (a) normalisation preserves the intended meaning of
the terms, and (b) normalisation derives canonical form of terms up to
certain congruence relation.

% Canonicity of NBE,
% as defined by the mentioned congruence relation, varies from an application
% to another. In simpler cases, syntactic equality is considered, while for
% others ...

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Chars
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\subsection{A First Example}
\label{sec:CharsLists}
As the first example, consider the "hello world" of NBE, terms of the
following language:
\begin{spec}
c ∈ Char (set of characters)
L,M,N ∈ Chars ::= ε₀ | Chr c | M ∙ N
\end{spec}

The language, refered to as Chars, consists of an empty string, a
string containing only one character, and concatenation of strings.

For example, the terms
\begin{spec}
Chr 'N' ∙ (Chr 'B' ∙ Chr 'E')
\end{spec} and
\begin{spec}
(Chr 'N' ∙ ε₀) ∙ ((Chr 'B' ∙ ε₀) ∙ (Chr 'E' ∙ ε₀))
\end{spec} both represent the string ``NBE".

The intended equational theory for this language is the one of
free monoids, i.e., congruence over the following equations:
\begin{center}
\begin{spec}
      ε₀ ∙ M  =  M
     M  ∙ ε₀  =  M
 (L ∙ M) ∙ N  =  L ∙ (M ∙ N)
\end{spec}
\end{center}
NBE provides a normalisation process to derive a cannonical form for
the terms with respect to above equational theory. If two terms
represent the same string, they have an identical canonical form.
For instance, the two example terms above normalise to the following
term in canonical form:
\begin{spec}
Chr 'N' ∙ (Chr 'B' ∙ (Chr 'E' ∙ ε₀))
\end{spec}

For a specific syntactic domain, in this case the Chars language,
there are different ways to implement a NBE algorithm, as
there are different semantic domains to choose from.
For pedagogical purposes, two distinct NBE algorithms are presented
for the Chars language based on two distinct semantic domains:
(1) lists of characters, and
(2) functions over the syntactic domain itself.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Chars Lists
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\subsubsection{Lists as Semantic}
The syntactic domain given to be the Chars language, and semantic
domain chosen to be a list of characters, the next step
for defining a NBE algorithm is defining an evaluation function:

\begin{spec}
⟦_⟧ : Chars → List Char

⟦ ε₀     ⟧ = []
⟦ Chr n  ⟧ = [ n ]
⟦ M ∙ N  ⟧ = ⟦ M ⟧ ++ ⟦ N ⟧
\end{spec}

Evaluation defined above is a simple mapping from Chars terms to
lists, where empty string is mapped to empty list, singleton
string to singleton list, and concatenation of strings to
concatenation of lists.
For instance, the two example terms representing ``NBE" earlier are
evaluated to the list |['N', 'B', 'E']|.

Above evaluation process is particularly interesting in that it is
compositional: semantic of a term is constructured from the semantic
of its subterms. Though compositionality is a highly desired property,
thanks to the elegant mathmatical properties, the evaluation
process in NBE is not required to be compositional.
In fact, some evaluation functions cannot be defined compositionaly.
Compositionality of a function forces it to be expressible solely by
folds, and not every function can be defined solely in terms of folds.
For instance, evaluation that rely on some forms of global
transformations, sometimes cannot be expressed solely in terms of
folds.

The next step is to define a reification process:

\begin{spec}
↓ : List Char → Chars

↓ []        = ε₀
↓ (c ∷ cs)  = Chr c ∙ (↓ cs)
\end{spec}

Reification defined above is a simple mapping from lists to Chars
terms, where empty list is mapped to empty strings, cons of list head
to list tail to concatenation of the corresponding singleton string
to the reified string of tail.
For example, the list |['N', 'B', 'E']| from earlier is reified to the
following term:
\begin{spec}
Chr 'N' ∙ (Chr 'B' ∙ (Chr 'E' ∙ ε₀))
\end{spec}
The reification function is also compositional.

Putting the pieces together normalisation function is defined as
usual:
\begin{spec}
norm : Chars → Chars
norm M = ↓ ⟦ M ⟧
\end{spec}
As expected, above function derives canonical form of Chars terms.
For instance, we have
\begin{spec}
norm (Chr 'N' ∙ (Chr 'B' ∙ Chr 'E'))
  =
norm ((Chr 'N' ∙ ε₀) ∙ ((Chr 'B' ∙ ε₀) ∙ (Chr 'E' ∙ ε₀)))
  =
Chr 'N' ∙ (Chr 'B' ∙ (Chr 'E' ∙ ε₀))
\end{spec}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Chars Hughes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\subsubsection{Functions as Semantic}
\label{sec:CharsHughes}
The syntactic domain given to be the Chars language, and semantic
domain now chosen to be functions over syntactic domain itself, the next step
for defining a NBE algorithm is defining an evaluation function:

\begin{spec}
⟦_⟧ : Chars → (Chars → Chars)

⟦ ε₀     ⟧ = id
⟦ Chr n  ⟧ = λ N → (Chr n) ∙ N
⟦ M ∙ N  ⟧ = ⟦ M ⟧ ∘ ⟦ N ⟧
\end{spec}

Evaluation defined above is a simple mapping from Chars terms to
functions from Chars to Chars, where empty string is mapped to
identity function, singleton string to a function that concats the
same singleton string to its input, and concatenation of strings to
function composition.
For instance, the two example terms representing ``NBE" earlier are
evaluated to the function
\begin{spec}
λ N → Chr 'N' ∙ (Chr 'B' ∙ (Chr 'E' ∙ N))
\end{spec}
Above evaluation is also compositional.

The next step is to define a reification process:

\begin{spec}
↓ : (Chars → Chars) → Chars

↓ f = f ε₀
\end{spec}

Reification defined above is very simples: it applies semantic
function to empty string.
For example, the function
\begin{spec}
λ N → Chr 'N' ∙ (Chr 'B' ∙ (Chr 'E' ∙ N))
\end{spec}
from earlier is reified to the following term:
\begin{spec}
Chr 'N' ∙ (Chr 'B' ∙ (Chr 'E' ∙ ε₀))
\end{spec}
Reification is also obviousely compositional.

Normalisation function is defined as usual.  However, the
normalisation process based on function semantics is more efficient
compared to the one based on list semantics.  Essentially, the
evaluation process using the semantic domain |Char → Char|, evaluates
terms using an efficient representation of lists, known as Hughes
lists \citep{hughes1986novel}.

\subsubsection{Observation}
\label{sec:ADT}
For this example, three domains are explicitly discussed: Chars
syntactic domain, semantic domain based on normal lists and semantic
domain based on Hughes lists.  There is also a fourth domain implicit
in the discussion: the syntactic domain of canonical forms, which is a
subset of the syntactic domain. For Chars language, terms in canonical
form are of the following grammar:
\begin{spec}
c ∈ Char (set of characters)
N ∈ CanonicalChars ::= ε₀ | Chr c ∙ N
\end{spec}

For instance, the example canonical form deriven earlier follows the
above grammar.

Compared to Chars, the grammar of canonical forms is less flexible but
more compact: it is easier to program in Chars, but it is also harder
to analyse programs in Chars. At the cost of implementing a
normalisation process, like the two NBE algorithms above, one can use
benefits of the two languages: let programs to be written in the
syntactic domain, since they are easier to write, then normalise the
programs and let analysis be done on normalised programs, since they
are easier to analyse.  It is an important observation, which can be
generalised to any language possessing canonical forms. Indeed,
compilers use the same approach by transforming programs written in
the flexible surface syntax to a more compact internal
representation. For languages with computational content, such
transformations often improve the performance of the programs.
In this perspective, optimisation of terms can be viewed as
normalisation of terms.

Next section puts this observation to work for EDSLs.
