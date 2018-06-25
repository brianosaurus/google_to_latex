#!/usr/local/bin/gsed -E -f

# remove comments from people
#s/^([^%]*)%.*$/\1/
#s/^}$//


# changing the document type for proper formatting
s/scrbook/article/
s/Valor:.*$//

# sets up the title page
s/A Fair Currency//
s/The Valor Foundation//
s/\\begin\{\document\}/\\title{Valor: A Fair Currency}\
\\usepackage{tocbibind}\
\\usepackage{float}\
\\usepackage{flafter}\
\\usepackage{xcolor}\
\\usepackage{sectsty}\
\\author{The Valor Foundation}\
\\date{}\
\\begin{document}\
\\maketitle/

# add this to the above to make paragraphs dark gray
# \\paragraphfont{\\color{darkgray}}\


# The abstract section
s/chapter\{Abstract.*$/begin{abstract}/

# This is how we set the TOC level ... it inserts above the section the TOC depth
s/chapter\{Introduction.*$/end{abstract}\
\\setcounter{tocdepth}{2}\
\\section*{Introduction\\label{ref-002}}/

# formatting
s/tableofcontents/tableofcontents\
\\pagebreak\
\\listoffigures/

# changing chapers to sections, sections to subsections, and subsections to paragraphs
s/^\\chapter\{\}$//
s/\\subsubsection/\\paragraph/
s/\\subsection/\\subsubsection*/
s/\\section/\\subsection/
s/\\chapter(.*)/\\pagebreak\
\\section\1/

# Removing section numbers to let LaTex do that for us
s/\{[0-9]\. /{/
s/\{[0-9]\.[0-9] /{/
/^[[:space:]]*$/d

# Tables and tabluarlx aren't working in this doc, remove them
s/\\begin\{table\}//
s/\\end\{table\}//
s/\\begin\{tabularx\}.*//
s/\\end\{tabularx\}//
s/p\{\\dimexpr 1\\linewidth-2\\tabcolsep\}\}//
s/ \\\\//

# formatting the equations
s/extra2\\newline/extra2\\newline\
\\newline/
s/size\(Set2\)\\newline/size(Set2)\\newline\
\\newline/
s/^commonP(.*)\\newline/commonP\1\\newline\
\\newline/
s/commonP$/commonP\\newline/

# formats the equations so they look nicer by putting '$' around the equations
# to math format them and also adding a 0.25em space before the > symbols
s/^Set([0-9].*)$/$Set\1$/ 
s/^threshold([0-9].*)$/$threshold\1$/ 
s/^safetyP(.*)$/$safetyP\1$/ 
s/^commonP(.*)$/$commonP\1$/ 
s/^100(.*) or\\newline$/$100\1$ or \\newline/ 
s/^100 - \((.*)$/$100 - (\1$/ 
s/\{\\textgreater/\\hspace{0.25em}{\\textgreater/g

# formatting
s/archiver and a basic validator./archiver and a basic validator.\
\\newline\
\\newline/

# Figures don't need numbers in LaTex
s/Figure [0-9]+: //

# Fixing figures to be side by side and float appropriately.
# When a new IMPORT happens these images have to be specifically reset to their img number
s/\\begin\{figure\}/\\begin{figure}[h]/
s/\\includegraphics\[width=1\\textwidth\]\{Valor_White_Paper.docx.tmp\/word\/media\/image15.jpg\}//
s/\\includegraphics\[width=1\\textwidth\]\{Valor_White_Paper.docx.tmp\/word\/media\/image14.jpg\}//
s/\\caption\{\\textbf\{Valor Network Implementation,\} Steps 1--2.\}/\\caption{\\textbf{Valor Network Implementation,} Steps 1--2.}\
\\includegraphics\[width=0.5\\textwidth\]{Valor_White_Paper.docx.tmp\/word\/media\/image15.jpg}\
\\includegraphics\[width=0.5\\textwidth\]{Valor_White_Paper.docx.tmp\/word\/media\/image14.jpg}/

# the below 2 lines change all figures to 0.5 width and then revert the first and sixth ones to width=1
#s/width=1\\textwidth/width=0.5\\textwidth/

# Formatting
s/\\subsection\{Distributed Ledger/\\pagebreak\\subsection{Distributed Ledger/

# Long URL line
s/ \\href\{https:\/\/www.stellar.org\/developers\/stellar-core\/software\/admin.html}(.*)\\textit\{Accessed/\
 \\newline\\href{https:\/\/www.stellar.org\/developers\/stellar-core\/software\/admin.html}\1\
 \\newline\\textit{Accessed/
  
# Fixing shortened images
s/\.jpg\}\\includegraphics/.jpg}\
\\includegraphics/

# Formatting
s/\\subsection\{Horizon Client Server/\\pagebreak\
\\subsection{Horizon Client Server/

# this fixes a too long line wuth a URL in it
s/\\href\{https:\/\/arstechnica.com/\\newline\
  \\href{https:\/\/\/arstechnica.com/

# this fixes a too long line wuth a URL in it
s/http:\/\/www.springer.com/\\newline\
  http:\/\/www.springer.com/

# this fixes a too long line wuth a URL in it
s/\href\{http:\/\/www.marktaker.com/\\newline\
  \\href{http:\/\/www.marktaker.com/

# this fixes a too long line wuth a URL in it
s/https:\/\/bitcoinfoundation.org/\\newline\
  https:\/\/bitcoinfoundation.org/

# this fixes a section that has 'ApplicationProvoders' it puts a space in there
s/Application%.*/Application/
