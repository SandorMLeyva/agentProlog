
%	Este robot solo limpia el churre
robot1(_,_, Pos, Childs, Dirty,_,_, ChildsResult, DirtyResult, NewPos):-
	member(Pos, Dirty),
	delete(Dirty, Pos, DirtyResult),
	NewPos = Pos,
	ChildsResult = Childs,!.

robot1(BoardHeight,BoardWidth, Pos, Childs, Dirty,Obstacles,_, ChildsResult, DirtyResult, NewPos):-
	bfs([[Pos]], BoardHeight, BoardWidth, Obstacles, Dirty, Path),
	length(Path, L),
	L >=1,
	nth0(1, Path, NewPos),
	DirtyResult= Dirty,
	ChildsResult= Childs.

% =====================nuevo robot===========================

%	Lleva los ninnos para el corral y si por el camino encuentra churre lo limpia
%	Lleva ninno y se encuentra churre

getIndex2_1(Path, NewPos):-
	length(Path, L),	
	L >= 3,nth0(2, Path, NewPos),!.
	
getIndex2_1(Path, NewPos):-
	length(Path, L),		
	L >= 2,nth0(1, Path, NewPos),!.
	

getIndex2_1(Path, NewPos):-
	nth0(0, Path, NewPos).
	

:- dynamic(carrying/1).
carrying(false).


:- dynamic(inCorral/1).
inCorral([-1,-1]).

% cargando un ninno y se encuentra un churre
robot2(_,_, Pos, Childs, Dirty,_,_, ChildsResult, _, NewPos):-
	carrying(Carrying),
	Carrying,
	member(Pos, Dirty),
	append([Pos], Childs, ChildsResult),	
	asserta(carrying(false)),
	retract(carrying(true)),	
	NewPos = Pos,writeln('no esta cargando ninno y hay un churre'),!.
% no esta cargando ninno y hay un churre
robot2(_,_, Pos, Childs, Dirty,_,_, ChildsResult, DirtyResult, NewPos):-
	carrying(Carrying),
	not(Carrying),
	member(Pos, Dirty),
	delete(Dirty, Pos, DirtyResult),
	NewPos = Pos,
	ChildsResult = Childs,!.
% no esta cargando ninno , se encuentra uno y no hay churre
robot2(_,_, Pos, Childs, Dirty,_,_, ChildsResult, _, NewPos):-
	carrying(Carrying),
	not(Carrying),
	% writeln('comprobando churre'),
	not(member(Pos, Dirty)),
	% writeln('no hay churre'),
	member(Pos, Childs),
	% writeln('hay ninno en esa posicion'),
	delete(Childs, Pos, ChildsResult),
	% PONER QUE ESTA CARGANDO NINNO
	asserta(carrying(true)),
	retract(carrying(false)),
	NewPos = Pos,
	writeln(' no esta cargando ninno , se encuentra uno y no hay churre'),!.
%	esta cargando ninno y se encuentra un corral
robot2(_,_, Pos, Childs, _,_,Corral, ChildsResult, _, NewPos):-
	carrying(Carrying),
	Carrying,
	member(Pos, Corral),
	asserta(inCorral(Pos)),
	asserta(carrying(false)),
	retract(carrying(true)),
	countGlobalRobotChild(X),
	X1 is X + 1,
	asserta(countGlobalRobotChild(X1)),
	retract(countGlobalRobotChild(X)),
	NewPos = Pos,
	ChildsResult = Childs,
	writeln('esta cargando ninno y se encuentra un corral'),!.
	% agrego al ninno a algu lugar donde tenga los ninnos en corral o corral ocupado
	% Pongo que ya no estoy cargando un ninno

%	ninno cargado y no hay suciedad, entonces se busca camino para corral
robot2(BoardHeight,BoardWidth, Pos, Childs, Dirty,Obstacles,Corral, ChildsResult, DirtyResult, NewPos):-
	carrying(Carrying),
	Carrying,
	bfs([[Pos]], BoardHeight, BoardWidth, Obstacles, Corral, Path),
	getIndex2_1(Path,NewPos),
	DirtyResult= Dirty,
	ChildsResult= Childs,
	writeln('ninno cargado y no hay suciedad, entonces se busca camino para corral'),!.

% sin ninno ni suciedad, busca ninno
robot2(BoardHeight,BoardWidth, Pos, Childs, Dirty,Obstacles,_, ChildsResult, DirtyResult, NewPos):-
	carrying(Carrying),
	not(Carrying),
	bfs([[Pos]], BoardHeight, BoardWidth, Obstacles, Childs, Path),
	length(Path, L),
	L >=1,nth0(1, Path, NewPos),
	DirtyResult= Dirty,
	ChildsResult= Childs,
	writeln('Pos'),
	writeln(Pos),
	writeln('Path'),
	writeln(Path),
	writeln('sin ninno ni suciedad, busca ninno').

%	Movimiento de los ninnos