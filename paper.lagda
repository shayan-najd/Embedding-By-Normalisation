\documentclass[preprint]{sigplanconf}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lhs2TeX package imports
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%include agda.fmt

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% latex package imports
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\usepackage{amsmath}

% \usepackage{stmaryrd}
% \usepackage{proof}
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
%format ≜c = "≜_c"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% latex macros
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\DeclareUnicodeCharacter{7523}{\ensuremath{_r}}
\DeclareUnicodeCharacter{8343}{\ensuremath{_l}}
\DeclareUnicodeCharacter{8337}{\ensuremath{_e}}
\DeclareUnicodeCharacter{8348}{\ensuremath{_t}}
\DeclareUnicodeCharacter{7522}{\ensuremath{_i}}
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
approach to embedding.

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
semantic, normalisation-by-evaluation, NBE,
type-directed partial evaluation, TDPE

%if False
\begin{code}
open import Relation.Binary.PropositionalEquality
   using (_≡_;cong;sym;trans;refl;cong₂;subst)
open import Data.Product
open import Function
\end{code}
%endif

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
DSLs come with their own ecosystem, ranging from liberaries to
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
where SQL queries, as embedded DSL programs, are integerated with
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
to subtelties caused by embedding, EDSLs are often presented
informally by actual code in a mainstream host language; it is
difficult to distinguish an EDSL from the the host language, as the
boundry between an EDSL and its host language is not entirely clear.
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
% (informally) a new particular EDSL.  It is notriously difficult to
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
shallow embedding is when an interface form by a set of functions is
used to represent the syntax, and implementation of the functions as
semantics;
final tagless embedding\citep{Tagless}, which is a specific form of
shallow embedding, is when type-classes are used to define interface
representing syntax, and instances of the type-classes for semantics.

One key issue with this lack of a principled approach to
embedding is scalability of existing solutions. Once one moves from
embedding simpler DSLs to DSLs with richer computational content, it
becomes harder for embedding to stay close to the intended syntax and
semantic in one hand, and reuse the host machinery in the other.

% todo: forward-reference to a section with

The kind of principles this paper is aiming for is the ones of
mathmatical nature: abstract, simple, and insightful. These are the
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
Semantic algebras and folds enjoy clear mathmatical and formal
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
language features. NBE enjoys clear mathmatical and formal
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
      correpondence to NBE (Section \ref{sec:NBE} and \ref{sec:EBN})
\item To show how to systematically embedd different variants of
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
      observing such techniques through EBN lense
      (Section \ref{sec:RelatedWork})
\end{itemize}

To steer clear from the mentioned informality prevalent in EDSL
literature, code in the main body of this paper is presented using
type theory, as implemented in the proof assistant Agda
\citep{Agda}. Only a minimal set of language features in Agda is
used, hoping for the presentation to remain accessible to the readers
familiar with functional programming.
When inferrable from context, some unnecessary implementation details,
such as type instantiations or overloading of constants, are
intensionally left out of the code for brevity.
As mentioned, the implementation concerns are addressed separately, in
Section \ref{sec:Implementation}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% NBE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\section{Normalisation-by-Evaluation}
\label{sec:NBE}
%include NBE.lagda

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EBN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\section{Embedding-by-Normalisation}
\label{sec:EBN}

\begin{center}
\begin{tabular}{rcl}
NBE              &\ \ <--->\ \ &  EBN \\  \\
Syntactic Domain &\ \ <--->\ \ &  Object Language\\
Semantic  Domain &\ \ <--->\ \ &  Host   Language (a subset of)\\
Evaluation       &\ \ <--->\ \ &  Encoding\\
Reification      &\ \ <--->\ \ &  Code Extraction
\end{tabular}
\end{center}

% General recipie is as follows:
% \begin{enumerate}
% \item define the syntax of your DSL formally,
%       possibly as a variant of typed lambda calculus with a set of primitives
% \item choose a proper semantic domain,
% \item define the corresponding evaluation and reification functions,
% \item write an interpreter / code generator for normal syntactic forms, and
% \item program in the shallow embedding layer.
% \end{enumerate}

% todo: mention relation to other embedding techniques
%       enough to explain HOAS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Basic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\subsection{Units, Functions, and Products}
\label{sec:Basic}
%include Basic.lagda


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Primitives
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\subsection{Base Types, Literals, and Primitives}
\label{sec:Primitives}
%include Primitives.lagda

% todo: mention Feldspar here

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sums
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\subsection{Sums}
\label{sec:Sums}
%include Sums.lagda

% todo: mention TDPE / offline PE here

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Smart
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\subsection{Smart Primitives}
\label{sec:Smart}
%include Smart.lagda

% todo: mention online PE here

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Richer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\subsection{Richer Languages}
\label{sec:Richer}

% todo: mention Altenkirch and Dybjer's

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

% todo: mention when EBN can be implemented by
%       tagless/shallow

% todo: mention the two impossibilities:
%       (a) sum types
%       (b) primitives

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Conclusion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\section{Conclusion}
\label{sec:conclusion}

% This paper is to free embedding from Girard's wedding cake dilemma.
% Show the diagram of correspondence
% Mention Compostional evaluation = shallow embedding
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
%  LocalWords:  usepackage amssymb stmaryrd pdfauthor Shayan Najd cL
%  LocalWords:  Lindley Svenningsson Wadler pdftitle pagebackref url
%  LocalWords:  pdftex backref hyperref graphicx color usenames tex
%  LocalWords:  dvipsnames svgnames xcolor newcommand todo noindent
%  LocalWords:  framebox parbox dimexpr linewidth fboxsep fboxrule xs
%  LocalWords:  textbf papersize setlength pdfpageheight paperheight
%  LocalWords:  pdfpagewidth paperwidth conferenceinfo ICFP Nara NBE
%  LocalWords:  copyrightyear copyrightdata nnnn ToDo copyrightdoi ys
%  LocalWords:  nnnnnnn publicationrights authorinfo LFCS Chalmers ns
%  LocalWords:  maketitle equational EBN reifying Applicative DSL EP
%  LocalWords:  EDSL TDPE GPLs Haskell DSLs SQL VHDL Nbe evaluators
%  LocalWords:  reification Tagless Virtualised Agda monad EDSLs agda
%  LocalWords:  relatedwork RawFP EPSRC bibliographystyle abbrvnamed
%  LocalWords:  sigplanconf Sem cdsl CDSLs OCaml Danvy's CACM LMS ucs
%  LocalWords:  Sam's Dybjer's Altenkirch's Walid's Ziria utf Lof chr
%  LocalWords:  inputenc Schwichtenberg denotational compositional
%  LocalWords:  NBE Example endif regex lexing associativity nbe
