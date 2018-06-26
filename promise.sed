#!/usr/local/bin/gsed -E -f

# remove comments from people
#s/^([^%]*)%.*$/\1/
#s/^}$//

# changing the document type for proper formatting
s/scrbook/article/

# set point size
s/\\documentclass.*/\\documentclass[11pt]{article}/

# sets up the title page
s/\\begin\{\document\}/\\title{Promise \\protect\\\\ A decentralized, peer-to-peer, \\protect\\\\repayment protocol}\
\\usepackage{extsizes}\
\\usepackage[nottoc, notlot, notlof]{tocbibind}\
\\usepackage{float}\
\\usepackage{flafter}\
\\usepackage{sectsty}\
\\usepackage{tocbibind}\
\\usepackage[table, svgnames]{xcolor}\
\\usepackage{array}\
\\usepackage{cellspace}\
\\setlength\\cellspacetoplimit{4pt}\
\\setlength\\cellspacebottomlimit{4pt}\
\\usepackage{etoolbox}\
\\colorlet{headercolour}{Silver}\
\\usepackage{hyperref}\
\\hypersetup{\
  colorlinks = true,\
  linkcolor  = black\
}\
\\author{yoshiroshinji@protonmail.com}\
\\date{\\today\\\\Version 0.1}\
\\begin{document}\
\\maketitle/

s/^Promise.*//1
s/^A decentralized, peer-to-peer,.*//
s/^repayment protocol.*// 

# fix urls by bacslashing unbackslashed hashes
s/[^\\]#/\\#/g

s/^yoshiroshinji@protonmail.com//
s/^ Yoshiro Shinji.*//

s/^\\textbf\{ROUGH DRAFT\}/\\begin{center}\
\\textbf{ROUGH DRAFT}/
s/^\\textbf\{NOT FOR DISTRIBUTION\}/\\textbf{NOT FOR DISTRIBUTION}\
\\end{center}/


# add this to the above to make paragraphs dark gray
# \\paragraphfont{\\color{darkgray}}\


# The abstract section
s/section\{\\textbf\{Abstrac.*$/begin{abstract}/

# This is how we set the TOC level ... it inserts above the section the TOC depth
s/^\\section\{Introduction\}/\\end{abstract}\
\\pagebreak\
\\setcounter{tocdepth}{2}\
\\tableofcontents\
\\listoffigures\
\\listoftables\
\\pagebreak\
\\section{Introduction}/


# \\setcounter{tocdepth}{2}\
# \\section*{Introduction\\label{ref-002}}/

# formatting

# changing chapers to sections, sections to subsections, and subsections to paragraphs
# s/^\\chapter\{\}$//
# s/\\subsubsection/\\paragraph/
# s/\\subsection/\\subsubsection*/
# s/\\section/\\subsection/
# s/\\chapter(.*)/\\pagebreak\
# \\section\1/

# Removing section numbers to let LaTex do that for us
# s/\{[0-9]\. /{/
# s/\{[0-9]\.[0-9] /{/
# /^[[:space:]]*$/d

# Tables and tabluarlx aren't working in this doc, remove them
s/\\begin\{table\}/\\begin{table}[H]/g
s/\\begin\{tabularx.*/\\begin{tabularx}{\\textwidth}{|/g
s/tabcolsep\}/tabcolsep}|/g
s/tabcolsep\}\|}/tabcolsep}|}\
\\hline\
\\rowcolor{Silver}/g
s/^([^&]* & [^&]* & [^&]* & [^&]* \\\\)$/\1 \\hline/g

# change spacing in the tables
s/0.08/0.09/g
s/0.22/0.26/g
s/0.23/0.26/g
s/0.14/0.26/g
s/0.15/0.26/g
s/0.16/0.26/g
s/0.1[0-9]?/0.16/g
s/0.5[0-9]/0.485/g
s/0.6[0-9]/0.485/g

# make this bit really small
s/\(bytes\)/\\scriptsize{(bytes)}/g

# fix captions for tables
s/^.*Table [0-9].*$//g
s/\\end\{tabularx\}//g
s/\\end\{table\}//g

# caoptions for tables
s/store for this pledge \\\\ \\hline/store for this pledge \\\\ \\hline\
\\end{tabularx}\
\\caption{The fields in the Promise structure}\
\\end{table}/

s/List of public keys in the ring signature \\\\ \\hline/List of public keys in the ring signature\\\\ \\hline\
\\end{tabularx}\
\\caption{The signature structure}\
\\end{table}/

s/to pay the pledgee per block \\\\ \\hline/to pay the pledgee per block \\\\ \\hline\
\\end{tabularx}\
\\caption{The Pledge structure}\
\\end{table}/

