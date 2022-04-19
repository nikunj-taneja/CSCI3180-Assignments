% Sample trees.
% bt(bt(bt(nil,0,nil),s(0), bt(nil,s(s(s(0))),nil)), s(s(s(s(0)))), bt(nil,s(s(0)),nil))
% bt(bt(bt(nil,0,nil),s(0), bt(nil,s(s(s(0))),nil)), s(s(s(s(0)))), bt(nil,s(s(s(s(s(0))))),nil))

% 1. is_binary_tree(T)
% | ?- is_binary_tree(bt(bt(bt(nil,0,nil),s(0), bt(nil,s(s(s(0))),nil)), s(s(s(s(0)))), bt(nil,s(s(0)),nil))).
% yes





%2. lt(X,Y) and bs_tree(T). 
% | ?- bs_tree(bt(bt(bt(nil,0,nil),s(0), bt(nil,s(s(s(0))),nil)), s(s(s(s(0)))), bt(nil,s(s(0)),nil))).
% no
% | ?- bs_tree(bt(bt(bt(nil,0,nil),s(0), bt(nil,s(s(s(0))),nil)), s(s(s(s(0)))), bt(nil,s(s(s(s(s(0))))),nil))).
% yes





% 3. parent(T, P, C).
% | ?- parent(bt(bt(bt(nil,0,nil),s(0), bt(nil,s(s(s(0))),nil)), s(s(s(s(0)))), bt(nil,s(s(0)), nil)), s(s(s(s(0)))), C).
% C = s(0) ? ;
% C = s(s(0)) ? ;
% no

% | ?- parent(bt(bt(bt(nil,0,nil),s(0), bt(nil,s(s(s(0))),nil)), s(s(s(s(0)))), bt(nil,s(s(0)), nil)), P, 0).
% P = s(0) ? ;
% no





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






% 7. preorder(T, X).
% ?- preorder(bt(bt(bt(nil,0,nil),s(0), bt(nil,s(s(s(0))),nil)), s(s(s(s(0)))), bt(nil,s(s(0)),nil)), X).
% X = [s(s(s(s(0)))),s(0),0,s(s(s(0))),s(s(0))] ? ;
% no

append([],L,L).
append([H|T],L2,[H|L3]):-append(T,L2,L3).




