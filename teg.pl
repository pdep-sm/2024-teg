/* distintos paises */
paisContinente(americaDelSur, argentina).
paisContinente(americaDelSur, bolivia).
paisContinente(americaDelSur, brasil).
paisContinente(americaDelSur, chile).
paisContinente(americaDelSur, ecuador).
paisContinente(europa, alemania).
paisContinente(europa, espania).
paisContinente(europa, francia).
paisContinente(europa, inglaterra).
paisContinente(asia, aral).
paisContinente(asia, china).
paisContinente(asia, gobi).
paisContinente(asia, india).
paisContinente(asia, iran).

/*países importantes*/
paisImportante(argentina).
paisImportante(kamchatka).
paisImportante(alemania).

/*países limítrofes*/
limitrofes([argentina,brasil]).
limitrofes([bolivia,brasil]).
limitrofes([bolivia,argentina]).
limitrofes([argentina,chile]).
limitrofes([espania,francia]).
limitrofes([alemania,francia]).
limitrofes([nepal,india]).
limitrofes([china,india]).
limitrofes([nepal,china]).
limitrofes([afganistan,china]).
limitrofes([iran,afganistan]).

/*distribución en el tablero */
ocupa(argentina, azul, 4).
ocupa(bolivia, rojo, 1).
ocupa(brasil, verde, 4).
ocupa(chile, negro, 3).
ocupa(ecuador, rojo, 2).
ocupa(alemania, azul, 3).
ocupa(espania, azul, 1).
ocupa(francia, azul, 1).
ocupa(inglaterra, azul, 2). 
ocupa(aral, negro, 2).
ocupa(china, verde, 1).
ocupa(gobi, verde, 2).
ocupa(india, rojo, 3).
ocupa(iran, verde, 1).

/*continentes*/
continente(americaDelSur).
continente(europa).
continente(asia).

/*objetivos*/
objetivo(rojo, ocuparContinente(asia)).
objetivo(azul, ocuparPaises([argentina, bolivia, francia, inglaterra, china])).
objetivo(verde, destruirJugador(rojo)).
objetivo(negro, ocuparContinente(europa)).

% 1
% estaEnContinente/2: Relaciona un jugador y un continente si el jugador ocupa al menos un país en el continente.
estaEnContinente(Jugador, Continente):-
    ocupa(Pais, Jugador, _ ),
    paisContinente(Continente, Pais).

% 2
% cantidadPaises/2: Relaciona a un jugador con la cantidad de países que ocupa.
cantidadPaises(Jugador, Cantidad):-
    jugador(Jugador),
    findall(Pais, ocupa(Pais, Jugador, _), Paises),
    length(Paises, Cantidad).

% 3
% ocupaContinente/2: Relaciona un jugador y un continente si el jugador ocupa totalmente al continente.
ocupaContinente(Jugador, Continente):-
    continente(Continente),
    jugador(Jugador),
    not((estaEnContinente(OtroJugador, Continente), Jugador \= OtroJugador)).
ocupaContinente2(Jugador, Continente):-
    continente(Continente),
    jugador(Jugador),
    forall(paisContinente(Continente, Pais), ocupa(Pais, Jugador, _)).

jugador(Jugador):- objetivo(Jugador, _).

% 4 
% leFaltaMucho/2: Relaciona a un jugador y un continente si al jugador le falta 
% ocupar más de 2 países de dicho continente.
leFaltaMucho(Jugador, Continente):-
    jugador(Jugador),
    continente(Continente),
    /*estaEnContinente(Jugador, Continente),*/
    findall(Pais, (paisContinente(Continente, Pais), not(ocupa(Pais, Jugador, _))), Paises),
    length(Paises, Cantidad),
    Cantidad > 2.

% 5 
% sonLimitrofes/2: Relaciona 2 países si son limítrofes.
sonLimitrofes(Pais1, Pais2):-
    limitrofes([Pais1, Pais2]).
sonLimitrofes(Pais1, Pais2):-
    limitrofes([Pais2, Pais1]).

sonLimitrofes2(Pais1, Pais2):-
    limitrofes(Paises),
    member(Pais1, Paises),
    member(Pais2, Paises),
    Pais1 \= Pais2.

% 6 
/* esGroso/1: Un jugador es groso si cumple algunas de estas condiciones:
- ocupa todos los países importantes,
- ocupa más de 10 países
- o tiene más de 50 ejercitos.
*/
% paisOcupado(Pais, Ejercitos):- ocupa(Pais, _, Ejercitos).
tiene(Jugador, Pais, Ejercitos):- ocupa(Pais, Jugador, Ejercitos).
esGroso(Jugador):-
    jugador(Jugador),
    forall(paisImportante(Pais), ocupa(Pais, Jugador, _)).

esGroso(Jugador):-
    paisesJugador(Jugador, Paises),
    length(Paises, CantidadPaises),
    CantidadPaises > 10.

esGroso(Jugador):-
    paisesJugador(Jugador, Paises),
    maplist(tiene(Jugador), Paises, Cantidades),   
    sum_list(Cantidades, Total),
    Total > 50.

paisesJugador(Jugador, Paises):-
    jugador(Jugador),
    findall(Pais, 
            ocupa(Pais, Jugador, _), 
            Paises).



% 7
% estaEnElHorno/1: un país está en el horno si todos sus países limítrofes están ocupados
% por el mismo jugador que no es el mismo que ocupa ese país.
estaEnElHorno(Pais):-
    ocupa(Pais, Jugador, _),
    jugador(OtroJugador),
    OtroJugador \= Jugador,
    forall(sonLimitrofes(Pais, PaisLimitrofe), 
           ocupa(PaisLimitrofe, OtroJugador, _)).
/* NO HAGAN ESTO: */
estaEnElHorno2(Pais):-
    ocupa(Pais, Jugador, _),
    jugador(OtroJugador),
    OtroJugador \= Jugador,
    findall(PaisLimitrofe, sonLimitrofes(Pais, PaisLimitrofe), Paises), /* INNECESARIO */
    forall(member(OtroPais, Paises), ocupa(OtroPais, OtroJugador, _)).

% 8
% esCaotico/1: un continente es caótico si hay más de tres jugadores en el.

% 9
% capoCannoniere/1: es el jugador que tiene ocupado más países.

% 10
% ganadooor/1: un jugador es ganador si logro su objetivo.
