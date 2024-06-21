% Abbiegende Vorfahrtsstraße
vorfahrt(mitOR, [A, B, C, D], Reihenfolge) :- 
	Reihenfolge = [PrioAFinal, PrioBFinal, PrioCFinal, PrioDFinal],
	reihenfolgeB_MitOR(B, PrioBFinal),
	reihenfolgeC_MitOR(C, B, PrioBFinal, PrioCFinal),
	reihenfolgeD_MitOR(D, B, PrioBFinal, C, PrioCFinal, PrioDFinal),
	reihenfolgeA_MitOR(A, B, PrioBFinal, C, PrioCFinal, D, PrioDFinal, PrioAFinal).
% Kreuzungsart ohne
vorfahrt(ohne, [A, B, C, D], Reihenfolge) :- 
	kreuzungOhne(ohne, [A, B, C, D], Reihenfolge).

% Vorfahrtsstraße
vorfahrt(mitOU, [A, B, C, D], Reihenfolge) :- 
	Reihenfolge = [PrioAFinal,PrioBFinal,PrioCFinal,PrioDFinal], 
	rechnePrioBFinal(B, D, PrioBFinal), 
	rechnePrioDFinal(D, B, PrioDFinal), 
	rechnePrioAFinal(A, B, PrioBFinal, C, D, PrioDFinal, PrioAFinal), 
	rechnePrioCFinal(C, B, PrioBFinal, D, PrioDFinal, A, PrioAFinal, PrioCFinal).

% Stelle die Prioritaet von Fahrzeug B fest (Fahrzeug von Oben)
rechnePrioBFinal(B, D, Result) :- 
	B = 'kein', Result = 0.
rechnePrioBFinal(B, D, Result) :- 
	(B = 'rechts'; B = 'geradeaus'), Result = 1.
rechnePrioBFinal(B, D, Result) :- 
	B = 'links', (D = 'kein'; D = 'links'), Result = 1.
rechnePrioBFinal(B, D, Result) :- 
	B = 'links', (D = 'rechts'; D = 'geradeaus'), Result = 2.

% Stelle die Prioritaet von Fahrzeug D fest (Fahrzeug von Unten)
rechnePrioDFinal(D, B, Result) :- 
	D = 'kein', Result = 0.
rechnePrioDFinal(D, B, Result) :- 
	(D = 'geradeaus'; D = 'rechts'), Result = 1.
rechnePrioDFinal(D, B, Result) :- 
	D = 'links', B = 'kein', Result = 1.
rechnePrioDFinal(D, B, Result) :- 
	D = 'links', nichtKein(B), Result = 2.

% Stelle die Prioritaet von Fahrzeug A fest (Fahrzeug von Links)
rechnePrioAFinal(A, B, PrioBFinal, C, D, PrioDFinal, Result) :- 
	A = 'kein', Result = 0.

rechnePrioAFinal(A, B, PrioBFinal, C, D, PrioDFinal, Result) :- 
	(A = 'rechts'; A = 'geradeaus'), B = 'kein', D = 'kein', Result = 1.

% Wenn A rechts ist, und B nicht kein oder D nicht kein, dann hat A zu warten 
rechnePrioAFinal(A, B, PrioBFinal, C, D, PrioDFinal, Result) :- 
	(A = 'rechts'; A = 'geradeaus'), 
	(nichtKein(B); nichtKein(D)), 
	maxP(PrioBFinal, PrioDFinal, PrioTemp), 
	Result is PrioTemp + 1.
% Wenn A links ist und C kein oder links ist, kann PrioAFinal jetzt festgestellt werden
rechnePrioAFinal(A, B, PrioBFinal, C, D, PrioDFinal, Result) :- 
	A = 'links', 
	B = 'kein', 
	(C = 'links'; C = 'kein'), 
	D = 'kein', 
	Result = 1.
rechnePrioAFinal(A, B, PrioBFinal, C, D, PrioDFinal, Result) :- 
	A = 'links', 
	(nichtKein(B); nichtKein(D)), 
	(C = 'kein'; C = 'links'), 
	groesstePrio(PrioBFinal, 0, PrioDFinal, PrioTemp), 
	Result is PrioTemp + 1.
