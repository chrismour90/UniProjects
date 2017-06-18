candidate_number(33747).

solve_task(Task,Cost) :-
  ( part(1) -> solve_task_1_3(Task, Cost)
  ; part(3) -> solve_task_1_3(Task, Cost)
  ; part(4) -> solve_task_4(Task, Cost)
  ).

%%%%%%%%%% Part 1 & 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
solve_task_1_3(Task,Cost) :-
  agent_current_position(oscar,P),
  solve_task_bt(Task,[[c(0,0,P),P]],0,R,Cost,_NewPos,[]),!,  % prune choice point for efficiency
  reverse(R,[_Init|Path]),
  agent_do_moves(oscar,Path).
  
 
%%%%%%%%%% Part 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%run as ailp_reset,explore(A).

explore(A) :- 
	findall(N,actor(N),NS),
	repeated(NS,[],A).
	
repeated([NS],_,[NS]).

repeated(NS,Oracles_Visited,A):-
		agent_current_energy(oscar,E),
		E>60,
		solve_task_part3(find(o(X)),_,Oracles_Visited),
		agent_ask_oracle(oscar,o(X),link,L),
		findall(K,(member(K,NS),wp(K,WT),wt_link(WT,L)),RetL),
		intersection(RetL,NS,NewNSList), remove_duplicates(NewNSList, Removed_dup),
		repeated(Removed_dup,[o(X)|Oracles_Visited],A).
		
repeated(NS,Oracles_Visited,A):-
		solve_task(find(c(X)),_), agent_topup_energy(oscar, c(X)),
		repeated(NS,Oracles_Visited,A).

		
remove_duplicates([],[]).

remove_duplicates([H | T], List) :-    
     member(H, T),
     remove_duplicates( T, List).

remove_duplicates([H | T], [H|T1]) :- 
      \+member(H, T),
      remove_duplicates( T, T1).
		
solve_task_part3(Task,Cost,Oracles_Visited) :-
  agent_current_position(oscar,P),
  solve_task_bt_part3(Task,[[c(0,0,P),P]],0,R,Cost,NewPos,[],Oracles_Visited),!,  % prune choice point for efficiency
  reverse(R,[_Init|Path]),
  agent_do_moves(oscar,Path).		

solve_task_bt_part3(Task,[Current|List],Depth,RPath,[cost(Cost),depth(Depth)],NewPos,History,Oracles_Visited) :-
  achieved_part3(Task,Current,RPath,Cost,NewPos,Oracles_Visited).

%%% go task %%%
solve_task_bt_part3(Task,[Current|List],D,RR,Cost,NewPos,History,Oracles_Visited) :-  
  Current = [c(F,G,P)|RPath],  
  G1 is G+1,
  (Task=go(Target) -> (setof([c(FL,G1,Pos1),Pos1|RPath],searchAstar(P,Pos1,Pos1,_,FL,Target,G1,History), Children) -> append(Children,List,NewList); NewList = List);
   Task=find(c(_)) -> (setof([c(FL,G1,Pos1),Pos1|RPath],searchFind(P,Pos1,Pos1,_,FL,G1,History),Children) ->  merge(Children,List,NewList); NewList = List);
   otherwise -> (setof([c(FL,G1,Pos1),Pos1|RPath],searchFind(P,Pos1,Pos1,_,FL,G1,History),Children) ->  merge(Children,List,NewList); NewList = List) 
  ),
  extract_pos_seen(NewList,History,Extracted),
  D1 is D+1,
  solve_task_bt_part3(Task,Extracted,D1,RR,Cost,NewPos,[P|History],Oracles_Visited). 
  
 
  
achieved_part3(find(O),Current,RPath,Cost,NewPos,Oracles_Visited) :-
  Current = [c(Cost,Travel,NewPos)|RPath],
  ( O=none    -> true
  ; otherwise -> RPath = [Last|_],map_adjacent(Last,_,O),
  \+memberchk(O,Oracles_Visited)  
  ).  

%%%%%%%%%% Part 4 (Optional) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
solve_task_4(Task,Cost):-
  my_agent(Agent),
  query_world( agent_current_position, [Agent,P] ),
  solve_task_bt(Task,[c(0,P),P],0,R,Cost,_NewPos),!,  % prune choice point for efficiency
  reverse(R,[_Init|Path]),
  query_world( agent_do_moves, [Agent,Path] ).
%%%%%%%%%% Part 4 (Optional) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%% Part 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Useful predicates %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% backtracking depth-first search, needs to be changed to List-based A*

solve_task_bt(Task,[Current|List],Depth,RPath,[cost(Cost),depth(Depth)],NewPos,History) :-
  achieved(Task,Current,RPath,Cost,NewPos).

%%% go task %%%
solve_task_bt(Task,[Current|List],D,RR,Cost,NewPos,History) :-  
  Current = [c(F,G,P)|RPath],  
  G1 is G+1,
  (Task=go(Target) -> (setof([c(FL,G1,Pos1),Pos1|RPath],searchAstar(P,Pos1,Pos1,_,FL,Target,G1,History), Children) -> append(Children,List,NewList); NewList = List);
   Task=find(c(_)) -> (setof([c(FL,G1,Pos1),Pos1|RPath],searchFind(P,Pos1,Pos1,_,FL,G1,History),Children) ->  merge(Children,List,NewList); NewList = List);
   otherwise -> (setof([c(FL,G1,Pos1),Pos1|RPath],searchFind(P,Pos1,Pos1,_,FL,G1,History),Children) ->  merge(Children,List,NewList); NewList = List) 
  ),
  extract_pos_seen(NewList,History,Extracted),
  D1 is D+1,
  solve_task_bt(Task,Extracted,D1,RR,Cost,NewPos,[P|History]). 
  
achieved(go(Exit),Current,RPath,Cost,NewPos) :-
  Current = [c(Total,Cost,NewPos)|RPath],
  ( Exit=none -> true
  ; otherwise -> RPath = [Exit|_]
  ).
  
  
achieved(find(O),Current,RPath,Cost,NewPos) :-
  Current = [c(Cost,Travel,NewPos)|RPath],
  ( O=none    -> true
  ; otherwise -> RPath = [Last|_],map_adjacent(Last,_,O)
  ).

searchAstar(F,N,N,1,F1,Target,G1,History) :-
  map_adjacent(F,N,empty),
  \+ memberchk(N,History),
  map_distance(N,Target,H),  
  F1 is G1 + H.

  searchFind(F,N,N,1,F1,G1,History) :-
  map_adjacent(F,N,empty),
  \+ memberchk(N,History),  
  F1 is G1.
  
	merge([],Agenda,Agenda).
	merge([C|Cs],[],[C|Cs]).
	merge([[c(V1,P1,Move1)|Rest1]|Rest12],[[c(V2,P2,Move2)|Rest2]|Rest22],[[c(V1,P1,Move1)|Rest1]|Rest3]):-
	V1<V2,
	merge(Rest12,[[c(V2,P2,Move2)|Rest2]|Rest22],Rest3).
	merge([[c(V1,P1,Move1)|Rest1]|Rest12],[[c(V2,P2,Move2)|Rest2]|Rest22],[[c(V2,P2,Move2)|Rest2]|Rest3]):-
	V1>=V2,
	merge([[c(V1,P1,Move1)|Rest1]|Rest12],Rest22,Rest3).
  
  
   extract_pos_seen(NewList,[],NewList).
    extract_pos_seen(NewList,[Pos|Rest],MinusAgenda):-
    delete(NewList,[c(_,_,Pos)|_],MinusAgenda),
    extract_pos_seen(MinusAgenda,Tail,NewExtracted).

