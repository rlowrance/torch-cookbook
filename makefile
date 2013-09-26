all: getting-started.pdf installing-torch.pdf linux-in-a-box.pdf using-torch-on-hadoop.pdf

getting-started.pdf: getting-started.tex
	pdflatex getting-started.tex

installing-torch.pdf: installing-torch.tex
	pdflatex installing-torch.tex

linux-in-a-box.pdf: linux-in-a-box.tex
	pdflatex linux-in-a-box.tex

using-torch-on-hadoop.pdf : using-torch-on-hadoop.tex \
 code/using-torch-on-hadoop/courant-abel-prize-winners \
 code/using-torch-on-hadoop/countInput-map.lua \
 code/using-torch-on-hadoop/countInput-reduce.lua \
 code/using-torch-on-hadoop/getKeyValue.lua \
 code/using-torch-on-hadoop/countInput-run.sh
	pdflatex using-torch-on-hadoop.tex

.PHONY: clean
clean:
	rm *.aux *.log

.PHONY: cleanall
cleanall: clean
	rm *.aux *.log *.pdf



 
