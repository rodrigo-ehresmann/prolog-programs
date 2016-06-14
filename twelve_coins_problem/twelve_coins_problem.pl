:- use_module(list_operations).
% LabeledCoins = [[1,2,[n,p,l]], [2,2,[n,p,l]], [3,2,[n,p,l]], [4,2,[n,p,l]], [5,3,[n,p,l]], [6,2,[n,p,l]], [7,2,[n,p,l]], [8,2,[n,p,l]], [9,2,[n,p,l]], [10,2,[n,p,l]], [11,2,[n,p,l]], [12,2,[n,p,l]]]

% Main predicate who must be called to solve the puzzle.
find_different_coin(Coins, Posicao, Peso) :- 
	label_coins(Coins, LabeledCoins),
	nl, show_variable('Labeled coins: ', LabeledCoins), nl,
	first_balance(LabeledCoins, FirstBalanceResult, DefinedCoinsFB, UndefinedCoinsFB),
	show_variable('First balance result: ', FirstBalanceResult),
	show_variable('Defined coins after first balance: ', DefinedCoinsFB),
	show_variable('Undefined coins after first balance: ', UndefinedCoinsFB), nl,
	((FirstBalanceResult = 1; FirstBalanceResult = 2) ->
		second_balance_if_first_is_unbalanced(DefinedCoinsFB, UndefinedCoinsFB, SecondBalanceResult, DefinedCoinsSB, UndefinedCoinsSB);
			second_balance_if_first_is_balanced(DefinedCoinsFB, UndefinedCoinsFB, SecondBalanceResult, DefinedCoinsSB, UndefinedCoinsSB)), 
	show_variable('Second balance result: ', SecondBalanceResult),
	show_variable('Defined coins after second balance: ', DefinedCoinsSB),
	show_variable('Undefined coins after second balance: ', UndefinedCoinsSB), nl,
	get_length(UndefinedCoinsSB, LenghtUndefinedCoinsSB),
	(LenghtUndefinedCoinsSB = 3 ->
		third_balance_with_3_undefined_coins(UndefinedCoinsSB, DefinedCoinsSB, ThirdBalanceResult, DefinedCoinsTB);
	LenghtUndefinedCoinsSB = 2 ->
		third_balance_with_2_undefined_coins(UndefinedCoinsSB, DefinedCoinsSB, ThirdBalanceResult, DefinedCoinsTB);
	LenghtUndefinedCoinsSB = 1 ->
		third_balance_with_1_undefined_coin(UndefinedCoinsSB, DefinedCoinsSB, ThirdBalanceResult, DefinedCoinsTB);
	write('ERROR: Wrong number of coins received for the third balance.')),
	show_variable('Third balance result: ', ThirdBalanceResult),
	show_variable('Defined coins after third balance: ', DefinedCoinsTB), nl,
	get_diferent_coin(DefinedCoinsTB, Posicao, Peso).

% Predicate who can be called for the third balance. It receive three possible heaviest coins,
% balance two of them and update their definitions, including the coin who was out of this balance.
balance_3_possible_heaviest_coins(Coins, BalanceResult, UpdatedCoins) :- 
	get_element(1, Coins, Coin1),
	get_element(2, Coins, Coin2),
	get_element(3, Coins, RemainingCoin),
	get_coin_weight(Coin1, WeightCoin1),
	get_coin_weight(Coin2, WeightCoin2),
	balance(WeightCoin1, WeightCoin2, BalanceResult),
	get_elements_to_remove_if_weighed_two_heaviest_coins(BalanceResult, ElementsToCoin1, ElementsToCoin2),
	((BalanceResult = 1; BalanceResult = 2) -> 
		ElementsToRemainingCoin = [h,l];
			ElementsToRemainingCoin = [n]),
	update_coin_definition(Coin1, ElementsToCoin1, UpdatedCoin1), 
	update_coin_definition(Coin2, ElementsToCoin2, UpdatedCoin2),
	update_coin_definition(RemainingCoin, ElementsToRemainingCoin, UpdatedRemainingCoin), % update_coin_definition/3 returns a single coin out of a list  
	insert_list_elements([UpdatedCoin1, UpdatedCoin2, UpdatedRemainingCoin], [], UpdatedCoins).

