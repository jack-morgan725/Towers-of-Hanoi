
-module(toh).
-export
([
	create_disks/1,
	create_towers/1,
	display_towers/1,
	reverse_list/1,
	reverse_list/2,
	get_tower_list/1,
	get_tower_list/2,
	update_tower_state/3,
	move/5,
	solve/1
]).

%--> If passed empty list, return empty list.
reverse_list([]) -> 
	[];

%--> Calls reverse_list() function with empty list preventing user from having to add the empty accumulator.
reverse_list(List) -> 
	reverse_list(List, []).	

%--> If empty list returned -> list successfully reversed.
reverse_list([Value], Acc) -> 
	[Value|Acc];

%--> Reverses a list.
reverse_list(List, Acc) ->
	[H|T] = List,
	reverse_list(T,[H|Acc]).

%--> Creates list of disks for StartTower.
create_disks(1) -> [1];
create_disks(N) -> 
	[N|create_disks(N-1)].

%--> Creates original GameState.
create_towers(N) ->
	io:format("----------------------------------------->~n"),
	[{tower1, reverse_list(create_disks(N))}, {tower2, []}, {tower3,[]}].
	
%--> If list is empty then Print closing barrier.
display_towers([]) -> 
	io:format("----------------------------------------->~n");
	
%--> Prints out current state of game.	
display_towers(GameState) ->

	[H|T] = GameState,
	io:format("> ~w: ~w~n", [element(1, H), element(2, H)]),
	display_towers(T).

%--> Returns the associated tower list.
get_tower_list(TowerList) -> 
	TowerList.

%--> Returns the tower list associated with the TowerName atom.
get_tower_list(TowerName, GameState) ->
	
	[H|NextTower] = GameState,
	
	if 
		element(1, H) == TowerName ->
			get_tower_list(element(2, H));
			
		element(1, H) /= TowerName ->
			get_tower_list(TowerName, NextTower)
	end.

%--> Updates a specified tower list with a provided list within the GameState and returns the updated GameState.
update_tower_state(GameState, TowerName, NewList) -> 
	
	%--> Breaking GameState up into tower tuples.
	[Tower1|RemainingTower1] = GameState,
	[Tower2|RemainingTower2] = RemainingTower1,
	[Tower3|_] = RemainingTower2,
	
	%--> Checking which tower needs to be changed in the GameState.
	case TowerName of 	
	
		tower1 -> 
			NewTower1 = setelement(2, Tower1, NewList),
			NewTower2 = Tower2,
			NewTower3 = Tower3;
		
		tower2 -> 
			NewTower1 = Tower1,
			NewTower2 = setelement(2, Tower2, NewList),
			NewTower3 = Tower3;
		
		tower3 -> 
			NewTower1 = Tower1,
			NewTower2 = Tower2,
			NewTower3 = setelement(2, Tower3, NewList)
	end,
	
	%--> Re-constructing the GameState with the updated tuples.
	UpdateGameState = [NewTower1, NewTower2, NewTower3],
	UpdateGameState.
	
%--> Moves a disk from one tower to another.
move(1, GameState, StartTower, EndTower, _Via) ->
	
	%--> Getting updated start tower list (start list minus 1 disk).
	[H|UpdatedStartList] = get_tower_list(StartTower, GameState),
	
	DestList = get_tower_list(EndTower, GameState),

	%--> Getting updated end tower list by adding the previously removed disk onto the list.
	UpdatedDestList = [H|DestList],
	
	%--> Updating the GameState with the updated lists.
	UpdatedGameStateStart = update_tower_state(GameState, StartTower, UpdatedStartList),
	UpdatedGameStateFinal = update_tower_state(UpdatedGameStateStart, EndTower, UpdatedDestList),
	
	display_towers(UpdatedGameStateFinal),
	UpdatedGameStateFinal;

%--> Moves N disks from StartTower to EndTower through Via tower.
move(Disks, GameState, StartTower, EndTower, Via) ->		
	
	%--> 1: Move N-1 disks from tower1 to tower2 via tower3.
	Stage1 = move(Disks-1, GameState, StartTower, Via, EndTower),
	
	%--> 2: Move remaining, single disk from tower1 to tower3 via tower2.
	Stage2 = move(1, Stage1, StartTower, EndTower, Via),
	
	%--> 3: Move N-1 disks from tower2 to tower3 via tower1.
	move(Disks-1, Stage2, Via, EndTower, StartTower).	
	
%--> Solves Towers of Hanoi puzzle.
solve(GameState) ->

	%--> Display starting GameState.
	display_towers(GameState),
	
	%--> Getting number of disks on source tower.
	[H|_T] = GameState,
	[Disks|_] = reverse_list(element(2, H)),
	
	%--> Move from tower1 to tower 3 via tower 2.
	move(Disks, GameState, tower1, tower3, tower2).
	
	
	
	
	
	
	
	
	
	
	
	
	