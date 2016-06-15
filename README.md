# Description
Puzzle solvers and other utilities developed with Prolog.

Implemented using SWI-Prolog version 6.6.4 for amd64.

## Twelve Coins Problem
Non generic implementation of a solver for the coins problem ([ballance puzzle](https://en.wikipedia.org/wiki/Balance_puzzle)), allowed to work with and only with twelve coins, finding the coin whit different weight.

In this implementation, consider that the representation of a coin is the list with the format *[coin_index, coin_weight, coins_definition]*, and that the coins options are the static list *[n,h,l]*, where *n* is normal, *h* is heaviest and *l* is lighter.

#### Usage
Call the *find_different_coin/3* predicate, informing a list with the coins weight, and returning the position of the different coin and its definition:

```prolog
?- find_different_coin([2,2,2,2,2,2,2,2,9,2,2,2], Position, Definition).
```

## Boolean Satisfability Problem
Solver implementation for [boolean satisfability problem](https://en.wikipedia.org/wiki/Boolean_satisfiability_problem) using non chronological backtracking ([bakcjumping](https://en.wikipedia.org/wiki/Backjumping)) technique.

In this implementation, the logical formula is in [CNF](https://fairmut3x.wordpress.com/2011/07/29/cnf-conjunctive-normal-form-dimacs-format-explained/) format, but only supports OR(v) logic operation. Consider that every atom is represented like *x1, x2, x3, ..., xN*, a negation is *~* and came before an atom name and the OR operation is *#*. Every logical expression need to be between parenthesis.

#### Usage
Call the *sat/1* predicate informing a CNF formula quoted, corresponding with the representation descripted above:

```prolog
?- sat("(x1 # x2) # (~x1)").
```
The output it will be printed in the console, informing the total time execution, number of atom instantiations and if the logic formula is sat (true) or unsat (false).

## Truth Table
Buil a truth table according the number of variables informed (doesn't supports propositional logic formulas).

#### Usage
Call the *build_truth_table/2* informing the number of variables to be used:

```prolog
?- build_truth_table(5, Columns).
```
The output it will be a list with lists, where each one represents a column of the table.
