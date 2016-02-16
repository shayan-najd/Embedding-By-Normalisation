\documentclass[preprint]{sigplanconf}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lhs2TeX package imports
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%include agda.fmt
%% %include polycode.fmt
%% %include forall.fmt

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lhs2TeX macros
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% latex package imports
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\usepackage{amsmath}

% \usepackage{amssymb}
% \usepackage{stmaryrd}
% \usepackage{proof}
\usepackage[
  pdfauthor={Shayan Najd,Sam Lindley,Josef Svenningsson,Philip Wadler},
  pdftitle={Embedding by Normalisation},
  pagebackref=true,pdftex,backref=none]{hyperref}
\usepackage{graphicx}
\usepackage{url}
\usepackage{color}
\usepackage[usenames,dvipsnames,svgnames,table]{xcolor}
\usepackage{ucs}
\usepackage[utf8x]{inputenc}
% \usepackage{listings}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% latex macros
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%include formalism.tex

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
This paper presents the profound insight that practical embedding
techniques, commonly used for implementing Domain-Specific Languages,
correspond to theoretical Normalisation-by-Evaluation (NbE)
techniques, commonly used for deriving canonical form of terms with
respect to an equational theory.

NbE constitutes of four components: a syntactic domain, a semantic
domain, and a pair of translation between the two.  Embedding also
constitutes of four components: an object language, a host language,
encoding of object terms in the host, and extraction of object code
from the host.

The correspondence is deep in that all four components in embedding
and NbE correspond to each other. Based on this correspondence, this
paper introduces Embedding-by-Normalisation (EbN), a principled
approach to embedding.

The correspondence is useful in that solutions from NbE can be
borrowed to solve problems in embedding. In particular, based on NbE
techniques, such as Type-Directed Partial Evaluation, this paper
presents a solution to the problem of reifying sum types, such as
conditional expressions, and primitives, such as literals and
operations on them.
\end{abstract}

\category{D.1.1}{Applicative (Functional) Programming}{}
\category{D.3.1}{Formal Definitions and Theory}{}
\category{D.3.2}{Language Classifications}
                {Applicative (functional) languages}
% todo: revise the categories above

\keywords
domain-specific language, DSL,
embedded domain-specific language, EDSL,
semantic, normalisation by evaluation, NbE,
type-directed partial evaluation, TDPE

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Introduction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\section{Introduction}
\label{sec:introduction}
Sometimes, less is more. Compared to General-Purpose Languages (GPLs)
like C, Java, or Haskell; Domain-Specific Languages (DSLs) like SQL,
VHDL, or HTML are smaller and simpler.
Unlike GPLs, DSLs are designed ground up to describe programs used in
a specific domain, e.g., SQL for database queries, VHDL for electronic
circuits, and HTML for web pages. DSLs are a powerful engineering
tool: DSLs abstract over domain-specific concepts and operations by
providing a set of primitives in the language. We refer to such
primitives as domain-specific constructs. For instance, SELECT
statement is a domain-specific construct in SQL.


\todo{}{motivate embedding here. mention easy implementation.}

\todo{}{explain the complications in the implementation of existing
        EDSLs.  refer to the fact that since it is easy to implement,
        people tend to come up with their own solutions.  mention the
        gaps in the implementation, e.g. support for sums and primitives.
        mention researchers frustration in
        understanding new EDSLs.}

\todo{}{motivate a systematic approach inspired by theory and
        semantics. Refer to the original goal that less is more, and
        that good theory simplifies EDSL implementation and
        understanding, and hence makes it more.}

