
% CSCI3180 Principles of Programming Languages
%
% --- Declaration ---
%
% I declare that the assignment here submitted is original except for source
% material explicitly acknowledged. I also acknowledge that I am aware of
% University policy and regulations on honesty in academic work, and of the
% disciplinary guidelines and procedures applicable to breaches of such policy
% and regulations, as contained in the website
% http://www.cuhk.edu.hk/policy/academichonesty/
%
% Assignment 4
% Name : Taneja Nikunj
% Student ID : 1155123371
% Email Addr : ntaneja9@cse.cuhk.edu.hk

% Sample trees.
% bt(bt(bt(nil,0,nil),s(0), bt(nil,s(s(s(0))),nil)), s(s(s(s(0)))), bt(nil,s(s(0)),nil))
% bt(bt(bt(nil,0,nil),s(0), bt(nil,s(s(s(0))),nil)), s(s(s(s(0)))), bt(nil,s(s(s(s(s(0))))),nil))

% 1. is_binary_tree(T)
% | ?- is_binary_tree(bt(bt(bt(nil,0,nil),s(0), bt(nil,s(s(s(0))),nil)), s(s(s(s(0)))), bt(nil,s(s(0)),nil))).
% yes

is_binary_tree(nil).
is_binary_tree(bt(LEFT, _, RIGHT)) :- 
    is_binary_tree(LEFT), is_binary_tree(RIGHT).


%2. lt(X,Y) and bs_tree(T). 
% | ?- bs_tree(bt(bt(bt(nil,0,nil),s(0), bt(nil,s(s(s(0))),nil)), s(s(s(s(0)))), bt(nil,s(s(0)),nil))).
% no
% | ?- bs_tree(bt(bt(bt(nil,0,nil),s(0), bt(nil,s(s(s(0))),nil)), s(s(s(s(0)))), bt(nil,s(s(s(s(s(0))))),nil))).
% yes

lt(0, s(_)).
lt(s(X), s(Y)) :- lt(X, Y).

bs_tree(bt(nil, _, nil)).
bs_tree(bt(bt(LL, L, LR), X, bt(RL, R, RR))) :- lt(L, X), lt(X, R), bs_tree(bt(LL, L, LR)), bs_tree(bt(RL, L, RR)).

% 3. parent(T, P, C).
% | ?- parent(bt(bt(bt(nil,0,nil),s(0), bt(nil,s(s(s(0))),nil)), s(s(s(s(0)))), bt(nil,s(s(0)), nil)), s(s(s(s(0)))), C).
% C = s(0) ? ;
% C = s(s(0)) ? ;
% no

% | ?- parent(bt(bt(bt(nil,0,nil),s(0), bt(nil,s(s(s(0))),nil)), s(s(s(s(0)))), bt(nil,s(s(0)), nil)), P, 0).
% P = s(0) ? ;
% no
parent(bt(bt(_,C,_), P, _), P, C).
parent(bt(_, P, bt(_,C,_)), P, C).
parent(bt(L, _, R), P, C) :- parent(L, P, C); parent(R, P, C).




% 4. decendent(T, A, D).
% | ?- decendent(bt(bt(bt(nil,0,nil),s(0), bt(nil,s(s(s(0))),nil)), s(s(s(s(0)))), bt(nil,s(s(0)), nil)), s(s(s(s(0)))), D).
% D = s(0) ? ;
% D = s(s(0)) ? ;
% D = 0 ? ;
% D = s(s(s(0))) ? ;
% no

% | ?- decendent(bt(bt(bt(nil,0,nil),s(0), bt(nil,s(s(s(0))),nil)), s(s(s(s(0)))), bt(nil,s(s(0)), nil)), P, 0).
% P = s(0) ? ;
% P = s(s(s(s(0)))) ? ;
% no
descendent(T, A, D) :- parent(T, A, D).
descendent(T, A, D) :- parent(T, A, C), descendent(T, C, D).




% 5. count_nodes(T, X).
% | ?- count_nodes(bt(bt(bt(nil,0,nil),s(0), bt(nil,s(s(s(0))),nil)), s(s(s(s(0)))), bt(nil,s(s(0)), nil)), X).
% X = s(s(s(s(s(0))))) ? ;
% no

% | ?- count_nodes(T, s(s(s(s(s(0)))))).
% T = bt(nil,_A,bt(nil,_B,bt(nil,_C,bt(nil,_D,bt(nil,_E,nil))))) ? ;
% T = bt(nil,_A,bt(nil,_B,bt(nil,_C,bt(bt(nil,_D,nil),_E,nil)))) ? ;
% T = bt(nil,_A,bt(nil,_B,bt(bt(nil,_C,nil),_D,bt(nil,_E,nil)))) ? ;
% T = bt(nil,_A,bt(nil,_B,bt(bt(nil,_C,bt(nil,_D,nil)),_E,nil))) ? ;
% T = bt(nil,_A,bt(nil,_B,bt(bt(bt(nil,_C,nil),_D,nil),_E,nil))) ? ;
% T = bt(nil,_A,bt(bt(nil,_B,nil),_C,bt(nil,_D,bt(nil,_E,nil)))) ?
% yes

sum(0, X, X).
sum(s(X), Y, s(Z)) :- sum(X, Y, Z).

count_nodes(nil, 0).
count_nodes(bt(L, _, R), s(X)) :- 
    count_nodes(L, NL), count_nodes(R, NR), sum(NL, NR, X).

% 6. sum_nodes(T, X).
% | ?- sum_nodes(bt(bt(nil, s(0), nil), s(s(s(s(0)))), bt(nil,s(s(0)), nil)), X).
% X = s(s(s(s(s(s(s(0))))))) ? ;
% no

% | ?- sum_nodes(T, s(s(s(s(s(s(s(0)))))))).
% T = bt(nil,s(s(s(s(s(s(s(0))))))),nil) ? ;
% T = bt(nil,s(s(s(s(s(s(s(0))))))),bt(nil,0,nil)) ? ;
% T = bt(nil,s(s(s(s(s(s(0)))))),bt(nil,s(0),nil)) ? ;
% T = bt(nil,s(s(s(s(s(0))))),bt(nil,s(s(0)),nil)) ? ;
% T = bt(nil,s(s(s(s(0)))),bt(nil,s(s(s(0))),nil)) ? ;
% T = bt(nil,s(s(s(0))),bt(nil,s(s(s(s(0)))),nil)) ?
% yes

subtract(X, 0, X).
subtract(X, s(Y), Z) :- subtract(X, Y, s(Z)).

sum_nodes(nil, 0).
sum_nodes(bt(L, Root, R), X) :- 
    sum_nodes(L, SL), sum_nodes(R, SR), sum(SL, SR, Y), subtract(X, Y, Root).

% 7. preorder(T, X).
% ?- preorder(bt(bt(bt(nil,0,nil),s(0), bt(nil,s(s(s(0))),nil)), s(s(s(s(0)))), bt(nil,s(s(0)),nil)), X).
% X = [s(s(s(s(0)))),s(0),0,s(s(s(0))),s(s(0))] ? ;
% no

append([],L,L).
append([H|T],L2,[H|L3]):-append(T,L2,L3).

preorder(nil, []).
preorder(bt(L, Root, R), X) :-
    preorder(L, PL), preorder(R, PR), append(PL, PR, Y), append([Root], Y, X).
