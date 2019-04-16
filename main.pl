generate_pos(BoardHeigth,BoardWidth,Dirty,Obstacles,Childs,Corral,Robots,Pos):-
	A is random(BoardHeigth),
	B is random(BoardWidth),
	append([A],[B],Pos),
	not(member(Pos,Dirty)),
	not(member(Pos,Obstacles)),
	not(member(Pos,Childs)),
	not(member(Pos,Corral)),
	not(member(Pos,Robots)),!.

generate_pos(BoardHeigth,BoardWidth,Dirty,Obstacles,Childs,Corral,Robots,Pos):-
		generate_pos(BoardHeigth,BoardWidth,Dirty,Obstacles,Childs,Corral,Robots,Pos).

generate_obstacle(BoardHeigth,BoardWidth,ObstacleCount,Dirty,Obstacles,Childs,Corral,Robots,ResultObstacles):-
	ObstacleCount > 0,
	X is ObstacleCount-1,
	generate_pos(BoardHeigth,BoardWidth,Dirty,Obstacles,Childs,Corral,Robots,Pos),
	Result = [Pos|Obstacles],
	generate_obstacle(BoardHeigth,BoardWidth,X,Dirty,Result,Childs,Corral,Robots,Result2),
	append([],Result2,ResultObstacles),!.

generate_obstacle(BoardHeigth,BoardWidth,0,Dirty,Obstacles,Childs,Corral,Robots,ResultObstacles):- 
	ResultObstacles = Obstacles.
			
generate_dirty(BoardHeigth,BoardWidth,DirtinessCount,Dirty,Obstacles,Childs,Corral,Robots,ResultDirtiness):-
	DirtinessCount > 0,
	X is DirtinessCount-1,
	generate_pos(BoardHeigth,BoardWidth,Dirty,Obstacles,Childs,Corral,Robots,Pos),
	Result = [Pos|Dirty],
	generate_dirty(BoardHeigth,BoardWidth,X,Result,Obstacles,Childs,Corral,Robots,Result2),
	append([],Result2,ResultDirtiness),!.

generate_dirty(BoardHeigth,BoardWidth,0,Dirty,Obstacles,Childs,Corral,Robots,ResultDirtiness):- 
	ResultDirtiness = Dirty.

generate_childs(BoardHeigth,BoardWidth,ChildsCount,Dirty,Obstacles,Childs,Corral,Robots,ResultChilds):-
	ChildsCount > 0,
	X is ChildsCount-1,
	generate_pos(BoardHeigth,BoardWidth,Dirty,Obstacles,Childs,Corral,Robots,Pos),
	Result = [Pos|Childs],
	generate_childs(BoardHeigth,BoardWidth,X,Dirty,Obstacles,Result,Corral,Robots,Result2),
	append([],Result2,ResultChilds),!.

generate_childs(BoardHeigth,BoardWidth,0,Dirty,Obstacles,Childs,Corral,Robots,ResultChilds):- 
	ResultChilds = Childs.

%generate_corral(BoardHeigth,BoardWidth,CorralCount,Dirty,Obstacles,Childs,Corral,Robots,ResultDirtiness)

main:-
	Agent = 5,
	BoardHeigth = 50,
	BoardWidth = 50,
	Time = 0,
	TimeChange = 5,
	DirtinessPercent = 17,
	DirtinessCount is round((DirtinessPercent/100)*BoardHeigth*BoardWidth),
	ObstaclePercent = 10,
	ObstacleCount is round((ObstaclePercent/100)*BoardHeigth*BoardWidth),
	ChildsCount = 10,
	Dirty = [],
	Obstacles = [],
	Childs = [],
	Corral = [],
	Robots = [],
	generate_obstacle(BoardHeigth,BoardWidth,ObstacleCount,Dirty,Obstacles,Childs,Corral,Robots,ObstaclesEnv),
	nl,	
	write(ObstaclesEnv),
	write(111111111111111111111111111111111111111111111111),	
	nl,
	generate_dirty(BoardHeigth,BoardWidth,DirtinessCount,Dirty,ObstaclesEnv,Childs,Corral,Robots,ResultDirtiness),
	nl,	
	write(ResultDirtiness),
	write(111111111111111111111111111111111111111111111111),	
	nl,
	generate_childs(BoardHeigth,BoardWidth,ChildsCount,Dirty,Obstacles,Childs,Corral,Robots,ResultChilds),
	nl,	
	write(ResultChilds),
	write(111111111111111111111111111111111111111111111111),	
	nl.
	%write(ObstaclesEnv).
	