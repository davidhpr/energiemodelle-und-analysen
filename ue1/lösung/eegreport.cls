%
% Letter-Klasse fuer einfache Notizen
% Autor: Andreas Fleischhacker
%
\def\fileversion{1.0}
\def\filedate{2013/07/18 }
\def\filename{eegscript}

\NeedsTeXFormat{LaTeX2e}

\ProvidesClass{\filename}[\filedate Notice-Klasse, (c) by Andreas Fleischhacker]
\typeout{Class: '\filename' Version \fileversion, Simple Notice File }

%% ========================================================================
%%%% Parameter
%% ========================================================================

% english version
\newif\if@english
\@englishfalse
\DeclareOption{english} {%
    \@englishtrue%
}

% others
\DeclareOption*{%
    \typeout{\CurrentOption not defined.}
}%
\ProcessOptions\relax

%% ========================================================================
%%%% Default settings
%% ========================================================================
\newcommand{\mypapersize}{A4} %% e.g., "A4", "letter", "legal", "executive", ...
\newcommand{\mylaterality}{oneside} %% "oneside" or "twoside"
\newcommand{\mydraft}{false} %% "true" or "false"
\newcommand{\myparskip}{half} %% e.g., "no", "full", "half", ...
\newcommand{\myBCOR}{0mm} %% Inner binding correction. 
\newcommand{\myfontsize}{11pt} %% e.g., 10pt, 11pt, 12pt
\newcommand{\mylinespread}{1.0} %% e.g., 1.0, 1.5, 2.0
\if@english \newcommand{\mylanguage}{ngerman,american} \else \newcommand{\mylanguage}{ngerman} \fi %% "english,ngerman", "ngerman,english", ...
\newcommand{\mybiblatexstyle}{authoryear} %% e.g., "alphabetic", "authoryear", ...
\newcommand{\mybiblatexdashed}{false}  %% "true" or "false"
\newcommand{\mybiblatexbackref}{true}  %% "true" or "false"
%\newcommand{\mybiblatexfile}{Literature.bib}
\newcommand{\mydispositioncolor}{30,103,182} %% e.g., "30,103,182" (blue/turquois), "0,0,0" (black), "0,102,153" (TU Wien Blue) ...
\newcommand{\mycolorlinks}{true}  %% "true" or "false"
\newcommand{\headcolor}{true}  %% "true" or "false"
\newcommand{\mytodonotesoptions}{} %% e.g., "" (empty), "disable", ...

%\setboolean{myaddlistoftodos}{false}  %% "true" or "false"
%% If set to "true": the current list of open todos is added after the
%% table of contents. If \mytodonotesoptions is set to "disable", no
%% list of todos is added, independent of this setting here.

%% ========================================================================
%%%% Document metadata
%% ========================================================================


