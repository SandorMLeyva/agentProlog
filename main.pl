generate_pos(BoardHeigth,BoardWidth,Dirty,Obstacles,Childs,Corral,Pos):-
	A is random(BoardHeigth),
	B is random(BoardWidth),
	append([A],[B],Pos),
	not(member(Pos,Dirty)),
	not(member(Pos,Obstacles)),
	not(member(Pos,Childs)),
	not(member(Pos,Corral)),!.

generate_pos(BoardHeigth,BoardWidth,Dirty,Obstacles,Childs,Corral,Pos):-
		generate_pos(BoardHeigth,BoardWidth,Dirty,Obstacles,Childs,Corral,Pos).

generate_obstacle(BoardHeigth,BoardWidth,ObstacleCount,Dirty,Obstacles,Childs,Corral,ResultObstacles):-
	ObstacleCount > 0,
	X is ObstacleCount-1,
	generate_pos(BoardHeigth,BoardWidth,Dirty,Obstacles,Childs,Corral,Pos),
	Result = [Pos|Obstacles],
	generate_obstacle(BoardHeigth,BoardWidth,X,Dirty,Result,Childs,Corral,Result2),
	append([],Result2,ResultObstacles),!.

generate_obstacle(BoardHeigth,BoardWidth,0,Dirty,Obstacles,Childs,Corral,ResultObstacles):- 
	ResultObstacles = Obstacles.
			
generate_dirty(BoardHeigth,BoardWidth,DirtinessCount,Dirty,Obstacles,Childs,Corral,ResultDirtiness):-
	DirtinessCount > 0,
	X is DirtinessCount-1,
	generate_pos(BoardHeigth,BoardWidth,Dirty,Obstacles,Childs,Corral,Pos),
	Result = [Pos|Dirty],
	generate_dirty(BoardHeigth,BoardWidth,X,Result,Obstacles,Childs,Corral,Result2),
	append([],Result2,ResultDirtiness),!.

generate_dirty(BoardHeigth,BoardWidth,0,Dirty,Obstacles,Childs,Corral,ResultDirtiness):- 
	ResultDirtiness = Dirty.

generate_childs(BoardHeigth,BoardWidth,ChildsCount,Dirty,Obstacles,Childs,Corral,ResultChilds):-
	ChildsCount > 0,
	X is ChildsCount-1,
	generate_pos(BoardHeigth,BoardWidth,Dirty,Obstacles,Childs,Corral,Pos),
	Result = [Pos|Childs],
	generate_childs(BoardHeigth,BoardWidth,X,Dirty,Obstacles,Result,Corral,Result2),
	append([],Result2,ResultChilds),!.

generate_childs(BoardHeigth,BoardWidth,0,Dirty,Obstacles,Childs,Corral,ResultChilds):- 
	ResultChilds = Childs.


generate_childs(BoardHeigth,BoardWidth,ChildsCount,Dirty,Obstacles,Childs,Corral,ResultChilds):-
	ChildsCount > 0,
	X is ChildsCount-1,
	generate_pos(BoardHeigth,BoardWidth,Dirty,Obstacles,Childs,Corral,Pos),
	Result = [Pos|Childs],
	generate_childs(BoardHeigth,BoardWidth,X,Dirty,Obstacles,Result,Corral,Result2),
	append([],Result2,ResultChilds),!.

generate_childs(BoardHeigth,BoardWidth,0,Dirty,Obstacles,Childs,Corral,ResultChilds):- 
	ResultChilds = Childs.

%generate_corral(BoardHeigth,BoardWidth,CorralCount,Dirty,Obstacles,Childs,Corral,ResultDirtiness)

main:-
	BoardHeigth = 50,
	BoardWidth = 10,
	Time = 0,
	TimeChange = 5,
	DirtinessPercent = 17,
	ObstaclePercent = 10,
	DirtinessCount is round((DirtinessPercent/100)*BoardHeigth*BoardWidth),
	ObstacleCount is round((ObstaclePercent/100)*BoardHeigth*BoardWidth),
	ChildsCount = 10,
	Dirty = [],
	Obstacles = [],
	Childs = [],
	Corral = [],
	generate_obstacle(BoardHeigth,BoardWidth,ObstacleCount,Dirty,Obstacles,Childs,Corral,ObstaclesEnv),
	generate_dirty(BoardHeigth,BoardWidth,DirtinessCount,Dirty,ObstaclesEnv,Childs,Corral,ResultDirtiness),
	generate_childs(BoardHeigth,BoardWidth,ChildsCount,ResultDirtiness,ObstaclesEnv,Childs,Corral,ResultChilds),
	generate_pos(BoardHeigth,BoardWidth,ResultDirtiness,ObstaclesEnv,ResultChilds,Corral,Robot).

	%write(ObstaclesEnv).
	