(* data type *)
datatype rank = Jack | Queen | King | Ace | Num of int;

(* basic version: the point of Ace is 1 *)
(* magic version: the point of Ace is 1 or 11*)

(* Problem 1 *)
(* compute the point for basic version *)
(* input: a rank *)
(* output: the basic point of the rank *)
fun get_basic_point

(* Problem 2 *)
(* get the cards of Player 1 *)
(*
** input: the number of cards for player 1
**        the number of cards for player 2
**        the common rank list for two players
*)
(* output: (the drawn cards of player 1, the drawn cards of player 2) *)
(* n1 + n2 is smaller than the number of cards *)
(* n1 and n2 are positive *)
fun get_cards 

(* Problem 3 *)
(* tanslate the sum of points to TP by objective function *)
(* the tool used by other functions *)
(* input: the sum of points for all cards *)
(* output: the TP computed by objective function *)
fun cal_TP 

(* Problem 4 *)
(* compute the TP for basic version *)
(* input: a rank list *)
(* output: the TP for basic version *)
fun get_basic_TP 

(* Problem 5 *)
(* compute TP considering the different choices of Ace for magic version *)
(* input: a rank list *)
(* output: the TP for magic version *)
fun get_TP 

(* Problem 6 *)
(* judge winner by the given rank lists of players *)
(*
** input: (the drawn cards of player 1, the drawn cards of player 2)
*)
(*
** output: 1 (player 1 wins) or
**         2 (player 2 wins) or
**         0 (tie)
*)
fun judge_winner_basic 

(* Problem 7 *)
(* judge winner by the given rank lists of players *)
(*
** input: (the drawn cards of player 1, the drawn cards of player 2)
*)
(*
** output: 1 (player 1 wins) or
**         2 (player 2 wins) or
**         0 (tie)
*)
fun judge_winner 

(* Problem 8 *)
(* judge winner by the number of drawn cards and the rank list *)
(* n1 + n2 is smaller than the number of cards *)
(* n1 and n2 are positive *)
(*
** input: the number of cards for player 1
**        the number of cards for player 2
**        the common rank list for two players
*)
(*
** output: 1 (player 1 wins) or
**         2 (player 2 wins) or
**         0 (tie)
*)
fun basic_result 

(* Problem 9 *)
(* judge winner by the number of drawn cards and the rank list *)
(* n1 + n2 is smaller than the number of cards *)
(* n1 and n2 are positive *)
(*
** input: the number of cards for player 1
**        the number of cards for player 2
**        the common rank list for two players
*)
(*
** output: 1 (player 1 wins) or
**         2 (player 2 wins) or
**         0 (tie)
*)
fun result 

(* Problem 10 *)
(* magic version *)
(* judge the largest TP which can be gotten by player 2 with any legal number of drawn cards *)
(*
** input: the number of cards for player 1
**        the common rank list for two players
*)
(* output: the largest TP *)
fun cal_largest_TP 















