%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% kaobook
% LaTeX Class
% Version 0.9.8 (2021/08/23)
%
% This template originates from:
% https://www.LaTeXTemplates.com
%
% For the latest template development version and to make contributions:
% https://github.com/fmarotta/kaobook
%
% Authors:
% Federico Marotta (federicomarotta@mail.com)
% Based on the doctoral thesis of Ken Arroyo Ohori (https://3d.bk.tudelft.nl/ken/en)
% and on the Tufte-LaTeX class.
% Modified for LaTeX Templates by Vel (vel@latextemplates.com)
%
% License:
% LPPL (see included MANIFEST.md file)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 你真的想阅读魔改后的 kaohandt 屎山源码嘛？

%----------------------------------------------------------------------------------------
%	CLASS CONFIGURATION
%----------------------------------------------------------------------------------------

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{guidehandt}[2022/03/06 v0.1.0 guidehandt modified from kaohandt by at-xy]
\newcommand{\@baseclass}{ctexart} % Base class name

% Set the default options
\PassOptionsToClass{zihao=-4,a4paper,oneside,linespread=1.3}{\@baseclass}

% Pass through any other options to the base class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{\@baseclass}}

\ProcessOptions\relax % Process the options

\LoadClass{\@baseclass} % Load the base class

%----------------------------------------------------------------------------------------
%	USEFUL PACKAGES AND COMMANDS
%----------------------------------------------------------------------------------------

\RequirePackage{etoolbox} % Easy programming to modify TeX stuff
\RequirePackage{calc} % Make calculations
\RequirePackage[usenames,dvipsnames,table]{xcolor} % Colours
\RequirePackage{iftex} % Check wether XeTeX is being used
\RequirePackage{xifthen} % Easy conditionals
\RequirePackage{options} % Manage class options
\RequirePackage{xparse} % Parse arguments for macros
\RequirePackage{xpatch} % Patch LaTeX code in external packages
\RequirePackage{xstring} % Parse strings
\RequirePackage{afterpage} % Run commands after specific pages
\AtEndPreamble{\RequirePackage{scrhack}} % Make some packages compatible with KOMAScript

%----------------------------------------------------------------------------------------
%	TITLE AND AUTHOR MACROS
%----------------------------------------------------------------------------------------

