:- (dynamic customer/9).
:- consult(menu).
:- consult(utils).
:- consult(quiz).
:- consult(graphs).

%  
% Facts Structure
% customer(NAME,BALANCE,MONTHLY_INCOME,RELIANTS,DEADLINE,[APPLICATIONS],[VALUES],PROFILE,MONTHLY_EXPENSES)
% 
customer(rafa, 40000, 7000, 0, 12, [bdr], [1], agressive, 1).
customer(deise, 5000, 3000, 0, 12, [savings_account], [1], conservative, 1).
customer(luiz, 20000, 12000, 0, 12, [multimarket], [2], moderate, 1).
customer(bianca, 10000, 5000, 0, 12, [lci], [3], conservative, 1).
customer(evandro, 200000, 30000, 0, 12, [coe], [4], agressive, 2).
customer(hanna, 35000, 9000, 0, 12, [financial_letters], [5], moderate, 4).
customer(otto, 50000, 15000, 0, 12, [financial_letters, multimarket_fund], [5, 6], moderate, 6).
customer(daniels, 100000, 20000, 0, 12, [coe, bdr], [7, 8], agressive, 8).

% 
% Financial Applications Structure 
% financial_application(name, incomes, deadline, minimal_value, profile)
% 
financial_application(savings_account, 0.7, 1000, 1, conservative).
financial_application(lci, 1.6, 365, 1000, conservative).
financial_application(financial_letters, 2.0, 500, 2000, moderate).
financial_application(multimarket_fund, 3.0, 600, 2000, moderate).
financial_application(coe, 5.0, 1000, 10000, agressive).
financial_application(bdr, 8.0, 2000, 10000, agressive).

financial_applications_names([savings_account, lci, financial_letters, multimarket_fund, coe, bdr]).
emergency_fund_applications([savings_account,lci]).

%
%   Colors
%
colors([red, blue, green, yellow, gray, black, brown, cyan, violet]).

%
%   Minimal incomes per reliant
%
reliant_minimal(1100).


%%%%%%%%%%%%%%%%%%%%%%
%%                  %%
%%  Program Logics  %%
%%                  %%
%%%%%%%%%%%%%%%%%%%%%%


where_can_invest(NAME, DEADLINE, PROFILE, VALUE):-
    customer(NAME,BALANCE,_,RELIANTS,_,APPLICATIONS,VALUES,_,_),
    calculate_emergengy_fund(RELIANTS,APPLICATIONS,VALUES,MONTHLY_EXPENSES,SUM,TOTAL_EXPENSES),
    (SUM < TOTAL_EXPENSES ->
        write("It's necessary to have a emergency fund."),
        nl,
        emergency_fund_applications(EMERGENCY_FUND_APLICATIONS),
        % retorna_lista_valor_p_investir_menor_saldo(EMERGENCY_FUND_APLICATIONS,BALANCE,RESULT),
        list_length(RESULT,LENGTH),
        write("Possible Options:"),
        nl,
        list_values(RESULT),
        write("Do you want to diversified apply? (y/n)"),
        nl,
        read(ANSWER),
        write(ANSWER),
        nl,
        diversified_apply_answer_check(ANSWER,EMERGENCY_FUND_APLICATIONS,CUSTOMER,VALUE)
    ; SUM >= TOTAL_EXPENSES ->
        financial_applications_names(FINANCIAL_APPLICATIONS_NAMES),
        can_apply(VALUE,DEADLINE,PROFILE,FINANCIAL_APPLICATIONS_NAMES,APP_LIST,_),
        list_length(APP_LIST,LENGTH),
        check_list_length(LENGTH,APP_LIST,CUSTOMER,VALUE)
    ).


