reg(a).
reg(b).
%reg(c).
%reg(d).
%reg(e).
init_reg(a).
init_count(1).

% Sobel
%goal_in(-1,1,1,a).
%goal_in(-1,0,2,a).
%goal_in(-1,-1,1,a).
%goal_in(1,1,1,a).
%goal_in(1,0,2,a).
%goal_in(1,-1,1,a).

% 2x2 box
goal_in(0,0,1,a).
goal_in(0,1,1,a).
goal_in(1,0,1,a).
goal_in(1,1,1,a).




moves(7).
