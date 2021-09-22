# Makefile to work with JupyterBook

SRC=$(wildcard *.ipynb) $(wildcard *.yml) $(wildcard res/*)

TARGET_DIR=_build

TARGET_HTML=$(TARGET_DIR)/index.html
TARGET_HTML_DIR=$(TARGET_DIR)/html

TARGET_LATEX=$(TARGET_DIR)/book.tex
TARGET_LATEX_DIR=$(TARGET_DIR)/latex

all: $(TARGET_HTML) $(TARGET_LATEX)

$(TARGET_HTML): $(SRC)
	$(RM) -R $(TARGET_HTML_DIR)
	jupyter-book build --builder=html .

$(TARGET_LATEX): $(SRC)
	$(RM) -R $(TARGET_LATEX_DIR)
	jupyter-book build --builder=latex .

publish: $(TARGET_HTML)
	ghp-import --no-jekyll --push --force $(TARGET_HTML_DIR)