% Predicate who can be called for the third balance. It receive three possible lightest coins,
% balance two of them and update their definitions, including the coin who was out of this balance.
balance_3_possible_lightest_coins(Coins, BalanceResult, UpdatedCoins) :- 
	get_element(1, Coins, Coin1),
	get_element(2, Coins, Coin2),
	get_element(3, Coins, RemainingCoin),
	get_coin_weight(Coin1, WeightCoin1),
	get_coin_weight(Coin2, WeightCoin2),
	balance(WeightCoin1, WeightCoin2, BalanceResult),
	get_elements_to_remove_if_weighed_two_lightest_coins(BalanceResult, ElementsToCoin1, ElementsToCoin2),
	((BalanceResult = 1; BalanceResult = 2) -> 
		ElementsToRemainingCoin = [h,l];
			ElementsToRemainingCoin = [n]),
	update_coin_definition(Coin1, ElementsToCoin1, UpdatedCoin1),
	update_coin_definition(Coin2, ElementsToCoin2, UpdatedCoin2),
	update_coin_definition(RemainingCoin, ElementsToRemainingCoin, UpdatedRemainingCoin), % update_coin_definition/3 returns a single coin out of a list
	insert_list_elements([UpdatedCoin1, UpdatedCoin2, UpdatedRemainingCoin], [], UpdatedCoins).

% Predicate who can be called for the third balance. Receive two possible heaviest coins, balance them
% and update their definition.
balance_2_possible_heaviest_coins(Coins, BalanceResult, UpdatedCoins) :- 
	get_element(1, Coins, Coin1),
	get_element(2, Coins, Coin2),
	get_coin_weight(Coin1, WeightCoin1),
	get_coin_weight(Coin2, WeightCoin2),
	balance(WeightCoin1, WeightCoin2, BalanceResult),
	get_elements_to_remove_if_weighed_two_heaviest_coins(BalanceResult, ElementsToCoin1, ElementsToCoin2),
	update_coin_definition(Coin1, ElementsToCoin1, UpdatedCoin1),
	update_coin_definition(Coin2, ElementsToCoin2, UpdatedCoin2),
	insert_list_elements([UpdatedCoin1, UpdatedCoin2], [], UpdatedCoins).
	
% Predicate who can be called for the third balance. Receive two possible heaviest coins, balance them
% and update their definition.
balance_2_possible_lightest_coins(Coins, BalanceResult, UpdatedCoins) :-  
	get_element(1, Coins, Coin1),
	get_element(2, Coins, Coin2),
	get_coin_weight(Coin1, WeightCoin1),
	get_coin_weight(Coin2, WeightCoin2),
	balance(WeightCoin1, WeightCoin2, BalanceResult),
	get_elements_to_remove_if_weighed_two_lightest_coins(BalanceResult, ElementsToCoin1, ElementsToCoin2),
	update_coin_definition(Coin1, ElementsToCoin1, UpdatedCoin1),
	update_coin_definition(Coin2, ElementsToCoin2, UpdatedCoin2),
	insert_list_elements([UpdatedCoin1, UpdatedCoin2], [], UpdatedCoins).

% It makes the first balance. Split the labeled coins in three groups, balance the two first groups
% and update the definition of all coins.
first_balance(LabeledCoins, BalanceResult, DefinedCoins, UndefinedCoins) :- 
	split_list_3(LabeledCoins, Coins1, Coins2, Coins3),
	get_coins_weight(Coins1, WeightCoins1), 
	get_coins_weight(Coins2, WeightCoins2),
	balance(WeightCoins1, WeightCoins2, BalanceResult), 
	get_elements_to_remove_at_first_second_balance(BalanceResult, ElementsToCoin1, ElementsToCoin2, ElementsToCoin3), 
	update_coins_definition(Coins1, ElementsToCoin1, UpdatedCoins1), 
	update_coins_definition(Coins2, ElementsToCoin2, UpdatedCoins2),
	update_coins_definition(Coins3, ElementsToCoin3, UpdatedCoins3),
	insert_list_elements(UpdatedCoins1, UpdatedCoins2, UpdatedCoins),
	insert_list_elements(UpdatedCoins, UpdatedCoins3, UpdatedCoins_2),
	split_in_undefined_defined_coins(UpdatedCoins_2, DefinedCoins, UndefinedCoins).