%% ========================================================================
%%%% Include packages
%% ========================================================================
\LoadClass[%
	fontsize=\myfontsize,%% size of the main text
	paper=\mypapersize,  %% paper format
	parskip=\myparskip,  %% vertical space between paragraphs (instead of indenting first par-line)
	DIV=classic,            %% calculates a good DIV value for type area; 66 characters/line is great
	headinclude=true,    %% is header part of margin space or part of page content?
	footinclude=false,   %% is footer part of margin space or part of page content?
	open=right,          %% "right" or "left": start new chapter on right or left page
	appendixprefix=true, %% adds appendix prefix; only for book-classes with \backmatter
	bibliography=totoc,  %% adds the bibliography to table of contents (without number)
	draft=\mydraft,      %% if true: included graphics are omitted and black boxes
	                     %%          mark overfull boxes in margin space
	BCOR=\myBCOR,        %% binding correction (depends on how you bind
	                     %% the resulting printout.
	\mylaterality        %% oneside: document is not printed on left and right sides, only right side
	                     %% twoside: document is printed on left and right sides
]{scrartcl}  %% article class of KOMA: "scrartcl", "scrreprt", or "scrbook".
	            %% CAUTION: If documentclass will be changed, *many* other things
	            %%          change as well like heading structure, ...
\RequirePackage[utf8]{inputenc} %% UTF8 as input characters
\RequirePackage[\mylanguage]{babel}  %% used languages; default language is *last* language of options
\RequirePackage{scrpage2} %%  advanced page style using KOMA

% Literature
\RequirePackage[
	backend=biber, %% using "biber" to compile references (instead of "biblatex")
	style=\mybiblatexstyle, %% see biblatex documentation
	%style=alphabetic, %% see biblatex documentation
%	date=long,
%    refsection=section,		% biblography in each chapter
	dashed=\mybiblatexdashed, %% do *not* replace recurring reference authors with a dash
	backref=\mybiblatexbackref, %% create backlings from references to citations
	natbib=true, %% offering natbib-compatible commands
	hyperref=true, %% using hyperref-package references
]{biblatex}  %% remove, if using BibTeX instead of biblatex

%% new literature options for law
%\DeclareBibliographyDriver{legislation}{% 
%  \usebibmacro{bibindex}% 
%  \usebibmacro{begentry}% 
%  \usebibmacro{title}% 
%  \setunit{\addsemicolon\space}% 
%  \printfield{note}% 
%  \usebibmacro{pageref}% 
%  \usebibmacro{finentry}} 
%    
%\renewbibmacro*{cite}{% 
%  \iffieldundef{shorthand} 
%    {\ifthenelse{\ifnameundef{labelname}\OR\iffieldundef{labelyear}} 
%       {\usebibmacro{cite:label}}% 
%       {{\printnames{labelname}},%      %Kapitälchen 
%        \setunit{\nameyeardelim}}% 
%        \setunit*{\addspace} 
%       \usebibmacro{cite:labelyear+extrayear}} 
%   {\usebibmacro{cite:shorthand}}} 


\RequirePackage[pdftex]{graphicx}
\RequirePackage{pgfplots}
% Mathmode
\RequirePackage{amsmath,amssymb,amsfonts}
% Tabulars
\RequirePackage{tabularx}
\RequirePackage{array}
\RequirePackage{booktabs}
\RequirePackage{multirow}
% Graphics
\RequirePackage{graphicx}
% Color
\RequirePackage{xcolor}
% Hyperrefs
\RequirePackage{hyperref}
% Textboxes
\RequirePackage[absolute]{textpos} % use showboxes for draft mode
% new enviroment
\RequirePackage{environ}

\RequirePackage{pifont}
\RequirePackage{ifthen}
\RequirePackage{xspace} % This package is required for intelligent spacing after commands
\RequirePackage{xcolor}
	\definecolor{DispositionColor}{RGB}{30,103,182} %% used for links and so forth in screen-version
	%\definecolor{DispositionColor}{gray}{0}
	\definecolor{MyGray}{gray}{0}
	\definecolor{eeg_green}{RGB}{0, 128, 65}
\RequirePackage[normalem]{ulem}
\RequirePackage{framed}
\RequirePackage{eso-pic}
\RequirePackage{enumitem}
	\newboolean{myaddlistoftodos}
\RequirePackage[\mytodonotesoptions]{todonotes}  %% option "disable" removes all todonotes output from resulting document
\RequirePackage{siunitx}

%% Language settings
%\RequirePackage[utf8]{inputenc}
%\RequirePackage[\mylanguage]{babel}

%\makeatletter
% language
%\newif\if@useGerman                             % explizit deutsche Namen verwenden und german-Package einbinden ?
%\newif\if@useNoGerman                           % explizit englische Namen verwenden
%\DeclareOption{nogerman}{\@useNoGermantrue\@useGermanfalse}
%\DeclareOption{german}{\@useGermantrue\@useNoGermanfalse}

% options
\parindent 0pt

% hyperref setup
\hypersetup{
%    bookmarks=true,         % show bookmarks bar?
    unicode=false,          % non-Latin characters in Acrobat’s bookmarks
    pdftoolbar=true,        % show Acrobat’s toolbar?
    pdfmenubar=true,        % show Acrobat’s menu?
    pdffitwindow=false,     % window fit to page when opened
    pdfstartview={FitH},    % fits the width of the page to the window
    pdftitle={My title},    % title
    pdfauthor={Author},     % author
    pdfsubject={Subject},   % subject of the document
    pdfcreator={Creator},   % creator of the document
    pdfproducer={Producer}, % producer of the document
    pdfkeywords={keyword1} {key2} {key3}, % list of keywords
    pdfnewwindow=true,      % links in new window
    colorlinks=false,       % false: boxed links; true: colored links
    linkcolor=eeg_green,    % color of internal links (change box color with linkbordercolor)
    citecolor=eeg_green,    % color of links to bibliography
    filecolor=eeg_green,    % color of file links
    urlcolor=eeg_green,     % color of external links
    linkbordercolor=eeg_green, % color of boxes (link)
    urlbordercolor=eeg_green,  % color of boxes (url)
    citebordercolor=eeg_green,
    menubordercolor=eeg_green,
    runbordercolor=eeg_green, 
}

%% ========================================================================
%%%% Typographic Settings
%% ========================================================================

\RequirePackage[protrusion=true,factor=900]{microtype}

\frenchspacing  %% Macro to switch off extra space after punctuation.
%\usepackage{hfoldsty}  %% enables text figures using additional font
%% ... OR use ...
%\RequirePackage[sc,osf]{mathpazo} %% switches to Palatino with small caps and old style figures

%% Font selection from:
%%     http://www.matthiaspospiech.de/latex/vorlagen/allgemein/preambel/fonts/
%% use following lines *instead* of the mathpazo package above:
%% ===== Serif =========================================================
%% for Computer Modern (LaTeX default font), simply remove the mathpazo above
%\usepackage{charter}\linespread{1.05} %% Charter
%\usepackage{bookman}                  %% Bookman (laedt Avant Garde !!)
%\usepackage{newcent}                  %% New Century Schoolbook (laedt Avant Garde !!)
%% ===== Sans Serif ====================================================
%\renewcommand{\familydefault}{\sfdefault}  %% this one in *combination* with the default mathpazo package
%\usepackage{cmbright}                  %% CM-Bright (eigntlich eine Familie)
%\usepackage{tpslifonts}                %% tpslifonts % Font for Slides


\DeclareRobustCommand{\myacro}[1]{\textsc{\lowercase{#1}}} %%  abbrevations using small caps

%\setheadsepline{.4pt}[\color{DispositionColor}]
%\renewcommand{\headfont}{\normalfont\sffamily\color{DispositionColor}}
%\renewcommand{\pnumfont}{\normalfont\sffamily\color{DispositionColor}}
%\addtokomafont{disposition}{\color{DispositionColor}}
%\addtokomafont{caption}{\color{DispositionColor}\footnotesize}
%\addtokomafont{captionlabel}{\color{DispositionColor}}

\setheadsepline{.4pt}[\color{eeg_green}]
\renewcommand{\headfont}{\normalfont\sffamily\color{eeg_green}}
\renewcommand{\pnumfont}{\normalfont\sffamily\color{eeg_green}}
\addtokomafont{disposition}{\color{eeg_green}}
\addtokomafont{caption}{\color{eeg_green}\footnotesize}
\addtokomafont{captionlabel}{\color{eeg_green}}

%% see also: http://www.komascript.de/node/858 (German description)
\RequirePackage[bottom]{footmisc}

\RequirePackage{enumitem}
\setlist{noitemsep}   %% kills the space between items

\RequirePackage[babel=true,strict=true,english=american,german=guillemets]{csquotes}

\linespread{\mylinespread}

%% ========================================================================
%%%% My titlepage
%% ========================================================================
\newcommand{\mytitlepage}{
\begin{titlepage}

% First Page
% TU Wien logo
\AddToShipoutPicture*{%
  \AtPageUpperLeft{%
   \hspace{20mm}%
    \raisebox{-30mm}{%\baselineskip}{%
     \makebox[20mm][l]{\includegraphics[height=20mm]{graphics/TU_Logo.pdf}}
}}}%
%  EEG Logo
\AddToShipoutPicture*{%
  \AtPageUpperLeft{%
    \hspace{\paperwidth}%
    \raisebox{-35mm}{%\baselineskip}{%
    \makebox[-15mm][r]{\includegraphics[height=25mm]{graphics/EEG_logo.png}}
}}}%

\begin{center}
     
\vspace*{5cm}

\begin{textblock}{15.98}[0,0](0,4)
\centering
%\rule{\paperwidth}{1pt}
\huge\textbf{\textsf{\mytitle}}\\
\vspace*{0.8cm}
\ifthenelse{\equal{\mysubject}{}}{}{\Large \textsf{\mysubject}\\ \vspace*{0.8cm}}
\ifthenelse{\equal{\mydate}{}}{}{\Large \textsf{\mydate}\\ \vspace*{0.8cm}}

\end{textblock}


\begin{textblock}{13.97}[0,0](1.4,12)
\raggedright
\Large
\ifthenelse{\equal{\myauthors}{}}{}{\textsf{ \if@english Authors: \else Autoren: \fi \myauthors}\\ \vspace*{0.2cm}}
\ifthenelse{\equal{\mysupervisor}{}}{}{\textsf{ \if@english Supervisor: \else Betreuer: \fi \mysupervisor}\\ \vspace*{0.2cm}}
\ifthenelse{\equal{\myuniversity}{}}{}{\textsf{ \myuniversity}\\ \vspace*{0.2cm}}
\ifthenelse{\equal{\myinstitute}{}}{}{\textsf{ \myinstitute}\\ \vspace*{0.2cm}}
\ifthenelse{\equal{\myworkinggroup}{}}{}{\textsf{ \myworkinggroup}\\ \vspace*{0.2cm}}

\end{textblock}

\end{center}
\end{titlepage}
}

%% ========================================================================
%%%% My commands
%% ========================================================================

\newcommand{\myfig}[6]{
\begin{figure}[#6]
  \begin{center}
     \includegraphics[keepaspectratio,#2]{graphics/#1}
     \caption[#4]{#3}
     \label{fig:#5} %% NOTE: always label *after* caption!
  \end{center}
\end{figure}
}

\newcommand{\myfigframed}[6]{
\begin{figure}[#6]
  \begin{center}
	 \setlength\fboxsep{0.5pt} 
	 \setlength\fboxrule{0.5pt}
     \fbox{\includegraphics[keepaspectratio,#2]{graphics/#1}}
     \caption[#4]{#3}
     \label{fig:#5} %% NOTE: always label *after* caption!
  \end{center}
\end{figure}
}

%\myfig{}%% filename in figures folder
%       {width=}%% maximum width/height, aspect ratio will be kept
%       {}%% caption
%       {}%% optional (short) caption for list of figures
%       {}%% label
%       {}%% figure position

\newcommand{\myfigpdftex}[6]{
\begin{figure}[#6]
  \def\svgwidth{#2\textwidth}
  \begin{center}
    \input{graphics/#1.pdf_tex}
    \caption[#4]{#3}
    \label{fig:#5} %% NOTE: always label *after* caption!
  \end{center}
\end{figure}
}
% example:
%\myfigpdftex{}%% filename in figures folder
%       {}%% maximum height, aspect ratio will be kept
%       {}%% caption
%       {}%% optional (short) caption for list of figures
%       {}%% label
%       {}%% figure position

\newcommand{\vect}[1]{\mathbf{#1}} % vector symbol: bold
\newcommand{\mat}[1]{\mathbf{#1}}  % matrix symbol: bold
\newcommand{\esym}[1]{\textit{#1}} % symbols without a kursiv font
\newcommand{\Epsilon}{\mathcal{E}} % big epsilon
\newcommand{\underconsideration}[2]{\left.#1\right\vert_{#2}}
\newcommand{\germanword}[1]{\foreignlanguage{ngerman}{#1}}
\newcommand{\germanwordQM}[1]{\glqq\foreignlanguage{ngerman}{#1}\grqq}
\newcommand{\myeqitem}[2]{#1 & -- &  #2 \\}
\newenvironment{myquote}{\begin{quote} \small}{\end{quote}}
%\newenvironment{myeqdes}
%	{\tabularx{\textwidth}{lcX}}
%	{\endtabularx}
	
\NewEnviron{myeqdes}{%
   \begin{tabularx}{\textwidth}{lcX}%
    \BODY
   \end{tabularx}
}
