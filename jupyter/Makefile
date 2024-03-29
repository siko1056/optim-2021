# Makefile to work with JupyterBook

SRC=$(wildcard *.ipynb) $(wildcard *.yml) $(wildcard res/*)

TARGET_DIR=_build

TARGET_HTML_DIR=$(TARGET_DIR)/html
TARGET_HTML=$(TARGET_HTML_DIR)/index.html

TARGET_LATEX_DIR=$(TARGET_DIR)/latex
TARGET_LATEX=$(TARGET_LATEX_DIR)/optim.tex

TARGET_PDF=$(TARGET_LATEX_DIR)/optim.pdf

all: $(TARGET_HTML) $(TARGET_LATEX)

$(TARGET_HTML): $(SRC)
	$(RM) -R $(TARGET_HTML_DIR)
	jupyter-book build --builder=html .

$(TARGET_LATEX): $(SRC)
	$(RM) -R $(TARGET_LATEX_DIR)
	jupyter-book build --builder=latex .

$(TARGET_PDF): $(SRC)
	sed -i 's/\\begin{split}\\tag\*{\$$\\Box\$$}\\end{split}/\\tag\*{\$$\\Box\$$}/g' $(TARGET_LATEX)
	sed -i '/^\\setmainlanguage.*/i \\\\usepackage{xeCJK}\n\\setCJKmainfont{IPAMincho}\n\\setCJKsansfont{IPAGothic}\n\\setCJKmonofont{IPAGothic}' $(TARGET_LATEX)
	cd $(TARGET_LATEX_DIR) && $(MAKE)

pdf: $(TARGET_PDF)
	xdg-open $(TARGET_PDF)

clean:
	$(RM) -R $(TARGET_DIR)
