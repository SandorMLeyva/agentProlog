
% 	Comprueba si esta sucio para despedir al robot, guarda con assert el contador global de despidos	
very_dirty(BoardHeight,BoardWidth,ChildsCount, CorralCount ,DirtinessCount,ObstacleCount):-
	Free is (BoardHeight*BoardWidth) - (ChildsCount+ CorralCount + ObstacleCount),
	A is (3/5)*Free,
	A < DirtinessCount,
	countGlobalRobotFired(Current),
	NewCurrent is Current + 1,
	retract(countGlobalRobotFired(Current)),
	asserta(countGlobalRobotFired(NewCurrent)).
	


%	comprueba si todo esta limpio y todos los ninnos estan en corral
all_clean(_,_, Childs, Dirty,_,_):-
	length(Childs, 0),
	length(Dirty, 0),
	countGlobalRobotCleanHouse(X),
	X1 is X + 1,
	asserta(countGlobalRobotCleanHouse(X1)),
	retract(countGlobalRobotCleanHouse(X)).
	
	
%	Reglas dinamicas
:- dynamic(countG/1).
countG(1).



simulation(BoardHeight,BoardWidth, I,T, Pos, Childs, Dirty,Obstacles,Corral, DirtyResult, ObstaclesResult, ChildsResult, NewPos):-
	I < T,
	CurrentT is I + 1,
	not(all_clean(BoardHeight,BoardWidth, Childs, Dirty,Obstacles,Corral)),
	robot1(BoardHeight,BoardWidth, Pos, Childs, Dirty,Obstacles,Corral, ChildsResult, DirtyResult1, NewPos),
	child(BoardHeight,BoardWidth, ChildsResult, DirtyResult1,Obstacles,Corral, DirtyResult, ObstaclesResult, ChildsResult2),
	

	length(ChildsResult2, ChildsCount),
	length(Corral, CorralCount),
	length(DirtyResult, DirtinessCount),
	length(ObstaclesResult, ObstacleCount),	
	not(very_dirty(BoardHeight,BoardWidth,ChildsCount, CorralCount ,DirtinessCount,ObstacleCount)),
    simulation(BoardHeight,BoardWidth, CurrentT,T, NewPos, ChildsResult2, DirtyResult,ObstaclesResult,Corral, _, _, _, _),!.


simulation(BoardHeight,BoardWidth, _,_, _, Childs, Dirty,Obstacles,Corral, _, _, _, _):-
	countG(Current),
	Current < 100,
	writeln('====================+++Nueva simulacion+++++============================='),
	% writeln(Current),
	C is Current + 1,
	GlobalC = countG(C),
	retract(countG(Current)),	
	asserta(GlobalC),
	carrying(X),
	retract(carrying(X)),
	asserta(carrying(false)),
	length(Dirty, Len),

	%calculando porciento de casillas sucias
	length(Obstacles, OInt),
	length(Corral, CInt),
	length(Childs, ChildInt),
	
	Total is (BoardHeight*BoardWidth)-(OInt+CInt+ChildInt),
	Percent is 100*(Len/Total),

	asserta(countGlobalDirty(Percent)),
	main,!.	
% simulation(BoardHeight,BoardWidth, I, Pos, Childs, Dirty,Obstacles,Corral, DirtyResult, ObstaclesResult, ChildsResult3, NewPos):-

simulation(_,_, _ ,_,_, _, _,_,_, _, _, _, _):-
	writeln('La simulacion finalizo').


:-dynamic(bh/1).
:-dynamic(bw/1).
:-dynamic(time/1).
:-dynamic(child_count/1).
:-dynamic(dirtiness_percent/1).
:-dynamic(obstacle_percent/1).

init:-
	writeln('Board Heigth'),read(Heigth),
	assert(bh(Heigth)),
	writeln('Board Width'),read(Width),
	assert(bw(Width)),	
	writeln('Time'), read(Time),
	assert(time(Time)),
	writeln('Childs Count'), read(ChildsCount),
	assert(child_count(ChildsCount)),
	writeln('Dirtiness Percent'), read(DirtinessPercent),
	assert(dirtiness_percent(DirtinessPercent)),
	writeln('Obstacle Percent'), read(ObstaclePercent),
	assert(obstacle_percent(ObstaclePercent)),
	main.



main:-
	consult(['stats.pl','envirorment.pl','bfs.pl','robot.pl','child.pl']),

	BoardHeight = 9,
	BoardWidth = 9,
	TimeChange = 20,
	ChildsCount = 0,
	DirtinessPercent = 30,
	ObstaclePercent = 30,

	DirtinessCount is round((DirtinessPercent/100)*BoardHeight*BoardWidth),
	ObstacleCount is round((ObstaclePercent/100)*BoardHeight*BoardWidth),
	Dirty = [],
	Obstacles = [],
	Childs = [],


	generate_pos(BoardHeight,BoardWidth,[],[],[],[],Corral),
	generate_corral(BoardHeight, BoardWidth, ChildsCount, [Corral], CorralResult),
	generate_obstacle(BoardHeight,BoardWidth,ObstacleCount,Dirty,Obstacles,Childs,CorralResult,ObstaclesEnv),
	generate_dirty(BoardHeight,BoardWidth,DirtinessCount,Dirty,ObstaclesEnv,Childs,CorralResult,ResultDirtiness),
	generate_childs(BoardHeight,BoardWidth,ChildsCount,ResultDirtiness,ObstaclesEnv,Childs,CorralResult,ResultChilds),
	
	generate_pos(BoardHeight,BoardWidth,ResultDirtiness,ObstaclesEnv,ResultChilds,CorralResult,Robot),
	simulation(BoardHeight,BoardWidth, 0,TimeChange,Robot, ResultChilds, ResultDirtiness,ObstaclesEnv,CorralResult, DirtyResult, ObstaclesResult, ChildsResult, NewPos).
	
iter(X):-
	X < 30,
	X1 is X + 1,
	main,
	csv,
	iter(X1).