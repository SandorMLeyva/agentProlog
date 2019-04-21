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

generate_obstacle(BoardHeight,BoardWidth,ObstacleCount,Dirty,Obstacles,Childs,Corral,ResultObstacles):-
	ObstacleCount > 0,
	X is ObstacleCount-1,
	generate_pos(BoardHeight,BoardWidth,Dirty,Obstacles,Childs,Corral,Pos),
	Result = [Pos|Obstacles],
	generate_obstacle(BoardHeight,BoardWidth,X,Dirty,Result,Childs,Corral,Result2),
	append([],Result2,ResultObstacles),!.

generate_obstacle(BoardHeight,BoardWidth,0,Dirty,Obstacles,Childs,Corral,ResultObstacles):- 
	ResultObstacles = Obstacles.
			
generate_dirty(BoardHeight,BoardWidth,DirtinessCount,Dirty,Obstacles,Childs,Corral,ResultDirtiness):-
	DirtinessCount > 0,
	X is DirtinessCount-1,
	generate_pos(BoardHeight,BoardWidth,Dirty,Obstacles,Childs,Corral,Pos),
	Result = [Pos|Dirty],
	generate_dirty(BoardHeight,BoardWidth,X,Result,Obstacles,Childs,Corral,Result2),
	append([],Result2,ResultDirtiness),!.

generate_dirty(BoardHeight,BoardWidth,0,Dirty,Obstacles,Childs,Corral,ResultDirtiness):- 
	ResultDirtiness = Dirty.

generate_childs(BoardHeight,BoardWidth,ChildsCount,Dirty,Obstacles,Childs,Corral,ResultChilds):-
	ChildsCount > 0,
	X is ChildsCount-1,
	generate_pos(BoardHeight,BoardWidth,Dirty,Obstacles,Childs,Corral,Pos),
	Result = [Pos|Childs],
	generate_childs(BoardHeight,BoardWidth,X,Dirty,Obstacles,Result,Corral,Result2),
	append([],Result2,ResultChilds),!.

generate_childs(BoardHeight,BoardWidth,0,Dirty,Obstacles,Childs,Corral,ResultChilds):- 
	ResultChilds = Childs.

sample(L, R) :- length(L, Len), random(0, Len, Random), nth0(Random, L, R).

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


generate_corral(BoardHeight, BoardWidth,0, Corrales, CorralResult) :-
	CorralResult = Corrales.

generate_corral(BoardHeight, BoardWidth,CorralCount, Corrales, CorralResult) :-
	generate_corral(BoardHeight, BoardWidth,CorralCount, Corrales, CorralResult).

new_dirty(BoardHeight, BoardWidth, [X,Y],Pos):-
	%How to use
	% new_dirty(BoardHeight,BoardWidth, [5,4], Pos),
	% write(Pos).
	random(0, 8, R),	
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
		X > -1, X < BoardWidth, Y1 > -1, Y1 < BoardHeight);
	 (R =:= 4, X1 is X + 1, Y1 is Y+1,
        append([X1],[Y1],Pos),
        X1 > -1, X1 < BoardWidth, Y1 > -1, Y1 < BoardHeight);
     (R =:= 5, X1 is X - 1 , Y1 is Y-1,
        append([X1],[Y1],Pos),
        X1 > -1, X1 < BoardWidth, Y1 > -1, Y1 < BoardHeight);
     (R =:= 6, X1 is X + 1, Y1 is Y-1,
        append([X1],[Y1],Pos),
        X1 > -1, X1 < BoardWidth, Y1 > -1, Y1 < BoardHeight);
     (R =:= 7, X1 is X - 1, Y1 is Y+1,
        append([X1],[Y1],Pos),
        X1 > -1, X1 < BoardWidth, Y1 > -1, Y1 < BoardHeight)),!.

new_dirty(BoardHeight, BoardWidth, [X,Y],Pos):-
	Pos = [].


inList(Item, List, R):-
	member(Item, List), R is 1, !.	

inList(Item, List, R):-
	not(member(Item, List)), R is 0.