% It makes the second balance, if the result of the first balance was unbalanced. Gets the group of
% the possible heaviest coins and split it in two groups with two coins each, inserting then one coin
% of the possible lightest coins in each group, transforming them in two groups of mixed coins. Balance
% the two groups and update their definitions, including the two coins who were out of this balance. 
second_balance_if_first_is_unbalanced(DefinedCoinsFB, UndefinedCoinsFB, BalanceResult, DefinedCoins, UndefinedCoins) :-
	split_in_heaviest_lightest_coins(UndefinedCoinsFB, HeaviestCoins, LightestCoins),
	split_list_2(HeaviestCoins, HCoins1, HCoins2),	
	get_element(1, LightestCoins, LCoin1),
	get_element(2, LightestCoins, LCoin2),
	insert_element(LCoin1, HCoins1, MixCoins1),
	insert_element(LCoin2, HCoins2, MixCoins2),
	delete_by_list_elements(UndefinedCoinsFB, MixCoins1, RemainingCoins),
	delete_by_list_elements(RemainingCoins, MixCoins2, RemainingCoins_2),
	get_coins_weight(MixCoins1, WeightMixCoins1),
	get_coins_weight(MixCoins2, WeightMixCoins2),
	balance(WeightMixCoins1, WeightMixCoins2, BalanceResult),
	get_elements_to_remove_at_first_second_balance(BalanceResult, ElementsToMixCoins1, ElementsToMixCoins2, _),
	((BalanceResult = 1; BalanceResult = 2) ->
		ElementsToRemainingCoins = [l]; ElementsToRemainingCoins = []), % If balanced, the remaining coins are normal, else, they continue how possible lightest coins and must be balanced at the third balance
	update_coins_definition(MixCoins1, ElementsToMixCoins1, UpdatedMixCoins1),
	update_coins_definition(MixCoins2, ElementsToMixCoins2, UpdatedMixCoins2),
	update_coins_definition(RemainingCoins_2, ElementsToRemainingCoins, UpdatedRemainingCoins_2),
	insert_list_elements(UpdatedMixCoins2, UpdatedMixCoins1, MixCoins3),
	insert_list_elements(UpdatedRemainingCoins_2, MixCoins3, MixCoins4),
	insert_list_elements(MixCoins4, DefinedCoinsFB, MixCoins5),
	split_in_undefined_defined_coins(MixCoins5, DefinedCoins, UndefinedCoins).

% It makes the  second balance, if the result of the first balance was balanced. It forms two groups
% wich three coins each, one only with undefined coins and other only whit normal coins. Balance the
% two groups and update the coins, including the coins who was out of this balance.	
second_balance_if_first_is_balanced(DefinedCoinsFB, UndefinedCoinsFB, BalanceResult, DefinedCoins, UndefinedCoins) :-
	get_list_elements(3, UndefinedCoinsFB, SampleUCoins),
	get_list_elements(3, DefinedCoinsFB, SampleNCoins),
	delete_by_list_elements(UndefinedCoinsFB, SampleUCoins, RemainingCoin),
	get_coins_weight(SampleUCoins, WeightSampleUCoins),
	get_coins_weight(SampleNCoins, WeightSampleNCoins),
	balance(WeightSampleUCoins, WeightSampleNCoins, BalanceResult),
	get_elements_to_remove_at_first_second_balance(BalanceResult, ElementsToSampleUCoins, _, _),
	((BalanceResult = 1; BalanceResult = 2) -> ElementsToRemainingCoin = [h,l];
		ElementsToRemainingCoin = []), % If unbalanced, the remaining coin is normal, else, it stay with the same definition and must be balanced at the third balance
	update_coins_definition(SampleUCoins, ElementsToSampleUCoins, UpdatedSampleUCoins),	
	update_coins_definition(RemainingCoin, ElementsToRemainingCoin, UpdatedRemainingCoin),
	insert_list_elements(UpdatedSampleUCoins, UpdatedRemainingCoin, MixCoins),
	insert_list_elements(MixCoins, DefinedCoinsFB, UpdatedMixCoins), 
	split_in_undefined_defined_coins(UpdatedMixCoins, DefinedCoins, UndefinedCoins).

