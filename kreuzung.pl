vorfahrt(ohne, [A, B, C, D], Reihenfolge) :- writeln('Noch nicht implementiert...').
vorfahrt(mitOR, [A, B, C, D], Reihenfolge) :- writeln('Noch nicht implementiert...').

% Vorfahrtsstraße
vorfahrt(mitOU, [A, B, C, D], Reihenfolge) :- Reihenfolge = [PrioAFinal,PrioBFinal,PrioCFinal,PrioDFinal], rechnePrioBFinal(B, D, PrioBFinal), rechnePrioDFinal(D, B, PrioDFinal), rechnePrioAFinal(A, B, PrioBFinal, C, D, PrioDFinal, PrioAFinal), rechnePrioCFinal(C, B, PrioBFinal, D, PrioDFinal, A, PrioAFinal, PrioCFinal).

% Stelle die Prioritaet von Fahrzeug B fest (Fahrzeug von Oben)
rechnePrioBFinal(B, D, Result) :- B = 'kein', Result = 0.
rechnePrioBFinal(B, D, Result) :- (B = 'rechts'; B = 'geradeaus'), Result = 1.
rechnePrioBFinal(B, D, Result) :- B = 'links', (D = 'kein'; D = 'links'), Result = 1.
rechnePrioBFinal(B, D, Result) :- B = 'links', (D = 'rechts'; D = 'geradeaus'), Result = 2.

% Stelle die Prioritaet von Fahrzeug D fest (Fahrzeug von Unten)
rechnePrioDFinal(D, B, Result) :- D = 'kein', Result = 0.
rechnePrioDFinal(D, B, Result) :- (D = 'geradeaus'; D = 'rechts'), Result = 1.
rechnePrioDFinal(D, B, Result) :- D = 'links', B = 'kein', Result = 1.
rechnePrioDFinal(D, B, Result) :- D = 'links', (B = 'rechts'; B = 'geradeaus'; B = 'links'), Result = 2.

% Stelle die Prioritaet von Fahrzeug A fest (Fahrzeug von Links)
rechnePrioAFinal(A, B, PrioBFinal, C, D, PrioDFinal, Result) :- A = 'kein', Result = 0.
% rechnePrioAFinal(A, B, PrioBFinal, C, D, PrioDFinal, Result) :- A = 'rechts', (B = 'rechts'; B = 'kein'), Result = 1.
rechnePrioAFinal(A, B, PrioBFinal, C, D, PrioDFinal, Result) :- A = 'rechts', B = 'kein', D = 'kein', Result = 1.
rechnePrioAFinal(A, B, PrioBFinal, C, D, PrioDFinal, Result) :- A = 'rechts', (B = 'rechts'; B = 'geradeaus'; B = 'links'; D = 'rechts'; D = 'geradeaus'; D = 'links'), maxP(PrioBFinal, PrioDFinal, PrioTemp), Result is PrioTemp + 1.
rechnePrioAFinal(A, B, PrioBFinal, C, D, PrioDFinal, Result) :- A = 'geradeaus', B = 'links', (D = 'rechts'; D = 'geradeaus'; D = 'kein'), Result is PrioBFinal + 1.
rechnePrioAFinal(A, B, PrioBFinal, C, D, PrioDFinal, Result) :- A = 'geradeaus', B = 'links', D = 'links', Result is PrioDFinal + 1.
rechnePrioAFinal(A, B, PrioBFinal, C, D, PrioDFinal, Result) :- A = 'geradeaus', B = 'geradeaus', (D = 'rechts'; D = 'geradeaus'; D = 'kein'), Result is PrioBFinal + 1.
rechnePrioAFinal(A, B, PrioBFinal, C, D, PrioDFinal, Result) :- A = 'geradeaus', B = 'geradeaus', D = 'links', Result is PrioDFinal + 1.
rechnePrioAFinal(A, B, PrioBFinal, C, D, PrioDFinal, Result) :- A = 'geradeaus', (B = 'rechts'; B = 'kein'), Result is PrioDFinal + 1.
% Wenn A links ist und C kein oder links ist, kann PrioAFinal jetzt festgestellt werden
rechnePrioAFinal(A, B, PrioBFinal, C, D, PrioDFinal, Result) :- A = 'links', (B = 'rechts'; B = 'kein'), (C = 'links'; C = 'kein'), (D = 'kein'), Result = 1.
rechnePrioAFinal(A, B, PrioBFinal, C, D, PrioDFinal, Result) :- A = 'links', (B = 'geradeaus'; B = 'links'; D = 'rechts'; D = 'geradeaus'; D = 'links'), (C = 'kein'; C = 'links'), groesstePrio(PrioBFinal, 0, PrioDFinal, PrioTemp), Result is PrioTemp + 1.
% Wenn A links ist und C rechts oder geradeaus ist, muss zunaechst PrioCFinal festgestellt werden (mit rechnePrioCFuerRG)
rechnePrioAFinal(A, B, PrioBFinal, C, D, PrioDFinal, Result) :- A = 'links', (B = 'geradeaus'; B = 'links'; D = 'rechts'; D = 'geradeaus'; D = 'links'), (C = 'rechts'; C = 'geradeaus'), rechnePrioCFuerRG(C, B, PrioBFinal, D, PrioDFinal, PrioC), groesstePrio(PrioBFinal, PrioC, PrioDFinal, PrioTemp), Result is PrioTemp + 1.

