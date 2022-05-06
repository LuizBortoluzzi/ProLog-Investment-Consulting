:- use_module(library(pce)).
:- use_module(library(pce_style_item)).
:- use_module(library(tabular)).
:- use_module(library(autowin)).


add_costumer_gui :-
    new(Dialog, dialog('Add a Costumer')),
    send_list(Dialog,
              append,
              
              [ new(NAME, text_item(costumer_name)),
                new(BALANCE, int_item(balance)),
                new(MONTHLY_INCOME, text_item(monthly_Income)),
                new(RELIANTS, int_item(reliants, low:=0, high:=40)),
                new(DEADLINE, text_item(deadline)),
                new(APPLICATIONS, text_item(applications)),
                new(VALUES, text_item(values)),
                new(PROFILE, menu(investment_profile, cycle)),
                new(MONTHLY_EXPENSES, int_item(monthly_Expenses)),
                button(cancel, message(Dialog, destroy)),
                button(add,
                       and(message(@prolog,
                                   assert_customer,
                                   NAME?selection,
                                   BALANCE?selection,
                                   MONTHLY_INCOME?selection,
                                   RELIANTS?selection,
                                   DEADLINE?selection,
                                   APPLICATIONS?selection,
                                   VALUES?selection,
                                   PROFILE?selection,
                                   MONTHLY_EXPENSES?selection),
                           message(Dialog, destroy)))
              ]),
    send_list(PROFILE, append, [conservative, moderate, agressive]),
    send(Dialog, default_button, add),
    send(Dialog, open).
 
 add_customer_success :-
    new(Dialog, dialog('Success')),
    new(MESSAGE, text("Customer Successfuly Added!")),
    send(Dialog, append, MESSAGE),
    send(Dialog, append, button(ok, message(Dialog, destroy))),
    send(Dialog, default_button, ok),
    send(Dialog, open).

search_customer_apps_gui :-
    new(Dialog, dialog('Search Costumer Applications')),
    send_list(Dialog,
              append,
              
              [ new(NAME, text_item(costumer_name)),
                button(cancel, message(Dialog, destroy)),
                button(search,
                       and(message(@prolog,
                                   show_customer_applications_values,
                                   NAME?selection),
                           message(Dialog, destroy)))
              ]),
    send(Dialog, default_button, search),
    send(Dialog, open).

search_customer_info_gui :-
    new(Dialog, dialog('Costumer Informations')),
    send_list(Dialog,
              append,
              
              [ new(NAME, text_item(costumer_name)),
                button(cancel, message(Dialog, destroy)),
                button(search,
                       and(message(@prolog,
                                   get_customer_information,
                                   NAME?selection),
                           message(Dialog, destroy)))
              ]),
    send(Dialog, default_button, search),
    send(Dialog, open).
 
show_customer_info_gui(NAME, BALANCE, MONTHLY_INCOME, RELIANTS, DEADLINE, APPLICATIONS, VALUES, PROFILE, MONTHLY_EXPENSES) :-
    new(P, auto_sized_picture('Customer Informations')),
    send(P, display, new(T, tabular)),
    send(T, border, 1),
    send(T, cell_spacing, -1),
    send(T, rules, all),
    send_list(T,
              
              [ append('Name', bold),
                append(NAME),
                next_row,
                append('Balance', bold),
                append(BALANCE),
                next_row,
                append('Mon. Incomes', bold),
                append(MONTHLY_INCOME),
                next_row,
                append('Reliants', bold),
                append(RELIANTS),
                next_row,
                append('Deadline', bold),
                append(DEADLINE),
                next_row,
                append('Profile', bold),
                append(PROFILE),
                next_row,
                append('Mon. Expenses', bold),
                append(MONTHLY_EXPENSES),
                next_row
              ]),
    send(T, append, 'Applications', bold),
    send(T, next_row),
    send_list(T, append, APPLICATIONS),
    send(T, next_row),
    send_list(T, append, VALUES),
    send(P, open).