\todo{}{explain NbE briefly}
\todo{}{explain connection between NbE and embedding}
\todo{}{explain TDPE briefly}
\todo{}{explain TDPE's solution to the two problems}
\todo{}{explain the bridge we made between the world of people in the
DSL community and semantic community and that we expect much more
results pass through this bridge}

\section{Normalisation-by-Evaluation}
\label{sec:NbE}
NbE is the process of deriving normal form of terms with respect to an
equational theory.

\todo{}{mention history: Martin Lof, Berger, and Schwichtenberg}
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
the evaluation process in NbE is often quite different from the one in the
standard evaluators.
Although it is not necessarily required, the evaluation process in NbE
is often denotational (compositional).

\item [reification]:
The process of mapping (back) elements of semantic domain to the
corresponding terms in the syntactic domain.

\end{description}

Formally, NbE can be defined as follows:
\begin{code}
record NbE : Set₁ where
   field
    Syn  :  Set
    Sem  :  Set
    ⟦_⟧   :  Syn → Sem
    ↓    :  Sem → Syn

   normalise : Syn → Syn
   normalise m = ↓ ⟦ m ⟧
\end{code}

Additionally, above should guarantee that, (a) |normalise| preserves
the intended meaning of the terms, and (b) |normalise| produces terms
in a normal form with respect to the intended equational theory.

\todo{Sam}{is above accurate and adequate? }

\subsection{A First Example}
%if False
\begin{code}
module NbEExamle where
 open import Data.Nat
 open import Data.List
 open import Relation.Binary.PropositionalEquality
   using (_≡_)
 infix 4 _≜_
\end{code}
%endif

Consider terms of the following grammar:
\begin{code}
 data Chars : Set where
    ε₀  : Chars
    chr : ℕ   → Chars
    _∙_ : Chars → Chars → Chars
\end{code}

\todo{}{Explain the intended use of above as regex for lexing and parsing.}

with the following equational theory:
\begin{code}
 data _≜_ : Chars → Chars → Set where
    left-identity   :  ∀ {a}      → ε₀ ∙ a ≜ a
    right-identity  :  ∀ {a}      → a ∙ ε₀ ≜ a
    associativity   :  ∀ {a b c}  → (a ∙ b) ∙ c ≜ a ∙ (b ∙ c)
\end{code}

The corresponding NbE is as follows:

\begin{code}
 flatten : Chars → List ℕ
 flatten ε₀         = []
 flatten (chr x)    = [ x ]
 flatten (xs ∙ ys)  = flatten xs ++ flatten ys

 roughen : List ℕ → Chars
 roughen []        = ε₀
 roughen (n ∷ ns)  = chr n ∙ roughen ns

 nbe-Chars : NbE
 nbe-Chars  =
  record
     { Syn  = Chars;
       Sem  = List ℕ;
       ⟦_⟧   = flatten;
       ↓    = roughen}
\end{code}

It is easy to prove that normalisation above respects the two properties:

%if False
\begin{code}
 open NbE nbe-Chars
\end{code}
%endif

\begin{code}
 preservation : ∀ {a b : Chars} → a ≜ b → normalise a ≜ b
 preservation left-identity   = {!!}
 preservation right-identity  = {!!}
 preservation associativity   = {!!}

 normalisation : ∀ {a} → normalise (normalise a) ≡ normalise a
 normalisation = {!!}
\end{code}

\todo{prove it, but consider taking out of the paper}

\section{Embedding-by-Normalisation}
\label{sec:EbN}

General recipie is as follows:
\begin{enumerate}
\item choose the signature of domain-specific constructs in your DSL,
\item choose a proper semantic domain,
\item define the corresponding evaluation and reification functions,
\item write an interpreter / code generator for normal syntactic forms, and
\item program in the shallow embedding layer.
\end{enumerate}

\subsection{Deep \& Quoted Embedding}
\label{sec:deep}
%if False
\begin{code}
module Deep where
 open import Function using (id)
\end{code}
%endif

Deep embedding is a form of embedding where object terms are encoded as datatypes in the host language.

Deep embedding is a very simple NbE:
\begin{code}
 nbe-deep : (Rep : Set) → (Rep → Rep) → NbE
 nbe-deep Rep optimiser =
  record
     { Syn  = Rep;
       Sem  = Rep;
       ⟦_⟧   = id;
       ↓    = optimiser}
\end{code}

\todo{}{explain optimiser is normaliser + delta rules}
\todo{}{explain quoted embedding is basically deep embedding but with sugar and (possibly) pre-defined optimiser/normaliser}

\subsection{Shallow \& Tagless Embedding}
\label{sec:shallow}

Shallow embedding is a form of embedding where object terms are encoded by host terms computing their semantics.
Semantics of shallow embedding should be compositional.
Shallow embedding is a form of NbE where evaluation is denotational.
Final tagless embedding is a technique for implementing shallow embedding, parametric over the semantic.
Shallow embeddings are folds over deep embeddings.

% \begin{spec}
%  nbe-shallow : (f : Functor) → ((sem : Set) → f sem) → Set → NbE
%  nbe-shallow f algebra interp  =
%   record
%      { Syn  = Rep;
%        Sem  = Rep;
%        ⟦_⟧   = id;
%        ↓    = }
% \end{spec}

\subsection{Overloaded \& Virtualised Embedding}
\label{sec:overloaded}
\todo{}{bring in the work on how to use type-classes / implicits}

\section{Type-Directed Partial Evaluation}
\label{sec:TDPE}

\subsection{Functions, Pairs, and Terms}
\label{sec:cdsl}
\todo{}{CDSLs should be mentioned here.}

\subsection{Sums}
\label{sec:sums}

\subsection{Primitives}
\label{sec:primitives}


\subsection{Final Solution}
\label{sec:final}


\section{Implementation}
\subsection{Agda}
\label{sec:Agda}

\subsection{Haskell and Overloading}
\label{sec:Haskell}

\subsection{OCaml and Effects}
\label{sec:OCaml}

\section{Discussion \& Related Work}
\label{sec:relatedwork}

\todo{}{Mention Danvy's other related work}
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

\section{Conclusion}
\label{sec:conclusion}

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

%  LocalWords:  documentclass preprint lhs polycode fmt forall amsmath
%  LocalWords:  usepackage amssymb stmaryrd pdfauthor Shayan Najd cL
%  LocalWords:  Lindley Svenningsson Wadler pdftitle pagebackref url
%  LocalWords:  pdftex backref hyperref graphicx color usenames tex
%  LocalWords:  dvipsnames svgnames xcolor newcommand todo noindent
%  LocalWords:  framebox parbox dimexpr linewidth fboxsep fboxrule xs
%  LocalWords:  textbf papersize setlength pdfpageheight paperheight
%  LocalWords:  pdfpagewidth paperwidth conferenceinfo ICFP Nara NbE
%  LocalWords:  copyrightyear copyrightdata nnnn ToDo copyrightdoi ys
%  LocalWords:  nnnnnnn publicationrights authorinfo LFCS Chalmers ns
%  LocalWords:  maketitle equational EbN reifying Applicative DSL EP
%  LocalWords:  EDSL TDPE GPLs Haskell DSLs SQL VHDL Nbe evaluators
%  LocalWords:  reification Tagless Virtualised Agda monad EDSLs agda
%  LocalWords:  relatedwork RawFP EPSRC bibliographystyle abbrvnamed
%  LocalWords:  sigplanconf Sem cdsl CDSLs OCaml Danvy's CACM LMS ucs
%  LocalWords:  Sam's Dybjer's Altenkirch's Walid's Ziria utf Lof chr
--  LocalWords:  inputenc Schwichtenberg denotational compositional
--  LocalWords:  NbEExamle endif regex lexing associativity nbe
