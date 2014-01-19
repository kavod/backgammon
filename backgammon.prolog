/*
Stratégie Basvod

Pour une nouvelle partie : basvod([[[1,2],[12,5],[17,3],[19,5]],[[6,5],[8,3],[13,5],[24,2]]],[0,0],[0,0],[2,1],L,B,S,C).

Basvod est la fonction principale qui à partir d'une situation de jeu va retourner le coup proposé ainsi que la nouvelle situation
-L1 : Position du plateau
	C'est un COUPLE de liste, chaque liste représentant respectivement la position de nos pion et celle des pions adverses
	Chaque liste se décompose de la manière suivante : [[X1,Y1],[X2,Y2],...] Xi étant la ième position que l'on occupe, Yi étant le nombre de pion sur ce pic
	Exemple : [[1,2],[3,4],[5,2]] indique 2 pion sur le pic N°1, 4 pions sur le pic N°3 et 2 pions sur le pic N°5
B1 : Occupation de la bar.
	C'est un couple de valeur, chaque valeur représentant le nombre de pions mangés.
	Exemple : [3,2] : indique que nous avons 3 pions dans le bar et que l'adversaire en a 2
SN1 : Le nombre de pion que nous avons sorti du jeu
SE : le nombre de pion que l'adversaire a sorti du jeu
L3 : la situation d'arrivée
BN : le nombre de nos pions dans le bar à la fin du tour
BE : le nombre de pion que l'adversaire a dans le bar à la fin du tour.
SN2 : le nombre de pion que nous avons sorti du jeu à la fin du tour
LC : la liste des coups effectués pendant ce tour.
*/

basvod(L1,B1,[SN1,SE],[X,X],L3,[BE,BN],[SE,SN2],LC) :- 	bbjeu(L1,B1,SN1,[X,X,X,X],[],L2,[BN,BE],SN2,LC),
							bbadversaire(L2,L3).

basvod(L1,B1,[SN1,SE],[X,Y],L3,[BE,BN],[SE,SN2],LC) :- 	X>Y,
							bbjeu(L1,B1,SN1,[X,Y],[],L2,[BN,BE],SN2,LC),
							bbadversaire(L2,L3).
							
basvod(L1,B1,[SN1,SE],[X,Y],L3,[BE,BN],[SE,SN2],LC) :- 	Y>X,
							bbjeu(L1,B1,SN1,[Y,X],[],L2,[BN,BE],SN2,LC),
							bbadversaire(L2,L3).



/**********************************************************************************************************************************************************
 * lors que le tour est terminé, on met les valeurs du plateau point de vue adversaire (24=>1,1=>24,...) ainsi que l'ordre des valeurs de bar et de sortie *
 **********************************************************************************************************************************************************/

/* On inverse le plateau bbadversaire avec le notre */
bbadversaire([N1,E1],[E2,N2])	:-	bbadversaireR(N1,N2),
					bbadversaireR(E1,E2).


/* On convertit les valeurs des pics occupé pour être compréhensible par l'bbadversaire*/
bbadversaireR([],[]).

bbadversaireR([C1|L1],L3)	:-	bbadversaireR(L1,L2),
					bbchangevaleur(C1,C2),
					bbconcat(L2,[C2],L3).

bbchangevaleur([X1,Y],[X2,Y])	:-	X2 is 25 - X1.



/*******************************************************************************************************/


bbjeu(L,B,S,[],LC1,L,B,S,LC1).

bbjeu(L,[BN,BE],S,LV1,LC,L,[BN,BE],S,LC)	:-	BN>0,
							\+ bbsortieBar(L,[BN,BE],LV1,LC,_,_,_,_).

bbjeu(L1,[BN,BE],S1,LV1,LC1,L3,B3,S3,LC3)	:-	BN>0,
							bbsortieBar(L1,[BN,BE],LV1,LC1,L2,B2,LV2,LC2),
							bbjeu(L2,B2,S1,LV2,LC2,L3,B3,S3,LC3).
							
bbjeu(L1,[0,BE1],S1,LV1,LC1,L2,[0,BE2],S2,LC2)	:-	bbBarVide(L1,BE1,S1,LV1,LC1,L2,BE2,S2,LC2).


