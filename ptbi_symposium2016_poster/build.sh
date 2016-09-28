#!/bin/bash

LATEX=xelatex
LATEX=pdflatex

$LATEX poster_portrait
bibtex poster_portrait
$LATEX poster_portrait
$LATEX poster_portrait

