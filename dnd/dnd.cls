\LoadClassWithOptions{book}

\newif\ifcatalan
\newif\ifspanish
\newif\ifenglish
\englishtrue
\DeclareOption{catalan}{\catalantrue \englishfalse}
\DeclareOption{spanish}{\spanishtrue \englishfalse}
\DeclareOption{english}{}
\ProcessOptions\relax

\NeedsTeXFormat{LaTeX2e} %Latex Version
\ProvidesClass{dnd}[2013/10/21 Latex class for Dungeons and Dragons adventures] %Class provided

\RequirePackage{fp}
\RequirePackage{colortbl}
\RequirePackage{booktabs}
\RequirePackage[compact]{titlesec}
\RequirePackage{xifthen}
\RequirePackage{xstring}
\RequirePackage{xkeyval}
\RequirePackage{enumitem}
\RequirePackage[margin=0.75in]{geometry}
\RequirePackage{pifont}
\RequirePackage[utf8]{inputenc}


% Renew the array and indent sizes
\renewcommand{\arraystretch}{0.8}
\setlength\parindent{0pt}

%renew booktabs rules separator
\setlength{\aboverulesep}{0.5pt}
\setlength{\belowrulesep}{0.5pt}
\setlist[itemize]{itemsep=0mm}

%Allow page ragged bottoms.
% do not stretch text to fill the whole page
\raggedbottom

%page handling
\newcommand{\newevenside}{
        \ifthenelse{\isodd{\thepage}}{\clearpage}{
        \clearpage
        \phantom{placeholder}% doesn't appear on page
        \thispagestyle{empty} % if want no header/footer
        \clearpage
        }
}

%Language Handling
%Just for the 3 supported languages. English, Catalan and Spanish
\newcommand{\transl}[3]{
    \ifenglish
    #1
    \fi
    \ifcatalan
    #2
    \fi
    \ifspanish
    #3
    \fi
}

%Sections and subsections format

\titleformat{\section}[block]      % Customise the \section command
    {\Large\scshape} % Make the \section headers large (\Large), % small capitals (\scshape) and left aligned (\raggedright)
    {}{0pt} % Can be used to give a prefix to all sections, like 'Section ...'
    {} % Can be used to insert code before the heading
[\titlerule] % Inserts a horizontal line after the headin

\titleformat{\subsection}        % Customise the \section command
    {\normalsize\scshape} % Make the \section headers large (\Large), % small capitals (\scshape) and left aligned (\raggedright)
    {}{0pt} % Can be used to give a prefix to all sections, like 'Section ...'
    {\rule{1ex}{1ex}} % Can be used to insert code before the heading
    [\titlerule] % Inserts a horizontal line after the headin

%\titleformat{command}[shape]{format}{label}{sep}{before}[after]


