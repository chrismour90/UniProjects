% find_identity(-A) <- find hidden identity by repeatedly calling agent_ask_oracle(oscar,o(1),link,L)
:- dynamic 
	pedicted_list/1.

find_identity(A):-
	agent_ask_oracle(oscar,A,link,L),
	findall(N, pedicted_list(N), Predicted_Actors),
	length(Predicted_Actors,Predicted_Counter),
	(Predicted_Counter = 0 -> actor_counter_func(Predicted_Counter, Actor_Counter);
	otherwise ->  Actor_Counter is Predicted_Counter),
	actor_link_func(L, [], Predicted_Counter, Actor_Counter).

find_identity(A).
	
actor_counter_func(Predicted_Counter, C) :-
    (Predicted_Counter = 0 -> findall(N, actor(N), NS);
     otherwise -> findall(N, pedicted_list(N), NS)),
    length(NS, C).

get_wiki_func(Current, L):-
	wp(Current,WT),wt_link(WT,Link),
	(L = Link -> assert(pedicted_list(Current));
	L \= Link -> fail).

actor_link_func(_,ActorList,_,Actor_Counter):-
	length(ActorList, X),
	X = Actor_Counter.

actor_link_func(L, ActorList, Predicted_Counter, Actor_Counter):-
	(Predicted_Counter > 0 -> pedicted_list(Current), retract(pedicted_list(Current));
	 otherwise -> actor(Current)),
	\+ memberchk(Current, ActorList),
	append([Current],ActorList,NewActorList),
	get_wiki_func(Current,L),
	actor_link_func(L, NewActorList, Predicted_Counter, Actor_Counter).