% Wenn A links ist und C rechts oder geradeaus ist, muss zunaechst PrioCFinal festgestellt werden (mit rechnePrioCFuerRG)
rechnePrioAFinal(A, B, PrioBFinal, C, D, PrioDFinal, Result) :- 
	A = 'links', 
	(nichtKein(B); nichtKein(D)), 
	(C = 'rechts'; C = 'geradeaus'), 
	rechnePrioCFuerRG(C, B, PrioBFinal, D, PrioDFinal, PrioC), 
	groesstePrio(PrioBFinal, PrioC, PrioDFinal, PrioTemp), 
	Result is PrioTemp + 1.

% Stelle die Prioritaet von Fahrzeug C fest (Fahrzeug von Links), wenn C rechts oder geradeaus ist
rechnePrioCFuerRG(C, B, PrioBFinal, D, PrioDFinal, Result) :- 
	C = 'kein', Result = 0.
rechnePrioCFuerRG(C, B, PrioBFinal, D, PrioDFinal, Result) :- 
	(C = 'rechts'; C = 'geradeaus'), 
	B = 'kein', 
	D = 'kein', 
	Result = 1.
rechnePrioCFuerRG(C, B, PrioBFinal, D, PrioDFinal, Result) :- 
	(C = 'rechts'; C = 'geradeaus'), 
	(B = 'rechts'; B = 'geradeaus'; B = 'links'; D = 'rechts'; D = 'geradeaus'; D = 'links'), 
	maxP(PrioBFinal, PrioDFinal, PrioTemp), 
	Result is PrioTemp + 1.

% Stelle die Prioritaet von Fahrzeug C fest (Fahrzeug von Rechts), für den Fall, dass C links ist
rechnePrioCFinal(C, B, PrioBFinal, D, PrioDFinal, A, PrioAFinal, PrioCFinal) :- 
	(C = 'kein'; C = 'rechts'; C = 'geradeaus'), 
	rechnePrioCFuerRG(C, B, PrioBFinal, D, PrioDFinal, PrioCFinal).
rechnePrioCFinal(C, B, PrioBFinal, D, PrioDFinal, A, PrioAFinal, Result) :- 
	C = 'links', D = 'kein', B = 'kein', A = 'kein', Result = 1.
rechnePrioCFinal(C, B, PrioBFinal, D, PrioDFinal, A, PrioAFinal, Result) :- 
	C = 'links', 
	(nichtKein(A); nichtKein(B); nichtKein(D)), 
	groesstePrio(PrioAFinal, PrioBFinal, PrioDFinal, PrioTemp), 
	Result is PrioTemp + 1.

% Gibbt die groesste Zahl zurueck
groesstePrio(X, Y, Z, Result) :- 
	maxP(X, Y, Max1), 
	maxP(Max1, Z, Result).
maxP(A, B, A) :- A >= B.
maxP(A, B, B) :- B > A.

% Fahrzeug X ist nicht kein, wenn es rechts, geradeaus oder links ist
nichtKein(X) :- 
	X = rechts; X = geradeaus; X = links.

% Zaehle die Anzahl der Fahrzeuge auf der Kreuzung. Ein Fahrzeug wird gezählt,
% wenn es eines der Richtungswuensche rechts, geradeaus oder links hat.
zaehleFahrzeuge([], 0).
zaehleFahrzeuge([K|R], Result) :- 
	zaehleFahrzeuge(R, SubResult), 
	(K = 'rechts'; K = 'links'; K = 'geradeaus'), 
	Result is SubResult + 1.
zaehleFahrzeuge([K|R], Result) :- 
	zaehleFahrzeuge(R, SubResult), 
	K = 'kein', 
	Result is SubResult.

% Kreuzungsart ohne
kreuzungOhne(ohne, [A, B, C, D], Reihenfolge) :- 
	Reihenfolge = [1, 1, 1, 1], 
	zaehleFahrzeuge([A, B, C, D], AF), AF = 4, 
	A = 'rechts', B = 'rechts', C = 'rechts', D = 'rechts'.