%\newcommand{\ddenc}[1]{
%    \rule{2ex}{1ex}\hspace{\stretch{1}} {#1} \hspace{\stretch{1}}\rule{2ex}{1ex} \\
%}
%\newcommand{\ddsec}[1]{
%    \rule{1ex}{1ex}\hspace{\stretch{1}} {#1} \hspace{\stretch{1}}\rule{1ex}{1ex} \\
%}

% 1 400 500 600
% 2 500 625 750
% 3 600 750.800
% 4 700 875 900
% 5 800 1000 1200
% 6 1000 1250 1500
% 7 1200 1500 1800
% 8 1400 1750 1800
% 9 1600 2000 2400
% 10 2000 2500 3000

% Encounter level
% Two versions. One calculates and prints the expected XP according to level
% and number of Players.
% The other will just print the Level and XP passed as parameters

\newcommand{\enclvlNC}[2]{
    Nivell encontre #1, (#2 XP)
    \newline
}

\newcommand{\enclvl}[3]{
    \FPeval{\level}{#1}
    \FPeval{\npc}{#2}
    \FPeval{\xp}{0} %Init XP to 0, just in case

    % ERROR REPORT WHEN LEVEL IS NOT ACCEPTED
    \ifthenelse{ \level > 9 }{
        \ClassError{dnd}{Only Heroic levels are supported [1-9]}{enclvl tag generated this error}
    }{}
    \ifthenelse{ \npc > 6 }{
        \ClassError{dnd}{4-6 Players are supported }{enclvl tag generated this error}
    }{}

    \ifthenelse{ \npc = 4 }{
        \ifthenelse{ \level < 5 }{
            \FPeval{\xp}{trunc(300 + \level * 100,0)}
        }{
            \FPeval{\xp}{trunc(600 + ((\level -4) * 200),0)}
            %TODO This won't work for levels 10 and up!
        }

    }{
        \ifthenelse{ \npc = 5 }{
            \ifthenelse{ \level < 5 }{
                \FPeval{\xp}{trunc((500-125) + \level * 125,0)}
            }{
                \FPeval{\xp}{trunc((1000-250) + ((\level -4) * 250),0)}
            }
        }{
            \ifthenelse{ \level < 5 }{
                \FPeval{\xp}{trunc((600-150) + \level * 150,0)}
            }{
                \FPeval{\xp}{trunc((1200-300) + ((\level -4) * 300),0)}
            }
        }
    }
    Nivell encontre #1 [\xp], (#3 XP)
    \newline
}

\definecolor{aloudcolor}{rgb}{0.3,0.2,0}
\newcommand{\aloud}[1]{
    {\scriptsize\ding{70} \textcolor{aloudcolor}{#1}}
}

\newcommand{\scheck}[3]{
    {\scriptsize \textbf{#1 CD#2} \textcolor{aloudcolor}{#3}}
}
\newcommand{\qrespons}[2]{
    {\scriptsize \textbf{#1:} \textcolor{aloudcolor}{#2}}
}

%
%
% Commands for creating monsters
%
%

%
% MONSTER ENVIRONMENT
%
%\define@boolkey [NPK] {mcv} {LineTwo}[true]{}
\define@cmdkey      [DMK] {ddm}     {name}      {}
\define@cmdkey      [DMK] {ddm}     {keywords}  {}
\define@cmdkey      [DMK] {ddm}     {role}      {}
\define@cmdkey      [DMK] {ddm}     {HP}        {}
\define@cmdkey      [DMK] {ddm}     {lvl}       {}
\define@cmdkey      [DMK] {ddm}     {xp}        {}
\define@cmdkey      [DMK] {ddm}     {initiative}{}
\define@cmdkey      [DMK] {ddm}     {perception}{}
\define@cmdkey      [DMK] {ddm}     {AC}        {}
\define@cmdkey      [DMK] {ddm}     {Fort}      {}
\define@cmdkey      [DMK] {ddm}     {Refl}      {}
\define@cmdkey      [DMK] {ddm}     {Will}      {}
\define@cmdkey      [DMK] {ddm}     {speed}     {}
\define@cmdkey      [DMK] {ddm}     {AP}        {}
\define@cmdkey      [DMK] {ddm}     {save}      {}
\define@cmdkey      [DMK] {ddm}     {vision}    {}
\define@cmdkey      [DMK] {ddm}     {immune}    {}
\define@cmdkey      [DMK] {ddm}     {resist}    {}
\define@cmdkey      [DMK] {ddm}     {vulnerable}{}

\define@boolkey     [DMK] {ddm}     {elite}[false]{}
\define@boolkey     [DMK] {ddm}     {solo}[false]{}

\define@boolkey     [DMK] {ddm}     {simmune}[false]{}
\define@boolkey     [DMK] {ddm}     {sresist}[false]{}
\define@boolkey     [DMK] {ddm}     {svulnerable}[false]{}

\presetkeys     [DMK] {ddm} {name         = name undefined,
                             keywords     = keywords ,
                             role         = Brute ,
                             HP           = 1,
                             lvl          = 1,
                             xp           = 1,
                             initiative   = 0,
                             perception   = 0,
                             AC           = 10,
                             Fort         = 10,
                             Refl         = 10,
                             Will         = 10,
                             speed        = 5,
                             AP           = 0,
                             save         = 0,
                             vision       = ,
                             immune       = ,
                             resist       = ,
                             vulnerable   = ,
                                           }{}



\newenvironment{ddmonster}[1][]{
    \setkeys[DMK]{ddm}{#1}

    \begin{scriptsize}
    \begin{tabular}{lr}

    \toprule

    %First Row contains the Name + role and level
    \rowcolor[gray]{0.8}
    {\small \cmdDMK@ddm@name} & {\small \cmdDMK@ddm@role ,  lvl \cmdDMK@ddm@lvl}\\

    %Second Row contains the keywords, if its Solo or Elite. And the role + xp
    \rowcolor[gray]{0.8}
    \ifDMK@ddm@solo
        \cmdDMK@ddm@keywords &
        \transl{Solo}{Solitari}{Solitario}
        (\cmdDMK@ddm@xp xp)
        \\
    \else
        \ifDMK@ddm@elite
            \cmdDMK@ddm@keywords &
            \transl{Elite}{Elit}{Élite}
            (\cmdDMK@ddm@xp xp)
            \\
        \else
            \cmdDMK@ddm@keywords & (\cmdDMK@ddm@xp xp)\\
        \fi
    \fi

    %Separe the top definition from the Defenses and HP
    \midrule

    %Row with HP and Initiative
    \FPeval{\bloodied}{trunc(\cmdDMK@ddm@HP/2,0)}%
    \textbf{HP} {\cmdDMK@ddm@HP}/{\bloodied}
    &
    \textbf{\transl{Initiative}{Iniciativa}{Iniciativa}}
    +{\cmdDMK@ddm@initiative} \\

    %Row with Defenses and Perceptions
    \textbf{\transl{AC}{CA}{CA}} \cmdDMK@ddm@AC,
    \textbf{\transl{Fort}{Fort}{Fort}} \cmdDMK@ddm@Fort,
    \textbf{\transl{Refx}{Refl}{Refl}} \cmdDMK@ddm@Refl,
    \textbf{\transl{Will}{Vol}{Vol}} \cmdDMK@ddm@Refl,
    &
    \textbf{\transl{Perception}{Percepció}{Percepción}} +\cmdDMK@ddm@perception \\


    %Row with Speed, Saves and AP
    %TODO! Would like to print AP and Save conditionally
    \textbf{\transl{Speed}{Vel}{Vel}} \cmdDMK@ddm@speed,
    \textbf{\transl{Save}{Salv}{Salv}} +\cmdDMK@ddm@save,
    \textbf{\transl{AP}{PA}{PA}} +\cmdDMK@ddm@AP
        &
    \transl{vision}{visió}{visión}: \cmdDMK@ddm@vision
        \\

    \ifDMK@ddm@simmune
        \multicolumn{2}{p{0.9\linewidth}}{\textbf{Immune} \cmdDMK@ddm@immune}\\
    \else
    \fi

    \ifDMK@ddm@sresist
        \multicolumn{2}{p{0.9\linewidth}}{\textbf{Resist} \cmdDMK@ddm@resist}\\
    \else
    \fi

    \ifDMK@ddm@svulnerable
        \multicolumn{2}{p{0.9\linewidth}}{\textbf{Vulnerable} \cmdDMK@ddm@vulnerable}\\
    \else
    \fi

    % This is conditional print of Save and AP, but does not work because
    % multispan fails inside the ifthenselse?
    %\ifthenelse{ \APval > 0 \AND \saveval > 0 }
    %{
    %%speed ap and save
    %    \multicolumn{2}{l}{
    %            \textbf{Speed} \cmdDMK@ddm@speed,
    %            \textbf{Save} +\cmdDMK@ddm@save,
    %            \textbf{AP} +\cmdDMK@ddm@AP
    %            }\\
    %}
    %{
    %    \ifthenelse{ \APval = 0 }{speed and save&b\\}
    %    {
    %        \ifthenelse{ \saveval = 0 }{speed and AP&b\\}
    %    }
    %}

    %HERE FINISHES THE BASIC ROWS. From here the user may use other constructs
    % to fill the monster
    % \ddmStandardSection \ddmExtraSection \ddmAuraSection \ddmAction \ddmReaction
    % \ddmEquip
}
{
    %FINISH MONSTER TABLE
    \bottomrule
    \end{tabular}
    \end{scriptsize}
    \vspace{5pt}
}

% Monster Section Headers
\newcommand{\ddmStandardSection}{
    \midrule
    \multicolumn{2}{c}{
        \cellcolor[gray]{0.7}
        \transl{Standard Actions}{Accions Estandard}{Acciones Estandar}
    } \\
}
\newcommand{\ddmMovementSection}{
    \midrule
    \multicolumn{2}{c}{
        \cellcolor[gray]{0.7}
        \transl{Movement Actions}{Accions de Moviment}{Acciones de Movimiento}
    } \\
}
\newcommand{\ddmMinorSection}{
    \midrule
    \multicolumn{2}{c}{
        \cellcolor[gray]{0.7}
        \transl{Minor Actions}{Accions Menors}{Acciones Menores}
    } \\
}
\newcommand{\ddmTraitsSection}{
    \midrule
    \multicolumn{2}{c}{
        \cellcolor[gray]{0.7}
        \transl{Traits}{Trets}{Características}
    } \\
}
\newcommand{\ddmExtraSection}{
    \midrule
    \multicolumn{2}{c}{
        \cellcolor[gray]{0.7}
        Extras
    } \\
}

%Monster Actions

%An action with name-type and simple description
\newcommand{\ddmActionS}[3]{

    \midrule

    \rowcolor[gray]{0.8}
    {#1} & {#2} \\
    \midrule
    \multicolumn{2}{p{0.9\linewidth}}{#3} \\
}

%An action with name-type. Attack and hit
\newcommand{\ddmActionAH}[4]{

    \midrule

    \rowcolor[gray]{0.8}
    {#1} & {#2} \\
    \midrule
    \multicolumn{2}{p{0.9\linewidth}}{\transl{Attack}{Atac}{Ataque}: #3} \\
    \multicolumn{2}{p{0.9\linewidth}}{\transl{Hit}{Encert}{Acierto}: #4} \\
}


%An action with name-type. Attack and hit and miss
\newcommand{\ddmActionAHM}[5]{

    \midrule

    \rowcolor[gray]{0.8}
    {#1} & {#2} \\
    \midrule
    \multicolumn{2}{p{0.9\linewidth}}{\transl{Attack}{Atac}{Ataque}: #3} \\
    \multicolumn{2}{p{0.9\linewidth}}{\transl{Hit}{Encert}{Acierto}: #4} \\
    \multicolumn{2}{p{0.9\linewidth}}{\transl{Miss}{Falla}{Fallo}: #5} \\
}

\newcommand{\ddmEffect}[3]{
    \midrule
    \rowcolor[gray]{0.8}
    {#1} & {#2} \\
    \midrule
    \multicolumn{2}{p{0.9\linewidth}}{\transl{Effect}{Efecte}{Efecto}: #3} \\
}

\newcommand{\ddmTrigger}[4]{
    \midrule
    \rowcolor[gray]{0.8}
    {#1} & {#2} \\
    \midrule
    \multicolumn{2}{p{0.9\linewidth}}{\transl{Trigger}{Desencadenant}{Desencadenante}: #3} \\
    \multicolumn{2}{p{0.9\linewidth}}{\transl{Effect}{Efecte}{Efecto}: #4} \\
}

\newcommand{\ddmAura}[3]{
    \midrule
    \rowcolor[gray]{0.8}
    {#1} & Aura {#2} \\
    \midrule
    \multicolumn{2}{p{0.9\linewidth}}{#3} \\
}

\newcommand{\ddmPower}[2]{
    \midrule
    \rowcolor[gray]{0.8}
    {#1} & . \\
    \midrule
    \multicolumn{2}{p{0.9\linewidth}}{#2} \\
}

\newcommand{\ddmEquip}[1]{
    \midrule
    \multicolumn{2}{l}{ \textbf{\transl{Equip}{Equip}{Equipo}:} #1 }\\
}


\newcommand{\ddmAlignLang}[2]{
    \midrule
    \textbf{\transl{Alignment}{Alineació}{Alineación}:} #1 & \textbf{\transl{Languages}{Idiomes}{Idiomas}:} #2 \\
}


% ABILITY MODIFIERS PER PLAYER. (PER MONSTER?)
% 0 1 -5
% 2 3 -4
% 4 5 -3
% 6 7 -2
% 8 9 -1
% 10 11 0
% 12 13 1
% 14 15 2
% 16 17 3
% 18 19 4
% 20 21 5

% Calculate ability modifiers
% ability value, level
%
\newcommand{\abilityeval}[2]{
    \FPeval{\abmod}{trunc(-5 + round(#1/2 -0.1,0) + round(#2/2 -0.1,0) ,0)}
    \abmod
}

%Print a table of Ability values and modifiers according to ability values and
%level. Additionally add skills if defined
% Str, Dex, Wis, Con, Int, Cha, Level, Extra skills
\newcommand{\ddmStats}[8]{
    \multicolumn{2}{p{0.9\linewidth}}{
        \textbf{skills:} {#8}
    } \\

    \multicolumn{2}{l}{
        \begin{tabular}{l|l|l}
            \textbf{ \transl{Str}{For}{Fue}}  #1  (\emph{\abilityeval{#1}{#7}})
            &
            \textbf{ \transl{Dex}{Des}{Des}}  #2  (\emph{\abilityeval{#2}{#7}})
            &
            \textbf{ \transl{Wis}{Sav}{Sab}}  #3  (\emph{\abilityeval{#3}{#7}})
            \\
            \textbf{ \transl{Con}{Con}{Con}}  #4  (\emph{\abilityeval{#4}{#7}})
            &
            \textbf{ \transl{Int}{Int}{Int}}  #5  (\emph{\abilityeval{#5}{#7}})
            &
            \textbf{ \transl{Cha}{Car}{car}}  #6  (\emph{\abilityeval{#6}{#7}})
            \\
        \end{tabular}
    }\\
}

\newcommand{\ddmStatsNoMod}[7]{
    \multicolumn{2}{p{0.9\linewidth}}{
        \textbf{skills:} {#7}
    } \\
    % TODO I am using trunc and this creates some problems when negative numbers
    % should be rounded down and not trunked. trunk(1.5) = floor(1.5)
    % trunk(-1.5) != floor(-1.5)
    \multicolumn{2}{l}{
        \begin{tabular}{lll}
            \textbf{ \transl{Str}{For}{Fue}} #1
            &
            \textbf{ \transl{Dex}{Des}{Des}} #2
            &
            \textbf{ \transl{Wis}{Sav}{Sab}} #3
            \\
            \textbf{ \transl{Con}{Con}{Con}} #4
            &
            \textbf{ \transl{Int}{Int}{Int}} #5
            &
            \textbf{ \transl{Cha}{Car}{car}} #6
            \\
        \end{tabular}
    }\\
}

%Ability keys
\define@cmdkey      [DMS] {ddm}     {Str}      {}
\define@cmdkey      [DMS] {ddm}     {Dex}      {}
\define@cmdkey      [DMS] {ddm}     {Wis}      {}
\define@cmdkey      [DMS] {ddm}     {Con}      {}
\define@cmdkey      [DMS] {ddm}     {Int}      {}
\define@cmdkey      [DMS] {ddm}     {Cha}      {}
\define@cmdkey      [DMS] {ddm}     {skills}   {}
\define@cmdkey      [DMS] {ddm}     {lvl}      {} %multiple definition here! mhm


\presetkeys     [DMS] {ddm} {
                             Str          = 10,
                             Dex          = 10,
                             Wis          = 10,
                             Con          = 10,
                             Int          = 10,
                             Cha          = 10,
                             skills       = ,
                             lvl          = 1,
                         }{}

% TODO: I really want this to work. But just now is bullshitting about something
% and I am to tired to take care of it: keep with dmStats. No Named Args
\newcommand{\ddmAbilities}[1][]{
    \setkeys[DMS]{ddm}{#1}

    %\multicolumn{2}{p{0.9\linewidth}}{
    %    \textbf{skills:} {\cmdDMS@ddm@skills}
    %} \\
    %\multicolumn{2}{l}{

    %    %\begin{tabular}{lll}
    %    %    \FPeval{\fue}{\cmdDMS@ddm@Str}%
    %    %    \FPeval{\hlvl}{trunc(\cmdDMS@ddm@lvl/2,0)}%

    %    %    \FPeval{\fuemod}{ trunc( ((\fue - 10)/2) + \hlvl,0)}%
    %    %    \textbf{Fue} \fue (\fuemod)
    %    %    &
    %    %    \FPeval{\des}{\cmdDMS@ddm@Dex}%
    %    %    \FPeval{\hlvl}{trunc(\cmdDMS@ddm@lvl/2,0)}%

    %    %    \FPeval{\desmod}{trunc(((\des - 10)/2) + \hlvl,0)}%
    %    %    \textbf{Des} \des (\desmod)
    %    %    &

    %    %    \FPeval{\sab}{\cmdDMS@ddm@Wis}%
    %    %    \FPeval{\hlvl}{trunc(\cmdDMS@ddm@lvl/2,0)}%

    %    %    \FPeval{\sabmod}{trunc(((\sab - 10)/2) + \hlvl,0)}%
    %    %    \textbf{Sab} \sab (\sabmod)
    %    %    \\

    %    %    \FPeval{\con}{\cmdDMS@ddm@Con}%
    %    %    \FPeval{\hlvl}{trunc(\cmdDMS@ddm@lvl/2,0)}%

    %    %    \FPeval{\conmod}{trunc(((\con - 10)/2) + \hlvl,0)}%
    %    %    \textbf{Con} \con (\conmod)
    %    %    &

    %    %    \FPeval{\int}{\cmdDMS@ddm@Int}%
    %    %    \FPeval{\hlvl}{trunc(\cmdDMS@ddm@lvl/2,0)}%

    %    %    \FPeval{\intmod}{trunc(((\int- 10)/2) + \hlvl,0)}%
    %    %    \textbf{Int} \int (\intmod)
    %    %    &

    %    %    \FPeval{\car}{\cmdDMS@ddm@Cha}%
    %    %    \FPeval{\hlvl}{trunc(\cmdDMS@ddm@lvl/2,0)}%

    %    %    \FPeval{\carmod}{trunc(((\car- 10)/2) + \hlvl,0)}%
    %    %    \textbf{Car} \car (\carmod)
    %    %    \\
    %    %\end{tabular}
    %}\\
}


%
% NPC CREATION
%
\define@cmdkey      [DMK] {npc}     {name}       {}
\define@cmdkey      [DMK] {npc}     {summary}    {}


\presetkeys     [DMK] {npc} {name         = name,
                             summary      = summary,
                                           }{}



\newenvironment{ddnpc}[1][]{
    \setkeys[DMK]{npc}{#1}

    \begin{scriptsize}
    \begin{tabular*}{0.9\linewidth}{l}
    \toprule

    \rowcolor[gray]{0.8}
    \textbf{\cmdDMK@npc@name} \\
    \rowcolor[gray]{0.8}
    \emph{\cmdDMK@npc@summary}\\
}
{
    %FINISH NPC table
    \bottomrule
    \end{tabular*}
    \end{scriptsize}
    \vspace{5pt}

}

\newcommand{\ddnpcSection}[2]{
    \midrule
    \textbf{{#1}} \\
    \multicolumn{1}{p{0.8\linewidth}}{#2} \\
}

\newcommand{\ddSimpleObject}[2]{
    \begin{tabular}{l}
        \toprule
        \multicolumn{1}{p{0.8\linewidth}}{ \ding{125}  \hspace{\stretch{1}} \textbf{{#1}} \hspace{\stretch{1}} \ding{126} } \\
        \midrule
        \multicolumn{1}{p{0.8\linewidth}}{{#2}} \\
        \bottomrule
    \end{tabular}
    \vspace{5pt}
}

\newcommand{\ddRuleReminder}[2]{
    \begin{tabular}{l}
        \toprule

        \multicolumn{1}{p{0.8\linewidth}}{ \ding{72}  \hspace{\stretch{1}}
        \textbf{\transl{RULES}{REGLES}{REGLAS}:} {#1} \hspace{\stretch{1}} \ding{72} } \\
        \midrule
        \multicolumn{1}{p{0.8\linewidth}}{{#2}} \\
        \bottomrule
    \end{tabular}
    \vspace{5pt}
}

\newcommand{\ddMonsterLore}[2]{
    \textbf{{#1}
    \transl{Lore}{Coneixement}{Conocimiento}
    } \newline
    {#2}
}