diversified_apply_answer_check(ANSWER,APP_LIST,CUSTOMER,BALANCE):-
    (ANSWER = y ->
        write("How much do you wanna invest? Example [10,20,30]"),
        nl,
        write("Available Balance $ "),
        write(BALANCE),
        nl,
        read(HOW_MUCH),
        how_much(APP_LIST, CUSTOMER,HOW_MUCH)
    ; ANSWER = n ->
        write("Want to choose it? (y/n)"),
        nl,
        read(CHOICE),
        apply_choosing_answer_check(CHOICE,APP_LIST,CUSTOMER)
    ).


apply_choosing_answer_check(ANSWER,APP_LIST,CUSTOMER):-
    (ANSWER = y ->
        write("Liste as aplicações onde quer investir. (Exemplo: [tesouro_selic,cdb,lci])"),
        nl,
        write("Available Financials Applications:"),
        nl,
        write(APP_LIST),
        nl,
        read(CHOOSED_APP_LIST),
        write("And the values? Write them in the same order:"),
        nl,
        write(" (Example: [3000,200,4000]) "),
        nl,
        read(VALUES_LIST),
        how_much(CHOOSED_APP_LIST,CUSTOMER,VALUES_LIST)
    ; ANSWER = n ->
        write("Ok...")
    ).

how_much(APP_LIST,NAME,VALUES_LIST):-
    customer(NAME,BALANCE,_,_,_,_,_,_,_),
    sum_applications(VALUES_LIST,APP_LIST,VALUES_LIST,RESULT),
    (RESULT =< BALANCE ->
        choosed_apply(APP_LIST,VALUE,NAME),
        write("Applications Success.")
    ; VALUE >= BALANCE ->
        write("Sorry, you don't have enougth money, your balance is: "),
        write("$ "),
        write(BALANCE)
    ).


checks_customer_balance(APP_LIST,NAME,VALUE):-
    customer(NAME,BALANCE,_,_,_,_,_,_,_),
    (VALUE =< BALANCE ->
        diversified_apply(APP_LIST,VALUE,NAME),
        write("Applications Success.")
    ; VALUE >= BALANCE ->
        write("Sorry, you don't have enougth money, your balance is: "),
        write("$ "),
        write(BALANCE)
    ).

diversified_apply(APP_LIST,TOTAL_VALUE,NAME):-
    list_length(APP_LIST, LIST_LENGTH),
    VALUES is TOTAL_VALUE/LIST_LENGTH,
    customer(NAME,BALANCE,MONTHLY_INCOME,RELIANTS,DEADLINE,APPLICATIONS,VALUES,PROFILE,MONTHLY_EXPENSES),
    retract(customer(NAME,_,_,_,_,_,_,_,_)),
    customer_applications(APPLICATIONS,APP_VALUES,APP_LIST,VALUES,VALUES_RESULTS,APP_RESULTS),
    FINAL_BALANCE is BALANCE - TOTAL_VALUE,
    assertz(customer(NAME,FINAL_BALANCE,MONTHLY_INCOME,RELIANTS,DEADLINE,APPLICATIONS,VALUES,PROFILE,MONTHLY_EXPENSES)).


choosed_apply(APP_LIST,TOTAL_VALUE,NAME):-
    list_length(APP_LIST, LIST_LENGTH),
    customer(NAME,BALANCE,MONTHLY_INCOME,RELIANTS,DEADLINE,APPLICATIONS,VALUES,PROFILE,MONTHLY_EXPENSES),
    retract(customer(NAME,_,_,_,_,_,_,_,_)),
    customer_applications(APP_NAMES,APP_VALUES,APP_LIST,VALUES,VALUES_RESULTS,APP_RESULTS),
    sum_applications(VALUES_LIST,APP_LIST,VALUES_LIST,RESULT),
    FINAL_BALANCE is BALANCE - RESULT,
    assertz(customer(NAME,FINAL_BALANCE,MONTHLY_INCOME,RELIANTS,DEADLINE,APPLICATIONS,VALUES,PROFILE,MONTHLY_EXPENSES)).