search_applications_profit_gui :-
    new(Dialog, dialog('Search Costumer Applications Profit')),
    send_list(Dialog,
              append,
              
              [ new(NAME, text_item(costumer_name)),
                button(cancel, message(Dialog, destroy)),
                button(search,
                       and(message(@prolog,
                                   get_all_customer_application_profit,
                                   NAME?selection),
                           message(Dialog, destroy)))
              ]),
    send(Dialog, default_button, search),
    send(Dialog, open).

show_applications_profit_gui(FINANCIAL_APPLICATIONS, VALUES) :-
    new(P, auto_sized_picture('Customer Applications Profit')),
    send(P, display, new(T, tabular)),
    send(T, border, 1),
    send(T, cell_spacing, -1),
    send(T, rules, all),
    send(T, append, 'Applications Profits', bold),
    send(T, next_row),
    send_list(T, append, FINANCIAL_APPLICATIONS),
    send(T, next_row),
    send_list(T, append, VALUES),
    send(P, open).

verify_emergency_fund_gui :-
    new(Dialog, dialog('Verify Costumer Emergency Fund')),
    send_list(Dialog,
              append,
              
              [ new(NAME, text_item(costumer_name)),
                button(cancel, message(Dialog, destroy)),
                button(search,
                       and(message(@prolog,
                                   get_emergency_fund,
                                   NAME?selection),
                           message(Dialog, destroy)))
              ]),
    send(Dialog, default_button, search),
    send(Dialog, open).

emergency_fund_result(TEXT, RESULT) :-
    new(Dialog, dialog('Costumer Emergency Fund')),
    new(MESSAGE, text(TEXT)),
    new(R, text(RESULT)),
    send(Dialog, append, MESSAGE),
    send(Dialog, append, R),
    send(Dialog, append, button(ok, message(Dialog, destroy))),
    send(Dialog, default_button, ok),
    send(Dialog, open).


check_minimal_investment_value_gui :-
    new(Dialog, dialog('Check Minimal Investment Value')),
    send_list(Dialog,
              append,
              
              [ new(NAME, text_item(costumer_name)),
                button(cancel, message(Dialog, destroy)),
                button(search,
                       and(message(@prolog,
                                   check_minimal_value,
                                   NAME?selection),
                           message(Dialog, destroy)))
              ]),
    send(Dialog, default_button, search),
    send(Dialog, open).

minimal_value_result(TEXT) :-
     new(Dialog, dialog('Result')),
     new(MESSAGE, text(TEXT)),
     send(Dialog, append, MESSAGE),
     send(Dialog, append, button(ok, message(Dialog, destroy))),
     send(Dialog, default_button, ok),
     send(Dialog, open).

menu :-
    new(MENU_D, dialog('Prolog Investment Consulting')),
    new(DG, dialog_group('Options')),
    send(DG,
         append,
         button(add_a_Costumer, message(@prolog, add_costumer_gui))),
    send(DG,
         append,
         button(show_Costumer_Applications,
                message(@prolog, search_customer_apps_gui)),
         below),
    send(DG,
         append,
         button(search_Costumer_Informations,
                message(@prolog, search_customer_info_gui)),
         below),
    send(DG,
         append,
         button(verify_Emergency_Fund,
                message(@prolog, verify_emergency_fund_gui)),
         below),
    send(DG,
         append,
         button(check_Minimal_Investment_Value,
                message(@prolog, check_minimal_investment_value_gui)),
         below),
    send(DG,
         append,
         button(profile_Investment_Quiz,
                message(@prolog, profile_investment_quiz_gui)),
         below),
    send(DG,
         append,
         button(where_to_Apply, message(@prolog, where_to_apply_gui)),
         below),
    send(DG,
         append,
         button(customer_Applications_Profit,
                message(@prolog, search_applications_profit_gui)),
         below),
    send(DG, gap, size(60, 20)),
    send(MENU_D, gap, size(30, 10)),
    send(MENU_D, append, DG),
    send(MENU_D, append, button(quit, message(MENU_D, destroy))),
    send(MENU_D, open).

