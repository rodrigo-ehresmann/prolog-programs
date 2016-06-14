% Formula is a CNF formula in the format: "() & ()", where all atoms need be named x1, x2, x3, ..., xN.
sat(Formula) :-
	get_time(StartTime),
	reset_facts_base,
	string_codes(Formula, Codes),
	find_atoms(Codes, Atoms),
	normalize_atoms(Atoms, NAtoms),
	most_restricted_variable(NAtoms, MostRestAtom),
	get_formula_pieces(Codes, FPieces),
	order_formula_pieces(FPieces, MostRestAtom, ReorderedFPieces), % Where the Reordered FPieces are already lists with the atoms of the  FPieces
	(is_satisfiable(ReorderedFPieces) ->
		info('Sat', StartTime);
			info('Unsat', StartTime)).

% Keeps only the atoms, removing the negations
normalize_atoms([], []).
normalize_atoms([Atom|Atoms], [NAtom|NAtoms]) :-
	(member(126, Atom)
	-> remove_first(Atom, NAtom),
	   normalize_atoms(Atoms, NAtoms)
	;  NAtom = Atom),
	normalize_atoms(Atoms, NAtoms).

% Orders the formula pieces according the most restricted atom, returning already lists with the atoms of the FPieces
order_formula_pieces([], _, []).
order_formula_pieces([FPiece|FPieces], MostRestAtom, [ReorderedPiece|ReorderedPieces]) :-
	order_formula_pieces(FPieces, MostRestAtom, ReorderedPieces),
	find_atoms(FPiece, Atoms),
	order_atoms(MostRestAtom, Atoms, ReorderedPiece).

% Reorders a list of atoms, putting the most restricted atom, if exists in the list, at the first position of the list.
% The if is necessary to check if exists the atom in the non negated form or negated form
order_atoms(MostRestAtom, Atoms, ReorderedAtoms) :-
	(member(MostRestAtom, Atoms) ->
		Aux = MostRestAtom;
			insert_first(126, MostRestAtom, Aux),
			member(Aux, Atoms)),
	delete_by_element(Aux, Atoms, As),
	insert_first(Aux, As, ReorderedAtoms), !.
order_atoms(MostRestAtom, Atoms, ReorderedAtoms) :-
	ReorderedAtoms = Atoms, !.

% Delete an element from a list, specifying it.
delete_by_element(Element, [Element|Tail], Tail).
delete_by_element(Element, [Head|Tail], [Head|Result]) :-
	delete_by_element(Element, Tail, Result).

% Check if each one of the formula pieces is satisfiable
is_satisfiable([]).
is_satisfiable([FPiece|FPieces]) :-
	test_piece(FPiece, FPiece), !,
	is_satisfiable(FPieces).
is_satisfiable([FPiece|FPieces]) :-
	try_change_value(FPiece, AtomChanged),
	findall(X, atom_affects(AtomChanged, X), AffectedFPieces),
	retest_pieces(AffectedFPieces),
	is_satisfiable(FPieces).

% Test one formula piece checking if it's satisfiable
test_piece([], FPiece) :- fail. % If list empty, none of the atoms are true, so the predicate fail
test_piece([Atom|Atoms], FPiece) :- % Basically, check if is an atom and have Value = true
	not(member(126, Atom)), % Check if is not a negated atom
	(not(atom_affects(Atom, FPiece)) ->
		assertz(atom_affects(Atom, FPiece)); true), % Write a fact if he doesn't exists yet
	atom_value(Atom, Value),
	Value = true, !.
test_piece([Atom|Atoms], FPiece) :- % Basically, if the atom is valued, call again test_piece trying a new atom
	not(member(126, Atom)),
	atom_value(Atom, _), !,
	test_piece(Atoms, FPiece).
test_piece([Atom|Atoms], FPiece) :- % Basically, write two facts, from the atom and its negated version with their respective values
	not(member(126, Atom)),
	not(atom_value(Atom, _)),
	assertz(atom_value(Atom, true)),
	assertz(negated_atom_value(Atom, false)),
	add_instance, !.
test_piece([Atom|Atoms], FPiece) :- % From here down to the last test_piece the same tings are made, but yet with negated atoms
	remove_first(Atom, A), % Remove the first code because negated atoms start with "~", and it's necessary write and check only the atom name in the facts base
	(not(atom_affects(A, FPiece)) ->
		assertz(atom_affects(A, FPiece)); true),
	negated_atom_value(A, Value),
	Value = true, !.
test_piece([Atom|Atoms], FPiece) :- % If is literal, check if have value and make recursive call
	remove_first(Atom, A),
	negated_atom_value(A, _), !,
	test_piece(Atoms, FPiece).
test_piece([Atom|Atoms], FPiece) :- % If is a literal, write facts with the value from the literal and its atom
	member(126, Atom),
	remove_first(Atom, A),
	not(negated_atom_value(A, _)),
	assertz(atom_value(A, false)),
	assertz(negated_atom_value(A, true)),
	add_instance, !.