% Provide an optional argument to the \title command in which to store a plain text title, without any formatting
% Usage: \title[Plain Title]{Actual Title}
\newcommand{\@plaintitle}{}
\renewcommand{\title}[2][]{%
	\gdef\@title{#2} % Store the full title in @title
	\ifthenelse{\isempty{#1}}{ % If there is no plain title
		\renewcommand{\@plaintitle}{\@title} % Use full title
	}{ % If there is a plain title
		\renewcommand{\@plaintitle}{#1} % Use provided plain-text title
	}%
	\hypersetup{pdftitle={\@plaintitle}} % Set the PDF metadata title
}

% Provide an optional argument to the \author command in which to store a plain text author, without any formatting
% Usage: \author[Plain Author]{Actual Author}
\newcommand{\@plainauthor}{}
\renewcommand{\author}[2][]{%
	\gdef\@author{#2} % Store the full author in @author
	\ifthenelse{\isempty{#1}}{ % If there is no plain author
		\renewcommand{\@plainauthor}{\@author}% Use full author
	}{ % If there is a plain author
		\renewcommand{\@plainauthor}{#1}% Use provided plain-text author
	}%
	\hypersetup{pdfauthor={\@plainauthor}} % Set the PDF metadata author
}

% Make a bookmark to the title page
\pretocmd{\maketitle}{\pdfbookmark[1]{\@plaintitle}{title}}{}{}%

\DeclareRobustCommand*{\giturl}[1]{\gdef\my@giturl{#1}}
\newcommand\@giturl[1]{\href{http://#1}{\texttt{#1}}}

\ExplSyntaxOn
\cs_new_protected:Npn \__kao_spread_box:nnn #1#2#3
  {
    \mode_leave_vertical:
    \hbox_to_wd:nn { #1 }
      { #2 \tl_map_inline:xn { #3 } { ##1 \hfil } \unskip }
  }
\cs_generate_variant:Nn \__kao_spread_box:nnn { nnV }
\RenewDocumentCommand \maketitle { }
  {
	\group_begin:
	\center
    \__kao_spread_box:nnV { 13cm } { \sffamily\bfseries\zihao{-2} }
		\@title
	\skip_vertical:n { 4ex }
    \zihao{4}\@author
	\skip_vertical:n { 0.5ex }
    \@date
	\skip_vertical:n { -1ex }
	\color{njuviolet}\rule{10em}{1pt}
	\skip_vertical:n { 0ex }
  \exp_args:NV \@giturl \my@giturl
	\endcenter
  \@thanks
	\group_end:
	\par
  }
\ExplSyntaxOff

%----------------------------------------------------------------------------------------
%	PAGE LAYOUT
%----------------------------------------------------------------------------------------

% Define lengths to set the scale of the document. Changing these
% lengths should affect all the other pagesize-dependent elements in the
% layout, such as the geometry of the page, the spacing between
% paragraphs, and so on. (As of now, not all the elements rely on hscale
% and vscale; future work will address this shortcoming.)
\newlength{\hscale}
\newlength{\vscale}

% By default, the scales are set to work for a4paper
\setlength{\hscale}{1mm}
\setlength{\vscale}{1mm}

% Set the default page layout
\RequirePackage{geometry}

% Command to choose among the three possible layouts
\DeclareDocumentCommand{\pagelayout}{m}{%
	\ifthenelse{\equal{margin}{#1}}{\marginlayout\marginfloatsetup}{}%
	\ifthenelse{\equal{wide}{#1}}{\widelayout\widefloatsetup}{}%
	\ifthenelse{\equal{fullwidth}{#1}}{\fullwidthlayout\widefloatsetup}{}%
}

\newif\ifwidelayout%
\def\IfWideLayout{%
	\ifwidelayout%
		\expandafter\@firstoftwo%
	\else%
		\expandafter\@secondoftwo%
	\fi%
}

% Layout #1: large margins
\newcommand{\marginlayout}{%
	\newgeometry{
		top=27.4\vscale,
		bottom=27.4\vscale,
		inner=30\hscale,
		textwidth=107\hscale,
		marginparsep=6\hscale,
		marginparwidth=40\hscale,
	}%
	\recalchead%
	\widelayoutfalse%
}

% Layout #2: small, symmetric margins
\newcommand{\widelayout}{%
	\newgeometry{
		top=27.4\vscale,
		bottom=27.4\vscale,
		inner=30\hscale,
		outer=30\hscale,
		marginparsep=0mm,
		marginparwidth=0mm,
	}%
	\recalchead%
	\widelayouttrue%
}

% Layout #3: no margins and no space above or below the body
\newcommand{\fullwidthpage}{%
	\newgeometry{
		top=0mm,
		bottom=0mm,
		inner=0mm,
		outer=0mm,
		marginparwidth=0mm,
		marginparsep=0mm,
	}%
	\recalchead%
	\widelayouttrue%
}

% Set the default page layout
\AtBeginDocument{\pagelayout{wide}}

%----------------------------------------------------------------------------------------
%	HEADERS AND FOOTERS
%----------------------------------------------------------------------------------------

\RequirePackage{scrlayer-scrpage}		% Customise head and foot regions

% Set the header height to prevent a warning
%\setlength{\headheight}{27.4\vscale}
% Increase the space between header and text
\setlength{\headsep}{11\vscale}

% Define some LaTeX lengths used in the page headers
\newlength{\headtextwidth} % This is the width of the text
\newlength{\headmarginparsep} % This is the width of the whitespace between text and margin
\newlength{\headmarginparwidth} % This is the width of the margin
\newlength{\headtotal} % This is the total width of the header
\newlength{\contentwidth} % An alias for \headtotal
\newcommand{\recalchead}{% Command to recalculate the header-related length when needed
	\setlength{\headtextwidth}{\textwidth}%
	\setlength{\headmarginparsep}{\marginparsep}%
	\setlength{\headmarginparwidth}{\marginparwidth}%
	\setlength{\headtotal}{\headtextwidth+\headmarginparsep+\headmarginparwidth}%
	\setlength{\contentwidth}{\headtotal}%
}

\AtBeginDocument{% Recalculate the header-related lengths
	\recalchead%
}

% Header style with an empty header and the page number in the footer
\newpagestyle{pagenum.scrheadings}{%
	{}%
	{}%
	{}%
}{%
	{\makebox[\textwidth][r]{\thepage}}%
	{\makebox[\textwidth][l]{\thepage}}%
	{\makebox[\textwidth][l]{\thepage}}%
}

% Set the default page style
\pagestyle{pagenum.scrheadings}

%----------------------------------------------------------------------------------------
%	PARAGRAPH FORMATTING
%----------------------------------------------------------------------------------------

\ctexset{
  section/format = \bfseries\sffamily\zihao{4},
  subsection/format = \bfseries\sffamily\zihao{-4}
}

\RequirePackage{ragged2e} % Required to achieve better ragged paragraphs
\RequirePackage{setspace} % Required to easily set the space between lines
\RequirePackage{hyphenat} % Hyphenation for special fonts
\RequirePackage{needspace} % Required to prevent page break right after a sectioning command
% \RequirePackage{xspace} % Better print trailing whitespace

% TODO: recognize space/indent justified/raggedright class options

% Settings for a normal paragraph
\newcommand{\@body@par}{%
	% \justifying% Justify text
	% \singlespacing% Set the interline space to a single line
	% \frenchspacing% No additional space after periods
	\normalfont% Use the default font
	\normalsize% Use the default size
}

% Settings for paragraphs in the margins
\newcommand{\@margin@par}{%
	\justifying% justify text
	\setlength{\RaggedRightParindent}{0em}% Suppress indentation
	\setlength{\parindent}{0em}% Suppress indentation
	\setlength{\parskip}{0.5pc}% Set the space between paragraphs
	%\singlespacing% Set the space between lines
	\frenchspacing% No additional space after periods
	\normalfont% Use the default font
	\footnotesize% Use a smaller size
}

% By default, use @body@par settings
\@body@par

%----------------------------------------------------------------------------------------
%	WIDE PARAGRAPHS
%----------------------------------------------------------------------------------------
\newcommand*{\@addmargin}[2][\@tempa]{%
  \list{}{%
    \if@tempswa
      \def\@tempa{\leftmargin}%
      \setlength{\leftmargin}{#2}%
      \setlength{\rightmargin}{#1}%
    \else
      \def\@tempa{\rightmargin}%
      \setlength{\rightmargin}{#2}%
      \setlength{\leftmargin}{#1}%
    \fi
    \setlength{\listparindent}{\parindent}%
    \setlength{\itemsep}{\parskip}%
    \setlength{\itemindent}{\z@}%
    \setlength{\@tempskipa}{\topsep}%
    \setlength{\topsep}{\z@}%
    \setlength{\parsep}{\parskip}%
    \setlength{\@tempskipb}{\partopsep}%
    \setlength{\partopsep}{\z@}%
    \let\makelabel\@gobble
    \setlength{\labelwidth}{\z@}%
    \advance\@listdepth\m@ne
  }%
  \item\nobreak\ignorespaces
}
\newenvironment{addmargin}{%
  \@tempswafalse\@addmargin
}{%
  \advance\@listdepth\@ne
  \endlist
}

% Environment for a wide paragraph
% \hskip 2em 实际比两个字符多一点点空白，一般看不出来，有空再修复
\NewDocumentEnvironment{widepar}{}{
	\begin{addmargin}[0cm]{-\marginparwidth-\marginparsep}%
    \hskip 2em%
}{%
	\end{addmargin}%
}

% Environment for a full width paragraph
\NewDocumentEnvironment{fullwidthpar}{}{%
	\if@twoside%
	\Ifthispageodd{%
		\begin{addmargin}[-1in-\hoffset-\oddsidemargin]{-\paperwidth+1in+\hoffset+\oddsidemargin+\textwidth}%
	}{%
		\begin{addmargin}[-\paperwidth+1in+\hoffset+\oddsidemargin+\textwidth]{-\paperwidth+1in+\hoffset+\oddsidemargin+\marginparsep+\marginparwidth+\textwidth}%
	}%
	\else%
	\begin{addmargin}[-1in-\hoffset-\oddsidemargin]{-\paperwidth+1in+\hoffset+\oddsidemargin+\textwidth}%
	\fi%
}{%
	\end{addmargin}%
}

% Environment for a wide equation
\NewDocumentEnvironment{wideequation}{}{%
	\begin{widepar}%
	\begin{equation}%
}{%
	\end{equation}%
	\end{widepar}%
}

%----------------------------------------------------------------------------------------
%	FOOTNOTES, MARGINNOTES AND SIDENOTES
%----------------------------------------------------------------------------------------

\RequirePackage[section]{placeins} % Prevent floats to cross sections
\extrafloats{100} % Require more floats

\RequirePackage{marginnote} % Provides options for margin notes
%\RequirePackage{marginfix} % Make marginpars float freely; it should not be loaded as it prevents the marginnotes to stay aligned with the main text
\RequirePackage{sidenotes} % Use sidenotes
\RequirePackage{chngcntr} % Reset counters at sections

% TODO: see also page 440 of the KOMA-script guide
\RequirePackage[
	bottom,
	symbol*,
	hang,
	flushmargin,
	% perpage,
	stable,
]{footmisc} % Required to set up the footnotes
\RequirePackage{footnotebackref} % Creates back references from footnotes to text

% Fix the color of the footnote marker when back-referenced
\patchcmd{\footref}{\ref}{\hypersetup{colorlinks=black}\ref}{}{}%
% Workaround to fix back references
\edef\BackrefFootnoteTag{bhfn:\theBackrefHyperFootnoteCounter}%

% FIXME: I am not able to choose the paragraph layout of footnotes, probably the footnotes package conflicts with scrbook.
%\renewcommand{\footnotelayout}{\@margin@par}

%----------------------------------------------------------------------------------------

% Justify and format margin notes
\renewcommand*{\raggedleftmarginnote}{} % Suppress left margin
\renewcommand*{\raggedrightmarginnote}{} % Suppress right margin
\renewcommand*{\marginfont}{\@margin@par} % Format marginnotes according to \@marginpar (see above)
\renewcommand{\marginnotevadjust}{0.8\vscale} % Bring all marginnotes downwards a bit
%\marginposadjustment=1\vscale % Bring downwards also the marginpars
%\marginheightadjustment=10cm % Adjust the height of the margins for each page
%\RequirePackage[marginnote=true]{snotez} % Provides options for sidenotes

% Copied from snotez's \sidenote
\def\kao@if@nblskip#1{%
	\expandafter\ifx\@car#1\@nil*%
		\expandafter\@firstoftwo%
	\else%
		\expandafter\@secondoftwo%
	\fi%
}

% Command to detect whether we are inside an mdframed environment
\newif\ifinfloat % First, set this flag whenever we are in an mdframed environment...
\AtBeginEnvironment{mdframed}{\infloattrue}
\AtBeginEnvironment{minipage}{\infloattrue}

\def\IfInFloatingEnvir{% ...Then, detect the flag
	\ifinfloat%
		\expandafter\@firstoftwo%
	\else%
		\expandafter\@secondoftwo%
	\fi%
}


% Redefine the command to print marginnotes:
% (a) the optional offset argument goes at the first position
% (b) the offset can also be a multiple of baselineskip, like for snotez's \sidenote
% Usage: \marginnote[<offset>]{Text of the note.}
\let\oldmarginnote\marginnote%
\RenewDocumentCommand\marginnote{ o m }{%
	\IfNoValueOrEmptyTF{#1}{%
		\IfInFloatingEnvir{%
			\oldmarginnote{#2}%
		}{%
			\marginpar{\@margin@par#2}%
		}%
	}{%
		\oldmarginnote{#2}[\kao@if@nblskip{#1}{\@cdr#1\@nil\baselineskip}{#1}]%
	}%
}

% Initially set the sidenote counter to zero instead of 1, and update it before printing the sidenote.
\setcounter{sidenote}{0}%
\RenewDocumentCommand\sidenote{ o o +m }{%
	\IfNoValueOrEmptyTF{#1}{%
		\refstepcounter{sidenote}% This command has been moved here
	}{%
	}%
	\sidenotemark[#1]%
	\sidenotetext[#1][#2]{#3}%
	\@sidenotes@multimarker%
}

% Formatting sidenote markers
\RenewDocumentCommand\@sidenotes@thesidenotemark{ m }{% Format the marker
	\leavevmode%
	\ifhmode%
		\edef\@x@sf{\the\spacefactor}%
		\nobreak%
	\fi%
	\hbox{\@textsuperscript{\normalfont#1}}%
	\ifhmode%
		\spacefactor\@x@sf%
	\fi%
	\relax%
}%

% Formatting the sidenote text
\RenewDocumentCommand\sidenotetext{ o o +m }{% number, offset, text
	\IfNoValueOrEmptyTF{#1}{%
		\marginnote[#2]{\thesidenote:\enskip#3}%
	}{%
		\marginnote[#2]{#1:\enskip#3}%
	}%
}

%----------------------------------------------------------------------------------------
%	FIGURES, TABLES, LISTINGS AND CAPTIONS
%----------------------------------------------------------------------------------------

\RequirePackage{graphicx} % Include figures
\setkeys{Gin}{width=\linewidth,totalheight=\textheight,keepaspectratio} % Improves figure scaling
\RequirePackage{tikz} % Allows to draw custom shapes
\RequirePackage{tikzpagenodes} % Allows to anchor tikz nodes to page elements
\RequirePackage{booktabs} % Nicer tables
\RequirePackage{multirow} % Cells occupying multiple rows in tables
\RequirePackage{multicol} % Multiple columns in dictionary
\RequirePackage{rotating} % Allows tables and figures to be rotated
\RequirePackage{listings} % Print code listings
%\RequirePackage{minted}
\RequirePackage[hypcap=true]{caption} % Correctly placed anchors for hyperlinks
% \RequirePackage{atbegshi}
% \RequirePackage{perpage}
\let\c@abspage\relax
% \newcommand{\pp@g@sidenote}{}
\RequirePackage{floatrow} % Set up captions of floats
%\RequirePackage{dblfloatfix} % Better positioning of wide figures and tables

% Improve the figure placing (see https://www.overleaf.com/learn/latex/Tips)
\def\topfraction{.9}%
\def\textfraction{0.35}%
\def\floatpagefraction{0.8}%

% Set the space between floats and main text
\renewcommand\FBaskip{.4\topskip}%
\renewcommand\FBbskip{\FBaskip}%

% Tighten up space between displays (e.g., equations) and make symmetric (from tufte-latex)
\setlength\abovedisplayskip{6pt plus 2pt minus 4pt}%
\setlength\belowdisplayskip{6pt plus 2pt minus 4pt}%
\abovedisplayskip 10\p@ \@plus2\p@ \@minus5\p@%
\abovedisplayshortskip \z@ \@plus3\p@%
\belowdisplayskip \abovedisplayskip%
\belowdisplayshortskip 6\p@ \@plus3\p@ \@minus3\p@%

\setlength\columnseprule{.4pt} % Set the width of vertical rules in tables

% The marginfix package prevents the margin notes to stay aligned with the main text, so it cannot be used. However, we define the \marginskip command, which is the only command we need from that package.
\newcommand\marginskip[1]{%
	\marginpar{\@margin@par\vspace{#1 - \baselineskip}}% We subtract the \baselineskip that we have in margin pars.
}

\newlength{\kaomarginskipabove} % Specify the space above a marginfigure, margintable or marginlisting
\newlength{\kaomarginskipbelow} % Specify the space below a marginfigure, margintable or marginlisting
\setlength{\kaomarginskipabove}{3mm plus 2pt minus 2pt}
\setlength{\kaomarginskipbelow}{3mm plus 2pt minus 2pt}

% Environment to hold a margin figure (from the sidenotes package)
% We redefine it here because we want to use our own caption formatting.
\RenewDocumentEnvironment{marginfigure}{o}{%
	\FloatBarrier%
	\marginskip{\kaomarginskipabove}%
	\begin{lrbox}{\@sidenotes@marginfigurebox}%
	\begin{minipage}{\marginparwidth}%
		\captionsetup{type=figure}%
}{%
	\end{minipage}%
	\end{lrbox}%
	\marginnote[#1]{\usebox{\@sidenotes@marginfigurebox}}%
	\marginskip{\kaomarginskipbelow}%
}

% Environment to hold a margin table (from the sidenotes package)
\RenewDocumentEnvironment{margintable}{o}{%
	\FloatBarrier%
	\marginskip{\kaomarginskipabove}%
	\begin{lrbox}{\@sidenotes@margintablebox}%
	\begin{minipage}{\marginparwidth}%
		\captionsetup{type=table}%
}{%
	\end{minipage}%
	\end{lrbox}%
	\marginnote[#1]{\usebox{\@sidenotes@margintablebox}}%
	\marginskip{\kaomarginskipbelow}%
}

% Environment to hold a margin listing
\newsavebox{\@sidenotes@marginlistingbox}%
\NewDocumentEnvironment{marginlisting}{o}{% The optional parameter is the vertical offset
	\FloatBarrier%
	\marginskip{\kaomarginskipabove}%
	\begin{lrbox}{\@sidenotes@marginlistingbox}%
	\begin{minipage}{\marginparwidth}%
		\captionsetup{type=lstlisting}%
}{%
	\end{minipage}%
	\end{lrbox}%
	\marginnote[#1]{\usebox{\@sidenotes@marginlistingbox}}%
	\marginskip{\kaomarginskipbelow}%
}

% Change the position of the captions
\DeclareFloatSeparators{marginparsep}{\hskip\marginparsep}%

% Detect whether there is a caption in the current environment by switching the kaocaption toggle when \caption is called. If there is no caption, reset the floatsetup. Without this fix, the floatrow package will align the environment to the main text if there is a caption, but to the margin if there is no caption.
\newtoggle{kaocaption}
\AtBeginEnvironment{figure}{%
	\let\oldcaption\caption%
	\RenewDocumentCommand{\caption}{s o m}{%
		\IfBooleanTF{#1}{%
			\oldcaption*{#3}%
		}{%
			\IfValueTF{#2}{%
				\oldcaption[#2]{#3}%
			}{%
				\oldcaption{#3}%
			}%
		}%
		\toggletrue{kaocaption}%
	}%
}
\AtEndEnvironment{figure}{%
	\iftoggle{kaocaption}{%
	}{%
		\RawFloats%
		\centering%
	}%
	\togglefalse{kaocaption}%
}
\AtBeginEnvironment{table}{%
	\let\oldcaption\caption%
	\RenewDocumentCommand{\caption}{s o m}{%
		\IfBooleanTF{#1}{%
			\oldcaption*{#3}%
		}{%
			\IfValueTF{#2}{%
				\oldcaption[#2]{#3}%
			}{%
				\oldcaption{#3}%
			}%
		}%
		\toggletrue{kaocaption}%
	}%
}
\AtEndEnvironment{table}{%
	\iftoggle{kaocaption}{%
	}{%
		\RawFloats%
		\centering%
	}%
	\togglefalse{kaocaption}%
}

% Change the formatting of the captions
% \addtokomafont{captionlabel}{\bfseries} % Bold font for the figure label
% Declare a new style to format the caption according to \@margin@par (see above)
\DeclareCaptionFormat{margin}{\@margin@par #1#2#3}
% Declare a new caption style for lstlistings
\newsavebox\mycap
\DeclareCaptionFormat{llap}{%
	\begin{lrbox}{\mycap}%
	\begin{minipage}{\marginparwidth}%
	\@margin@par #1:#2#3%
	\end{minipage}%
	\end{lrbox}%
	\marginnote[0.2cm]{\usebox\mycap}%
}
% Set the global caption style
\captionsetup{
	format=margin, % Use the style previously declared
	strut=no,%
	%hypcap=true, % Links point to the top of the figure
	singlelinecheck=false,%
	%width=\marginparwidth,
	indention=0pt, % Suppress indentation
	parindent=0pt, % Suppress space between paragraphs
	aboveskip=6pt, % Increase the space between the figure and the caption
	belowskip=6pt, % Increase the space between the caption and the table
}

% Needed to have continued figures and tables (https://en.wikibooks.org/wiki/LaTeX/Floats,_Figures_and_Captions#Figures_in_multiple_parts)
\DeclareCaptionLabelFormat{cont}{#1~#2\alph{ContinuedFloat}}
\captionsetup[ContinuedFloat]{labelformat=cont}

% Captions for the 'margin' layout
\NewDocumentCommand{\marginfloatsetup}{}{%
\if@twoside%
	\floatsetup[figure]{% Captions for figures
		margins=hangoutside,% Put captions in the margins
		facing=yes,%
		capposition=beside,%
		capbesideposition={bottom,outside},%
		capbesideframe=yes,%
		capbesidewidth=\marginparwidth,% Width of the caption equal to the width of the margin
		capbesidesep=marginparsep,%
		floatwidth=\textwidth,% Width of the figure equal to the width of the text
	}%
	\floatsetup[widefigure]{% Captions for wide figures
		margins=hangoutside,% Put captions below the figure
		facing=yes,%
		capposition=bottom%
	}%
	\floatsetup[table]{% Captions for tables
		margins=hangoutside,% Put captions in the margin
		facing=yes,%
		capposition=beside,%
		capbesideposition={top,outside},%
		%capbesideposition=outside,
		capbesideframe=yes,%
		capbesidewidth=\marginparwidth,% Width of the caption equal to the width of the margin
		capbesidesep=marginparsep,%
		floatwidth=\textwidth,% Width of the figure equal to the width of the text
	}%
	\floatsetup[widetable]{% Captions for wide tables
		margins=hangoutside,% Put captions above the table
		facing=yes,%
		capposition=above%
	}%
	\floatsetup[longtable]{% Captions for longtables
		margins=raggedright,% Overwrite the hangright setting from the `table' environment
		%LTcapwidth=table,% Set the width of the caption equal to the table's
	}%
	\floatsetup[lstlisting]{% Captions for lstlistings
		margins=hangoutside,% Put captions in the margin
		facing=yes,%
		capposition=beside,%
		capbesideposition={top,outside},%
		%capbesideposition=outside,
		capbesideframe=yes,%
		capbesidewidth=\marginparwidth,% Width of the caption equal to the width of the margin
		capbesidesep=marginparsep,%
		floatwidth=\textwidth,% Width of the figure equal to the width of the text
	}%
	\floatsetup[listing]{% Captions for listings (minted package)
		margins=hangoutside,% Put captions in the margin
		facing=yes,%
		capposition=beside,%
		capbesideposition={top,outside},%
		%capbesideposition=outside,
		capbesideframe=yes,%
		capbesidewidth=\marginparwidth,% Width of the caption equal to the width of the margin
		capbesidesep=marginparsep,%
		floatwidth=\textwidth,%Width of the figure equal to the width of the text
	}%
	\captionsetup*[lstlisting]{%
		format=llap,%
		labelsep=space,%
		singlelinecheck=no,%
		belowskip=-0.6cm,%
	}%
\else%
	\floatsetup[figure]{% Captions for figures
		margins=hangright,% Put captions in the margins
		facing=yes,%
		capposition=beside,%
		capbesideposition={bottom,right},%
		capbesideframe=yes,%
		capbesidewidth=\marginparwidth,% Width of the caption equal to the width of the margin
		capbesidesep=marginparsep,%
		floatwidth=\textwidth,% Width of the figure equal to the width of the text
	}%
	\floatsetup[widefigure]{% Captions for wide figures
		margins=hangright,% Put captions below the figure
		facing=no,%
		capposition=bottom%
	}%
	\floatsetup[table]{% Captions for tables
		margins=hangright,% Put captions in the margin
		facing=yes,%
		capposition=beside,%
		capbesideposition={top,right},%
		%capbesideposition=outside,
		capbesideframe=yes,%
		capbesidewidth=\marginparwidth,% Width of the caption equal to the width of the margin
		capbesidesep=marginparsep,%
		floatwidth=\textwidth,% Width of the figure equal to the width of the text
	}%
	\floatsetup[widetable]{% Captions for wide tables
		margins=hangright,% Put captions above the table
		facing=no,%
		capposition=above%
	}%
	\floatsetup[longtable]{% Captions for longtables
		margins=raggedright,% Overwrite the hangright setting from the `table' environment
		%LTcapwidth=table,% Set the width of the caption equal to the table's
	}%
	\floatsetup[lstlisting]{% Captions for lstlisting
		margins=hangright,% Put captions in the margin
		facing=yes,%
		capposition=beside,%
		capbesideposition={top,right},%
		%capbesideposition=outside,
		capbesideframe=yes,%
		capbesidewidth=\marginparwidth,% Width of the caption equal to the width of the margin
		capbesidesep=marginparsep,%
		floatwidth=\textwidth,% Width of the figure equal to the width of the text
	}%
	\floatsetup[listing]{% Captions for listing (minted package)
		margins=hangright,% Put captions in the margin
		facing=yes,%
		capposition=beside,%
		capbesideposition={top,right},%
		%capbesideposition=outside,
		capbesideframe=yes,%
		capbesidewidth=\marginparwidth,% Width of the caption equal to the width of the margin
		capbesidesep=marginparsep,%
		floatwidth=\textwidth,% Width of the figure equal to the width of the text
	}%
	\captionsetup*[lstlisting]{%
		format=llap,%
		labelsep=space,%
		singlelinecheck=no,%
		belowskip=-0.6cm,%
	}%
\fi%
}

% Captions for the 'wide' layout
\NewDocumentCommand{\widefloatsetup}{}{%
	\floatsetup[figure]{ % Captions for figures
		capposition=bottom,%
		margins=centering,%
		floatwidth=\textwidth%
	}
	\floatsetup[widefigure]{ % Captions for wide figures
		margins=hangoutside, % Put captions below the figure
		facing=yes,%
		capposition=bottom%
	}
	\floatsetup[table]{ % Captions for tables
		capposition=above,%
		margins=centering,%
		floatwidth=\textwidth%
	}
	\floatsetup[widetable]{ % Captions for wide tables
		margins=hangoutside, % Put captions above the table
		facing=yes,%
		capposition=above%
	}
	\floatsetup[lstlisting]{ % Captions for lstlistings
		capposition=above,%
		margins=centering,%
		floatwidth=\textwidth%
	}
	\floatsetup[listing]{ % Captions for listings (minted package)
		capposition=above,%
		margins=centering,%
		floatwidth=\textwidth%
	}
	\captionsetup*[lstlisting]{% Captions style for lstlistings
		%format=margin,%
		labelsep=colon,%
		strut=no,%
		singlelinecheck=false,%
		indention=0pt,%
		parindent=0pt,%
		aboveskip=6pt,%
		belowskip=6pt,%
		belowskip=-0.1cm%
	}
}

%----------------------------------------------------------------------------------------
%	ENCODING AND FONTS
%----------------------------------------------------------------------------------------

% https://tex.stackexchange.com/questions/47576/combining-ifxetex-and-ifluatex-with-the-logical-or-operation
% Introduce a command to find out whether the compiler is XeTeX or LuaTeX
\newif\ifxetexorluatex
\ifxetex
	\xetexorluatextrue
\else
	\ifluatex
		\xetexorluatextrue
	\else
		\xetexorluatexfalse
	\fi
\fi

\RequirePackage{amssymb} % Must be loaded before unicode-math
\RequirePackage[force]{filehook} % Fixes an error
\RequirePackage{unicode-math} % Math fonts in xetexorluatex
\setromanfont[ % Libertinus Serif font
	Scale=1.04
]{Libertinus Serif}
\setsansfont[ % Libertinus Sans font
	Scale=1
]{Libertinus Sans}
\setmonofont{cmun}[
	Extension      = .otf,
	UprightFont    = *btl,
	BoldFont       = *tb,
	ItalicFont     = *bto,
	BoldItalicFont = *tx,
	HyphenChar     = None]
\setmathfont{Libertinus Math} % Libertinus Math font
\ifluatex
\else
	\RequirePackage{morewrites} % Fix some errors related to floats (not necessary with LuaLaTeX
\fi

\setCJKmainfont{Source Han Serif SC}[
  UprightFont     = * SemiBold,
  BoldFont        = * Heavy,
  ItalicFont      = * SemiBold,
  BoldItalicFont  = * SemiBold,
  RawFeature      = +fwid]
\setCJKsansfont{Sarasa Gothic SC}
\setCJKmonofont{Sarasa Mono SC}

%----------------------------------------------------------------------------------------
%	HYPERREFERENCES
%----------------------------------------------------------------------------------------

\RequirePackage{hyperref} % Required for hyperlinks
\RequirePackage{bookmark} % Required for pdf bookmarks

\PassOptionsToPackage{hyphens}{url} % Break long URLs and use hyphens to separate the pieces

\hypersetup{ % Set up hyperref options
	unicode, % Use unicode for links
	pdfborder={0 0 0}, % Suppress border around pdf
	%xetex,
	%pagebackref=true,
	%hyperfootnotes=false, % We already use footmisc
	bookmarksdepth=subsubsection,
	bookmarksopen=true, % Expand the bookmarks as soon as the pdf file is opened
	%bookmarksopenlevel=4,
	linktoc=all, % Toc entries and numbers links to pages
	breaklinks=true,
	colorlinks=true
}

% Define a new color for the footnote marks
\def\@footnotecolor{black}
\define@key{Hyp}{footnotecolor}{%
	\HyColor@HyperrefColor{#1}\@footnotecolor%
}
\def\@footnotemark{%
	\leavevmode
	\ifhmode\edef\@x@sf{\the\spacefactor}\nobreak\fi
	\stepcounter{Hfootnote}%
	\global\let\Hy@saved@currentHref\@currentHref
	\hyper@makecurrent{Hfootnote}%
	\global\let\Hy@footnote@currentHref\@currentHref
	\global\let\@currentHref\Hy@saved@currentHref
	\hyper@linkstart{footnote}{\Hy@footnote@currentHref}%
	\@makefnmark
	\hyper@linkend
	\ifhmode\spacefactor\@x@sf\fi
	\relax
}

% Redefine the \thanks command to allow users to use \label within \thanks without getting warnings
\let\oldthanks\thanks
\renewcommand\thanks[1]{%
	\label{bhfn:0}%
	\oldthanks{#1}%
}

% Adjust the colour of the footnotes marks using the colour defined above
\renewcommand\@makefntext[1]{%
	\renewcommand\@makefnmark{%
		\mbox{\textsuperscript{\normalfont%
			\hyperref[\BackrefFootnoteTag]{%
				\color{\@footnotecolor}{\@thefnmark}%
			}}\,%
		}%
	}%
	\BHFN@OldMakefntext{#1}%
}

%----------------------------------------------------------------------------------------
%	COLOURS
%----------------------------------------------------------------------------------------

% Choose the default colors
\hypersetup{
	%anchorcolor=Red,
	%citecolor=DarkOrange!70!black,
	citecolor=OliveGreen,
	filecolor=OliveGreen,
	%linkcolor=Blue,
	linkcolor=Black,
	%menucolor=Red,
	%runcolor=Red,
	urlcolor=njumagenta,
}

%----------------------------------------------------------------------------------------
%	ITEMS
%----------------------------------------------------------------------------------------

\renewcommand{\labelitemi}{\small$\blacktriangleright$} % Use a black triangle for the first level of \item's
\renewcommand{\labelitemii}{\textbullet} % Use a bullet for the second level of \item's
\RequirePackage[inline]{enumitem} % Used to customise lists (in particular, we don't want to put whitespace between items)
\setlist[itemize]{noitemsep}
\setlist[enumerate]{noitemsep}
\setlist[description]{noitemsep}

%----------------------------------------------------------------------------------------
%	SIMPLE BOXED ENVIRONMENT
%----------------------------------------------------------------------------------------

% kaobox (while tcolorbox may be more rich, I find it too complicated so I prefer mdframed)
\RequirePackage{tikz}
\RequirePackage[framemethod=TikZ]{mdframed}

% Define a new style for mdframed boxes
%\mdfsetup{skipabove=\topskip,skipbelow=0pt}
\mdfdefinestyle{kaoboxstyle}{
	skipabove=1.5\topskip,
	skipbelow=.5\topskip,
	rightmargin=0pt,
	leftmargin=0pt,
	%innertopmargin=3pt,
	%innerbottommargin=3pt,
	innerrightmargin=7pt,
	innerleftmargin=7pt,
	topline=false,
	bottomline=false,
	rightline=false,
	leftline=false,
	%linewidth=1pt,
	%roundcorner=0pt,
	%font={},
	%frametitlefont={},
	frametitlerule=true,
	linecolor=black,
	%backgroundcolor=LightBlue,
	fontcolor=black,
	%frametitlebackgroundcolor=LightBlue,
}

% Define a new environment using the style created above
\newmdenv[
	style=kaoboxstyle,
	backgroundcolor=RoyalBlue!25!White,
	frametitlebackgroundcolor=RoyalBlue!25!White,
]{kaobox}

%----------------------------------------------------------------------------------------
%	ENVIRONMENT WITH A COUNTER
%----------------------------------------------------------------------------------------

% Define an environment titled 'Comment' and numbered incrementally
\newenvironment{kaocounter}{
	\refstepcounter{kaocounter}
	\begin{kaobox}[frametitle=Comment~\thekaocounter\autodot]
}{
	\end{kaobox}
}

% Define the commands to manage the counter for the 'kaocounter' environment
\newcounter{kaocounter}
\counterwithin{kaocounter}{section}
\newcommand*{\kaocounterformat}{% Format for the caption
	Comment~\thekaocounter\csname autodot\endcsname}
\newcommand*{\fnum@kaocounter}{\kaocounterformat}


%----------------------------------------------------------------------------------------
%	FLOATING ENVIRONMENT WITH TOC ENTRIES
%----------------------------------------------------------------------------------------

% Define a floating environment
\newenvironment{kaofloating}{%
	\@float{kaofloating}%
}{%
	\end@float%
}

% Configure the 'kaofloating' environment
\newcommand*{\fps@floatingbox}{tbph}% Allowed positions for the environment (top, bottom, own page, here)
\newcommand*{\ftype@floatingbox}{5}% Set the type of float (floats of the same type cannot change their order; figures and tables are type 1 and 2 respectively)
\newcommand*{\floatingboxformat}{% Set a title of the environment
	Insight~\thefloatingbox\csname autodot\endcsname}
\newcommand*{\fnum@floatingbox}{\floatingboxformat}% Use the environment title
\newcommand*{\ext@floatingbox}{loi}% Choose the extension of the auxiliary file for this environment

%----------------------------------------------------------------------------------------
%	ADDITIONAL PACKAGES
%----------------------------------------------------------------------------------------

% Listings code
\RequirePackage{listings}

\lstdefinestyle{style@base}
  {
    basewidth       = 0.5 em,
    gobble          = 1,
    lineskip        = 3 pt,
    frame           = l,
    framerule       = 1 pt,
    framesep        = 0 pt,
    xleftmargin     = 2 em,
    xrightmargin    = 3 em,
    escapeinside    = {(*}{*)},
    breaklines      = true,
    basicstyle      = \small\ttfamily,
    keywordstyle    = \bfseries\color{njuviolet},
    commentstyle    = \itshape\color{white!50!gray},
    stringstyle     = \color{nju-chem-red},
    backgroundcolor = \color{white!95!gray}
  }
\lstdefinestyle{style@shell}
  {
    style      = style@base,
    rulecolor  = \color{njumagenta},
    % language   = bash,
    alsoletter = {-},
    emphstyle  = \color{nju-cs-green}
  }
\lstdefinestyle{style@latex}
  {
    style      = style@base,
    rulecolor  = \color{njublue},
    language   = [LaTeX]TeX,
    alsoletter = {*, -},
    texcsstyle = *\color{njuviolet},
    emphstyle  = [1]\color{nju-ai-orange},
    emphstyle  = [2]\color{nju-cs-green}
  }
\lstdefinestyle{style@text}
  {
    style      = style@base,
    rulecolor  = \color{njuyellow},
    alsoletter = {-},
    emphstyle  = \color{nju-cs-green}
  }
\lstnewenvironment{shellexample}[1][]{%
  \lstset{style=style@shell, #1}}{}
\lstnewenvironment{latexexample}[1][]{%
  \lstset{style=style@latex, #1}}{}
\lstnewenvironment{textexample}[1][]{%
  \lstset{style=style@text, #1}}{}
\lstset{style=style@base}

%----------------------------------------------------------------------------------------
%	TOC
%----------------------------------------------------------------------------------------

\ctexset{tocdepth=3}

%----------------------------------------------------------------------------------------
%	NUMBERING
%----------------------------------------------------------------------------------------

%\setcounter{secnumdepth}{\kao@secnumdepth} % Set section numbering depth

% \counterwithin*{sidenote}{section} % Uncomment to reset the sidenote counter at each section
%\counterwithout{sidenote}{section} % Uncomment to have one sidenote counter for the whole document