kreuzungOhne(ohne, [A, F1, F2, F3], Reihenfolge) :- 
	Reihenfolge = [1, PrioF1Final, PrioF2Final, PrioF3Final], 
	zaehleFahrzeuge([A, F1, F2, F3], AF), AF = 4, 
	reiehenFolgeVonDrei([F1, F2, F3], A, PrioF1Final, PrioF2Final, PrioF3Final).

% Wenn weniger als vier Fahrzeuge auf Kreuzung, dann finde erstes 'kein' in der Liste 
kreuzungOhne(ohne, [A, F1, F2, F3], Reihenfolge) :- 
	Reihenfolge = [0, PrioF1Final, PrioF2Final, PrioF3Final], 
	A = 'kein', 
	reiehenFolgeVonDrei([F1, F2, F3], A, PrioF1Final, PrioF2Final, PrioF3Final).

kreuzungOhne(ohne, [F3, B, F1, F2], Reihenfolge) :- 
	Reihenfolge = [PrioF3Final, 0, PrioF1Final, PrioF2Final], 
	B = 'kein', 
	reiehenFolgeVonDrei([F1, F2, F3], B, PrioF1Final, PrioF2Final, PrioF3Final).

kreuzungOhne(ohne, [F2, F3, C, F1], Reihenfolge) :- 
	Reihenfolge = [PrioF2Final, PrioF3Final, 0, PrioF1Final], 
	C = 'kein', 
	reiehenFolgeVonDrei([F1, F2, F3], C, PrioF1Final, PrioF2Final, PrioF3Final).

kreuzungOhne(ohne, [F1, F2, F3, D], Reihenfolge) :- 
	Reihenfolge = [PrioF1Final, PrioF2Final, PrioF3Final, 0], 
	D = 'kein', 
	reiehenFolgeVonDrei([F1, F2, F3], D, PrioF1Final, PrioF2Final, PrioF3Final).

% Stelle die Reihenfolge von den drei Fahrzeuge F1, F2 und F3 fest
reiehenFolgeVonDrei([F1, F2, F3], K, PrioF1Final, PrioF2Final, PrioF3Final) :- 
	rechnePrioF1Final(F1, F2, F3, K, PrioF1Final), 
	rechnePrioF2Final(F2, F1, K, PrioF1Final, PrioF2Final), 
	rechnePrioF3Final(F3, F2, F1, K, PrioF1Final, PrioF2Final, PrioF3Final).

rechnePrioF1Final(F1, F2, F3, K, Result) :- F1 = 'kein', Result = 0.
rechnePrioF1Final(F1, F2, F3, K, Result) :- F1 = 'rechts', Result = 1.
rechnePrioF1Final(F1, F2, F3, K, Result) :- F1 = 'geradeaus', nichtKein(K), Result = 2.
rechnePrioF1Final(F1, F2, F3, K, Result) :- F1 = 'geradeaus', K = 'kein', Result = 1.
rechnePrioF1Final(F1, F2, F3, K, Result) :- F1 = 'links', nichtKein(F2), (K = 'geradeaus'; K = 'links'), Result = 2.
rechnePrioF1Final(F1, F2, F3, K, Result) :- F1 = 'links', nichtKein(F2), (K = 'kein'; K = 'rechts'), Result = 1.
rechnePrioF1Final(F1, F2, F3, K, Result) :- F1 = 'links', F2 = 'kein', (F3 = 'rechts'; F3 = 'geradeaus'), K = 'geradeaus', Result = 3.
rechnePrioF1Final(F1, F2, F3, K, Result) :- F1 = 'links', F2 = 'kein', (F3 = 'rechts'; F3 = 'geradeaus'), K = 'kein', Result = 2.
rechnePrioF1Final(F1, F2, F3, K, Result) :- F1 = 'links', F2 = 'kein', (F3 = 'kein'; F3 = 'links'), (K = 'geradeaus'; K = 'links'), Result = 2.
rechnePrioF1Final(F1, F2, F3, K, Result) :- F1 = 'links', F2 = 'kein', (F3 = 'kein'; F3 = 'links'), K = 'kein', Result = 1.

