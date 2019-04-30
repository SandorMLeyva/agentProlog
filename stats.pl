
%	Reglas dinamicas



:- dynamic(countGlobalDirty/1).
countGlobalDirty(0).
:- dynamic(countGlobalRobotFired/1).
countGlobalRobotFired(0).
:- dynamic(countGlobalRobotChild/1).
countGlobalRobotChild(0).
:- dynamic(countGlobalRobotCleanHouse/1).
countGlobalRobotCleanHouse(0).

removeZlist([H|Z]):-
    writeln('va a borrar'),
    retract(countGlobalRobotChild(H)),
    writeln('Borro'),
    removeZlist(Z).
removeZlist([]):-
    assert(countGlobalRobotCleanHouse(0)).
    

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

csv:-
    open('stats.csv', append, Stream),
    findall(X, countGlobalDirty(X), Li),
    length(Li, N),
    sumlist(Li, Sum),
    Avg is round(Sum / N),
    % writeln('Porciento de casillas sucias medio'),
    % writeln(Avg),
    write(Stream,Avg),
    write(Stream,','),
    countGlobalRobotFired(X1),
    % writeln('Total de robot despedidos'),
    % writeln(X1),
    write(Stream,X1),
    write(Stream,','),
    % countGlobalRobotChild(X2),
    findall(Xy,countGlobalRobotChild(Xy),[Xq|_]),
    retractall(countGlobalRobotChild(_)),
    % writeln('Total de ninnos puestos en corral'),
    % writeln(Xq),
    write(Stream,Xq),
    write(Stream,','),
    countGlobalRobotCleanHouse(X3),
    % writeln('Total de entornos limpios completamente y ninnos en corral'),
    % writeln(X3),
    write(Stream,X3),
    nl(Stream),
    retractall(carrying(_)),
    countG(M),
    retract(countG(M)),
    close(Stream),    
    assert(countG(1)).

%limpiar el resto de