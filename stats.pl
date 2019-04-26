
%	Reglas dinamicas



:- dynamic(countGlobalDirty/1).
countGlobalDirty(0).
:- dynamic(countGlobalRobotFired/1).
countGlobalRobotFired(0).
:- dynamic(countGlobalRobotChild/1).
countGlobalRobotChild(0).
:- dynamic(countGlobalRobotCleanHouse/1).
countGlobalRobotCleanHouse(0).