% Try change the value frome one atom that has't its value changed yet
try_change_value([], _) :- !, false.
try_change_value([Atom|Atoms], Atom) :- % Try with a non negated atom
	not(member(126, Atom)),
	not(atom_changed(Atom)),
	add_instance,
	atom_value(Atom, Value),
	change_bool(Value, NewValue),
	retract(atom_value(Atom, _)),
	assertz(atom_value(Atom, NewValue)),
	retract(negated_atom_value(Atom, _)),
	assertz(negated_atom_value(Atom, Value)),
	assertz(atom_changed(Atom)), !.
try_change_value([Atom|Atoms], A) :- % Try with a negated atom
	member(126, Atom),
	remove_first(Atom, A),
	not(atom_changed(A)),
	add_instance,
	negated_atom_value(A, Value),
	change_bool(Value, NewValue),
	retract(negated_atom_value(A, _)),
	assertz(negated_atom_value(A, NewValue)),
	retract(atom_value(A, _)),
	assertz(atom_value(A, Value)),
	assertz(atom_changed(A)), !.
try_change_value([Atom|Atoms], AtomChanged) :-
	try_change_value(Atoms, AtomChanged).

% Retest pieces afected for an atom who was changed
retest_pieces([]).
retest_pieces([AffectedFPiece|AffectedFPieces]) :-
	test_piece(AffectedFPiece, AffectedFPiece), !.
retest_pieces([AffectedFPiece|AffectedFPieces]) :- % If piece retested isn't satisfiable, try change one of its atoms and retest afected pieces again
	try_change_value(AffectedFPiece, AtomChanged),
	findall(X, atom_affects(AtomChanged, X), NewAffectedFPieces),
	retest_pieces(NewAffectedFPieces).

add_instance :-
	instances(I),
	retractall(instances(_)),
	NewI is I + 1,
	assertz(instances(NewI)).

info(IsSat, StartTime) :-
	instances(I),
	get_time(EndTime),
	TotalTime is EndTime - StartTime,
	writef('%w%w', ['Tempo de execução: ', TotalTime]), nl,
	writef('%w%w', ['Instanciações: ', I]), nl,
	write(IsSat).

reset_facts_base :-
	retractall(atom_value(_, _)),
	retractall(negated_atom_value(_, _)),
	retractall(atom_changed(_)),
	retractall(atom_afect_piece(_, _)),
	retractall(instances(_)),
	retractall(atom_affects(_, _)),
	assertz(instances(0)).

% Find negatet and non negated atoms from a list of codes
find_atoms([], []).
find_atoms([Code|Codes], [Atom|Atoms]) :-
	(Code = 120; Code = 126),
	find_atom_pieces(Codes, Code, AtomPieces),
	insert_first(Code, AtomPieces, Atom),
	(Code = 120 ->
		NextCodes = Codes;
			Code = 126 ->
				remove_first(Codes, NextCodes)), % It's necessary because if is a non negated atom, the negation's code must be removed that in the next loop the same atom it's not identified again, yet in its non negated form
	find_atoms(NextCodes, Atoms),
	!.
find_atoms([Code|Codes], Atoms) :-
	find_atoms(Codes, Atoms).

% Identified an atom, predicate find_atoms call this to get the rest of the atom name, who can be numbers or 'x' followed by numbers
find_atom_pieces([], _, []).
find_atom_pieces([Code|Codes], StartCode, [Code|AtomPieces]) :-
	(StartCode = 120 ->
		(Code >= 48, Code =< 57);
			StartCode = 126 ->
				(Code = 120; Code >= 48, Code =< 57)),
	find_atom_pieces(Codes, StartCode, AtomPieces),
	!.
find_atom_pieces([Code|Codes], StartCode, AtomPieces) :-
	find_atom_pieces([], StartCode, AtomPieces).

% Get formula pieces, splited in parenthesis at the entry
get_formula_pieces(Codes, Pieces) :-
	find_open_parenthesis(Codes, Pieces).

% Called from get_formula_pieces
find_open_parenthesis([], []) :- !.
find_open_parenthesis([Code|Codes], [C|Cs]) :-
	Code = 40,
	find_close_parenthesis(Codes, C),
	find_open_parenthesis(Codes, Cs), !.
find_open_parenthesis([Code|Codes], Contents) :-
	find_open_parenthesis(Codes, Contents), !.

% Called from find_close_parenthesis
find_close_parenthesis([], []).
find_close_parenthesis([Code|Codes], [Code|Cs]) :-
	not(Code = 41),
	find_close_parenthesis(Codes, Cs).
find_close_parenthesis([C|S], []).

% change boolean value
change_bool(Value, NewValue) :-
	(Value = true ->
		NewValue = false; NewValue = true).

remove_first([H|T], T).

insert_first(Element, [H|List], [Element, H| List]).

remove_repeated_elements([], []).
remove_repeated_elements([H|T], [H|T2]) :-
	not(member(H, T)),
	remove_repeated_elements(T, T2), !.
remove_repeated_elements([H|T], List) :-
	remove_repeated_elements(T, List).

most_restricted_variable(ListIn, V) :-
    sort(ListIn, SortedList),
    maplist(count(ListIn), SortedList, ListKeys), % Return each element with number of times that its repeated in the list, at the format -NumberOfTimes-ElementName
    keysort(ListKeys, [_-V|_Vs]).
count(List, Elm, Key-Elm) :-
    aggregate(count, member(Elm, List), Count), % Count the number of occurrences of each element in the list.
    Key is -Count.
