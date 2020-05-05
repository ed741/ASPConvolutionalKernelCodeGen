dir(left).
dir(up).
dir(down).
dir(right).

goal_reg(R) :- goal_in(_,_,_,R).
init_tile(X,Y) :- goal_in(X,Y,_,_).
in(AX,AY,C,R,AX,AY,0) :- init_tile(AX,AY), init_reg(R), init_count(C).

1 { move(R,RR,D,T) : reg(R), reg(RR), dir(D); add(R,RA,RB,T) : reg(R), reg(RA), reg(RB) ; sub(R,RA,RB,T) : reg(R), reg(RA), reg(RB); null(T)} 1 :- moves(M), T = 1..M.

in(AX,AY,C,R,X,Y,T) :- move(R,RR,left ,T), in(AX,AY,C,RR,X+1,Y,T-1).
in(AX,AY,C,R,X,Y,T) :- move(R,RR,up   ,T), in(AX,AY,C,RR,X,Y-1,T-1).
in(AX,AY,C,R,X,Y,T) :- move(R,RR,right,T), in(AX,AY,C,RR,X-1,Y,T-1).
in(AX,AY,C,R,X,Y,T) :- move(R,RR,down ,T), in(AX,AY,C,RR,X,Y+1,T-1).

in(AX,AY,C,R,X,Y,T) :- add(R,RA,RB,T), in(AX,AY,CA,RA,X,Y,T-1), in(AX,AY,CB,RB,X,Y,T-1), C=CA+CB.
in(AX,AY,C,R,X,Y,T) :- add(R,RA,RB,T), in(AX,AY,C,RA,X,Y,T-1), not in(AX,AY,_,RB,X,Y,T-1).
in(AX,AY,C,R,X,Y,T) :- add(R,RA,RB,T), in(AX,AY,C,RB,X,Y,T-1), not in(AX,AY,_,RA,X,Y,T-1).

in(AX,AY,C,R,X,Y,T) :- sub(R,RA,RB,T), in(AX,AY,CA,RA,X,Y,T-1), in(AX,AY,CB,RB,X,Y,T-1), C=CA-CB.
in(AX,AY,C,R,X,Y,T) :- sub(R,RA,RB,T), in(AX,AY,C,RA,X,Y,T-1), not in(AX,AY,_,RB,X,Y,T-1).
in(AX,AY,-C,R,X,Y,T) :- sub(R,RA,RB,T), in(AX,AY,C,RB,X,Y,T-1), not in(AX,AY,_,RA,X,Y,T-1).


reset(R,T) :- move(R,_,_,T).
reset(R,T) :- add(R,_,_,T).
reset(R,T) :- sub(R,_,_,T).
in(AX,AY,C,R,X,Y,T+1) :- in(AX,AY,C,R,X,Y,T), not reset(R,T+1), not moves(T).

:- in(AX,AY,CA,R,X,Y,T), in(AX,AY,CB,R,X,Y,T), CA!=CB.
:- goal_in(AX,AY,C,R), not in(AX,AY,C,R,0,0,M), moves(M).
:- in(AX,AY,C,R,0,0,M), goal_reg(R), not goal_in(AX,AY,C,R), moves(M), C!=0.

#maximize{1,T:null(T)}.

#show move/4.
#show add/4.
#show sub/4.
#show null/1.