rechnePrioF2Final(F2, F1, K, PrioF1Final, Result) :- F2 = 'kein', Result = 0.
rechnePrioF2Final(F2, F1, K, PrioF1Final, Result) :- F2 = 'rechts', K = 'links', Result = 2.
rechnePrioF2Final(F2, F1, K, PrioF1Final, Result) :- F2 = 'rechts', (K = 'kein'; K = 'rechts'; K = 'geradeaus'), Result = 1.
rechnePrioF2Final(F2, F1, K, PrioF1Final, Result) :- F2 = 'geradeaus', F1 = 'kein', K = 'links', Result = 2.
rechnePrioF2Final(F2, F1, K, PrioF1Final, Result) :- F2 = 'geradeaus', F1 = 'kein', (K = 'kein'; K = 'rechts'; K = 'geradeaus'), Result = 1.
rechnePrioF2Final(F2, F1, K, PrioF1Final, Result) :- F2 = 'geradeaus', nichtKein(F1), Result is PrioF1Final + 1.
rechnePrioF2Final(F2, F1, K, PrioF1Final, Result) :- F2 = 'links', (F1 = 'kein'; F1 = 'rechts'), nichtKein(K), Result = 2.
rechnePrioF2Final(F2, F1, K, PrioF1Final, Result) :- F2 = 'links', (F1 = 'kein'; F1 = 'rechts'), K = 'kein', Result = 1.
rechnePrioF2Final(F2, F1, K, PrioF1Final, Result) :- F2 = 'links', (F1 = 'geradeaus'; F1 = 'links'), Result is PrioF1Final + 1.

rechnePrioF3Final(F3, F2, F1, K, PrioF1Final, PrioF2Final, Result) :- F3 = 'kein', Result = 0.
rechnePrioF3Final(F3, F2, F1, K, PrioF1Final, PrioF2Final, Result) :- F3 = 'rechts', nichtKein(F2), F1 = 'links', Result is PrioF1Final + 1.
rechnePrioF3Final(F3, F2, F1, K, PrioF1Final, PrioF2Final, Result) :- F3 = 'rechts', K = 'geradeaus', Result = 2.
rechnePrioF3Final(F3, F2, F1, K, PrioF1Final, PrioF2Final, Result) :- F3 = 'rechts', (K = 'kein'; K = 'rechts'; K = 'links'), Result = 1.
rechnePrioF3Final(F3, F2, F1, K, PrioF1Final, PrioF2Final, Result) :- F3 = 'geradeaus', nichtKein(F2), Result is PrioF2Final + 1.
rechnePrioF3Final(F3, F2, F1, K, PrioF1Final, PrioF2Final, Result) :- F3 = 'geradeaus', F2 = 'kein', (K = 'geradeaus'; K = 'links'), Result = 2.
rechnePrioF3Final(F3, F2, F1, K, PrioF1Final, PrioF2Final, Result) :- F3 = 'geradeaus', F2 = 'kein', (K = 'kein'; K = 'rechts'), Result = 1.
rechnePrioF3Final(F3, F2, F1, K, PrioF1Final, PrioF2Final, Result) :- 
	F3 = 'links', (F2 = 'kein'; F2 = 'rechts'), 
	F1 = 'kein', (K = 'geradeaus'; K = 'links'), Result = 2.
rechnePrioF3Final(F3, F2, F1, K, PrioF1Final, PrioF2Final, Result) :- 
	F3 = 'links', (F2 = 'kein'; F2 = 'rechts'), 
	F1 = 'kein', (K = 'kein'; K = 'rechts'), Result = 1.
rechnePrioF3Final(F3, F2, F1, K, PrioF1Final, PrioF2Final, Result) :- 
	F3 = 'links', (F2 = 'kein'; F2 = 'rechts'), 
	nichtKein(F1), Result is PrioF1Final + 1.
rechnePrioF3Final(F3, F2, F1, K, PrioF1Final, PrioF2Final, Result) :- 
	F3 = 'links', (F2 = 'geradeaus'; F2 = 'links'), 
	Result is PrioF2Final + 1.