% It makes the third balance, if received only three undefined coins of the second balance. Balance
% two coins of the same weith and update them, including the coin who was out of this balance.
third_balance_with_3_undefined_coins(UndefinedCoinsSB, DefinedCoinsSB, BalanceResult, DefinedCoins) :- 
	split_in_heaviest_lightest_coins(UndefinedCoinsSB, HeaviestCoins, LightestCoins),
	get_length(HeaviestCoins, LenghtHeaviestCoins),
	get_length(LightestCoins, LenghtLightestCoins), 
	(LenghtHeaviestCoins = 0 -> % If true, it means that have received three possible lightest coins
		balance_3_possible_lightest_coins(UndefinedCoinsSB, BalanceResult, UpdatedCoins),
		insert_list_elements(UpdatedCoins, DefinedCoinsSB, DefinedCoins);
	LenghtLightestCoins = 0 -> % If true, it means that have received three possible heaviest coins
		balance_3_possible_heaviest_coins(UndefinedCoinsSB, BalanceResult, UpdatedCoins),
		insert_list_elements(UpdatedCoins, DefinedCoinsSB, DefinedCoins);
	(LenghtHeaviestCoins = 2 -> 
		balance_2_possible_heaviest_coins(HeaviestCoins, BalanceResult, UpdatedCoins), 
		((BalanceResult = 1; BalanceResult = 2) -> 
			ElementsToRemainingCoin = [h,l];
				ElementsToRemainingCoin = [n]),
		update_coins_definition(LightestCoins, ElementsToRemainingCoin, UpdatedRemainingCoins),
		insert_list_elements(UpdatedCoins, UpdatedRemainingCoins, UpdatedCoins_2),
		insert_list_elements(UpdatedCoins_2, DefinedCoinsSB, DefinedCoins);
	LenghtLightestCoins = 2 ->
		balance_2_possible_lightest_coins(LightestCoins, BalanceResult, UpdatedCoins),
		((BalanceResult = 1; BalanceResult = 2) -> 
			ElementsToRemainingCoin = [h,l];
				ElementsToRemainingCoin = [n]),
	update_coins_definition(HeaviestCoins, ElementsToRemainingCoin, UpdatedRemainingCoins),
	insert_list_elements(UpdatedCoins, UpdatedRemainingCoins, UpdatedCoins_2),
	insert_list_elements(UpdatedCoins_2, DefinedCoinsSB, DefinedCoins);
	false)).	 

% It makes the third balance, if received only two undefined coins of the second balance. Balance them
% and update their definitions.
third_balance_with_2_undefined_coins(UndefinedCoinsSB, DefinedCoinsSB, BalanceResult, DefinedCoins) :- 
	split_in_heaviest_lightest_coins(UndefinedCoinsSB, HeaviestCoins, LightestCoins),
	get_length(HeaviestCoins, LenghtHeaviestCoins), 
	get_length(LightestCoins, LenghtLightestCoins), 
	(LenghtHeaviestCoins = 0 ->
		balance_2_possible_lightest_coins(LightestCoins, BalanceResult, UpdatedCoins);
	LenghtLightestCoins = 0 ->
		balance_2_possible_heaviest_coins(HeaviestCoins, BalanceResult, UpdatedCoins)),
	insert_list_elements(UpdatedCoins, DefinedCoinsSB, DefinedCoins).