/*******************************************************************************************************/


bbsortieBar(L1,[BN1,BE1],LV1,LC1,L2,[BN2,BE2],LV2,LC2) :-	bbsortieBarMange(L1,LV1,LC1,L2,LV2,LC2),
								BN2 is BN1 - 1,
								BE2 is BE1 + 1.

bbsortieBar(L1,[BN1,BE],LV1,LC1,L2,[BN2,BE],LV2,LC2) :-	\+ bbsortieBarMange(L1,LV1,LC1,_,_,_),
							bbsortieBarNormale(L1,LV1,LC1,L2,LV2,LC2),
							BN2 is BN1 - 1.



/******************************************************************************************************/


bbsortieBarMange(L1,[V|LV],LC,L2,LV,[[0,V]|LC]) :-	bbsortieBarMange2(L1,V,L2).

bbsortieBarMange(L1,[V|LV1],LC1,L2,[V|LV2],LC2) :-	\+ bbsortieBarMange2(L1,V,_),
							bbsortieBarMange(L1,LV1,LC1,L2,LV2,LC2).
							


/***************************************************************************************************/



bbsortieBarMange2([LN1,[[V,1]|LE]],V,[LN2,LE])		:-	bbInsertionCouple([V,1],LN1,LN2).

bbsortieBarMange2([LN1,[[X,Y]|LE1]],V,[LN2,[[X,Y]|LE2]]) :-	X<V,
								bbsortieBarMange2([LN1,LE1],V,[LN2,LE2]).


/**************************************************************************************************/


bbsortieBarNormale(L1,[V|LV],LC1,L2,LV,LC2) :-	bbsortieBarNormale2(L1,V,LC1,L2,LC2).

bbsortieBarNormale(L1,[V|LV1],LC1,L2,[V|LV2],LC2) :-	\+ bbsortieBarNormale2(L1,V,LC1,_,_),
							bbsortieBarNormale(L1,LV1,LC1,L2,LV2,LC2).

bbsortieBarNormale2([LN1,LE],V,LC,[LN2,LE],[[0,V]|LC]) :-	bbCaseVide(LN1,V),
								bbCaseVide(LE,V),
								bbInsertionCouple([V,1],LN1,LN2).

bbsortieBarNormale2([LN1,LE],V,LC,[LN2,LE],[[0,V]|LC]) :-	\+ bbCaseVide(LN1,V),
								bbincrementerPic(LN1,V,LN2).




  /**************************************************************************************************/  
    

    
bbBarVide(L,B,S,[],LC,L,B,S,LC)			:- write('\ng utilisé tous mes coups').
    
    
bbBarVide(L1,BE1,S1,LV1,LC1,L3,BE3,S2,LC3)	:-	write('\nEst-ce que je peux manger ?'),
							bbVaManger(L1,LV1,[],LC1,L2,LV2,LC2),
							write('\nMiam, oui ! Il me reste '),
							write(LV2),
							BE2 is BE1 + 1,
							bbBarVide(L2,BE2,S1,LV2,LC2,L3,BE3,S2,LC3),
							!.

% On initialise avec un pic imaginaire (de coordonnée 0) qui aurait une probabilité -1 de se faire manger

bbBarVide([LN,LE],BE,S,_,LC,[LN,LE],BE,S,LC)	:-	write('\nJe ne peux plus jouer').

bbBarVide([LN1,LE1],BE1,S1,LV1,LC1,L3,BE2,S3,LC3) :-	write('\nJe vais tenter de sauver un pion'),
							bbAsauver([],LN1,LE1,BE1,LV1,[0,0],-1,LV1,LV2,COUP),
							bbUpdate(LN1,S1,COUP,LN2,S2),
							write('\nG sauvé un pion et il me reste '),
							write(LV2),
							bbBarVide([LN2,LE1],BE1,S2,LV2,[COUP|LC1],L3,BE2,S3,LC3),
							!.

