all: paper.pdf

paper.tex: paper.lagda NBE.lagda Basic.lagda Primitives.lagda Sums.lagda Smart.lagda formalism.tex
	if [ -f "paper.tex" ]; then chmod +w paper.tex; fi
	lhs2TeX --agda -o paper.tex paper.lagda
	chmod -w paper.tex

paper.aux: paper.tex formalism.tex
	pdflatex paper

paper.bbl: paper.aux paper.bib
	bibtex paper

paper.pdf: paper.aux paper.bbl
	pdflatex paper
	pdflatex paper

.PHONY:clean
clean:
	rm -f *.out *.aux *.log *.bbl *.blg *.ptb *.brf *~ \
	paper.tex

clean-all: clean
	rm -f paper.pdf