customer_applications(APP_NAMES,APP_VALUES,[],_,NEW_APP_VALUES, APP_NAMES).
customer_applications(APP_NAMES,APP_VALUES,[APP_LIST_HEADER|APP_LIST_TAIL],VALUES,VALUES_RESULTS,APP_RESULTS):-
    
    (not(member(APP_LIST_HEADER, APP_NAMES))->

        insert_on_list(APP_VALUES,VALUES,VALUE_RESULT),
        insert_on_list(APP_NAMES,APP_LIST_HEADER,APP_RESULT),
        customer_applications(APP_RESULT,VALUE_RESULT,APP_LIST_TAIL,VALUES,VALUES_RESULTS,APP_RESULTS)
    
    ; member(APP_LIST_HEADER, APP_NAMES) ->
 
        get_updated_list_values(APP_NAMES,APP_VALUES,APP_LIST_HEADER,VALUES,RESULT),
        customer_applications(APP_NAMES,VALUE_RESULT,APP_LIST_TAIL,VALUES,VALUES_RESULTS,APP_RESULTS)
    ).


customer_applications(APP_NAMES,APP_VALUES,[APP_LIST_HEADER|APP_LIST_TAIL],[VALUES_LIST_HEADER|VALUES_LIST_TAIL],VALUES_RESULTS,APP_RESULTS):-
    
    (not(member(APP_LIST_HEADER, APP_NAMES))->

        insert_on_list(APP_VALUES,VALUES_LIST_TAIL,VALUE_RESULT),
        insert_on_list(APP_NAMES,APP_LIST_HEADER,APP_RESULT),
        customer_applications(APP_RESULT,VALUE_RESULT,APP_LIST_TAIL,VALUES_LIST_TAIL,VALUES_RESULTS,APP_RESULTS)
    
    ; member(APP_LIST_HEADER, APP_NAMES) ->

        get_updated_list_values(APP_NAMES,APP_VALUES,APP_LIST_HEADER,VALUES_LIST_HEADER,RESULT),
        customer_applications(APP_NAMES,VALUE_RESULT,APP_LIST_TAIL,VALUES_LIST_TAIL,VALUES_RESULTS,APP_RESULTS)
    ).


minimal_value(BALANCE, INCOMES, RELIANTS):-
    reliant_minimals(RELIANTS, MINIMAL),
    RESULT_ONE is INCOMES - MINIMAL,
    RESULT_TWO is BALANCE + RESULT_ONE,
    
    (RESULT_TWO < 100 ->
        write("Sorry it's not enougth"),
        fail
    ; RESULT_TWO >= 100 ->
        write("Congrats, let's invest?")
    ).

reliant_minimals(RELIANTS, MINIMAL):-
    reliant_minimal(REL_MIN),
    MINIMAL is RELIANTS * REL_MIN.


customer_profit(NAME):-
    customer(NAME,_,_,_,_,APPLICATIONS,VALUES,_,_),
    get_all_application_profit(APPLICATIONS,VALUES).


checks_emergency_fund(RECIPE, TOTAL_EXPENSES, RESULT):-
    RESULT is TOTAL_EXPENSES - RECIPE,
    (RECIPE >= TOTAL_EXPENSES ->
        write("Congratulations, you have enougth money to emergency fund!"),
        nl,
        write("Balance $: ")
     ; RECIPE < TOTAL_EXPENSES ->
        write("Holy crap! No money brother..."),
        nl,
        write("You will need $")  
    ),
    write(RESULT).


get_all_customer_application_profit(NAME):-
    customer(NAME,_,_,_,_, FINANCIAL_APPLICATIONS, VALUES,_,_),
    get_all_application_profit(FINANCIAL_APPLICATIONS, VALUES).



get_all_application_profit([],_).
get_all_application_profit([H|T],[H1|T1]):-
    financial_application(APP_NAME,INCOMES,_,_,_),
    VALUE is H1 * (INCOMES),
    write("Profits to "),
    write(APP_NAME),
    write(": $ "),
    write(VALUE),
    nl,
    get_all_application_profit(T, T1).