countChildsAround([X,Y], Childs, R):-
	X1 is X + 1,
	inList([X1,Y], Childs, R1),
	Y1 is Y+1,
	inList([X,Y1], Childs, R2),
	inList([X1,Y1], Childs, R3),
	X2 is X-1,
	inList([X2,Y], Childs, R4),
	Y2 is Y-1,
	inList([X,Y2], Childs, R5),
	inList([X2,Y2], Childs, R6),
	inList([X1,Y2], Childs, R7),
	inList([X2,Y1], Childs, R8),
	R is R1+R2+R3+R4+R5+R6+R7+R8.

add_list_set(Item,List,Result):-
	length(Item, L),
	L > 0,
	not(member(Item, List)),
	append([Item],List,Result),!.
	
add_list_set(Item,List,R):-
	R = List.
	
		

dirty_result(BoardHeight, BoardWidth,0, PosChild, DirtyResult):-
	new_dirty(BoardHeight, BoardWidth, PosChild,Pos1),
	add_list_set(Pos1,[],DirtyResult),!.

dirty_result(BoardHeight, BoardWidth,1, PosChild, DirtyResult):-
	new_dirty(BoardHeight, BoardWidth, PosChild,Pos1),
	new_dirty(BoardHeight, BoardWidth, PosChild,Pos2),

	add_list_set(Pos1,[],DirtyResult1),
	add_list_set(Pos2,DirtyResult1,DirtyResult),!.

dirty_result(BoardHeight, BoardWidth,R, PosChild, DirtyResult):-
	new_dirty(BoardHeight, BoardWidth, PosChild,Pos1),
	new_dirty(BoardHeight, BoardWidth, PosChild,Pos2),
	new_dirty(BoardHeight, BoardWidth, PosChild,Pos3),
	new_dirty(BoardHeight, BoardWidth, PosChild,Pos4),
	new_dirty(BoardHeight, BoardWidth, PosChild,Pos5),
	new_dirty(BoardHeight, BoardWidth, PosChild,Pos6),
	
	add_list_set(Pos1,[],DirtyResult1),
	add_list_set(Pos2,DirtyResult1,DirtyResult2),
	add_list_set(Pos3,DirtyResult2,DirtyResult3),
	add_list_set(Pos4,DirtyResult3,DirtyResult4),
	add_list_set(Pos5,DirtyResult4,DirtyResult5),
	add_list_set(Pos6,DirtyResult5,DirtyResult).


make_dirty(BoardHeight, BoardWidth, PosChild, Childs, DirtyResult):-
	countChildsAround(PosChild, Childs, R),
	dirty_result(BoardHeight, BoardWidth,R, PosChild, DirtyResult).

main:-
	BoardHeight = 15,
	BoardWidth = 15,
	Time = 0,
	TimeChange = 5,
	ChildsCount = 5,
	DirtinessPercent = 17,
	ObstaclePercent = 10,
	DirtinessCount is round((DirtinessPercent/100)*BoardHeight*BoardWidth),
	ObstacleCount is round((ObstaclePercent/100)*BoardHeight*BoardWidth),
	Dirty = [],
	Obstacles = [],
	Childs = [],
	generate_pos(BoardHeight,BoardWidth,[],[],[],[],Corral),
	generate_corral(BoardHeight, BoardWidth, ChildsCount, [Corral], Result),
	generate_obstacle(BoardHeight,BoardWidth,ObstacleCount,Dirty,Obstacles,Childs,Corral,ObstaclesEnv),
	generate_dirty(BoardHeight,BoardWidth,DirtinessCount,Dirty,ObstaclesEnv,Childs,Corral,ResultDirtiness),
	generate_childs(BoardHeight,BoardWidth,ChildsCount,ResultDirtiness,ObstaclesEnv,Childs,Corral,ResultChilds),
	nth0(0, ResultChilds, Elem),
	make_dirty(BoardHeight, BoardWidth, Elem, ResultChilds, DirtyResult),
	write(DirtyResult).
	
	

	%generate_pos(BoardHeight,BoardWidth,ResultDirtiness,ObstaclesEnv,ResultChilds,Corral,Robot).
	%Falta calcular los corrales
	%write(ObstaclesEnv).
	