% It makes the third balance, if received only one undefined coin of the second balance. Balance this
% coin against a normal coin and update its definition.
third_balance_with_1_undefined_coin(UndefinedCoinsSB, DefinedCoinsSB, BalanceResult, DefinedCoins) :- 
	get_element(1, UndefinedCoinsSB, UndefinedCoin),
	get_element(1, DefinedCoinsSB, DefinedCoin),
	get_coin_weight(UndefinedCoin, WeightUndefinedCoin),
	get_coin_weight(DefinedCoin, WeightDefinedCoin),
	balance(WeightUndefinedCoin, WeightDefinedCoin, BalanceResult),
	(BalanceResult = 1 -> 
		update_coin_definition(UndefinedCoin, [n,l], UpdatedUndefinedCoin);
	BalanceResult = 2 -> 
		update_coin_definition(UndefinedCoin, [n,h], UpdatedUndefinedCoin);
	write('ERROR: The undefined coin remaining have not the correct state of definition.'), false),
	insert_list_elements([UpdatedUndefinedCoin], DefinedCoinsSB, DefinedCoins).		 

% It makes the final step of the puzzle, analyzing al the coins, getting the position and weight of
% the diferent coin.
get_diferent_coin([], Position, Weight).
get_diferent_coin([Head|DefinedCoins], Position, Weight) :-
	get_element(3, Head, CoinDef),
	not(is_member(n, CoinDef)),
	get_element(1, Head, Position),
	get_element(1, CoinDef, Weight).
get_diferent_coin([Head|DefinedCoins], Position, Weight) :-
	get_diferent_coin(DefinedCoins, Position, Weight).

% It gets the elements who must be removed of the coin's definition, in any result balance of two 
% possible heaviest coins.
get_elements_to_remove_if_weighed_two_heaviest_coins(BalanceResult, ElementsToCoin1, ElementsToCoin2) :-
	(BalanceResult = 1 -> 
		ElementsToCoin1 = [n,l], 
		ElementsToCoin2 = [h,l];
			BalanceResult = 2 ->
				ElementsToCoin1 = [h,l], 
				ElementsToCoin2 = [n,l];
					BalanceResult = 3 -> 
						ElementsToCoin1 = [h,l], 
						ElementsToCoin2 = [h,l]).

% It gets the elements who must be removed of the coin's definition, in any result balance of two 
% possible lightest coins.
get_elements_to_remove_if_weighed_two_lightest_coins(BalanceResult, ElementsToCoin1, ElementsToCoin2) :-
	(BalanceResult = 1 -> 
		ElementsToCoin1 = [h,l], 
		ElementsToCoin2 = [n,h];
			BalanceResult = 2 ->
				ElementsToCoin1 = [n,h], 
				ElementsToCoin2 = [h,l];
					BalanceResult = 3 -> 
						ElementsToCoin1 = [h,l], 
						ElementsToCoin2 = [h,l]).

% Get a list of mixed coins and split it in two lists, one of undefined and other of defined coins.
split_in_undefined_defined_coins([], [], []).
split_in_undefined_defined_coins([Head1|Tail1], [Head1|Defined], Undefined) :-
	is_coin_defined(Head1),
	split_in_undefined_defined_coins(Tail1, Defined, Undefined).
split_in_undefined_defined_coins([Head1|Tail1], Defined, [Head1|Undefined]) :-
    not(is_coin_defined(Head1)),
    split_in_undefined_defined_coins(Tail1, Defined, Undefined).

% Get a list of mixed coins and split it in two lists, one of the possible heaviest and other of 
% the possible lightest coins.
split_in_heaviest_lightest_coins([], [], []).
split_in_heaviest_lightest_coins([Head1|Tail1], [Head1|Heaviest], Lightest) :-
    get_element(3, Head1, CoinDef),
	is_member(h, CoinDef),
    split_in_heaviest_lightest_coins(Tail1, Heaviest, Lightest).
split_in_heaviest_lightest_coins([Head1|Tail1], Heaviest, [Head1|Lightest]) :-
    get_element(3, Head1, CoinDef),
	is_member(l, CoinDef),
    split_in_heaviest_lightest_coins(Tail1, Heaviest, Lightest).

% Check the type of the coins definition.
% (u = totally undefined; l = possible lightest coins; h = possible heaviest coin; d = defined coin)
check_type_coin_definition(Coin, Type) :-
	get_element(3, Coin, CoinDef),
	get_length(CoinDef, Length),
	(Length = 3 ->
		Type = u; 
			(Length = 2, is_member(l, CoinDef)) ->
				Type = l; 
					(Length = 2, is_member(h, CoinDef)) ->
						Type = h; 
							Length = 1 ->
								Type = d).

