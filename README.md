# Description
Puzzle solvers and other utilities developed with Prolog.

Implemented using SWI-Prolog version 6.6.4 for amd64.

## Twelve Coins Problem
Non generic implementation of a solver for the coins problem ([ballance puzzle](https://en.wikipedia.org/wiki/Balance_puzzle)), allowed to work with and oly with twelve coins, finding the coin whit different weight.

In this implementation, considers that the representation of a coin is the list with the format *[coin_index, coin_weight, coins_definition]*, and that the coins options are the static list *[n,h,l]*, where *n* is normal, *h* is heaviest and *l* is lighter.

#### Usage
Call the *find_different_coin* predicate, informing a list with the coins weight, and returning the position of the different coin and its definition:

```prolog
?- find_different_coin([2,2,2,2,2,2,2,2,9,2,2,2], Position, Definition).
```
## Boolean Satisfability
Solver implementation for (boolean satisfability problem)[https://en.wikipedia.org/wiki/Boolean_satisfiability_problem] using non chronological backtracking ([bakcjumping](https://en.wikipedia.org/wiki/Backjumping)) technique.



#### Usage