bbBarVide([[[X,Y]|LN1],LE1],BE1,S1,[V|LV1],LC1,LN3,BE3,S3,LC3)	:-	write('\nJe vais tenter de sortir'),
									X>18,
									XV is X + V,
									XV>=25,
									Y1 is Y - 1,
									S2 is S1 + 1,
									write('\nG sorti un pion du pic '),
									write(X),
									bbBarVide([[[X,Y1]|LN1],LE1],BE1,S2,LV1,[[X,25]|LC1],LN3,BE3,S3,LC3),
									!.
								
								
								
bbBarVide([LN1,LE1],BE1,S1,LV1,LC1,L3,BE2,S3,LC3) :-	write('\nJe vais tenter de déplacer un pion'),
							bbdeplacement(LN1,LE1,BE1,S1,LV1,LC1,LN2,S2,LC2,[0,0],-99,[D,A],_),
							write('\nG déplacé un pion et il me reste '),
							V is A - D,
							bbextrait(V,LV1,LV2),
							write(LV2),
							bbBarVide([LN2,LE1],BE1,S2,LV2,LC2,L3,BE2,S3,LC3),
							!.


/**********************************************************************************************/
bbVaManger(L1,LV1,LI,LC1,L2,LV2,LC2)	:-	bbVaManger2(L1,LV1,LI,LC1,L2,LV2,LC2),
						!.

bbVaManger(L1,[V1,V2|LV1],LI,LC1,L2,LV2,LC2)	:-	V1V2 is V1 + V2,
							bbVaManger(L1,[V1V2|LV1],[V1,V2|LI],LC1,L2,LV2,LC2).


/*******************************************************************************************************/

bbVaManger2(L1,[V|LV1],LI,LC1,L2,LV1,[C|LC1])	:-	bbmange(L1,V,LI,L2,C),
							!.

bbVaManger2(L1,[V|LV1],LI,LC1,L2,[V|LV2],LC2)	:-	bbVaManger2(L1,LV1,LI,LC1,L2,LV2,LC2).

/*******************************************************************************************************/


bbmange([[[X,1]|LN1],LE1],V,LI,[LN2,LE2],[X,XV])	:-	XV is X + V,
								bbvalInter(X,LI,LE1),
								bbmange2(LE1,XV,LE2),
								bbInsertionCouple([XV,1],LN1,LN2),
								!.

bbmange([[[X,Y]|LN1],LE1],V,LI,[[[X,Y1]|LN2],LE2],[X,XV])	:-	Y>1,
									XV is X + V,
									bbvalInter(X,LI,LE1),
									Y1 is Y - 1,
									bbmange2(LE1,XV,LE2),
									bbInsertionCouple([XV,1],LN1,LN2),
									!.

bbmange([[[X,Y]|LN1],LE1],V,LI,[[[X,Y]|LN2],LE2],C)	:-	bbmange([LN1,LE1],V,LI,[LN2,LE2],C).
								



/*******************************************************************************************************/


% Tests sur les valeurs intermédiaires
bbvalInter(_,[],_).

bbvalInter(X,[V1,V2],LE1)	:-	bbvalInter1(X,[V1,V2],LE1).

bbvalInter(X,[V1,V2,V3|LI],LE1)	:-	bbvalInter2(X,[V1,V2,V3|LI],LE1).


/*******************************************************************************************************/


bbvalInter1(X,[V,_],LE1)	:-	XV is X + V,
					bbcaseVide(LE1,XV).

bbvalInter1(X,[_,V],LE1)	:-	XV is X + V,
					bbcaseVide(LE1,XV).


/*******************************************************************************************************/


bbvalInter2(X,[],LE1).

bbvalInter2(X,[V|LI],LE1)	:-	XV is X + V,
					bbcaseVide(LE1,XV),
					bbvalInter2(X,LI,LE1).



/*******************************************************************************************************/


bbmange2([[X,1]|LE],X,LE).

bbmange2([[X,Y]|LE1],P,[[X,Y]|LE2])	:-	X<P,
						bbmange2(LE1,P,LE2).



%On ne traite pas le cas de recouvrement où le pion n'est pas sauvable et que la proba de se faire manger est inférieur à un autre pion.
%Il faut REMONTER LE COUP !!!
%Il faut faire remonter la coordonnée du grand gagnant de notre concours "mais qui va avoir le droit de se sauver ! :)" lorsque la liste des pions à tester est vide.


