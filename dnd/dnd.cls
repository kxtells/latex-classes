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
        \ifenglish
        Solo
        \fi
        \ifcatalan
        Solitari
        \fi
        \ifspanish
        Solitario
        \fi
        (\cmdDMK@ddm@xp xp)
        \\
    \else
        \ifDMK@ddm@elite
            \cmdDMK@ddm@keywords &
            \ifenglish
            Elite
            \fi
            \ifcatalan
            Elit
            \fi
            \ifspanish
            Élite
            \fi
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
    \ifenglish
        \textbf{Initiative}
    \fi
    \ifcatalan
        \textbf{Iniciativa}
    \fi
    \ifspanish
        \textbf{Iniciativa}
    \fi
    +{\cmdDMK@ddm@initiative} \\

    %Row with Defenses and Perceptions
    \ifenglish
        \textbf{AC}     \cmdDMK@ddm@AC,
        \textbf{Fort}   \cmdDMK@ddm@Fort,
        \textbf{Refx}   \cmdDMK@ddm@Refl,
        \textbf{Will}    \cmdDMK@ddm@Will
        &
        \textbf{Perception} +\cmdDMK@ddm@perception \\
    \fi
    \ifcatalan
        \textbf{CA}     \cmdDMK@ddm@AC,
        \textbf{Fort}   \cmdDMK@ddm@Fort,
        \textbf{Refl}   \cmdDMK@ddm@Refl,
        \textbf{Vol}    \cmdDMK@ddm@Will
        &
        \textbf{Percepció} +\cmdDMK@ddm@perception \\
    \fi
    \ifspanish
        \textbf{CA}     \cmdDMK@ddm@AC,
        \textbf{Fort}   \cmdDMK@ddm@Fort,
        \textbf{Refl}   \cmdDMK@ddm@Refl,
        \textbf{Vol}    \cmdDMK@ddm@Will
        &
        \textbf{Percepción} +\cmdDMK@ddm@perception \\
    \fi


    %Row with Speed, Saves and AP
    %TODO! Would like to print AP and Save conditionally
    \ifenglish
        \textbf{Speed} \cmdDMK@ddm@speed,
        \textbf{Save} +\cmdDMK@ddm@save,
        \textbf{AP} +\cmdDMK@ddm@AP
        &
        vision: \cmdDMK@ddm@vision
        \\
    \fi
    \ifcatalan
        \textbf{Vel} \cmdDMK@ddm@speed,
        \textbf{salv} +\cmdDMK@ddm@save,
        \textbf{AP} +\cmdDMK@ddm@AP
        &
        visió: \cmdDMK@ddm@vision
        \\
    \fi
    \ifspanish
        \textbf{Vel} \cmdDMK@ddm@speed,
        \textbf{salv} +\cmdDMK@ddm@save,
        \textbf{AP} +\cmdDMK@ddm@AP
        &
        visión: \cmdDMK@ddm@vision
        \\
    \fi


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
        \ifenglish
            Standard Actions
        \fi
        \ifcatalan
            Accions Estandard
        \fi
        \ifspanish
            Acciones Estandard
        \fi
    } \\
}
\newcommand{\ddmMovementSection}{
    \midrule
    \multicolumn{2}{c}{
        \cellcolor[gray]{0.7}
        \ifenglish
            Movement Actions
        \fi
        \ifcatalan
            Accions Moviment
        \fi
        \ifspanish
            Acciones Movimiento
        \fi
    } \\
}
\newcommand{\ddmMinorSection}{
    \midrule
    \multicolumn{2}{c}{
        \cellcolor[gray]{0.7}
        \ifenglish
            Minor Actions
        \fi
        \ifcatalan
            Accions Menors
        \fi
        \ifspanish
            Acciones Menores
        \fi
    } \\
}
\newcommand{\ddmTraitsSection}{
    \midrule
    \multicolumn{2}{c}{
        \cellcolor[gray]{0.7}
        \ifenglish
            Traits
        \fi
        \ifcatalan
            Trets Especials
        \fi
        \ifspanish
            Características Especiales
        \fi
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
    \ifenglish
        \multicolumn{2}{p{0.9\linewidth}}{Attack: #3} \\
        \multicolumn{2}{p{0.9\linewidth}}{Hit: #4} \\
    \fi
    \ifcatalan
        \multicolumn{2}{p{0.9\linewidth}}{Atac: #3} \\
        \multicolumn{2}{p{0.9\linewidth}}{Encert: #4} \\
    \fi
    \ifspanish
        \multicolumn{2}{p{0.9\linewidth}}{Ataque: #3} \\
        \multicolumn{2}{p{0.9\linewidth}}{Acierto: #4} \\
    \fi

}


%An action with name-type. Attack and hit and miss
\newcommand{\ddmActionAHM}[5]{

    \midrule

    \rowcolor[gray]{0.8}
    {#1} & {#2} \\
    \midrule
    \ifenglish
        \multicolumn{2}{p{0.9\linewidth}}{Attack: #3} \\
        \multicolumn{2}{p{0.9\linewidth}}{Hit: #4} \\
        \multicolumn{2}{p{0.9\linewidth}}{Miss: #5} \\
    \fi
    \ifcatalan
        \multicolumn{2}{p{0.9\linewidth}}{Atac: #3} \\
        \multicolumn{2}{p{0.9\linewidth}}{Encert: #4} \\
        \multicolumn{2}{p{0.9\linewidth}}{Falla: #5} \\
    \fi
    \ifspanish
        \multicolumn{2}{p{0.9\linewidth}}{Ataque: #3} \\
        \multicolumn{2}{p{0.9\linewidth}}{Acierto: #4} \\
        \multicolumn{2}{p{0.9\linewidth}}{Fallo: #5} \\
    \fi
}

\newcommand{\ddmEffect}[3]{
    \midrule
    \rowcolor[gray]{0.8}
    {#1} & {#2} \\
    \midrule
    \ifenglish
        \multicolumn{2}{p{0.9\linewidth}}{Effect: #3} \\
    \fi
    \ifcatalan
        \multicolumn{2}{p{0.9\linewidth}}{Efecte: #3} \\
    \fi
    \ifspanish
        \multicolumn{2}{p{0.9\linewidth}}{Efecto: #3} \\
    \fi
}

\newcommand{\ddmTrigger}[4]{
    \midrule
    \rowcolor[gray]{0.8}
    {#1} & {#2} \\
    \midrule
    \ifenglish
        \multicolumn{2}{p{0.9\linewidth}}{Trigger: #3} \\
        \multicolumn{2}{p{0.9\linewidth}}{Effect: #4} \\
    \fi
    \ifcatalan
        \multicolumn{2}{p{0.9\linewidth}}{Desencadenant: #3} \\
        \multicolumn{2}{p{0.9\linewidth}}{Efecte: #4} \\
    \fi
    \ifspanish
        \multicolumn{2}{p{0.9\linewidth}}{Desencadenante: #3} \\
        \multicolumn{2}{p{0.9\linewidth}}{Efecto: #4} \\
    \fi
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
    \ifenglish
        \multicolumn{2}{l}{ \textbf{Equip:} #1 }\\
    \fi
    \ifcatalan
        \multicolumn{2}{l}{ \textbf{Equip:} #1 }\\
    \fi
    \ifspanish
        \multicolumn{2}{l}{ \textbf{Equipo:} #1 }\\
    \fi
}


\newcommand{\ddmAlignLang}[2]{
    \midrule
    \ifenglish
        \textbf{Alignment:} #1 & \textbf{Languages:} #2 \\
    \fi
    \ifcatalan
        \textbf{Alineació:} #1 & \textbf{Idiomes:} #2 \\
    \fi
    \ifspanish
        \textbf{Alineación:} #1 & \textbf{Idiomas:} #2 \\
    \fi
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

% Calculate monster stats
% Str, Dex, Sab, Con, Int, Car, Level, ExtraSkillsText
%
%
\newcommand{\ddmStats}[8]{
    \multicolumn{2}{p{0.9\linewidth}}{
        \textbf{skills:} {#8}
    } \\
    % TODO I am using trunc and this creates some problems when negative numbers
    % should be rounded down and not trunked. trunk(1.5) = floor(1.5)
    % trunk(-1.5) != floor(-1.5)
    \multicolumn{2}{l}{
        \begin{tabular}{lll}
            \FPeval{\fue}{#1}%
            \FPeval{\hlvl}{trunc(#7/2,0)}%
            \FPeval{\fuemod}{ trunc( ((\fue - 10)/2) + \hlvl,0)}%
            \ifenglish
                \textbf{Str} \fue (\fuemod)
            \fi
            \ifcatalan
                \textbf{For} \fue (\fuemod)
            \fi
            \ifspanish
                \textbf{Fue} \fue (\fuemod)
            \fi
            &
            \FPeval{\des}{#2}%
            \FPeval{\hlvl}{trunc(#7/2,0)}%
            \FPeval{\desmod}{trunc(((\des - 10)/2) + \hlvl,0)}%
            \ifenglish
                \textbf{Dex} \des (\desmod)
            \fi
            \ifcatalan
                \textbf{Des} \des (\desmod)
            \fi
            \ifspanish
                \textbf{Des} \des (\desmod)
            \fi
            &
            \FPeval{\sab}{#3}%
            \FPeval{\hlvl}{trunc(#7/2,0)}%
            \FPeval{\sabmod}{trunc(((\sab - 10)/2) + \hlvl,0)}%
            \ifenglish
                \textbf{Wis} \sab (\sabmod)
            \fi
            \ifcatalan
                \textbf{Sav} \sab (\sabmod)
            \fi
            \ifspanish
                \textbf{Sab} \sab (\sabmod)
            \fi
            \\
            \FPeval{\con}{#4}%
            \FPeval{\hlvl}{trunc(#7/2,0)}%
            \FPeval{\conmod}{trunc(((\con - 10)/2) + \hlvl,0)}%
            \ifenglish
                \textbf{Con} \con (\conmod)
            \fi
            \ifcatalan
                \textbf{Con} \con (\conmod)
            \fi
            \ifspanish
                \textbf{Con} \con (\conmod)
            \fi
            &
            \FPeval{\int}{#5}%
            \FPeval{\hlvl}{trunc(#7/2,0)}%
            \FPeval{\intmod}{trunc(((\int- 10)/2) + \hlvl,0)}%
            \ifenglish
                \textbf{Int} \int (\intmod)
            \fi
            \ifcatalan
                \textbf{Int} \int (\intmod)
            \fi
            \ifspanish
                \textbf{Int} \int (\intmod)
            \fi
            &
            \FPeval{\car}{#6}%
            \FPeval{\hlvl}{trunc(#7/2,0)}%
            \FPeval{\carmod}{trunc(((\car- 10)/2) + \hlvl,0)}%
            \ifenglish
                \textbf{Cha} \car (\carmod)
            \fi
            \ifcatalan
                \textbf{Car} \car (\carmod)
            \fi
            \ifspanish
                \textbf{Car} \car (\carmod)
            \fi
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
            \ifenglish
                \textbf{Str} #1
            \fi
            \ifcatalan
                \textbf{For} #1
            \fi
            \ifspanish
                \textbf{Fue} #1
            \fi
            &
            \ifenglish
                \textbf{Dex} #2
            \fi
            \ifcatalan
                \textbf{Des} #2
            \fi
            \ifspanish
                \textbf{Des} #2
            \fi
            &
            \ifenglish
                \textbf{Wis} #3
            \fi
            \ifcatalan
                \textbf{Sav} #3
            \fi
            \ifspanish
                \textbf{Sab} #3
            \fi
            \\
            \ifenglish
                \textbf{Con} #4
            \fi
            \ifcatalan
                \textbf{Con} #4
            \fi
            \ifspanish
                \textbf{Con} #4
            \fi
            &
            \ifenglish
                \textbf{Int} #5
            \fi
            \ifcatalan
                \textbf{Int} #5
            \fi
            \ifspanish
                \textbf{Int} #5
            \fi
            &
            \ifenglish
                \textbf{Cha} #6
            \fi
            \ifcatalan
                \textbf{Car} #6
            \fi
            \ifspanish
                \textbf{Car} #6
            \fi
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
        \ifenglish
            \textbf{RULES:}
        \fi
        \ifcatalan
            \textbf{REGLES:}
        \fi
        \ifspanish
            \textbf{REGLAS:}
        \fi
        {#1} \hspace{\stretch{1}} \ding{72} } \\
        \midrule
        \multicolumn{1}{p{0.8\linewidth}}{{#2}} \\
        \bottomrule
    \end{tabular}
    \vspace{5pt}
}

\newcommand{\ddMonsterLore}[2]{
    \textbf{{#1}
    \ifenglish
        Lore
    \fi
    \ifcatalan
        Coneixement
    \fi
    \ifspanish
        Conocimiento
    \fi
    } \newline
    {#2}
}
