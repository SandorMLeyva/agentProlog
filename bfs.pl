adjacent(X, Y, X1, Y):- X1 is X+1.
adjacent(X, Y, X1, Y):- X1 is X-1.
adjacent(X, Y, X, Y1):- Y1 is Y+1.
adjacent(X, Y, X, Y1):- Y1 is Y-1.
adjacent(X, Y, X1, Y1):- X1 is X+1, Y1 is Y+1.
adjacent(X, Y, X1, Y1):- X1 is X-1, Y1 is Y-1.
adjacent(X, Y, X1, Y1):- X1 is X+1, Y1 is Y-1.
adjacent(X, Y, X1, Y1):- X1 is X-1, Y1 is Y+1.


inside_enviroment(X, Y, N, M):-
	X >= 0,X < N, 
	Y >= 0,Y < M.


visited(Node, [LastPath|[]]):-member(Node, LastPath), !.
visited(Node, [Path|Paths]):-
	member(Node, Path);
	visited(Node, Paths).

expand([[[X, Y]|Path]|Paths], N, M, Obstacles, Extended):-
    findall(
        [[U,V], [X, Y]|Path],
        (
            adjacent(X, Y, U, V),	
            inside_enviroment(U, V, N, M),
            not(member([U, V], Obstacles)),
        not(visited([U,V], [[[X, Y]|Path]|Paths]))
    )
, Extended).

% BFS(PathsQueue, Rows, Cols, Obstacles, Goals, Solution)
bfs([[Node|Path]|_], _, _, _, GoalsList, Solution):-
	member(Node, GoalsList),
	reverse([Node|Path], Solution),	!.

bfs(PathsQueue, N, M, Obstacles, GoalsList, Solution):-
	PathsQueue = [_|Paths],
	expand(PathsQueue, N, M, Obstacles, Extended),
	append(Paths, Extended, Path1),
	bfs(Path1, N, M, Obstacles, GoalsList, Solution).

