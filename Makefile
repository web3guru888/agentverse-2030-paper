# Makefile for "Infrastructure for the Agentic Web"
# Robin Dey and Panyanon Viradecha, OpenHub Research, 2026

PAPER    = agentverse-paper
PAPERDIR = paper
ARXIVDIR = arxiv-submission

.PHONY: all pdf clean arxiv

all: pdf

pdf:
	cd $(PAPERDIR) && \
	pdflatex -interaction=nonstopmode $(PAPER).tex && \
	bibtex $(PAPER) && \
	pdflatex -interaction=nonstopmode $(PAPER).tex && \
	pdflatex -interaction=nonstopmode $(PAPER).tex
	@echo "PDF built: $(PAPERDIR)/$(PAPER).pdf"

arxiv: pdf
	mkdir -p $(ARXIVDIR)
	cp $(PAPERDIR)/$(PAPER).tex  $(ARXIVDIR)/
	cp $(PAPERDIR)/$(PAPER).bib  $(ARXIVDIR)/
	cp $(PAPERDIR)/jmlr2e.sty    $(ARXIVDIR)/
	cd $(ARXIVDIR) && tar -czf ../$(PAPER)-arxiv.tar.gz .
	@echo "arXiv bundle: $(PAPER)-arxiv.tar.gz"

clean:
	cd $(PAPERDIR) && \
	rm -f *.aux *.bbl *.blg *.log *.out *.toc *.lof *.lot
	@echo "Cleaned build artefacts"
