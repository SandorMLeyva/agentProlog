
%	Reglas dinamicas



:- dynamic(countGlobalDirty/1).
countGlobalDirty(0).
:- dynamic(countGlobalRobotFired/1).
countGlobalRobotFired(0).
:- dynamic(countGlobalRobotChild/1).
countGlobalRobotChild(0).
:- dynamic(countGlobalRobotCleanHouse/1).
countGlobalRobotCleanHouse(0).



summary:-
    findall(X, countGlobalDirty(X), Li),
    length(Li, N),
    sumlist(Li, Sum),
    Avg is round(Sum / N),
    writeln('Porciento de casillas sucias medio'),
    writeln(Avg),
    countGlobalRobotFired(X1),
    writeln('Total de robot despedidos'),
    writeln(X1),
    countGlobalRobotChild(X2),
    writeln('Total de ninnos puestos en corral'),
    writeln(X2),
    countGlobalRobotCleanHouse(X3),
    writeln('Total de entornos limpios completamente y ninnos en corral'),
    writeln(X3).