:- module(list_operations,[delete_by_position/3, 
						   delete_by_element/3, 
						   insert_element_by_position/4, 
						   get_length/2,
						   split_list_3/4,
						   get_element/3,
						   delete_by_list_elements/3,
						   is_member/2,
						   insert_element/3,
						   insert_list_elements/3,
						   split_list_2/3,
						   get_list_elements/3,
						   concatenate_2/3
						   ]).
	
% Delete an element from a list, specifying its position.
delete_by_position(1, [Head|Tail], Tail). 
delete_by_position(Position, [Head|Tail], [Head|Result]):-  
	NewPosition is Position - 1,
	delete_by_position(NewPosition, Tail, Result).
	
% Delete an element from a list, specifying it.
delete_by_element(Element, [Element|Tail], Tail).
delete_by_element(Element, [Head|Tail], [Head|Result]) :- 
	delete_by_element(Element, Tail, Result).
	
% Insert an element into a list, specifying the desirable position who it must be inserted.
insert_element_by_position(1, Element, List, [Element|List]).
insert_element_by_position(Position, Element, [Head|Tail], [Head|Result]) :- 
    NewPosition is Position - 1,
    insert_element_by_position(NewPosition, Element, Tail, Result).

% Get list length.
get_length([],0).
get_length([_|Tail],X) :-
	get_length(Tail,Y),
	X is Y + 1.

% Gived a list, split it in others two.
split_list_2([], [], []).
split_list_2([Head1|Tail1], [Head1|Tail2], List3) :-
	split_list_2(Tail1, List3, Tail2).
		
% Split one list in three other lists.
split_list_3([], [], [], []).
split_list_3([H|T], [H|L1], L2, L3):- 
	split_list_3(T, L3, L1, L2).

% Gived two lists, concatenate them in a theerd list.
concatenate_2([], List2, List2).
concatenate_2([Head1|Tail1], List2, [Head1|Tail3]) :- 
	concatenate_2(Tail1, List2, Tail3).

% Get an element of the list, specifyin its position.
get_element(1,[Head|_],Head).
get_element(Position,[_|Tail],Element) :- 
	get_element(NewPosition,Tail,Element), 
	Position is NewPosition + 1.

% Get a determined quantity of elements of a list.
get_list_elements(0, _, []).
get_list_elements(Quantity, [Head1|Tail1], [Head1|Tail2]) :-
	NewQuantity is Quantity -1,
	get_list_elements(NewQuantity, Tail1, Tail2).
	

% Specify in List2 a list of elements who must be removed, and return a List3 without these elements.		
delete_by_list_elements([], _, []).
delete_by_list_elements([Head|Tail], List2, List3) :-
        is_member(Head, List2),
        !,
        delete_by_list_elements(Tail, List2, List3).
delete_by_list_elements([Head|Tail1], List2, [Head|Tail3]) :-
        delete_by_list_elements(Tail1, List2, Tail3).

% Check if an element is member of a list.
is_member(Element, [Element|_]).
is_member(Element, [Head|Tail]) :-
	 is_member(Element, Tail).

% Insert an element in the head position of a list.
insert_element(Item, List, [Item|List]).

% Insert a list of elements in other list.
insert_list_elements([], List, List).
insert_list_elements([Head1|Tail1], List, [Head1|Tail2]) :-
	insert_list_elements(Tail1, List, Tail2).