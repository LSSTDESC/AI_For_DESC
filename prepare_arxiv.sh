#!/bin/bash
#
# Prepare files for arXiv submission
# Run this script from the project root directory
#

set -e

# Configuration
ARXIV_DIR="arxiv"
MAIN_TEX="main.tex"

echo "=== Preparing arXiv submission package ==="

# Clean and create arxiv directory
rm -rf "$ARXIV_DIR"
mkdir -p "$ARXIV_DIR"
mkdir -p "$ARXIV_DIR/sections"
mkdir -p "$ARXIV_DIR/figures"
mkdir -p "$ARXIV_DIR/desc-tex/logos"

echo "Copying main tex file..."
cp "$MAIN_TEX" "$ARXIV_DIR/"

echo "Copying section files..."
cp sections/*.tex "$ARXIV_DIR/sections/"

echo "Copying auxiliary tex files..."
cp authors.tex "$ARXIV_DIR/"
cp contributors.tex "$ARXIV_DIR/"
cp desc-standard-ack.tex "$ARXIV_DIR/"
cp methods_and_challenges.tex "$ARXIV_DIR/"

echo "Copying style files..."
cp lsstdescnote_customized.cls "$ARXIV_DIR/"
cp lsstdesc_macros.sty "$ARXIV_DIR/"

echo "Copying figures..."
cp figures/*.png "$ARXIV_DIR/figures/"

echo "Copying logos (required by class file)..."
cp desc-tex/logos/header.png "$ARXIV_DIR/desc-tex/logos/"

echo "Copying bibliography..."
# arXiv prefers .bbl files (pre-compiled bibliography)
if [ -f "main.bbl" ]; then
    cp main.bbl "$ARXIV_DIR/"
    echo "  - Copied main.bbl (pre-compiled bibliography)"
else
    echo "  - WARNING: main.bbl not found. You may need to compile the document first."
    echo "    Run: pdflatex main && bibtex main && pdflatex main && pdflatex main"
fi

# Also copy .bib file as backup (arXiv can use either)
if [ -f "refs.bib" ]; then
    cp refs.bib "$ARXIV_DIR/"
    echo "  - Copied refs.bib"
fi

echo ""
echo "Creating tarball for upload..."
cd "$ARXIV_DIR"
tar -czvf ../arxiv_submission.tar.gz *
cd ..

echo ""
echo "=== Done! ==="
echo ""
echo "Files prepared in: $ARXIV_DIR/"
echo "Tarball created: arxiv_submission.tar.gz"
echo ""
echo "Before uploading to arXiv:"
echo "  1. Verify the package compiles: cd $ARXIV_DIR && pdflatex main"
echo "  2. Check that all figures appear correctly"
echo "  3. Ensure the .bbl file is up to date"
echo ""
echo "Contents of $ARXIV_DIR/:"
ls -la "$ARXIV_DIR/"