% Return true or false, depending if the coin is or not defined.
is_coin_defined(Coin) :-
	get_element(3, Coin, CoinDef),
	get_length(CoinDef, Lenght),
	Lenght = 1.

% Receive a list of coins and update its definitions. 
% OBS: receive and return a list, even if is with only one coin.
update_coins_definition([], _, []).
update_coins_definition([Head1|Tail1], ElementsToRemove, [Head2|Tail2]) :-
	update_coin_definition(Head1, ElementsToRemove, Head2),
	update_coins_definition(Tail1, ElementsToRemove, Tail2).

% Receive a coin and update it definition.
% OBS: receive and return a labeled coin.
update_coin_definition(Coin, ElementsToRemove, UpdatedCoin) :-
	get_element(3, Coin, CoinDef),
	delete_by_position(3, Coin, NewCoin) ,
	delete_by_list_elements(CoinDef, ElementsToRemove, UpdatedCoinDef),
	insert_element_by_position(3, UpdatedCoinDef, NewCoin, UpdatedCoin).


% Gived a list with rotulated coins ([position, weight, definition]), return the total weight of 
% the coin's list.
get_coins_weight(LabeledCoins, Weight) :-
	get_length(LabeledCoins, QtCoins),
	get_coins_weight(LabeledCoins, QtCoins, Weight).

% Auxiliar predicate used by get_coins_weight/2.
get_coins_weight(LabeledCoins, 0, 0).
get_coins_weight(LabeledCoins, QtCoins, Weight) :-
	get_element(QtCoins, LabeledCoins, Coin), 
	get_coin_weight(Coin, CoinValue),
	NewQtCoins is QtCoins - 1, 
	get_coins_weight(LabeledCoins, NewQtCoins, Aux),
	Weight is CoinValue + Aux.

% Receive a coins and return it weight.
get_coin_weight(Coin, Weight) :-
	get_element(2, Coin, Weight).
	
% Balance two weights and see if they are balanced or unbalanced 
% (1 = hanging to left, 2 = hanging to right, 3 = balanced)	
balance(Weight1, Weight2, Result) :- 
	(Weight1 > Weight2 -> Result = 1; Weight2 > Weight1 -> Result = 2; Result = 3).

% Based in the result of the balance of two coin's list at the first and second balance, returns 
% what difinition need to be removed em both lists, including the third list when is the first balance.	
get_elements_to_remove_at_first_second_balance(BalanceResult, ElementsToCoin1, ElementsToCoin2, ElementsToCoin3) :-
	(BalanceResult = 1 -> 
		ElementsToCoin1 = [l], ElementsToCoin2 = [h], ElementsToCoin3 = [h,l]; 
		BalanceResult = 2 -> 
			ElementsToCoin1 = [h], ElementsToCoin2 = [l], ElementsToCoin3 = [h,l]; 
			BalanceResult = 3 -> 
				ElementsToCoin1 = [h,l], ElementsToCoin2 = [h,l], ElementsToCoin3 = []).

% Print the value of the variable specified (used for debugging).
show_variable(Label, Variable) :- 
	writef('%w%w', [Label, Variable]), nl.

% Gived a list of coins, return a list with labeled coins (coin = [position, weight, definition]).
% Example: [[1,2,[n,h,l]], [2,3,[n,h,l]],].
label_coins(Coins, LabeledCoins) :-
	get_length(Coins, QtCoins),
	label_coins(Coins, QtCoins, LabeledCoins).

% Auxiliar predicate used by label_coins/2.
label_coins(Coins, 0, []).
label_coins(Coins, Position, LabeledCoins) :-
	get_element(Position, Coins, Coin),
	NewPosition is (Position - 1),
	label_coins(Coins, NewPosition, List), 
	LabeledCoin = [Position, Coin, [n, h, l]],
	insert_element_by_position(Position, LabeledCoin, List, LabeledCoins).	
	
