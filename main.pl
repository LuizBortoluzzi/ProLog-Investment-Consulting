:- (dynamic customer/8).
:- consult(menu).
:- consult(utils).
:- consult(quiz).
:- consult(graphs).

/** 
 * Facts Structure
 * customer(name, balance, monthly_income, reliants, [financial_applications], [app_values], profile_type, monthly_expenses)
**/
customer(rafa, 40000, 7000, 0, [bdr],[1], agressive, 1).
customer(deise, 5000, 3000, 0, [savings_account],[1], conservative, 1).
customer(luiz, 20000, 12000, 0, [multimarket],[2], moderate, 1).
customer(bianca, 10000, 5000, 0, [lci], [3],conservative,1).
customer(evandro, 200000, 30000, 0, [coe], [4],agressive,2).
customer(hanna, 35000, 9000, 0, [financial_letters],[5], moderate,4).
customer(otto, 50000, 15000, 0, [financial_letters, multimarket_fund],[5,6], moderate, 6).
customer(daniels, 100000, 20000, 0, [coe,bdr], [7,8], agressive, 8).

/**
 * Financial Applications Structure 
 * financial_application(name, incomes, deadline, minimal_value, profile)
**/
financial_application(savings_account, 0.6, 1000, 1, conservative).
financial_application(lci, 11.65, null, 1, conservative).
financial_application(financial_letters, 1.0, null, 1, moderate).
financial_application(multimarket_fund, 1.0, null, 1, moderate).
financial_application(coe, 1.0, null, 1, agressive).
financial_application(bdr, 1.0, null, 1, agressive).

financial_applications_names([savings_account,lci,financial_letters,multimarket_fund,coe,bdr]).

/**
 * Colors
**/
colors([red, blue, green, yellow, gray, black, brown, cyan, violet]).

/**
 *  Minimal incomes per reliant
**/
reliant_minimal(1100).


/**
 * 
 *  Program Logics
 * 
 * 
 * 
 * 
 **/ 
search_options(CUSTOMER,_,_,VALUE):-
    customer(CUSTOMER,BALANCE,_,RELIANTS,FINANCIAL_APPLICATIONS,_,_),
    possible_options(RESULT),
    write("Do you want apply in some possible option? (Y/N)"),
    nl,
    read(ANSWER),
    write(ANSWER),
    nl,!.


where_invest(CUSTOMER, DEADLINE, PROFILE, VALUE):-
    customer(CUSTOMER,_,_,RELIANTS),
    financial_applications_names(FINANCIAL_APPLICATIONS_NAMES),!.

show_customer_applications(NAME):-
    halt.

/**
 * Checks if customer have enougth money to invest.
 **/ 
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

reliant_minimals(REALIANT, MINIMAL):-
    reliant_minimal(REL_MIN),
    MINIMAL is RELIANTS * REL_MIN.


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

