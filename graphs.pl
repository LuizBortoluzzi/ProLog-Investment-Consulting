/**
 * Documentations:
 * https://github.com/SWI-Prolog/packages-xpce/blob/master/prolog/lib/plot/demo.pl
 * http://www.swi-prolog.org/packages/xpce/UserGuide/libplot.html#sec:11.6
**/

:- use_module(library('plot/barchart')).
:- use_module(library(autowin)).
:- use_module(library(pce)).


/**
 *  Quiz Graph
 * 
 *  @param:
 *      A1 = (int/float) Altura da barra 1
 *      B1 = (int/float) Altura da barra 2
 *      C1 = (int/float) Altura da barra 3
 *      ANSWERS_QTD = (int/float) Total de respostas
 * */
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


/**
 * Gráficos Aplicações
 * 
 * @param:
 *      LIST = Lista com as barras a serem exibidas no gráfico,
 *                      já em formato Nome/Altura/Cor
 *      TOTAL = Valor do mais alto registro que será exibido
 * 
 **/
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


/**
 *  Build bars
 *  @param:
 *      L1 = Lista com os nomes das barras a serem exibidas
 *      L2 = Lista com os valores (alturas) das barras a serem exibidas
 *      L3 = Lista com os nomes das cores das barras a serem exibidas
 *      FINAL_LIST = Lista montada no padrão Nome/Altura/Cor a ser retornada
 *      monta_barras(LISTA_NOMES_APLICACOES, LISTA_QUANTIDADE_APLICACOES, LISTA_NOMES_CORES, FINAL_LIST):-
 **/
bars_build([], _, _, _).
bars_build([H|T], [H1|T1], [H2|T2], FINAL_LIST):-
    bars_build(T,T1,T2,FINAL_LIST1),
    append(FINAL_LIST1,[H/H1/H2],FINAL_LIST). 