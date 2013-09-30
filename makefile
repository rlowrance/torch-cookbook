all: getting-started.pdf installing-torch.pdf linux-in-a-box.pdf using-torch-on-hadoop.pdf \
	run-many-hadoop-jobs.pdf

getting-started.pdf: getting-started.tex
	pdflatex getting-started.tex

installing-torch.pdf: installing-torch.tex
	pdflatex installing-torch.tex

linux-in-a-box.pdf: linux-in-a-box.tex
	pdflatex linux-in-a-box.tex

run-many-hadoop-jobs.pdf: run-many-hadoop-jobs.tex \
	run-many-hadoop-jobs-assets/map-reduce.sh \
	run-many-hadoop-jobs-assets/go.sh
	pdflatex run-many-hadoop-jobs.tex

using-torch-on-hadoop.pdf : using-torch-on-hadoop.tex \
	using-torch-on-hadoop-assets/courant-abel-prize-winners.txt \
 using-torch-on-hadoop-assets/countInput-map.lua \
 using-torch-on-hadoop-assets/countInput-reduce.lua \
 using-torch-on-hadoop-assets/getKeyValue.lua \
 using-torch-on-hadoop-assets/countInput-run.sh
	pdflatex using-torch-on-hadoop.tex

.PHONY: clean
clean:
	rm *.aux *.log

.PHONY: cleanall
cleanall: clean
	rm *.aux *.log *.pdf



 
