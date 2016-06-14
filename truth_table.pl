% Build a truth table with n variables, retuning a list wich lists who represent the columns from
% the truth table.
build_truth_table(QtVars, [Col|Cols]) :-
	QtLines is 2^QtVars,
	Order is (QtLines / 2), % Order is in what sequence the boolean value must be changed (Ex: Order = 4, lines = 8, column1 = [0, 0, 0, 0, 1, 1, 1, 1])
	build_truth_table(QtVars, QtLines, Order, [Col|Cols]),
	truth_table_lines([Col|Cols], QtLines, QtVars, [Line|Lines]),
	reverse_list([Line|Lines], List).

reverse_list([], []).
reverse_list([Head|[]], [Head]).
reverse_list([Head|Tail], Answer) :-
  reverse_list(Tail, What),
  append(What, [Head], Answer), !.

% Auxiliar predicate called from build_truth_table/2, where the line's number is calculated only once
% and passe here.
build_truth_table(0, _, _, []) :- !.
build_truth_table(QtVar, QtLines, Order, [Val|Vals]) :-
	fill_list_with_boolean_values(QtLines, [Order|Order], true, Val),
	NewQtVar is QtVar - 1,
	NewOrder is (Order / 2),
	build_truth_table(NewQtVar, QtLines, NewOrder, Vals).

% Return a list with lists who represents the truth table lines
truth_table_lines(_, 0, _, []) :- !.
truth_table_lines(TruthTable, QtLines, QtVars, [Line|Lines]) :-
	get_truth_table_line(QtLines, TruthTable, QtVars, Line),
	%formated_print(Line),
	NewQtLines is QtLines - 1,
	truth_table_lines(TruthTable, NewQtLines, QtVars, Lines).

formated_print([]) :- !.
formated_print([H|T]) :-
	write(H),
	write('  '),
	formated_print(T),
	nl.

% take the cols from the truth table and returns a specified truth table line
get_truth_table_line(_, _, 0, []) :- !.
get_truth_table_line(LineIdx, [Col|Cols], QtVars, [Val|Vals]) :-
	NewQtVars is QtVars - 1,
	nth1(LineIdx, Col, Val),
	get_truth_table_line(LineIdx, Cols, NewQtVars, Vals).

% fill a list with boolean values acording the order passed
fill_list_with_boolean_values(0, _, _, []) :- !.
fill_list_with_boolean_values(QtValues, [Order|Count], Value, [Value|T]) :-
	(Count = 1 ->
		change_bool(Value, NewValue),
		NewCount = Order;
			NewValue = Value,
			NewCount is Count - 1),
	NewQtValues is QtValues - 1,
	fill_list_with_boolean_values(NewQtValues, [Order|NewCount], NewValue, T).

% change boolean value
change_bool(Value, NewValue) :-
	(Value = true ->
		NewValue = false; NewValue = true).
