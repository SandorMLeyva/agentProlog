
%	genera una suciedad dado un punto
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
		X1 > -1, X1 < BoardWidth, Y1 > -1, Y1 < BoardHeight)),
		countGlobalDirty(Current),
		NewCurrent is Current + 1,
		asserta(countGlobalDirty(NewCurrent)),
		retract(countGlobalDirty(Current)),!.

new_dirty(BoardHeight, BoardWidth, [X,Y],Pos):-
	Pos = [].

%	Es como un member pero siempre retorna true
inList(Item, List, R):-
	member(Item, List), R is 1, !.	

inList(Item, List, R):-
	not(member(Item, List)), R is 0.
%	Cuenta cuantos ninnos hay alrededor de un punto
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

add_list_set(Dirty,Obstacles,Item,List,Result):-
	length(Item, L),
	L > 0,
	not(member(Item,Dirty)),
	not(member(Item,Obstacles)),
	not(member(Item, List)),
	append([Item],List,Result).
	
add_list_set(Dirty,Obstacles, Item,List,R):-
	R = List.
		
dirty_result(BoardHeight, BoardWidth,Dirty,Obstacles,0, PosChild, DirtyResult):-
	new_dirty(BoardHeight, BoardWidth, PosChild,Pos1),
	add_list_set(Dirty,Obstacles,Pos1,[],DirtyResult),!.

dirty_result(BoardHeight, BoardWidth,Dirty,Obstacles,1, PosChild, DirtyResult):-
	new_dirty(BoardHeight, BoardWidth, PosChild,Pos1),
	new_dirty(BoardHeight, BoardWidth, PosChild,Pos2),

	add_list_set(Dirty,Obstacles,Pos1,[],DirtyResult1),
	add_list_set(Dirty,Obstacles,Pos2,DirtyResult1,DirtyResult),!.

dirty_result(BoardHeight, BoardWidth,Dirty,Obstacles,R, PosChild, DirtyResult):-
	new_dirty(BoardHeight, BoardWidth, PosChild,Pos1),
	new_dirty(BoardHeight, BoardWidth, PosChild,Pos2),
	new_dirty(BoardHeight, BoardWidth, PosChild,Pos3),
	new_dirty(BoardHeight, BoardWidth, PosChild,Pos4),
	new_dirty(BoardHeight, BoardWidth, PosChild,Pos5),
	new_dirty(BoardHeight, BoardWidth, PosChild,Pos6),
	
	add_list_set(Dirty,Obstacles,Pos1,[],DirtyResult1),
	add_list_set(Dirty,Obstacles,Pos2,DirtyResult1,DirtyResult2),
	
	add_list_set(Dirty,Obstacles,Pos3,DirtyResult2,DirtyResult3),
	add_list_set(Dirty,Obstacles,Pos4,DirtyResult3,DirtyResult4),
	add_list_set(Dirty,Obstacles,Pos5,DirtyResult4,DirtyResult5),
	add_list_set(Dirty,Obstacles,Pos6,DirtyResult5,DirtyResult).


make_dirty(BoardHeight, BoardWidth,Dirty,Obstacles, PosChild, Childs, DirtyResult):-
	countChildsAround(PosChild, Childs, R),
	dirty_result(BoardHeight, BoardWidth,Dirty,Obstacles,R, PosChild, DirtyResult).



move_obstacle(BoardHeight, BoardWidth, Dirty,Obstacles,Childs,Corral, [I,J], [X,Y], Result):-
	X1 is X+I,
	Y1 is Y+J,
	not(member([X1,Y1], Obstacles)),
	not(member([X1,Y1],Dirty)),
	not(member([X1,Y1],Childs)),
	not(member([X1,Y1],Corral)),
	X1 < BoardWidth,
	X1 > -1,
	Y1 < BoardHeight,
	Y1 > -1,
	delete(Obstacles, [X,Y], Result2),
	append([[X1,Y1]],Result2, Result),!.