% Abbiegende Vorfahrtsstraße
reihenfolgeB_MitOR(B, Result) :-
	B = 'kein', Result = 0.
reihenfolgeB_MitOR(B, Result) :-
	nichtKein(B), Result = 1.

reihenfolgeC_MitOR(C, B, PrioBFinal, Result) :-
	C = 'kein', Result = 0.
reihenfolgeC_MitOR(C, B, PrioBFinal, Result) :-
	C = 'rechts', Result = 1.
reihenfolgeC_MitOR(C, B, PrioBFinal, Result) :-
	C = 'geradeaus', nichtKein(B), Result is PrioBFinal + 1.
reihenfolgeC_MitOR(C, B, PrioBFinal, Result) :-
	C = 'geradeaus', B = 'kein', Result = 1.
reihenfolgeC_MitOR(C, B, PrioBFinal, Result) :-
	C = 'links', (B = 'geradeaus'; B = 'links'), Result is PrioBFinal + 1.
reihenfolgeC_MitOR(C, B, PrioBFinal, Result) :-
	C = 'links', (B = 'kein'; B = 'rechts'), Result = 1.

reihenfolgeD_MitOR(D, B, PrioBFinal, C, PrioCFinal, Result) :-
	D = 'kein', Result = 0.
reihenfolgeD_MitOR(D, B, PrioBFinal, C, PrioCFinal, Result) :-
	nichtKein(D), B = 'kein', C = 'kein', Result = 1.
reihenfolgeD_MitOR(D, B, PrioBFinal, C, PrioCFinal, Result) :-
	nichtKein(D), (nichtKein(B); nichtKein(C)),
	maxP(PrioBFinal, PrioCFinal, PrioTemp), Result is PrioTemp + 1.

reihenfolgeA_MitOR(A, B, PrioBFinal, C, PrioCFinal, D, PrioDFinal, Result) :-
	A = 'kein', Result = 0.
reihenfolgeA_MitOR(A, B, PrioBFinal, C, PrioCFinal, D, PrioDFinal, Result) :-
	A = 'rechts', B = 'kein', C = 'kein', Result = 1.
reihenfolgeA_MitOR(A, B, PrioBFinal, C, PrioCFinal, D, PrioDFinal, Result) :-
	A = 'rechts', (nichtKein(B); nichtKein(C)),
	maxP(PrioBFinal, PrioCFinal, PrioTemp), Result is PrioTemp + 1.
reihenfolgeA_MitOR(A, B, PrioBFinal, C, PrioCFinal, D, PrioDFinal, Result) :-
	A = 'geradeaus', nichtKein(D), Result is PrioDFinal + 1.
reihenfolgeA_MitOR(A, B, PrioBFinal, C, PrioCFinal, D, PrioDFinal, Result) :-
	A = 'geradeaus', D = 'kein', B = 'kein', C = 'kein', Result = 1.
reihenfolgeA_MitOR(A, B, PrioBFinal, C, PrioCFinal, D, PrioDFinal, Result) :-
	A = 'geradeaus', D = 'kein',
	(nichtKein(B); nichtKein(C)),
	maxP(PrioBFinal, PrioCFinal, PrioTemp), Result is PrioTemp + 1.
reihenfolgeA_MitOR(A, B, PrioBFinal, C, PrioCFinal, D, PrioDFinal, Result) :-
	A = 'links', (D = 'kein'; D = 'rechts'),
	B = 'kein', C = 'kein', Result = 1.
reihenfolgeA_MitOR(A, B, PrioBFinal, C, PrioCFinal, D, PrioDFinal, Result) :-
	A = 'links', (D = 'kein'; D = 'rechts'),
	(nichtKein(B); nichtKein(C)),
	maxP(PrioBFinal, PrioCFinal, PrioTemp), Result is PrioTemp + 1.
reihenfolgeA_MitOR(A, B, PrioBFinal, C, PrioCFinal, D, PrioDFinal, Result) :-
	A = 'links', (D = 'geradeaus'; D = 'links'), Result is PrioDFinal + 1.
	
	
	
