/**
 * Documentations:
 * https://github.com/SWI-Prolog/packages-xpce/blob/master/prolog/lib/plot/demo.pl
 * http://www.swi-prolog.org/packages/xpce/UserGuide/libplot.html#sec:11.6
**/

:- use_module(library('plot/barchart')).
:- use_module(library(autowin)).
:- use_module(library(pce)).


profile_graph(A1,B1,C1, ANSWERS_QTD) :-
    new(W,  auto_sized_picture('Profile Analyzer')),
    send(W, display, new(BC, bar_chart(horizontal,0,ANSWERS_QTD))),
    forall(member(Name/Height/Color,
              [a/A1/red, b/B1/green, c/C1/blue]),
           (   new(B, bar(Name, Height)),
               send(B, colour(Color)),
               send(BC, append, B)
           )),
    send(W, open).


applications_graph(LIST,TOTAL) :-
    new(W,  auto_sized_picture('Financial Applications Analyzer')),
    send(W, display, new(BC, bar_chart(horizontal,0,TOTAL))),
    forall(member(Name/Height/Color,
              LIST),
           (   new(B, bar(Name, Height)),
               send(B, colour(Color)),
               send(BC, append, B)
           )),
    send(W, open).


build_bars([], _, _, _).
build_bars([H|T], [H1|T1], [H2|T2], FINAL_LIST):-
    build_bars(T,T1,T2,FINAL_LIST1),
    append(FINAL_LIST1,[H/H1/H2],FINAL_LIST). 