% Stelle die Prioritaet von Fahrzeug C fest (Fahrzeug von Links), wenn C rechts oder geradeaus ist
rechnePrioCFuerRG(C, B, PrioBFinal, D, PrioDFinal, Result) :- C = 'kein', Result = 0.
% rechnePrioCFuerRG(C, B, PrioBFinal, D, PrioDFinal, Result) :- C = 'rechts', (D = 'rechts'; D = 'kein'), Result = 1.
rechnePrioCFuerRG(C, B, PrioBFinal, D, PrioDFinal, Result) :- C = 'rechts', (B = 'rechts'; B = 'geradeaus'; B = 'links'; D = 'rechts'; D = 'geradeaus'; D = 'links'), maxP(PrioBFinal, PrioDFinal, PrioTemp), Result is PrioTemp + 1.
rechnePrioCFuerRG(C, B, PrioBFinal, D, PrioDFinal, Result) :- C = 'rechts', (D = 'geradeaus'; D = 'links'), Result is PrioDFinal + 1.
rechnePrioCFuerRG(C, B, PrioBFinal, D, PrioDFinal, Result) :- C = 'geradeaus', D = 'links', Result is PrioDFinal + 1.
rechnePrioCFuerRG(C, B, PrioBFinal, D, PrioDFinal, Result) :- C = 'geradeaus', D = 'geradeaus', (B = 'kein'; B = 'rechts'; B = 'geradeaus'), Result is PrioDFinal + 1.
rechnePrioCFuerRG(C, B, PrioBFinal, D, PrioDFinal, Result) :- C = 'geradeaus', D = 'geradeaus', B = 'links', Result is PrioBFinal + 1.
rechnePrioCFuerRG(C, B, PrioBFinal, D, PrioDFinal, Result) :- C = 'geradeaus', (D = 'kein'; D = 'rechts'), Result is PrioBFinal + 1.

% Stelle die Prioritaet von Fahrzeug C fest (Fahrzeug von Rechts)
rechnePrioCFinal(C, B, PrioBFinal, D, PrioDFinal, A, PrioAFinal, PrioCFinal) :- (C = 'kein'; C = 'rechts'; C = 'geradeaus'), rechnePrioCFuerRG(C, B, PrioBFinal, D, PrioDFinal, PrioCFinal).
rechnePrioCFinal(C, B, PrioBFinal, D, PrioDFinal, A, PrioAFinal, Result) :- C = 'links', (D = 'rechts'; D = 'kein'), B = 'kein', A = 'kein', Result = 1.
rechnePrioCFinal(C, B, PrioBFinal, D, PrioDFinal, A, PrioAFinal, Result) :- C = 'links', (D = 'geradeaus'; D = 'links'; B = 'rechts'; B = 'geradeaus'; B = 'links'; A = 'rechts'; A = 'geradeaus'; A = 'links'), groesstePrio(PrioAFinal, PrioBFinal, PrioDFinal, PrioTemp), Result is PrioTemp + 1.

% Gibbt die groesste Zahl zurueck
groesstePrio(X, Y, Z, Result) :- maxP(X, Y, Max1), maxP(Max1, Z, Result).
maxP(A, B, A) :- A >= B.
maxP(A, B, B) :- B > A.