s/which this transaction is unlocked. \\\\ \\hline/which this transaction is unlocked.\\\\ \\hline\
\\end{tabularx}\
\\caption{Promise Tx structure}\
\\end{table}/

s/inclusion into a block. \\\\ \\hline/inclusion into a block.\\\\ \\hline\
\\end{tabularx}\
\\caption{TxIn fields}\
\\end{table}/

s/The first output is 0, etc. \\\\ \\hline/The first output is 0, etc. \\\\ \\hline\
\\end{tabularx}\
\\caption{The Outpoint structure}\
\\end{table}/

s/The first pledgee is 0, etc. \\\\ \\hline/The first pledgee is 0, etc. \\\\ \\hline\
\\end{tabularx}\
\\caption{The TxOut structure}\
\\end{table}/

# captions for figures
s/^.*The Promise Blockchain.*$//
s/image8.png\}/image8.png}\
\\caption{The Promise blockchain}/

s/^.*Keyblocks and Microblocks.*$//
s/image12.png\}/image12.png}\
\\caption{Keyblocks and Microblocks}/

s/\\textbf\{The transaction trie\}$//
s/^(.*)width=1(.*)image10.png\}/\\begin{figure}[H]\
\\begin{center}\
\1width=0.5\2image10.png}\
\\caption{The Transaction trie}\
\\end{center}\
\\end{figure}/


s/^.*The Pledge trie.*$//
s/^(.*)width=1(.*)image9.png\}/\\begin{figure}[H]\
\\begin{center}\
\1width=0.5\2image9.png}\
\\caption{The Pledge trie}\
\\end{center}\
\\end{figure}/

s/^.*The Contract trie.*$//
s/^(.*)width=1(.*)image11.png\}/\\begin{figure}[H]\
\\begin{center}\
\1width=0.5\2image11.png}\
\\caption{The Contract trie}\
\\end{center}\
\\end{figure}/

s/^.*The contract state trie.*$//
s/^(.*)width=1(.*)image7.png\}/\\begin{figure}[H]\
\\begin{center}\
\1width=0.5\2image7.png}\
\\caption{The Contract State trie}\
\\end{center}\
\\end{figure}/


#s/Note that If all TxIn inputs have final/\\break\
#\\newline\
#\\newline\
#Note that If all TxIn inputs have final/



# have to force place figures on this document
s/^\\paragraph\{(\\includegraphics.*)\}$/\1/
s/^(\\includegraphics.*)$/\\begin{figure}[H]\
\1\
\\end{figure}/
  
# fix equations
#s/^\$(.*)\$$/$$\1$$/g

s/NP\(tx\)=NumberofPledgeTermswithinthedefinedexpirationperiod\(E\)\$\$SumPledgeHashesP\(tx\)=VerifiedInterestbearingpledgesinnetwork/$NP(tx)=Number\\, of\\,Pledge\\,Terms\\,within\\,the\\,defined\\,expiration\\,expiration\\,period\\, (E)$$\
$$Sum\\,Pledge\\,Hashes\\,P(tx)=Verified\\,Interest\\,bearing\\,pledges\\,in\\,network$/

s/^(.*)\$payment=(.*)transactionvalidationanddelegationfees\$$/\1\
$$payment=\2transaction\\,validation\\,and\\,delegation\\,fees$$/
s/^(.*)modp.*$/$\1mod\\,p$$/
s/aggreg.pdf(.*)$/aggreg.pdf\1\\newline/
s/\$Promiseprivate\\_ k(.)signs(.*)\|\|(.*)\$/$Promise\\,private\\_k\1\\,signs\\,\2\\,||\\,\3$\\newline/g
s/this is called signer anonymity(.*)$/this is called signer anonymity\1\\newline/
s/^\$LetG_(.*)$/$LegG_\1\\newline/
s/^\$Sign(.*)$/$Sign\\,\1\\newline/
s/^\$Compute(.*)$/$Compute\\,\1\\newline/
s/^Verify(.*)$/Verify\1\\newline/
s/^\$\\\prod(.*)$/$\\prod\1\\newline/
s/The average orphan rate is given by(.*)$/The average orphan rate is given by\1\\newline/
s/orphanrate(.*)$/orphan\\,rate\1\\newline/g
s/ten percent can be approximated as(.*)$/ten percent can be approximated as\1\\newline/
s/The LWMA can be defined by the following equation(.*)$/The LWMA can be defined by the following equation\1\\newline/
s/Stake required with the LWMA(.*)$/Stake required with the LWMA\1\\newline/
s/LWMA\\left\(stake(.*)$/LWMA\\left(stake\1\\newline/


# this fixes a too long line wuth a URL in it
# s/\href\{http:\/\/www.marktaker.com/\\newline\
#   \\href{http:\/\/www.marktaker.com/

