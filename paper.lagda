\documentclass[preprint]{sigplanconf}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lhs2TeX package imports
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%include agda.fmt

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% latex package imports
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\usepackage{amsmath}
\usepackage{proof}
\usepackage{stmaryrd}
\usepackage[
  hidelinks,
  pdfauthor={Shayan Najd,Sam Lindley,Josef Svenningsson,Philip Wadler},
  pdftitle={Embedding By Normalisation},
  pagebackref=true,pdftex,backref=none]{hyperref}
\usepackage{graphicx}
\usepackage{url}
\usepackage{color}
\usepackage[usenames,dvipsnames,svgnames,table]{xcolor}
\usepackage{ucs}
\usepackage[utf8x]{inputenc}
% \usepackage{listings}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lhs2TeX macros
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%format ΣT     = "Σ_T"
%format ΓT     = "Γ_T"
%format Synr   = "\text{Syn}_r"
%format ⟨⟩r     = "⟨⟩_r"
%format →r     = "→_r"
%format ×r     = "×_r"
%format +r     = "+_r"
%format Typeₜ = "\underline{\text{Type}}"
%format epsf  = "eps_f"
%format chrf = "chr_f"
%format ∙f   = "∙_f"
%format Epsd  = "Eps_d"
%format Chrd = "Chr_d"
%format ∙d   = "∙_d"
%format Charsd = "Chars_d"
%format do = "\textbf{\text{do}}"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% latex macros
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\DeclareUnicodeCharacter{7523}{\ensuremath{_r}}
\DeclareUnicodeCharacter{8343}{\ensuremath{_l}}
\DeclareUnicodeCharacter{8345}{\ensuremath{_n}}
\DeclareUnicodeCharacter{8337}{\ensuremath{_e}}
\DeclareUnicodeCharacter{8348}{\ensuremath{_t}}
\DeclareUnicodeCharacter{7522}{\ensuremath{_i}}
\DeclareUnicodeCharacter{7525}{\ensuremath{_v}}
\DeclareUnicodeCharacter{10631}{\ensuremath{\llparenthesis}}
\DeclareUnicodeCharacter{10632}{\ensuremath{\rrparenthesis}}
% \DeclareUnicodeCharacter{120793}{\ensuremath{\mathscr{a}}}
\DeclareTextCommandDefault\textpi{\ensuremath{\pi}}
\DeclareTextCommandDefault\textlambda{\ensuremath{\lambda}}
\DeclareTextCommandDefault\textrho{\ensuremath{\rho}}
\DeclareTextCommandDefault\textGamma{\ensuremath{\Gamma}}
\DeclareTextCommandDefault\textiota{\ensuremath{\iota}}
\DeclareTextCommandDefault\textdelta{\ensuremath{\delta}}
\DeclareTextCommandDefault\textchi{\ensuremath{\chi}}
\DeclareTextCommandDefault\textXi{\ensuremath{\Xi}}
\DeclareTextCommandDefault\textxi{\ensuremath{\xi}}
\DeclareTextCommandDefault\textSigma{\ensuremath{\Sigma}}
\DeclareTextCommandDefault\textmu{\ensuremath{\mu}}
\DeclareTextCommandDefault\textalpha{\ensuremath{\alpha}}
\DeclareTextCommandDefault\textbeta{\ensuremath{\beta}}
\DeclareTextCommandDefault\textgamma{\ensuremath{\gamma}}
\DeclareTextCommandDefault\texteta{\ensuremath{\eta}}