move_obstacle(BoardHeight, BoardWidth, Dirty,Obstacles,Childs,Corral, [I,J], [X,Y], Result):-
	X1 is X+I,
	Y1 is Y+J,
	member([X1,Y1], Obstacles),
	move_obstacle(BoardHeight, BoardWidth, Dirty,Obstacles,Childs,Corral, [I,J], [X1,Y1], Result2),
	delete(Result2, [X,Y], Result3),	
	append(Result3,[], Result4),
	append([[X1,Y1]],Result4, Result),!.

move_obstacle(BoardHeight, BoardWidth, Dirty,Obstacles,Childs,Corral, [I,J], [X,Y], Obstacles).




moveChild(BoardHeight, BoardWidth, [X,Y],Dirty,Childs,Corral, Obstacles, ResultObstacles, ResultChilds):-
	sample([[1,0],[0,1],[-1,0],[0,-1],[1,1],[-1,-1],[1,-1],[-1,1]],[I,J]),
	X1 is X+I,
	Y1 is Y+J,
	X1 < BoardWidth, 
	X1 > -1,
	Y1 < BoardHeight, 
	Y1 > -1,
	not(member([X1,Y1],Childs)),
	member([X1,Y1], Obstacles),
	move_obstacle(BoardHeight, BoardWidth, Dirty,Obstacles,Childs,Corral, [I,J], [X1,Y1], ResultObstacles),
	delete(Childs, [X,Y], List2),
	% ResultChilds = [],
	append([[X1,Y1]], List2, ResultChilds),!.
	

moveChild(BoardHeight, BoardWidth, [X,Y],Dirty,Childs,Corral, Obstacles, ResultObstacles, ResultChilds):-
	sample([[1,0],[0,1],[-1,0],[0,-1],[1,1],[-1,-1],[1,-1],[-1,1]],[I,J]),
	X1 is X+I,
	Y1 is Y+J,
	X1 < BoardWidth, X1 > -1,
	Y1 < BoardHeight, Y1 > -1,
	not(member([X1,Y1],Childs)),
	not(member([X1,Y1], Obstacles)),
	ResultObstacles = Obstacles,
	delete(Childs, [X,Y], List2),
	append([[X1,Y1]], List2, ResultChilds),!.


moveChild(BoardHeight, BoardWidth, [X,Y],Dirty,Childs,Corral, Obstacles, ResultObstacles, ResultChilds):-
	ResultObstacles = Obstacles,
	ResultChilds = Childs.


% aqui se esta partiendo en algun lugar
itChilds(BoardHeight, BoardWidth, Length, Dirty,Obstacles, Childs,Corral, DirtyResult, ObstaclesResult, ChildsResult):-
	Length > 0,
	Pos is Length - 1,
	nth0(Pos, Childs, PosChild),
	
	itChilds(BoardHeight,BoardWidth, Pos, Dirty,Obstacles, Childs,Corral, DirtyResult2, ObstaclesResult2, ChildsResult2),
	
	%	ensucia
	
	make_dirty(BoardHeight, BoardWidth, DirtyResult2,ObstaclesResult2, PosChild, ChildsResult2, DirtyResult3),
	append(DirtyResult3, DirtyResult2, DirtyResult),
	%	mover
	moveChild(BoardHeight, BoardWidth, PosChild,DirtyResult,ChildsResult2,Corral, ObstaclesResult2, ObstaclesResult, ChildsResult),!.
	
	

itChilds(BoardHeight, BoardWidth, Length, Dirty,Obstacles, Childs,Corral, DirtyResult, ObstaclesResult, ChildsResult):-
	nth0(Length, Childs, PosChild),
	%	ensucia
	make_dirty(BoardHeight, BoardWidth, Dirty,Obstacles, PosChild, Childs, DirtyResult2),
	append(DirtyResult2, Dirty, DirtyResult),
	%	mover
	moveChild(BoardHeight, BoardWidth, PosChild,DirtyResult,Childs,Corral, Obstacles, ObstaclesResult, ChildsResult).
	
	

child(BoardHeight,BoardWidth, Childs, Dirty,Obstacles,Corral, DirtyResult, ObstaclesResult, ChildsResult):-
	length(Childs, L),
	itChilds(BoardHeight, BoardWidth, L, Dirty,Obstacles, Childs, Corral,DirtyResult, ObstaclesResult, ChildsResult).
	