bbAsauver(_,[],_,_,_,COUP,_,LV,LV,COUP).

bbAsauver(LT1,[[X,1]|LN1],LE1,BE1,LV1,_,P1,_,LV3,COUP2) :-	bbcalculProba(X,LE1,BE1,0,P2),
								P2>P1,
								bbestSauvable(X,LT1,LN1,LE1,LV1,[],LV2,COUP1),
								bbconcat(LT1,[[X,1]],LT2),
								bbAsauver(LT2,LN1,LE1,BE1,LV1,COUP1,P2,LV2,LV3,COUP2),
								!.

bbAsauver(LT1,[[X,1]|LN1],LE1,BE1,LV1,COUP1,P1,LV2,LV3,COUP2) :-	bbconcat(LT1,[[X,1]],LT2),
									bbAsauver(LT2,LN1,LE1,BE1,LV1,COUP1,P1,LV2,LV3,COUP2).

bbAsauver(LT1,[[X,Y]|LN1],LE1,BE1,LV1,COUP1,P1,LV2,LV3,COUP2) :-	Y>1,
									bbconcat(LT1,[[X,Y]],LT2),
									bbAsauver(LT2,LN1,LE1,BE1,LV1,COUP1,P1,LV2,LV3,COUP2).


/*******************************************************************************************************/


bbestSauvable(C,LN1,LN2,_,LV1,LI,LV2,COUP)		:-	bbestSauvable2(C,LN1,LN2,LV1,LV2,COUP),
								!.

bbestSauvable(C,LN1,LN2,LE,[V1,V2|LV1],LI,LV2,[D,A])	:-	V1V2 is V1 + V2,
								bbestSauvable(C,LN1,LN2,LE,[V1V2|LV1],[V1,V2|LI],LV2,[D,A]),
								bbvalInter(D,LI,LE).



/*******************************************************************************************************/


bbestSauvable2(C,LN1,LN2,[V|LV],LV,COUP)		:-	bbestSauvable3(C,LN1,LN2,V,COUP),
								!.

bbestSauvable2(C,LN1,LN2,[V|LV1],[V|LV2],COUP)		:-	bbestSauvable2(C,LN1,LN2,LV1,LV2,COUP).


/*******************************************************************************************************/


bbestSauvable3(C,[],_,V,[C,25])	:-	C > 18,
					25 =< C + V.
					
bbestSauvable3(C,[[X,_]|_],_,V,[C,25])	:-	X > 18,
						CV is C + V,
						CV = 25,
						!.

bbestSauvable3(C,[[X,Y]|LN1],_,V,COUP)	:-	X + V =< C,
						bbestSauvable4(C,[[X,Y]|LN1],V,COUP),
						!.

bbestSauvable3(C,_,LN2,V,[C,CV])	:-	CV is C + V,
						\+ bbcaseVide(LN2,CV),
						!.


/*******************************************************************************************************/


bbestSauvable4(C,[[X,Y]|_],V,[X,C])		:-	XV is X + V,
							XV = C,
							Y \= 2.
						
bbestSauvable4(C,[[X,_]|LN1],V,COUP)		:-	XV is X + V,
							XV < C,
							bbestSauvable4(C,LN1,V,COUP).


/*******************************************************************************************************/


bbcalculProba(X,[],BE,P1,P4)		:-	DIFF is 25 - X,
						bbproba(DIFF,P2),
						P3 is BE * P2,
						P4 is P1 + P3.

bbcalculProba(X,[[XE,_]|LE1],BE1,P2,P3)	:-	XE<X,
						bbcalculProba(X,LE1,BE1,P2,P3).
						
bbcalculProba(X,[[XE,_]|LE1],BE1,P1,P3)	:-	XE>X,
						DIFF is XE - X,
						bbproba(DIFF,P2),
						P is P1 + P2,
						bbcalculProba(X,LE1,BE1,P,P3).
						



/*******************************************************************************************************/

