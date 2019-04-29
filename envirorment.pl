%	genera una posicion aleatoria sobre el mapa que no coincida con ninguno de los parametros
generate_pos(BoardHeight,BoardWidth,Dirty,Obstacles,Childs,Corral,Pos):-
	A is random(BoardHeight),
	B is random(BoardWidth),
	append([A],[B],Pos),
	not(member(Pos,Dirty)),
	not(member(Pos,Obstacles)),
	not(member(Pos,Childs)),
	not(member(Pos,Corral)),!.

generate_pos(BoardHeight,BoardWidth,Dirty,Obstacles,Childs,Corral,Pos):-
		generate_pos(BoardHeight,BoardWidth,Dirty,Obstacles,Childs,Corral,Pos).

%	genera un obstaculo sobre el mapa
generate_obstacle(BoardHeight,BoardWidth,ObstacleCount,Dirty,Obstacles,Childs,Corral,ResultObstacles):-
	ObstacleCount > 0,
	X is ObstacleCount-1,
	generate_pos(BoardHeight,BoardWidth,Dirty,Obstacles,Childs,Corral,Pos),
	Result = [Pos|Obstacles],
	generate_obstacle(BoardHeight,BoardWidth,X,Dirty,Result,Childs,Corral,Result2),
	append([],Result2,ResultObstacles),!.

generate_obstacle(_,_,0,_,Obstacles,_,_,ResultObstacles):- 
	ResultObstacles = Obstacles.
			
generate_dirty(BoardHeight,BoardWidth,DirtinessCount,Dirty,Obstacles,Childs,Corral,ResultDirtiness):-
	DirtinessCount > 0,
	X is DirtinessCount-1,
	generate_pos(BoardHeight,BoardWidth,Dirty,Obstacles,Childs,Corral,Pos),
	Result = [Pos|Dirty],
	generate_dirty(BoardHeight,BoardWidth,X,Result,Obstacles,Childs,Corral,Result2),
	append([],Result2,ResultDirtiness),!.

generate_dirty(_,_,0,Dirty,_,_,_,ResultDirtiness):- 
	ResultDirtiness = Dirty.

generate_childs(BoardHeight,BoardWidth,ChildsCount,Dirty,Obstacles,Childs,Corral,ResultChilds):-
	ChildsCount > 0,
	X is ChildsCount-1,
	generate_pos(BoardHeight,BoardWidth,Dirty,Obstacles,Childs,Corral,Pos),
	Result = [Pos|Childs],
	generate_childs(BoardHeight,BoardWidth,X,Dirty,Obstacles,Result,Corral,Result2),
	append([],Result2,ResultChilds),!.

generate_childs(_,_,0,_,_,Childs,_,ResultChilds):- 
	ResultChilds = Childs.

%	toma un valor aleatorio de una lista
sample(L, R) :- 
	length(L, Len), 
	random(0, Len, Random), 
	nth0(Random, L, R).

generate_corral(BoardHeight, BoardWidth, CorralCount, Corrales, CorralResult) :-
	CorralCount > 0,
	C is CorralCount-1,
	random(0, 4, R),
    sample(Corrales,[X,Y]),
    ((R =:= 0, X1 is X + 1,
        append([X1],[Y],Pos),
        X1 > -1, X1 < BoardWidth, Y > -1, Y < BoardHeight);
     (R =:= 1, X1 is X - 1,
        append([X1],[Y],Pos),
        X1 > -1, X1 < BoardWidth, Y > -1, Y < BoardHeight);
     (R =:= 2, Y1 is Y + 1,
        append([X],[Y1],Pos),
        X > -1, X < BoardWidth, Y1 > -1, Y1 < BoardHeight);
     (R =:= 3, Y1 is Y - 1,
        append([X],[Y1],Pos),
        X > -1, X < BoardWidth, Y1 > -1, Y1 < BoardHeight)),

	not(member(Pos, Corrales)),
	Result = [Pos|Corrales],
			
	generate_corral(BoardHeight, BoardWidth, C, Result, Result2),
	append([],Result2,CorralResult),!.


generate_corral(_, _,0, Corrales, CorralResult) :-
	CorralResult = Corrales.

generate_corral(BoardHeight, BoardWidth,CorralCount, Corrales, CorralResult) :-
	generate_corral(BoardHeight, BoardWidth,CorralCount, Corrales, CorralResult).