get_updated_list_values([],[],_,_,[]).
get_updated_list_values([H|T],[H1|T1],APP_NAME,VALUE,[H2|RESULT]):-
    H = APP_NAME, % se forem iguais, adicionará o valor dele + VAL em uma variável nova
    H2 is VALUE + H1, % e então colocará H2 nesta posição da lista, no retorno
    get_updated_list_values(T,T1,APP_NAME,VALUE,RESULT),!.
get_updated_list_values([_|T],[H1|T1],APP_NAME,VALUE,[H1|RESULT]):- % Coloca o valor normal
    get_updated_list_values(T,T1,APP_NAME,VALUE,RESULT). %prossegue para o filho

show_customer_applications_values(NAME):-
    customer(NAME,_,_,_,_,APPLICATIONS,VALUE,_,_),
    write("Investments of "),
    write(NAME),
    nl,
    show_application_value(APPLICATIONS,VALUE),
    nl,
    colors(COLORS),
    build_bars(APPLICATIONS,VALUE,COLORS,FINAL_LIST),
    financial_applications_names(X),
    sum_applications(X,APPLICATIONS,VALUE,SUM),
    applications_graph(FINAL_LIST,SUM).


can_apply(_,_,_,[],AUX,AUX).
can_apply(INVESTMENT_VALUE,DEADLINE,PROFILE,[H|T],APP_LIST,AUX):-
    financial_application(H,_,APP_DEADLINE,MIN_VALUE,PROFILE),
    INVESTMENT_VALUE >= MIN_VALUE,
    DEADLINE >= APP_DEADLINE,
    can_apply(INVESTMENT_VALUE,DEADLINE,PROFILE,T,APP_LIST,[H|AUX]),!.

can_apply(INVESTMENT_VALUE,DEADLINE,PROFILE,[_|T],APP_LIST,AUX):-
    can_apply(INVESTMENT_VALUE,DEADLINE,PROFILE,T,APP_LIST,AUX),!.


calculate_emergency_fund(RELIANTS,CUSTOMER_APP_LIST,CUSTOMER_VALUES_LIST,EXPENSES,SUM,TOTAL_EXPENSES):-
    SIX_MONTH_EXPENSES is EXPENSES * 6,
    reliant_minimals(RELIANTS,REL_MIN),
    SIX_MONTH_EXPENSES_REL is REL_MIN * 6,
    TOTAL_EXPENSES is SIX_MONTH_EXPENSES + SIX_MONTH_EXPENSES_REL,
    emergency_fund_applications(NAME),
    sum_applications(NAME,CUSTOMER_APP_LIST,CUSTOMER_VALUES_LIST,SUM),
    nl.


emergency_fund_middleware(RELIANTS,EXPENSES,RESULT,APP_LIST,VALUES_LIST):-
    calculate_emergency_fund(RELIANTS,APP_LIST,VALUES_LIST,EXPENSES,RECIPE,TOTAL_EXPENSES),
    checks_emergency_fund(RECIPE,TOTAL_EXPENSES,RESULT).

get_best_list_choice([],_,[]).
get_best_list_choice([NAME|T],VALUE,[NAME|RESULT]):-
    financial_application(NAME,_,_,VALUE_TO_INVEST,_),
    VALUE_TO_INVEST =< VALUE,
    get_best_list_choice(T,VALUE,RESULT),!.

get_best_list_choice([H|T],VALUE,[H|RESULT]):-
    get_best_list_choice(T,VALUE,RESULT).


check_list_length(LENGTH,APP_LIST,CUSTOMER,VALUE_LIST):-
    (LENGTH > 0 ->
        write("Congratulations, you have enougth money to emergency fund!"),
        nl,
        write("Options to invest: "),
        nl,
        list_values(APP_LIST),
        write("Do you want to diversified apply? "),
        nl,
        read(ANSWER),
        diversified_apply_answer_check(ANSWER,APP_LIST,CUSTOMER,VALUE_LIST)
     ; LENGTH =< 0 ->
        write("Holy crap! No money brother..."),
        nl,
        write("You will need $")  
    ).