\newcommand{\todo}[2]
  {{\noindent\small\color{red}
   \framebox{\parbox{\dimexpr\linewidth-2\fboxsep-2\fboxrule}
                    {\textbf{TODO #1:} #2}}}}

% \newcommand{\todo}[2]{}

\newcommand{\cL}{{\cal L}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Document Header
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\begin{document}

\special{papersize=8.5in,11in}
\setlength{\pdfpageheight}{\paperheight}
\setlength{\pdfpagewidth}{\paperwidth}

\conferenceinfo{ICFP '16}{September 18--24, 2016, Nara, Japan}
\copyrightyear{2016}
\copyrightdata{978-1-nnnn-nnnn-n/yy/mm} % ToDo
\copyrightdoi{nnnnnnn.nnnnnnn}          % ToDo

\publicationrights{licensed}

\title{Embedding by Normalisation}
%% \subtitle{Domain-Specific Languages With Character}
%% \subtitle{Domain-Specific Languages With Semantics}
%% \subtitle{Domain-Specific Languages That You Understand}

\authorinfo{Shayan Najd}
           {LFCS,\\ The University of Edinburgh}
           {sh.najd@@ed.ac.uk}
\authorinfo{Sam Lindley}
           {LFCS,\\ The University of Edinburgh}
           {sam.lindley@@ed.ac.uk}
\authorinfo{Josef Svenningsson}
           {Functional Programming Group,
            Chalmers University of Technology}
           {josefs@@chalmers.se}
\authorinfo{Philip Wadler}
           {LFCS,\\ The University of Edinburgh}
           {wadler@@inf.ed.ac.uk}
\maketitle

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Abstract
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\begin{abstract}
This paper presents the insight that practical embedding techniques,
commonly used for implementing Domain-Specific Languages, correspond
to theoretical Normalisation-By-Evaluation (NBE) techniques, commonly
used for deriving canonical form of terms with respect to an
equational theory.

NBE constitutes of four components: a syntactic domain, a semantic
domain, and a pair of translations between the two.  Embedding also
often constitutes of four components: an object language, a host
language, encoding of object terms in the host, and extraction of
object code from the host.

The correspondence is deep in that all four components in embedding
and NBE correspond to each other. Based on this correspondence, this
paper introduces Embedding-By-Normalisation (EBN) as a principled
approach to study and structure embedding.

The correspondence is useful in that solutions from NBE can be
borrowed to solve problems in embedding. In particular, based on NBE
techniques, such as Type-Directed Partial Evaluation, this paper
presents a solution to the problem of extracting object code from
embedded programs involving sum types, such as conditional
expressions, and primitives, such as literals and operations on them.

% todo: mention that it lays foundation that is independent of
%       language features.
\end{abstract}

\category{D.1.1}{Applicative (Functional) Programming}{}
\category{D.3.1}{Formal Definitions and Theory}{}
\category{D.3.2}{Language Classifications}
                {Applicative (functional) languages}
% todo: revise the categories above

\keywords
domain-specific language, DSL,
embedded domain-specific language, EDSL,
semantic, normalisation-By-evaluation, NBE,
type-directed partial evaluation, TDPE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Introduction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\section{Introduction}
\label{sec:introduction}
% \subsection{The Problem: Understanding Embedding}
% \subsubsection{Domain-Specific Languages: Powerful, yet Simple}
Less is more sometimes. Compared to General-Purpose Languages (GPLs)
like C, Java, or Haskell; Domain-Specific Languages (DSLs) like SQL,
VHDL, or HTML are smaller and simpler.

Unlike GPLs, DSLs are designed ground up to describe programs used in
a specific domain, e.g., SQL for database queries, VHDL for electronic
circuits, and HTML for web pages. DSLs are a powerful engineering
tool: DSLs abstract over domain-specific concepts and operations by
providing a set of primitives in the language. Such primitives are
often referred to as domain-specific constructs. For instance, SELECT
statement is a domain-specific construct in SQL.

Like GPLs, DSLs can be implemented as a stand-alone language.  For a
particular stand-alone DSL, one needs to design the language from
scratch and implement all the required machinery, such as the ones for
parsing, name resolution, type checking, interpretation, or
compilation. Programs in stand-alone DSLs can be quite flexible in
their syntax, and enjoy well-defined semantics.  However, implementing
a new stand-alone language demands remarkable engineering effort.
There are wide range of tools and frameworks available that automate
parts of the implementation process \citep{spoofax}, yet still
noticeable amount of effort is required to customise and integrate
pieces.

Furthermore, as with any other distinct language, stand-alone
DSLs come with their own ecosystem, ranging from libraries to
editors. It is often difficult to integrate programs written in
different languages, and reuse the ecosystem of one for
another. Object-relational impedance mismatch \citep{?}, and
SQL injection security attacks \cite{?} are well-known instances of
such difficulties, where SQL queries, as stand-alone DSL programs, are
integrated with programs in mainstream GPLs.

Unlike GPLs, DSLs can often, thanks to their simplicity, be
implemented by embedding them in an existing host GPL. Embedding is
referred to a diverse set of techniques for implementing DSL terms, by
first encoding them as terms in a host language, and then defining
their semantics using the encoded terms. Semantics of DSL terms may be
defined inside the host language by interpreting them in the host
language's runtime system, or outside the host language by compiling
code and passing it to an external system.

Unlike stand-alone DSLs, embedded DSLs can reuse some of the existing
machinery implemented for their host language; for a particular
Embedded DSL (EDSL), one does not need to implement all the required
machinery.  For instance, by using quotations
\citep{QDSL,mainland-quoted}, macros \citep{racket}, overloading and
virtualisation of constructs \citep{ad-hoc,rompf2013scala}, or normal
techniques for modular programming \citep{1ML}, there is no
need for implementing a parser; by using higher-order abstract syntax
and piggybacking on module system of host , there is no need to
implement a name-resolver; and, by using mechanism similar to
Generalised Algebraic Data Types (GADTs) \citep{GADTs}, there is no
need to implement a type-checker.

Furthermore, as with any other host program, EDSL programs can often
integrate smoothly with other host programs, and reuse parts of the
ecosystem of the host language. Language-INtegrated Query (LINQ)
\citep{LINQ} is a well-known instance of such successful integration,
where SQL queries, as embedded DSL programs, are integrated with
programs in mainstream GPLs.

Although embedding can avoid remarkable implementation effort by
reusing the machinery available for the host language, it comes with
the expensive price of EDSLs losing their authentic identity.
Compared to stand-alone implementation, embedding is less flexible in
defining syntax and semantic of DSLs; more or less, syntax and
semantic of EDSLs often follow the ones of the host language.  There
are variety of smart and useful techniques to partially liberate EDSLs
from such restrictions (e.g., see \citet{QDSL, Definitional,
svenningsson:combining, Syntactic, scalalms}). However, the genius of
these techniques in one hand, and the subtle nature of embedding
process in the other, often causes complications in practice. A key
cause of such complications is lack of formality, both in the
programming interface provided by EDSLs, and in techniques used
for embedding them.

Unlike stand-alone languages that are often accompanied by a set of
formal descriptions, EDSLs often possess no formal descriptions. Due
to subtleties caused by embedding, EDSLs are often presented
informally by actual code in a mainstream host language; it is
difficult to distinguish an EDSL from the the host language, as the
boundary between an EDSL and its host language is not entirely clear.
Since often embedding techniques take smart use of techniques and
stacks of unconventional features available in the host language,
descriptions by actual code appear cryptic.  Such informal
descriptions makes EDSL hard to learn, not only for domain experts,
whom traditionally are assumed to be unfamiliar with the host
language, but also for the host language experts unfamiliar with the
domain. Whole is nothing without all its parts, and whole is greater
than the sum its parts.


% As it may not come surprising to the reader, increasing number of
% papers are being published in peer-reviewed conferences (at the time
% of writing this paper), key subjects of which are solely introducing
% (informally) a new particular EDSL.  It is notoriously difficult to
% compare these EDSLs with each others and draw conclusive results.
% Regarding similar problems with GPLs, Sir Tony Hoare once suggested
% \citep{?} introducing new features rather than new languages.
% It is possible to do so in GPLs, thanks to formal theory.

Unlike stand-alone languages whose implementations often follow a set
of well-known general principles (see \citet{Aho}), implementations
of EDSLs are less principled and techniques vary greatly from one host
language to another. Even for one particular host language, there are
many different approaches to embedding, that often are characterised
based on a unique set of language features they rely on.
For instance in Haskell,
deep embedding technique is when datatypes in host are used for
representing the syntax of EDSLs, and functions (programs in general)
over the datatypes for semantics;
quoted embedding, which is a specific form of deep embedding, is when
a form of quotations is used to represent syntax, and functions over
the unquoted representation (often normalised) for semantics;
shallow embedding is when an interface formed by a set of functions is
used to represent the syntax, and implementation of the functions as
semantics;
final tagless embedding \citep{Tagless}, which is a specific form of
shallow embedding, is when type-classes are used to define interface
representing syntax, and instances of the type-classes for semantics.

One key issue with this lack of a principled approach to
embedding is scalability of existing solutions. Once one moves from
embedding simpler DSLs to DSLs with richer computational content, it
becomes harder for embedding to stay close to the intended syntax and
semantic in one hand, and reuse the host machinery in the other.

% todo: forward-reference to a section with

The kind of principles this paper is aiming for is the ones of
mathematical nature: abstract, simple, and insightful. These are the
kind of principles that have been guiding design of functional
programs since their dawn. One may argue these principles are
discovered, as opposed to being invented \cite{Wadler-2015}.

For instance, \citet[p. 513]{Tagless} observes that final
tagless embeddings are semantic algebras and form fold-like
structures. This observation has been explored further by \citet{Gibbons},
where they identify shallow embedding as algebras of folds over syntax
datatypes in deep embedding.  Decomposing embedding techniques into
well-know structures such as semantic algebras or folds is liberating:
embedding techniques can be studied independent of language features.
Semantic algebras and folds enjoy clear mathematical and formal
descriptions (e.g., via categorical semantics), hence establishing
correspondence between embedding and folds enables borrowing ideas
from other related fields.

In pursuit of a formal foundation for practical embedding techniques,
this paper proposes Embedding-By-Normalisation, EBN for short, as a
principled and systematic approach to embedding. EBN is based on a
direct correspondence between embedding techniques in practice and
Normalisation-By-Evaluation \citep{MartinLof,Berger} (NBE) techniques
in theory.  NBE is a well-studied
approach (e.g., see \citet{NBE-Cat,NBE-Sum,NBE-Untyped,Lindley05})
% todo: add even more
in proof theory and programming semantics, commonly used for deriving
canonical form of terms with respect to an equational theory.
Decomposing embedding techniques into the key structures in
NBE is liberating: embedding techniques can be studied independent of
language features. NBE enjoys clear mathematical and formal
description, hence establishing correspondence between embedding and
NBE enables borrowing ideas from other related fields.  For instance,
this paper shows how to use the NBE technique Type-Directed Partial
Evaluation (TDPE)\citep{TDPE} to extract object code from host terms
involving sums types, such as conditional expressions, and primitives,
such as literals and operations on them. Although, there may exist
various smart practical solutions to the mentioned code extraction
problem; at the time of writing this paper, the process of code
extraction for sum types and primitives is considered an open
theoretical problem in EDSL community (see \citet{Gill:CACM}).
% todo: refer the related section

The contributions of this paper are as follows:
\begin{itemize}
\item To characterise the correspondence between
      Normalisation-By-Evaluation (NBE) and embedding techniques
      (Section \ref{sec:NBE} and \ref{sec:EBN})
\item To introduce Embedding-By-Normalisation (EBN) as a systematic
      and principled approach to embedding inspired by the
      correspondence to NBE (Section \ref{sec:NBE} and \ref{sec:EBN})
\item To show how to systematically embed different variants of
      simply-typed lambda calculus by using EBN (Section \ref{sec:Basic}
      and Section \ref{sec:Primitives})
\item To show how to extract code from embedded terms involving sum
      types, such as conditional expressions, by using EBN and
      exploiting the correspondence to Danvy's NBE technique for
      offline partial evaluation (Section \ref{sec:Sums})
\item To show how to extract code from embedded terms involving
      primitives and operations on them, by using EBN and exploiting
      the correspondence to simple online partial evaluation
      techniques (Section \ref{sec:Smart})
\item To show how to employ language features in Agda, Haskell, and
      OCaml for implementing EBN
      (Section \ref{sec:Implementation})
\item To show how EBN relates to some of the related existing
      techniques, and highlighting some interesting insights when
      observing such techniques through EBN lens
      (Section \ref{sec:RelatedWork})
\end{itemize}

% capture essence of Feldspar
% generic account by Σ and Ξ

To steer clear from the mentioned informality prevalent in EDSL
literature, code in the main body of this paper is presented using
type theory, as implemented in the proof assistant Agda
\citep{Agda}. Only a minimal set of language features in Agda is
used, hoping for the presentation to remain accessible to the readers
familiar with functional programming.
When inferrable from context, some unnecessary implementation details,
such as type instantiations or overloading of constants, are
intentionally left out of the code for brevity.
As mentioned, the implementation concerns are addressed separately, in
Section \ref{sec:Implementation}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% NBE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\section{Normalisation-By-Evaluation}
\label{sec:NBE}
Normalisation-by-Evaluation (NBE) is the process of deriving canonical
form of terms with respect to an equational theory.The process of
deriving canonical forms is often referred to as normalisation, where
the canonical forms are refereed to as normal forms. NBE dates back to
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

NBE constitutes of four components:
\begin{description}
\item [Syntactic Domain]
is the language of terms to be
normalised by a NBE algorithm.

\item [Semantic Domain]
is another language used in NBE, defining a model for
evaluating terms in the syntactic domain. Often the semantic domain
contains parts of the syntactic domain left uninterpreted. The
uninterpreted parts are referred to as the residual parts, and in their
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

More formally, an algorithm with NBE structure can be seen as an
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
preserve types of the terms. More formally, an algorithm with NBE
structure in a typed setting can be seen as an instance of the
following (dependent) record, with the following normalisation
function:

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

The language, referred to as Chars, consists of an empty string, a
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
NBE provides a normalisation process to derive a Canonical form for
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
compositional: semantic of a term is constructed from the semantic
of its subterms. Though compositionality is a highly desired property,
thanks to the elegant mathematical properties, the evaluation
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
⟦ Chr c  ⟧ = λ N → (Chr c) ∙ N
⟦ M ∙ N  ⟧ = ⟦ M ⟧ ∘ ⟦ N ⟧
\end{spec}

Evaluation defined above is a simple mapping from Chars terms to
functions from Chars to Chars, where empty string is mapped to
identity function, singleton string to a function that concatenates the
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

Reification defined above is very simple: it applies semantic
function to empty string.
For example, the function
\begin{spec}
λ N → Chr 'N' ∙ (Chr 'B' ∙ (Chr 'E' ∙ N))
\end{spec}
from earlier is reified to the following term:
\begin{spec}
Chr 'N' ∙ (Chr 'B' ∙ (Chr 'E' ∙ ε₀))
\end{spec}
Reification is also obviously compositional.

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

For instance, the example canonical form derived earlier follows the
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EBN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\section{Embedding-By-Normalisation}
\label{sec:EBN}

The key selling points for embedding DSLs are to reuse the machinery
available for a host language, from parser to type checker, and to
integrate with its ecosystem, from editors to run-time system.
EDSLs and embedding techniques that are proven successful in practice,
go beyond traditional sole reuse of syntactic machinery such as parser
and type-checker, and employ the evaluation mechanism of the host
language to optimise the DSL terms
\citep{axelsson2010feldspar,svensson2011obsidian,rompf2012lightweight,
Mainland:2010}.

Briefly put, what these techniques provide is
abstraction-without-guilt: the possibility to define layers of
abstraction in EDSLs, using features available in the host language,
without sacrificing the performance of final produced code.  As
mentioned in the previous section, an optimisation process, such as
the ones used in above techniques, can be viewed as a normalisation
process. So essentially, what the mentioned embedding techniques do is
to perform \textbf{normalisation} of embedded terms \textbf{by}
reusing the \textbf{evaluation} mechanism of the host language.  As
the names suggest, there is a correspondence between such embedding
techniques and NBE begging to be examined:
\begin{center}
optimisation of object by evaluation in host\\
   <--->\\
normalisation of syntax by evaluation in semantic
\end{center}

This section investigates the correspondence, by drawing
parallel between different components of the two sides.
But, before doing so, the class of EDSLs under investigation
should be specified.

\subsection{Normalised EDSLs}
\label{sec:NormalisedEDSLs}
Generally speaking, not every EDSL possess computational content,
e.g., consider DSLs used for data description. On the other hand, a
large and popular class of EDSLs possess some form of computational
content. For the latter, as mentioned earlier, embedding techniques
try to take full advantage of the evaluation process in the host
language to optimise object terms before extracting code from
them. The extracted code is passed, as data, to a back-end, which
either interprets the data by directly calling foreign function
interfaces (e.g., see \citet{MeijerLINQ, accelerate}), or by passing
it to an external compiler (e.g., see
\citet{FELDSPAR,sujeeth2013composition}). This class of EDSLs are
referred to as \emph{normalised EDSLs} in this paper, and they are
distinguished from other EDSLs by the fact that (a) they possess
computational content; (b) the object terms are optimised by using
evaluation in the host language; and (c) they extract code from
optimised object terms and the code is representable as data.

In general, embedding a DSL as a normalised EDSL constitutes of four
components:
\begin{description}
\item [Object Language]
      is the language defining the syntax of the DSL being embedded
\item [Host Language]
      is the language that the DSL is being embedded into
\item [Encoding]
      is the process of defining terms in the object language as a
      specific set of terms in the host language
\item [Code Extraction]
      is the process of deriving object code, as data, from the
      specific set of values (as opposed to general terms) in the host
      language that encode (optimised) object terms
\end{description}

Encoding of object terms as host terms is done in a way that
the resulting values after evaluation of host terms denote optimised
object terms.

For instance, the following is the four components in an embedding
of Chars language:
\begin{itemize}
\item \emph{Object language} is of the following grammar:
\begin{spec}
c ∈ Char (set of characters)
L,M,N ∈ Chars ::= ε₀ | Chr c | M ∙ N
\end{spec}
\item \emph{Host language} is a pure typed functional language
\item \emph{Encoding} is as follows:\\
|ε₀|    is encoded as the host (nullary) function |epsf = []| \\
|Chr c| is encoded as the host function |chrf c = [ c ]| \\
|M ∙ N| is encoded as the host function |M ∙f N = M ++ N|
\item \emph{code extraction} is a function from list values
to the datatype (of the $\__d$ indexed constructors) representing
the extracted code
\begin{spec}
↓ []        = Epsd
↓ (c ∷ cs)  = Chrd c ∙d (reify cs)
\end{spec}
\end{itemize}

Users of Chars EDSL write their programs using $\__f$ indexed
functions, and the extracted code, the $\__d$ indexed data, is passed
to back-end of the Chars EDSL.  A simple example of such back-end
would be a function that takes the code and prints the denoted string:

\begin{spec}
printChars : Charsd → IO ⟨⟩
printChars Epsd           = printString ""
printChars (Chrd c ∙d N)  = do  printChar   c
                                printChars  N
\end{spec}

\subsection{Correspondence}
\label{sec:Correspondence}
Comparing embedding structure, explained in Section
\ref{sec:NormalisedEDSLs}, with NBE structure, explained in Section
\ref{sec:NBE}, the correspondence is evident as follows:

\begin{center}
\begin{tabular}{rcl}
NBE              &\ \ <--->\ \ &  EBN \\  \\
Syntactic Domain &\ \ <--->\ \ &  Object Language\\
Semantic  Domain &\ \ <--->\ \ &  Host   Language (a subset of)\\
Evaluation       &\ \ <--->\ \ &  Encoding\\
Reification      &\ \ <--->\ \ &  Code Extraction
\end{tabular}
\end{center}

Viewing embedding through the lens of NBE, one can observe that many
of the smart techniques for encoding object terms as host terms
basically correspond to defining parts of an evaluation process that
maps object terms to values (as opposed to general terms) in a subset
of host language. Once one puts the two sides together, the
correspondence between code extraction and reification in NBE is also
not surprising. Even the name ``reification" has been used by some
embedding experts to refer to the code extraction process (see
\citet{Gill:CACM}).

This paper dubs an embedding process that follows the NBE structure as
Embedding-By-Normalisation, or EBN for short.
Embedding-by-normalisation is to be viewed as a general
theoretical framework to study existing embedding techniques in
practice, and also as a recipe on how to structure implementation of
normalised EDSLs.
EBN builds a bridge between theory and practice: theoretical solutions
in NBE can be used to solve practical problems in embedding, and vice
versa.

There are can be different approaches to perform embedding-by-normalisation.
For instance, provided a back-end to process input code represented as data,
embedding-by-normalisation follows the steps below:
\begin{enumerate}
\item The abstract syntax of the code expected by the back-end
      is identified. Such abstract syntax corresponds to the grammar of
      normal forms.
\item Semantic domain is identified as a subset of the host language.
\item Reification is identified as the process that maps terms in the
      semantic domain to terms in normal form, as usual.
\item Evaluation is identified as programs in the host language
      that map object terms to values in the semantic domain.
\end{enumerate}

Above steps can be reordered. However, important
observation here is that often defining syntax of normal forms and
semantic domain should be prioritised over defining the interface that
the end-users program in, i.e., the syntactic domain.  Syntactic
domain can be seen as the class of host programs that can be
normalised to terms following the grammar of normal forms.
% (see presheaf models in \citet{NBE-Cat}).

% todo: mention residualisation helps scalability
% todo: mention
% possibly as a variant of typed lambda calculus with a set of primitives

\subsection{Encoding Strategies}
\label{sec:EBN:Encoding}
Due to its correspondence to NBE, EBN is of mathematical nature:
abstract and general. Furthermore, as there are variety of NBE
algorithms, there are variety of corresponding EBN techniques. The
generality and variety make it difficult to propose a concrete
encoding strategy for EBN. The remainder of this section discusses
some general encoding strategies based on the existing techniques
including shallow embedding, final tagless embedding, deep embedding, and
quoted embedding.

\subsubsection{Shallow Embedding}
\label{sec:EBN:Shallow}
Shallow embedding is when an interface formed by a set
of functions in the host is used to represent the syntax of a DSL, and
implementation of the functions as semantics. In shallow embedding,
semantic of the DSL is required to be compositional \citep{Tagless,
Gibbons}.
In EBN, when encoding of object terms follows
shallow embedding, the four components of EBN are as follows:
\begin{description}
\item [Syntactic Domain] is an interface formed by a set of functions
                        (or values) in the host
\item [Semantic Domain] is the result type of above interface
\item [Evaluation] is the overall evaluation of the implementation of
                   the above interface in the host. In this setting,
                   EBN's evaluation process is also required to be
                   compositional, and evaluation of a syntactic term
                   is built up from the evaluation of its sub-terms.
\item [Reification] is a mapping from host values of the semantic
                    domain type to data that implements a subset of
                    syntactic domain interface, i.e., the subset that
                    corresponds to the grammar of normal forms.
\end{description}

The Chars example in Section \ref{sec:NormalisedEDSLs} is EBN with
shallow encoding.

\subsubsection{Final Tagless Embedding}
\label{sec:EBN:Tagless}
Final tagless embedding \citep{Tagless}, which is a specific form of
shallow embedding, is when the shallow interface is parametric over
the semantic type. In Haskell, the parametric interface is defined as
a type-class, where instantiating the type-class defines
semantics. Similar to shallow embedding, in final tagless embedding,
evaluation is required to be compositional.

In EBN, when encoding of object terms follows final tagless embedding,
the four components of EBN are as follows:

\begin{description}
                        %or  a set of type-classes?
\item [Syntactic Domain] is a type-class (or a similar machinery such as modules)
                        defining syntax in final tagless style
\item [Semantic Domain] is the type that the syntax type-class is
                        instantiated with
\item [Evaluation] is the implementation of an instance of syntax type class.
                   In this setting, EBN's evaluation process is also required
                   to be compositional. An instance of syntax type-class is
                   an algebra for folds over the syntactic language
\item [Reification] is a mapping from host values of the semantic
                    domain type to data that implements a subset of
                    syntactic domain interface, i.e., the subset that
                    corresponds to the grammar of normal forms.
\end{description}

%{

%format class    = "\textbf{class}"
%format instance = "\textbf{instance}"

For instance, the following is the four components in EBN of Chars
 language with final tagless encoding:
\begin{itemize}
\item \emph{Syntactic domain} is the following type-class declaration:
\begin{spec}
class CharsLike chars where
  epsf  : chars
  chrf  : Char → chars
  (∙f)  : chars → chars → chars
\end{spec}

\item \emph{Semantic domain} is the type |List Char| in a functional language with type-classes
\item \emph{Evaluation} is the following type-class instance:
\begin{spec}
instance CharsLike (List Char) where
  epsf    = []
  chrf c  = [ c ]
  m ∙f n  = m ++ n
\end{spec}
\item \emph{Reification} is the following function
\begin{spec}
reify : List Char → Charsd
reify []         = Epsd
reify (c :: cs)  = Chrd c ∙d (reify cs)
\end{spec}
where code is defined as the following algebraic datatype
\begin{spec}
data Charsd  =  Epsd
             |  Chrd c
             |  Charsd ∙d Charsd
\end{spec}
\end{itemize}

%}

\subsubsection{Deep Embedding}
\label{sec:EBN:Deep}
Deep embedding is when datatypes in host are used for representing the
syntax of a DSL, and semantics is defined as functions (programs in
general) over the syntax datatypes.

In EBN, when encoding of object terms follows deep embedding,
the four components of EBN are as follows:

\begin{description}
\item [Syntactic Domain] is a datatype
\item [Semantic Domain] is a type that the syntax datatype is transformed to
\item [Evaluation] is a function from syntax datatype to semantic domain
\item [Reification] is a mapping from host values of the semantic
                    domain type to a datatype describing normal forms
\end{description}

%{
For instance, the following is the four components in EBN of Chars
 language with deep encoding:
\begin{itemize}
\item \emph{Syntactic domain} is the following datatype:
\begin{spec}
data Charsd  =  Epsd
             |  Chrd c
             |  Charsd ∙d Charsd
\end{spec}
\item \emph{Semantic domain} is the type |List Char| in a functional language
                             with algebraic datatypes
\item \emph{Evaluation} is the following function:
\begin{spec}
eval : Charsd → List Char
eval  Epsd      = []
eval  (Chrd c)  = [ c ]
eval  (m ∙d n)  = m ++ n
\end{spec}
\item \emph{Reification} is the following function
\begin{spec}
reify : List Char → Charsd
reify []        = Epsd
reify (c ∷ cs)  = Chrd c ∙d (reify cs)
\end{spec}
\end{itemize}

%}

\subsubsection{Quoted Embedding}
\label{sec:EBN:Quoted}
Quoted embedding \citep{QDSL}, which is a specific form of deep
embedding, is when some form of quotations is used to represent
syntax, and semantics is defined as functions over the unquoted
representation.

In EBN, when encoding of object terms follows quoted embedding,
the four components of EBN are as follows:

\begin{description}
\item [Syntactic Domain] is the type of quoted terms in the host
\item [Semantic Domain] is a type that the unquoted representation of
                        syntactic terms is transformed to
\item [Evaluation] is a function from unquoted representation of
                   syntactic terms to semantic domain
\item [Reification] is a mapping from host values of the semantic
                    domain type to a datatype describing normal forms
\end{description}

%{
For instance, the following is the four components in EBN of Chars
 language with quoted encoding:
\begin{itemize}
\item \emph{Syntactic domain} is |Charsd|, the resulting type of a
      quasi-quotation denoted as |[c||...||]| for the grammar of Chars language.
\item \emph{Semantic domain} is the type |List Char|
      in a functional language with quasi-quotation
\item \emph{Evaluation} is the following function:
\begin{spec}
eval : Charsd → List Char
eval  [c| ε₀       |]  = []
eval  [c| Chr $c   |]  = [ c ]
eval  [c| $m ∙ $n  |]  = m ++ n
\end{spec}
where |$| denotes anti-quotation \citep{mainland-quoted}.
\item \emph{Reification} is the following function
\begin{spec}
reify : List Char → Charsd
reify []        = [c| ε₀ |]
reify (c ∷ cs)  = [c| Chr $c ∙ $(reify cs) |]
\end{spec}
\end{itemize}
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Type-Constrained Host as Semantic Domain
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\section{Type-Constrained Host as Semantic Domain}
\label{sec:Type-Constrained}
Back in 1966, Landin in his landmark paper \citep{Landin1966} argues
that seemingly different programming languages can be seen as
instances of one unified language and that the differences can be
factored as normal libraries for the unified language.  Landin
nominates lambda calculus as the unified language, and shows how to
encode seemingly different language constructs as normal programs in
this language. Since then, Landin's idea has been proven correct over
and over again, evidenced by successful functional programming
languages built based on the very idea (e.g., see the design of
\citet{?GHC}'s core language).

Although Landin's idea was originally expressed in terms of
general-purpose languages, it also applies to domain-specific ones.
Following on his footsteps, this section introduces a generic EBN
algorithm by modeling DSLs as a variant of lambda calculus, where
domain-specific constructs are represented as the standard notion of
primitive values and operations in lambda calculus (e.g., see
\citet{Plotkin1975}). Such a model allows for a parametric presentation of
DSLs, where syntax of a DSL can be identified solely by the signature
of the primitive values and operations.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Basic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\subsection{Simple Types and Products}
\label{sec:Basic}
This subsection presents an EBN technique for simply-typed lambda
calculus with product types, parametric over the set of base types,
literals, and the signature of primitive operations. The host language
is assumed to be a pure typed functional language, and the subset the EBN
technique is targeting (i.e., the semantic domain) is identified by a
constraint on the type of host terms.

\subsubsection{Syntactic Domain}
\label{sec:Basic:Syn}
The grammar of types in the object language is standard:
\begin{spec}
χ ∈ X (set of base types)
A,B ∈ Typeₜ::= χ | ⟨⟩ₜ | A →ₜ B | A ×ₜ B
\end{spec}

It is parametric over a set of base types. Besides base types, it
includes unit, function type, and product type.  The types of the
object language are underlined to distinguish it from the ones of the
host language.

The grammar of the terms in the object language is also standard
\citep{Filinski}:

\begin{spec}
x ∈ Γ (set of variables)
ξ ∈ Ξ (set of literals)
c ∈ Σ (signature of primitives)
L,M,N ∈ Syn ::= ξₜ  | c Mᵢ | ⟨⟩ₜ | x | λₜ x →ₜ N | L @ₜ M
                    | (M ,ₜ N) | π₁ₜ L | π₂ₜ L
\end{spec}

The language, referred to as |Syn|, is parametric over a set of
literals, and signature of primitive operations. Besides literals, and
primtive operations (which are assumed to be fully applied), it
involves unit term, variables, lambda abstraction, application, pairs,
and projections. The terms of the object language are underlined to
distinguish it from the ones of the host language.

As the typing rules and semantic of above language is standard and
trivial, they are omitted from the paper.

In this section, including the other subsections, the EBN technique is
presented in a way that it is independent of encoding strategy: the
underlined terms can be trivially encoded using the standard methods,
such as the ones explained in Section \ref{sec:EBN:Encoding}.  One
possible difficulty might be the treatment of free variables, which
can be trivially addressed by using well-known techniques such as
Higher-Order Abstract Syntax (HOAS) representation \citep{hoas}.
Representation of object terms is assumed be quotient with respect to
alpha-conversion, when new bindings are introduced variables are
assumed to be fresh, and substitutions to be capture avoiding.
Furthermore, terms in syntactic domain and the normal syntactic terms
are represented in the same way. Though in practice, depending on
encoding, the two may be implemented in different ways. In this paper,
host programs of the type |Syn A| refer to both the type of a host
term encoding a term of the type |A| in syntactic domain, and the type
of the extracted code for a normal syntactic term of the type |A|.
The type |Syn ΓT A| denotes open |Syn A| terms with |ΓT| being a typing
environment containing the free variables.

Now that the syntactic domain has been defined, i.e., the |Syn|
language, it is time to define the semantic domain.

\subsubsection{Semantic Domain}
\label{sec:Basic:Sem}
As the host language is a pure typed functional language, and the
object language being a tiny pure typed functional language itself, a
considerable part of the object language closely mirrors the one of
the host language.  Moreover, the representation of the syntactic
domain itself, is a program in the host language, i.e., a term of the
type |Syn A|. This observation is realised by defining semantic domain
as follows:
\[
\text{Sem}\ A = ∀ (α : Type).\ α ∼ A ⇒ α
\]
\[
\begin{array}{cc}
\infer[\text{Syn}_r]
{\text{Syn}\ A ∼ A}
{}
&
\infer[⟨⟩_r]
{⟨⟩ ∼ \underline{⟨⟩}}
{}
\\~\\
\infer[→_r]
{(α → β) ∼ (A\ \underline{→}\ B)}
{(α ∼ A) && (β ∼ B)}
&
\infer[×_r]
{(α × β) ∼ (A\ \underline{×}\ B)}
{(α ∼ A) && (β ∼ B)}
\end{array}
\]

That is, a term of type |A| in the semantic domain is any host term
whose type respects the |∼| relation. The relation |∼| states that (a)
semantic terms of unit, function, and product type correspond to host
terms of similar type, (b) a syntactic term encoded in the host
directly correspond to a semantic term of the same type.
Condition (b) is a distinguishing feature in the definition of
evaluation and semantic domain of NBE. As mentioned in Section
\ref{sec:NBE}, evaluation in NBE is allowed to leave parts of
syntactic terms uninterpreted. An uninterpreted part is referred to
as a residualised part, and the act of leaving a part uninterpreted as
residualising.

\subsubsection{Evaluation}
\label{sec:Basic:Eval}
Except for terms of base type, evaluation process is standard:
syntactic terms are mapped to corresponding host terms.  Terms of base
types, however, are residualised.  The definition of evaluation
function is as follows:

\begin{spec}
⟦_⟧ : Typeₜ → Type

⟦ χ       ⟧ = Syn χ
⟦ ⟨⟩ₜ     ⟧ = ⟨⟩
⟦ A →ₜ B  ⟧ = ⟦ A ⟧  →  ⟦ B ⟧
⟦ A ×ₜ B  ⟧ = ⟦ A ⟧  ×  ⟦ B ⟧
\end{spec}

\begin{spec}
⟦_⟧ : Syn ΓT A → ⟦ ΣT ⟧ → ⟦ ΓT ⟧ → ⟦ A ⟧

⟦ ξₜ         ⟧ Σᵥ Γᵥ  = ξₜ
⟦ c Mᵢ       ⟧ Σᵥ Γᵥ  = Σᵥ c ⟦ Mᵢ ⟧
⟦ ⟨⟩ₜ        ⟧ Σᵥ Γᵥ  = ⟨⟩
⟦ x          ⟧ Σᵥ Γᵥ  = Γᵥ x
⟦ λₜ x →ₜ N  ⟧ Σᵥ Γᵥ  = λ y → ⟦ N ⟧ Σᵥ (Γᵥ, x ↦ y)
⟦ L @ₜ M     ⟧ Σᵥ Γᵥ  = (⟦ L ⟧ Σᵥ Γᵥ) (⟦ M ⟧ Σᵥ Γᵥ)
⟦ (M ,ₜ N)   ⟧ Σᵥ Γᵥ  = (⟦ M ⟧ Σᵥ Γᵥ , ⟦ N ⟧ Σᵥ Γᵥ)
⟦ π₁ₜ L      ⟧ Σᵥ Γᵥ  = π₁ (⟦ L ⟧ Σᵥ Γᵥ)
⟦ π₂ₜ L      ⟧ Σᵥ Γᵥ  = π₂ (⟦ L ⟧ Σᵥ Γᵥ)
\end{spec}

Except the input syntactic term, the evaluation function takes two
extra arguments: the environment of semantic values corresponding to
each primitive operator, dented as the variable |Σᵥ| of type |⟦ ΣT ⟧|,
and the environment of semantic values corresponding to each free
variable, denoted as the variable |Γᵥ| of type |⟦ ΓT ⟧|.  At the
type-level, |ΣT| denotes the typing environment for the primitives,
and |ΓT| denotes the typing environment for free variables.  Following
the convention, the semantic bracket notation is overloaded, and
denotes the mapping of different kinds of elements from syntax to
semantic.

\subsubsection{Reification}
\label{sec:Basic:Reify}
The final step is to define the reification function. Reification can
be defined as a function indexed by the relation between syntax and
semantics:

\begin{spec}
↓ : α ~ A → α → Syn A

↓ Synr      V  = V
↓ ⟨⟩r       V  = ⟨⟩ₜ
↓ (a →r b)  V  = λₜ x →ₜ ↓ b (V (↑ a x ))
↓ (a ×r b)  V  = (↓ a (π₁ V) ,ₜ ↓ b (π₂ V))
\end{spec}
\begin{spec}
↑ : α ~ A → Syn A → α

↑ Synr      M  = M
↑ ⟨⟩r       M  = ⟨⟩
↑ (a →r b)  M  = λ x → ↑ b (M @ₜ (↓ a x))
↑ (a ×r b)  M  = (↑ a (π₁ₜ M) , ↑ b (π₂ₜ M))
\end{spec}

Above definition is similar to some classic NBE algorithms such as
\citet{Berger} and \citet{TDPE}. Essentially, what above does is a
form of η-expansion in two levels: object language and host language
\citep{TDPE}.  The reification function |↓| is mutually defined with
the function |↑| referred to as the reflection function.

Embedding a term by the EBN algorithm defined in this subsection
results in a code for the corresponding term in η-long β-normal form.
However, the normal form is not extensional, in that two normal terms may be
equivalent but syntactically distinct (see Section \ref{sec:Richer}).

% todo: NBE

% todo: mention Feldspar here

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sums
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\subsection{Sums}
\label{sec:Sums}
This section extends the EBN technique of the previous subsection,
to support DSL programs involving sum types, such as conditional
expressions.

\subsubsection{Syntactic Domain}
\label{sec:SumsSyn}
The grammar of syntactic domain in Section \ref{Sec:BasicSyn} is
extended as follows:
\begin{spec}
A,B ::= ... | A +ₜ B
\end{spec}
\begin{spec}
L,M,N ::=  ... | ι₁ₜ M | ι₂ₜ N | δₜ L M N
\end{spec}

The extensions are standard: sum types, left injection, right
injection, and case expression. To simplify the presentation, branches
of the case expression |δₜ L M N| (i.e., M and N) are standard terms
of function type, as opposed to a specific built-in language
constructs with bindings.  It follows Alonzo Church's original idea
that all variable bindings in syntax can be done via bindings in
lambda abstractions.

\subsubsection{Semantic Domain}
\label{sec:SumsSem}
To support sum types, it is not enough to simply add a clause to the
relation |~| of Section \ref{sec:Basic:Sem} relating sum types in the
host to the ones in the object. Treating sum types has been a
challenging problem in NBE and embedding. Essentially, to reify a
semantic term of the type |(Syn A + Syn B) → Syn C|, following the
same symmetric style of reify-reflect process in Section
\ref{sec:Basic:Reify}, one needs (due to contravariance of function
type) to convert a syntactic term of the type |Syn (A +ₜ B)| to a
semantic term of the type |Syn A + Syn B|. The conversion of the type
|Syn (A +ₜ B) → Syn A + Syn B| is problematic, since there is no way
to destruct a term of the type |Syn| and remain in the semantic
domain; the output type of the function is a term in the semantic
domain, while destructing a sum type in syntactic domain demands a
continuation in the syntactic domain. For a more detailed account of
the reification problem for sum types, refer to
\citet{QDSL,Gill:CACM,svenningsson:combiningJournal}.
In the context of partial evaluation, \citet{TDPE} proposed an elegant
solution to the problem of reification of sums, using composable
continuations (delimited continuations) based on shift and
reset\citep{Delimited}. This paper employs Danvy's solution.

Delimited continuations are effect-full constructs. To model
them in a pure and typed setting, this paper uses the standard
monadic semantic (e.g., see \citep{Atkey,Dyvbig,Wadler}).
The |~| relation from Section \ref{sec:Basic:Sem} is updated as follows:
\[
\begin{array}{cc}
\infer[→_r]
{(α ↝ β) ∼ (A\ \underline{→}\ B)}
{(α ∼ A) && (β ∼ B)}
&
\infer[+_r]
{(α + β) ∼ (A\ \underline{+}\ B)}
{(α ∼ A) && (β ∼ B)}
\end{array}
\]

where |↝| denotes type of monadic functions.

One subtle, yet important factor in play here is the perspective that
EBN offers: Danvy's elegant use of shift and reset is not a mere
technical solution (even if it may seem like so when used in an untyped
impure language); through the lens of NBE/EBN, it can be seen as a
change of semantic domain to a monadic one, where the use of shift and
reset are the resulting consequences.

\subsubsection{Evaluation}
\label{sec:Sums:Evaluation}
The evaluation process is updates the one in Section
\ref{sec:Basic:Eval}, by taking into account monadic structures, and
performing trivial monadic lifting:
\begin{spec}
...
⟦ A →ₜ B  ⟧ = ⟦ A ⟧  ↝  ⟦ B ⟧
⟦ A +ₜ B  ⟧ = ⟦ A ⟧  +  ⟦ B ⟧
\end{spec}
\begin{spec}
... (by trivial monadic lifting)
⟦ ι₁ₜ M      ⟧ Σᵥ Γᵥ  = ⦇ ι₁ (⟦ M ⟧ Σᵥ Γᵥ) ⦈
⟦ ι₂ₜ N      ⟧ Σᵥ Γᵥ  = ⦇ ι₂ (⟦ N ⟧ Σᵥ Γᵥ) ⦈
⟦ δₜ L M N   ⟧ Σᵥ Γᵥ  = join ⦇ δ (⟦ L ⟧ Σᵥ Γᵥ)  (⟦ M ⟧ Σᵥ Γᵥ)
                                                (⟦ N ⟧ Σᵥ Γᵥ) ⦈
\end{spec}
For clarity of presentation, applicative bracket notation
\citep{Applicative} is used in above (denoted as |⦇ ... ⦈| .
An applicative bracket notation |⦇ L M₀ ... Mₙ ⦈| is a mere syntactic sugar
equivalent to the following term using monadic do notation:
\begin{spec}
   do  x₀  ← M₀
       ...
       xₙ  ← Mₙ
       return (L x₀ ... xₙ)
\end{spec}
The function |join| is a the well-known monad join function, commonly
used for flattening nested monadic structures.

\subsubsection{Reification}
\label{sec:Sums:Reification}
To adopt Danvy's solution, the Reification process of
\ref{sec:Basic:Reify} is updated as follows:

\begin{spec}
...
↓ (A →ₑ B)  V  = λ x → reset ⦇ ↓ B (join ⦇ V (↑ A x) ⦈) ⦈
↓ (A +ₑ B)  V  = δ V  (λ x → ι₁ₜ (↓ A x))
                      (λ y → ι₂ₜ (↓ B y))
\end{spec}
\begin{spec}
↑ : α ~ A → Syn A ↝ α

... (by trivial monadic lifting)
↑ (A +ₑ B)  M  =  shift  (λ k →
                  δₜ M   (λ x → reset ⦇ (k ∘ ι₁) (↑ A x) ⦈)
                         (λ y → reset ⦇ (k ∘ ι₂) (↑ B y) ⦈))
\end{spec}

Except for the necessary monadic liftings, the nontrivial change is
the clause related to sum types in the reflection function.  Instead
of destructing |M| directly, which results in another term of |Syn|
type, first it asks for a continuation |k| that given a semantic value
of sum type, produces a syntactic term, and then uses this
continuation for constructing the syntactic continuations needed for
destructing |M|. Reader interested in more details, may try to follow
above algorithm step-by-step to reify the semantic term |λ x → ⟨⟩ₜ| of
the type |(Syn ⟨⟩ₜ + Syn ⟨⟩ₜ) → Syn ⟨⟩ₜ|, or the term |λ x → π₁ x| of
the same type, and consult \citet{TDPE}, if needed.


% todo: mention TDPE / offline PE here

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Smart
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\subsection{Smart Primitives}
\label{sec:Smart}
This subsection proposes an
alternative semantic domain, so that some of the primitives can be
mapped to their corresponding host programs and get partially
normalised.

\begin{spec}
A,B ::= ...
\end{spec}

\begin{spec}
L,M,N ::=  ...
\end{spec}

\begin{spec}
...
⟦ χ       ⟧ = Ξ χ   +  𝔼 χ
\end{spec}

\begin{spec}
...
⟦ ξₜ ⟧ Σᵥ Γᵥ  = ⦇ (ι₁ ξ) ⦈
\end{spec}

\begin{spec}
↓ ...

↑ ...
\end{spec}


% todo: mention online PE here

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Richer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\subsection{Richer Languages}
\label{sec:Richer}
This section discusses other possible extensions to support richer languages.

\todo{}{Mention support for recursion}
\todo{}{Mention support for side-effects}
\todo{}{Mention support for let / syntactic sharing}
\todo{}{Mention support for extensionality (related to the support for let)}
\todo{}{Mention support for datatypes}
\todo{}{Mention support for polymorphism}
\todo{}{Mention untyped approach}

\subsection{An Example}
\label{sec:Example}


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
Σᵥ  = {  ==ₜ  : {ℚₜ , ℚₜ} ↦ Boolₜ ,
         *ₜ   : {ℚₜ , ℚₜ} ↦ ℚₜ ,
         /ₜ   : {ℚₜ , ℚₜ} ↦ ℚₜ }
\end{spec}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Implementation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\section{Implementation}
\label{sec:Implementation}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Agda
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\subsection{Agda}
\label{sec:Agda}

% mention type function problem and need for relation
% mention HOAS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Haskell
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\subsection{Haskell and Overloading}
\label{sec:Haskell}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OCaml
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\subsection{OCaml and Effects}
\label{sec:OCaml}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Related Work
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\section{Discussion \& Related Work}
\label{sec:RelatedWork}

% todo: mention the two impossibilities:
%       (a) sum types
%       (b) primitives

\todo{}{Mention Filinsky}
\todo{}{Mention Danvy's other related work}
\todo{}{Mention Danvy's online partial evaluator}
\todo{}{Mention Gill's CACM}
\todo{}{Mention Feldspar again}
\todo{}{Mention LMS}
\todo{}{Mention Sam's PhD}
\todo{}{Mention Peter Dybjer's related works}
\todo{}{Mention Altenkirch's related works}
\todo{}{Mention Walid's related work}
\todo{}{Mention Ziria}
\todo{}{Go through PC members and makes sure to cite their related
works, to avoid being snipped at}

The work by \citet{svenningsson:combiningJournal} is perhaps the most
closely related to what is presented in this paper. They provide a
way to embed languages which combines deep and shallow embeddings
which allows DSLs to be normalised by using evaluation in the host
language.  Phrased in the framework of Embedding by Normalisation,
their methodology matches the form of embedding presented in section
\ref{sec:Basic}. Hence, they can use host language functions and
products for their DSL implementations. Though they cannot deal with
arbitrary sum types, although they provide tricks for dealing with a
restricted form of sum type, such as the |Maybe| type in the Haskell
standard library. Their implementation in Haskell uses a type-class
which contains two methods for encoding terms in the host language and
reifying terms respectively.

Examples of DSLs which use this style of embedding are Feldspar
\citep{axelsson2010feldspar}, Obsidian \citep{svensson2011obsidian}
and Nikola \citep{Mainland:2010}.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Conclusion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\section{Conclusion}
\label{sec:conclusion}

% This paper is to free embedding from Girard's wedding cake dilemma.
% Show the diagram of correspondence
% Mention Compositional evaluation = shallow embedding
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Acknowledgements
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\paragraph*{Acknowledgements}
Najd was funded by a Google Europe Fellowship in Programming
Technology. Svenningsson was funded by the Swedish Foundation for
Strategic Research under grant RawFP. Lindley and Wadler were funded
by EPSRC Grant EP/K034413/1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bibliography
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\bibliographystyle{abbrvnamed}
\bibliography{paper}

\end{document}

%  LocalWords:  documentclass preprint lagda polycode fmt forall amsmath
%  LocalWords:  usepackage amssymb stmaryrd pdfauthor cL lhs overline
%  LocalWords:  pdftitle pagebackref url Bool Danvy's residualising
%  LocalWords:  pdftex backref hyperref graphicx color usenames tex
%  LocalWords:  dvipsnames svgnames xcolor newcommand todo noindent
%  LocalWords:  framebox parbox dimexpr linewidth fboxsep fboxrule EP
%  LocalWords:  textbf papersize setlength pdfpageheight paperheight
%  LocalWords:  pdfpagewidth paperwidth conferenceinfo maketitle ADT
%  LocalWords:  copyrightyear copyrightdata nnnn ToDo copyrightdoi
%  LocalWords:  nnnnnnn publicationrights authorinfo evaluators epsf
%  LocalWords:  llparenthesis rrparenthesis mathscr textpi textrho
%  LocalWords:  DeclareTextCommandDefault textlambda textGamma citep
%  LocalWords:  textiota textdelta textchi textXi textxi textSigma
%  LocalWords:  textmu textalpha subsubsection bibliographystyle eps
%  LocalWords:  abbrvnamed emph rcl center itemize sigplanconf hughes
%  LocalWords:  hidelinks DeclareUnicodeCharacter ensuremath TypedNBE
%  LocalWords:  ucs utf citet untyped canonicity CharsLists monoids
%  LocalWords:  ICFP Nara subterms compositionality compositionaly
%  LocalWords:  Shayan Najd Sam Lindley Josef Svenningsson Philip Wadler
%  LocalWords:  LFCS Chalmers reified CharsHughes CanonicalChars chrf
%  LocalWords:  NBE equational EBN reifying Applicative DSL Epsd Chrd
%  LocalWords:  EDSL TDPE GPLs Haskell DSLs SQL VHDL NormalisedEDSLs
%  LocalWords:  reification Tagless Virtualised Agda monad EDSLs agda
%  LocalWords:  relatedwork RawFP EPSRC nullary reify Charsd EBN's
%  LocalWords:  Sem cdsl CDSLs OCaml Danvy CACM LMS printChars eval
%  LocalWords:  Dybjer Altenkirch Walid Ziria Lof chr printString GHC
%  LocalWords:  inputenc Schwichtenberg denotational compositional
%  LocalWords:  Example associativity printChar CharsLike Landin's
%  LocalWords:  spoofax GPL runtime Plotkin monadic extensionality
%  LocalWords:  QDSL virtualisation hoc rompf scala GADTs INtegrated
%  LocalWords:  LINQ Definitional svenningsson scalalms Hoare Sam's
%  LocalWords:  Aho datatypes tagless scalability embeddings Untyped
%  LocalWords:  MartinLof RelatedWork inferrable axelsson Dybjer's
%  LocalWords:  instantiations svensson Mejerlinq sujeeth Walid's
%  LocalWords:  representable versa presheaf residualisation Girard's
%  LocalWords:  HOAS
%  LocalWords:  datatype Nikola
%  LocalWords:  Filinsky evaluator combiningJournal Girard
%  LocalWords:  Landin Altenkirch's residualised composable
%  LocalWords:  contravariance liftings
