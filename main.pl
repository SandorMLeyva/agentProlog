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
			
generate_dirty(BoardHeigth,BoardWidth,DirtinessCount,Dirty,Obstacles,Childs,Corral,Robots,ResultDiriness):-
	DirtinessCount > 0,
	X is DirtinessCount-1,
	generate_pos(BoardHeigth,BoardWidth,Dirty,Obstacles,Childs,Corral,Robots,Pos),
	Result = [Pos|Dirty],
	generate_dirty(BoardHeigth,BoardWidth,X,Result,Obstacles,Childs,Corral,Robots,Result2),
	append([],Result2,ResultDiriness),!.

generate_dirty(BoardHeigth,BoardWidth,0,Dirty,Obstacles,Childs,Corral,Robots,ResultDiriness):- 
	ResultDiriness = Dirty.


main:-
	Agent = 5,
	BoardHeigth = 8,
	BoardWidth = 5,
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
	
	generate_dirty(BoardHeigth,BoardWidth,DirtinessCount,Dirty,ObstaclesEnv,Childs,Corral,Robots,ResultDiriness).

	%write(ObstaclesEnv).
	