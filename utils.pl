
list_values([]).
list_values([H,S]):-
    write(H),
    nl,
    list_values(S),!.


list_length([], 0).
list_length([_,S], SIZE):-
    list_length(S, S1),
    SIZE is S1 + 1.

insert_on_list(L, VALUE, RESULT):-
    append(L, [VALUE], RESULT),!.


show_application_value([], []).
show_application_value([H|S], [H1|S1]):-
    write("Financial Application: "),
    write(H),
    write(". Value $"),
    write(H1),
    nl,
    show_application_value(S, S1).


sum_applications([],_,_,0).
sum_applications([H|T],A,QT,SUM):-
    get_application_value(H,A,QT,_,VALUE),
    sum_applications(T,A,QT,S1),
    SUM is S1 + VALUE,!.


get_application_value(_,[],[],_,0).
get_application_value(A, [A], [A1], A, A1).
get_application_value(A, [H|_], [H1|_], APLICATION, VALUE):-
    A = H,
    APLICATION = H,
    VALUE is H1.
get_application_value(A, [_|T], [_|T1], APLICATION, VALUE):-
    get_application_value(A, T, T1, APLICATION, VALUE),!.

