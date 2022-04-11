/**
 * Reads customer name
 **/ 
get_customer(NAME):-
    write("Please type exactly the customer name:"),
    nl,
    read(NAME),
    validate_customer_name(NAME).

/**
 * Searches customer 
 **/
validate_customer_name(NAME):-
    customer(NAME,_,_,_,_,_).


/**
 * Prints Menu
 **/
menu():-
    nl,
    write("##### Welcome to ProLog Investment Consulting #####"),
    nl,
    write(" -- Choose one option bellow --"),
    nl,
    write(" 1 - Add a Customer."),
    nl,
    write(" 2 - Show a Customer Applications"),
    nl,
    write(" 3 - Show a Customer Informations."),
    nl,
    write(" 4 - Verify Emergency Fund of a Customer."),
    nl,
    write(" 5 - Verify if the customer have the minimal value for investment"),
    nl,
    write(" 6 - Quiz to discover your profile"),
    nl,
    write(" 7 - Where to apply?"),
    nl,
    write(" 8 - How much i'll gonna get in my applications?"),
    nl,
    write(" 0 - Exit."),
    nl,
    read(X),
    option(X),
    menu().


/**
 * Option 1 - Add a Customer
 **/       
option(X):-
    X = 1,
    write("Name: "),
    nl,
    read(NAME),
    write("Balance:"),
    nl,
    read(BALANCE),
    write("Monthly Income:"),
    nl,
    read(MONTHLY_INCOME),
    write("Reliants Quantity:"),
    nl,
    read(RELIANTS),
    write("Deadline:"),
    nl,
    read(DEADLINE),
    write("Applications (Exemple: [x,y,z]):"),
    nl,
    read(APPLICATIONS),
    write("Values (At same order. Example: [50,100,200]):"),
    nl,
    read(VALUES),
    write("Profile (Available Profiles: conservative, moderate, agressive):"),
    nl,
    read(PROFILE),
    write("Monthly Expenses:"),
    nl,
    read(MONTHLY_EXPENSES),
    assertz(customer(NAME,BALANCE,MONTHLY_INCOME,RELIANTS,DEADLINE,APPLICATIONS,VALUES,PROFILE,MONTHLY_EXPENSES)),
    write("Customer Added Successfuly!"),
    nl,!. 


/**
 * Option 2 - Show a Customer Applications
 **/
option(X):-
    X = 2,
    get_customer(NAME),
    show_customer_applications(NAME),!.

/**
 * Option 3 - Show a Customer Informations
 **/   
option(X):-
    X = 3,
    get_customer(NAME),
    customer(NAME,BALANCE,MONTHLY_INCOME,RELIANTS,FINANCIAL_APPLICATIONS,VALUES,PROFILE,MONTHLY_EXPENSES), 
    write("Name: "),
    write(NAME),
    nl,
    write("Balance: "),
    write(BALANCE),
    nl,
    write("Monthly Incomes:"),
    write(MONTHLY_INCOME),
    nl,
    write("Reliants Quantity:"),
    write(RELIANTS),
    nl,
    write("Financial Aplications and Values:"),
    nl,
    write(FINANCIAL_APPLICATIONS),
    nl,
    write(VALUES),
    nl,
    write("Profile:"),
    write(PROFILE),
    nl,
    write("Monthly Expenses:"),
    write(MONTHLY_EXPENSES),
    nl,!.
   
option(X):-
    X = 3,
    write("Customer not found. "),
    nl,!.

/**
 * Option 4 - Verify Emergency Fund of a Customer
 **/    
option(X):-
    X = 4,
    get_customer(NAME),
    customer(NAME,_,_, DEP, _, APLIC, QT_APLIC, _, DESP),
    verify_emergency_fund( DEP, DESP, _, APLIC, QT_APLIC).

/**
 * Option 5 - Verify if the customer have the minimal value for investment
 **/       
option(X):-
    X = 5,
    get_customer(NAME),
    customer(NAME,BALANCE,MONTHLY_INCOME, RELIANTS, _, _, _, _),
    minimal_value(BALANCE,MONTHLY_INCOME,RELIANTS).

/**
 * Option 6 - Quiz to discover your profile
 **/   
option(X):-
    X = 6,
    get_customer(NAME),
    customer(NAME,_,_,_, _, _, _, _), 
    profile_quiz(NAME).
    
/**
 * Option 7 - Where to apply?
 **/   
option(X):-
    X = 7,
    get_customer(NAME),
    customer(NAME,BALANCE,_,_,_,_,PROFILE,_), 
    search_options(NAME,_,_,BALANCE).

/**
 * Option 8 - How much i'll gonna get in my applications?
 **/       
option(X):-
    X = 8,
    get_customer(NAME),
    get_all_customer_application_profit(NAME).

/**
 * Option 0 - Ends the execution
 **/
option(X):-
    X = 0,
    halt.