(*
* CSCI3180 Principles of Programming Languages
*
* --- Declaration ---
*
* I declare that the assignment here submitted is original except for source
* material explicitly acknowledged. I also acknowledge that I am aware of
* University policy and regulations on honesty in academic work, and of the
* disciplinary guidelines and procedures applicable to breaches of such policy
* and regulations, as contained in the website
* http://www.cuhk.edu.hk/policy/academichonesty/
*
* Assignment 4
* Name : Taneja Nikunj
* Student ID : 1155123371
* Email Addr : ntaneja9@cse.cuhk.edu.hk
*)

(* data type *)
datatype rank =  Jack | Queen | King | Ace | Num of int;

(* basic version: the point of Ace is 1 *)
(* magic version: the point of Ace is 1 or 11*)

(* Problem 1 *)
(* compute the point for basic version *)
(* input: a rank *)
(* output: the basic point of the rank *)
fun get_basic_point (r: rank) =  
    case r of 
        Ace                   => 1
    |   (Jack | King | Queen) => 10
    |   (Num x)               => x;

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

fun get_cards ((n1: int), (n2: int), (card_list: rank list)) = (
    let 
        fun get_cards_helper ((n1: int), (n2: int), (card_list: rank list), (player1_list: rank list), (player2_list: rank list)) = (
            case (n1, n2) of
                (0, 0) => (player1_list, player2_list)
            |   (0, _) => get_cards_helper(n1, n2-1, tl(card_list), player1_list, player2_list @ [hd(card_list)])
            |   (_, 0) => get_cards_helper(n1-1, n2, tl(card_list), player1_list @ [hd(card_list)], player2_list)
            |   (_, _) => get_cards_helper(n1-1, n2-1, tl(tl(card_list)), player1_list @ [hd(card_list)], player2_list @ [hd(tl(card_list))])
        )
    in 
        get_cards_helper(n1, n2, card_list, [], [])
    end
)

(* Problem 3 *)
(* tanslate the sum of points to TP by objective function *)
(* the tool used by other functions *)
(* input: the sum of points for all cards *)
(* output: the TP computed by objective function *)
fun cal_TP (sp: int) =
    if sp > 0 andalso (sp mod 21) = 0 then 21 else sp mod 21;

(* Problem 4 *)
(* compute the TP for basic version *)
(* input: a rank list *)
(* output: the TP for basic version *)
fun get_basic_TP ((cards: rank list)) = (
    let
        fun get_basic_TP_helper((cards: rank list), (tp_so_far): int) = (
            case length(cards) of
                0 => tp_so_far
            |   _ => get_basic_TP_helper(tl(cards), tp_so_far + get_basic_point(hd(cards)))
        )
    in 
        get_basic_TP_helper(cards, 0)
    end
)

(* Problem 5 *)
(* compute TP considering the different choices of Ace for magic version *)
(* input: a rank list *)
(* output: the TP for magic version *)
fun get_TP ((cards: rank list)) = (
    let 
        fun max((a: int), (b: int)) = if a >= b then a else b
    in 
        case length(cards) of
            0 => 0
        |   _ => (
            case hd(cards) of 
                Ace => max(cal_TP(11 + get_TP(tl(cards))), cal_TP(1 + get_TP(tl(cards))))
            |   _   => cal_TP(get_basic_point(hd(cards)) + get_TP(tl(cards)))
        )
    end 
)

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
fun judge_winner_basic((p1_cards: rank list), (p2_cards: rank list)) = 
    let
        val (p1_tp, p2_tp) = (get_basic_TP(p1_cards), get_basic_TP(p2_cards))
    in
        if p1_tp > p2_tp then 1
        else if p1_tp < p2_tp then 2
        else 0
    end;

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
fun judge_winner ((p1_cards: rank list), (p2_cards: rank list)) = 
    let
        val (p1_tp, p2_tp) = (get_TP(p1_cards), get_TP(p2_cards))
    in
        if p1_tp > p2_tp then 1
        else if p1_tp < p2_tp then 2
        else 0
    end;

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
fun basic_result ((n1: int), (n2: int), (card_list: rank list)) = (
    let 
        val (p1_cards, p2_cards) = get_cards(n1, n2, card_list)
    in
        judge_winner_basic(p1_cards, p2_cards)
    end
)

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
fun result ((n1: int), (n2: int), (card_list: rank list)) = (
    let 
        val (p1_cards, p2_cards) = get_cards(n1, n2, card_list)
    in
        judge_winner(p1_cards, p2_cards)
    end
)

(* Problem 10 *)
(* magic version *)
(* judge the largest TP which can be gotten by player 2 with any legal number of drawn cards *)
(*
** input: the number of cards for player 1
**        the common rank list for two players
*)
(* output: the largest TP *)
fun cal_largest_TP ((n1: int), (card_list: rank list)) = (
    let
        fun cal_largest_TP_helper((card_list: rank list), (cur_max_tp: int), (tp_so_far: int)) = (
            let
                fun max((a: int), (b: int)) = if a >= b then a else b
            in 
                case length(card_list) of
                    0 => cur_max_tp
                |   _ => (
                    case hd(card_list) of
                        Ace => (
                            let
                                val (updated_tp_1, updated_tp_11) = (cal_TP(tp_so_far + 1), cal_TP(tp_so_far + 11))
                            in
                                max(
                                    cal_largest_TP_helper(tl(card_list), max(cur_max_tp, updated_tp_1), updated_tp_1),
                                    cal_largest_TP_helper(tl(card_list), max(cur_max_tp, updated_tp_11), updated_tp_11)
                                )
                            end
                        )
                    |   _ => (
                        let
                            val updated_tp = cal_TP(tp_so_far + get_basic_point(hd(card_list)))
                        in
                            cal_largest_TP_helper(tl(card_list), max(cur_max_tp, updated_tp), updated_tp)
                        end
                    )
                )
            end
        )
        fun select_all_possible_cards((n1: int), (card_list: rank list), (pick: int), (selected_cards: rank list)) = (
            case n1 of
                0 => selected_cards @ card_list
            |   _ => (
                case pick of
                    0 => select_all_possible_cards(n1-1, tl(card_list), 1, selected_cards)
                |   _ => select_all_possible_cards(n1, tl(card_list), 0, selected_cards @ [hd(card_list)])
            )
        )
        val p2_cards = select_all_possible_cards(n1, card_list, 0, [])
    in
        cal_largest_TP_helper(p2_cards, 0, 0)
    end
)