bbproba(1,12).
bbproba(2,13).
bbproba(3,15).
bbproba(4,16).
bbproba(5,16).
bbproba(6,18).
bbproba(7,6).
bbproba(8,6).
bbproba(9,5).
bbproba(10,3).
bbproba(11,2).
bbproba(12,3).
bbproba(13,0).
bbproba(14,0).
bbproba(15,1).
bbproba(16,1).
bbproba(17,0).
bbproba(18,1).
bbproba(19,0).
bbproba(20,1).
bbproba(21,0).
bbproba(22,0).
bbproba(23,0).
bbproba(24,1).
bbproba(X,-99) :- X>24.


/*******************************************************************************************************/


% A partir du coup, on met à jour la liste des pions et la sortie

bbUpdate(LN1,S1,[D,A],LN3,S2)	:-	bbDepart(D,LN1,LN2),
					bbArrive(A,LN2,S1,LN3,S2).
					
bbDepart(D,[[D,1]|LN1],LN1).

bbDepart(D,[[D,Y]|LN1],[[D,Y1]|LN1])	:-	Y>1,
						Y1 is Y - 1.

bbDepart(D,[[X,Y]|LN1],[[X,Y]|LN2])	:-	X<D,
						bbDepart(D,LN1,LN2).


/*******************************************************************************************************/


bbArrive(25,L,S1,L,S2)	:-	S2 is S1 + 1.

bbArrive(A,[],S,[[A,1]],S)			:-	A<25.

bbArrive(A,[[X,Y]|LN1],S,[[A,1],[X,Y]|LN1],S)	:-	A<25,
							A<X.

bbArrive(A,[[A,Y]|LN1],S,[[A,Y1]|LN1],S)	:-	Y1 is Y + 1.

bbArrive(A,[[X,Y]|LN1],S,[[X,Y]|LN2],S)		:-	A<25,
							A>X,
							bbArrive(A,LN1,S,LN2,S).


/*******************************************************************************************************/


bbdeplacement(L1,_,_,S1,[],LC1,L2,S2,[[D,A]|LC1],[D,A],P,[D,A],P)	:-	bbUpdate(L1,S1,[D,A],L2,S2).

bbdeplacement(L,LE,BE1,S1,[V|LV1],LC1,L2,S2,LC2,COUP1,P1,COUP3,P3)	:-	bbdeplacement2(L,LE,BE1,S1,V,COUP1,P1,COUP2,P2),
										P1<P2,
										bbdeplacement(L,LE,BE1,S1,LV1,LC1,L2,S2,LC2,COUP2,P2,COUP3,P3),
										!.

bbdeplacement(L,LE,BE1,S1,[V|LV1],LC1,L2,S2,LC2,COUP1,P1,COUP2,P2)	:-	bbdeplacement(L,LE,BE1,S1,LV1,LC1,L2,S2,LC2,COUP1,P1,COUP2,P2).


/*******************************************************************************************************/


bbdeplacement2([],_,_,_,_,COUP,P,COUP,P).

bbdeplacement2([[X,Y]|LN1],LE,BE1,S1,V,_,P1,COUP2,P2)	:-	bbdeplacement3([X,Y],LN1,LE,BE1,S1,V,COUP,P1,DIFF),
								bbdeplacement2(LN1,LE,BE1,S1,V,COUP,DIFF,COUP2,P2),
								!.

bbdeplacement2([[X,Y]|LN1],LE,BE1,S1,V,COUP,P1,COUP2,DIFF)	:-	bbdeplacement2(LN1,LE,BE1,S1,V,COUP,P1,COUP2,DIFF).


/*******************************************************************************************************/


bbdeplacement3([X,1],LN,LE,BE,S1,V,[X,XV],P1,DIFF)	:-		XV is X + V,
									bbcaseVide(LE,XV),
									bbcalculProba(X,LE,BE,0,P2),
									bbcalculProba(XV,LE,BE,0,P3),
									DIFF is P2 - P3,
									P1<DIFF,
									!.

bbdeplacement3([X,2],LN,LE,BE,S1,V,[X,XV],P1,DIFF)	:-	XV is X + V,
								bbcaseVide(LE,XV),
								bbcaseVide(LN,XV),
								bbcalculProba(X,LE,BE,0,P2),
								bbcalculProba(XV,LE,BE,0,P3),
								DIFF is 0 - P2 - P3,
								P1<DIFF.


bbdeplacement3([X,2],LN,LE,BE,S1,V,[X,XV],P1,DIFF)	:-	XV is X + V,
								bbcaseVide(LE,XV),
								\+ bbcaseVide(LN,XV),
								bbcalculProba(X,LE,BE,0,P2),
								DIFF is 0 - P2,
								P1<DIFF.

bbdeplacement3([X,Y],LN,LE,BE,S1,V,[X,XV],P1,DIFF)	:-		
									Y>2,
									XV is X + V,
									bbcaseVide(LN,XV),
									bbcaseVide(LE,XV),
									bbcalculProba(XV,LE,BE,0,P3),
									DIFF is 0 - P3,
									P1<DIFF.
								
bbdeplacement3([X,Y],LN,LE,BE,S1,V,[X,XV],P1,DIFF)	:-		Y>2,
									XV is X + V,
									\+ bbcaseVide(LN,XV),
									bbcaseVide(LE,XV),
									DIFF is 0,
									P1<DIFF.




/**
	extrait(X,L1,L2) extrait X de L1 et renvoie le résultat dans L2
**/
				
bbextrait(X,[X|L],L).
bbextrait(X,[Y|L1],[Y|L2])	:-	Y\=X,
					bbextrait(X,L1,L2).



/*******************************************************************************************************/


% Concaténation
bbconcat([],[],[]).

bbconcat(L,[],L) :- L\=[].

bbconcat([],L,L) :- L\=[].

bbconcat([X|Y],Z,[X|R]):-	Z \= [],
				bbconcat(Y,Z,R).

/*******************************************************************
 * Permet d'incrémenter le nombre de pion sur un pic             ***
 * On fournit la liste des pics de notre couleurs ([[BP,BN],BR]) ***
 * Le numéro du pic (P)                                          ***
 * Le paramètre de sortie contient la liste des pics, modifiée   ***
 *******************************************************************/
bbincrementerPic([[BP,BN]|BR] ,P, [[BP,BN]|L2]):-
    BP<P,
    bbincrementerPic(BR,P,L2).

bbincrementerPic([[BP,BN]|BR] ,P, [[BP,BN2]|BR]):-
    BP=P,
    BN2 is BN + 1.

/****************************************************************************
 * verifie qu'un pic est vide pour une couleur donnee (liste de couples)  ***
 ****************************************************************************/
bbCaseVide([],_).

bbCaseVide([[BP,_]|BR],P):-
    BP<P,
    bbCaseVide(BR,P).

bbCaseVide([[BP,_]|_],P):-
    BP>P.

/****************************************************************************
 * insertion d'un couple (pion entrant PE) dans la liste d'une couleur L  ***
 ****************************************************************************/
bbInsertionCouple([PE,UN],[[P,N]|L],[[PE,UN]|[[P,N]|L]]):-
    PE<P.

bbInsertionCouple([PE,UN],[],[[PE,UN]]).

bbInsertionCouple([PE,UN],[[P,N]|L], [[P,N]|C]):-
    PE>P,
    bbInsertionCouple([PE,UN],L,C).
    
    
    

/********************************************************************************
 * Permet de supprimer un couple pic-pion (NP,NN)                             ***
 * compris dans la liste d'une couleur            ([[NP,NN]|NR])              ***
 * On fournit le numéro de pic (CA)                                           ***
 * Le paramètre de sortie contient la liste des pics de la couleur, modifiée  ***
 ********************************************************************************/
bbSupprimerPic([[NP,NN]|NR],CA, [[NP,NN]|L2] ):-
    NP<CA,
    bbSupprimerPic(NR,CA,L2).

bbSupprimerPic([[NP,_]|NR],CA, NR):-
    NP=CA.
    
/****************************************************************************
 * verifie qu'un pic est vide pour une couleur donnee (liste de couples)  ***
 ****************************************************************************/
bbcaseVide([],_).

bbcaseVide([[BP,_]|BR],P):-
    BP<P,
    bbcaseVide(BR,P).

bbcaseVide([[BP,_]|_],P):-
    BP>P.



