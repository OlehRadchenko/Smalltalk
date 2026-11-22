
Object subclass: Warunki [
    | nazwa |

    Warunki class >> new [
        | inst |
        inst := super new.
        inst initialize.
        ^inst
    ]

    initialize [
        nazwa := 'Warunki nieznane'.
    ]

    nazwa [ ^nazwa ]
    nazwa: n [ nazwa := n. ^self ]

    Warunki class >> optymalne [
        ^WarunkiOptymalne new
    ]

    Warunki class >> burzaPylowa [
        ^BurzaPylowa new
    ]

    Warunki class >> deszczMeteorytow [
        ^DeszczMeteorytow new
    ]

    Warunki class >> zorzaPolarna [
        ^ZorzaPolarna new
    ]

    modyfikujCzas: czasPodstawowy dlaOdcinka: odcinek [
        self subclassResponsibility.
    ]

    komentarzWidokowy [
        ^''
    ]
]

Warunki subclass: WarunkiOptymalne [
    initialize [
        super initialize.
        nazwa := 'Warunki optymalne (brak anomalii)'.
    ]

    modyfikujCzas: czasPodstawowy dlaOdcinka: odcinek [
        ^czasPodstawowy
    ]
]

Warunki subclass: BurzaPylowa [
    initialize [
        super initialize.
        nazwa := 'Burza pylowa na Marsie'.
    ]

    modyfikujCzas: czasPodstawowy dlaOdcinka: odcinek [
        "Spowalnia ruch o 20% oraz dolicza 5 minut procedur pyloodpornych"
        ^((czasPodstawowy * 1.20) + 5) rounded
    ]
]

"Deszcz meteorytow w kosmosie - podwaja czas skafandra, +50% lazik, prom ma pancerz"
Warunki subclass: DeszczMeteorytow [
    initialize [
        super initialize.
        nazwa := 'Deszcz meteorytow w kosmosie'.
    ]

    modyfikujCzas: czasPodstawowy dlaOdcinka: odcinek [
        ^odcinek modyfikujCzasDlaDeszczuMeteorytow: czasPodstawowy
    ]
]


Warunki subclass: ZorzaPolarna [
    initialize [
        super initialize.
        nazwa := 'Zorza polarna'.
    ]

    modyfikujCzas: czasPodstawowy dlaOdcinka: odcinek [
        ^odcinek modyfikujCzasDlaZorzyPolarnej: czasPodstawowy
    ]

    komentarzWidokowy [
        ^' (Karynka z rodzinką chce obejrzeć widoczki!)'
    ]
]

Object subclass: Pasazer [
    | imie |

    Pasazer class >> new [
        | inst |
        inst := super new.
        inst initialize.
        ^inst
    ]

    Pasazer class >> nazwa: nazwisko [
        | inst |
        inst := self new.
        inst imie: nazwisko.
        ^inst
    ]

    initialize [
        imie := 'Anonim'.
    ]

    imie [ ^imie ]
    imie: n [ imie := n. ^self ]

    opisTaryfy [
        ^'Pasazer'
    ]

    naliczKoszt: cenaPodstawowa [
        self subclassResponsibility.
    ]
]

Pasazer subclass: Turysta [
    opisTaryfy [
        ^'Turysta (taryfa normalna)'
    ]

    naliczKoszt: cenaPodstawowa [
        ^cenaPodstawowa
    ]
]

"Inzynier Bazy Ares - 100% znizki (podrozuje calkowicie za darmo)"
Pasazer subclass: InzynierBazyAres [
    opisTaryfy [
        ^'Inżynier Bazy Ares (ulga 100%)'
    ]

    naliczKoszt: cenaPodstawowa [
        ^0
    ]
]

"Gornik Kolonijny - 50% znizki"
Pasazer subclass: GornikKolonijny [
    opisTaryfy [
        ^'Górnik Kolonijny (ulga 50%)'
    ]

    naliczKoszt: cenaPodstawowa [
        cenaPodstawowa <= 0 ifTrue: [ ^0 ].
        ^(cenaPodstawowa * 0.5) rounded
    ]
]

"Polityk - na Marsa za darmo (0 zl), ale powrot na Ziemie kosztuje 250% biletu"
Pasazer subclass: Polityk [
    | kierunek |

    Polityk class >> naMarsa [
        | inst |
        inst := self new.
        inst kierunekNaMarsa.
        ^inst
    ]

    Polityk class >> powrotNaZiemie [
        | inst |
        inst := self new.
        inst kierunekPowrotNaZiemie.
        ^inst
    ]

    initialize [
        super initialize.
        kierunek := #NaMarsa.
    ]

    kierunekNaMarsa [
        kierunek := #NaMarsa.
        ^self
    ]

    kierunekPowrotNaZiemie [
        kierunek := #PowrotNaZiemie.
        ^self
    ]

    kierunek [ ^kierunek ]

    opisTaryfy [
        kierunek = #NaMarsa ifTrue: [
            ^'Polityk [Kierunek: Na Marsa]'
        ].
        ^'Polityk [Kierunek: Powrót na Ziemię] (taryfa karna 250%)'
    ]

    naliczKoszt: cenaPodstawowa [
        kierunek = #NaMarsa ifTrue: [
            ^0
        ].
        cenaPodstawowa <= 0 ifTrue: [ ^0 ].
        ^(cenaPodstawowa * 2.5) rounded
    ]
]

Object subclass: OdcinekPodrozy [
    | poczatek koniec dystans czasBazowy |

    OdcinekPodrozy class >> new [
        | inst |
        inst := super new.
        inst initialize.
        ^inst
    ]

    OdcinekPodrozy class >> z: pPoczatkowy do: pKoncowy dystans: dystansKm [
        | inst |
        inst := self new.
        inst poczatek: pPoczatkowy.
        inst koniec: pKoncowy.
        inst dystans: dystansKm.
        ^inst
    ]

    initialize [
        poczatek := 'Punkt Startowy'.
        koniec := 'Punkt Docelowy'.
        dystans := 0.
        czasBazowy := 0.
    ]

    poczatek [ ^poczatek ]
    poczatek: nazwa [ poczatek := nazwa. ^self ]

    koniec [ ^koniec ]
    koniec: nazwa [ koniec := nazwa. ^self ]

    dystans [ ^dystans ]
    dystans: km [ 
        km < 0 ifTrue: [ self error: 'Blad: Dystans nie moze byc ujemny!'. ].
        dystans := km. 
        ^self 
    ]

    ustawCzas: min [ czasBazowy := min. ^self ]

    czas [
        czasBazowy > 0 ifTrue: [ ^czasBazowy ].
        ^self obliczCzas
    ]

    obliczCzas [
        ^dystans rounded
    ]

    koszt [
        ^0
    ]
    
    emisjaCO2[
        ^0
    ]

    opis [
        ^'Odcinek standardowy'
    ]

    "MODUL F: Koszt dla pasazera"
    kosztDlaOsoby: pasazer [
        (pasazer isKindOf: Pasazer) ifFalse: [
            self error: 'Blad: Argument musi byc obiektem klasy Pasazer'.
        ].
        ^pasazer naliczKoszt: self koszt
    ]

    kosztDla: pasazer [
        ^self kosztDlaOsoby: pasazer
    ]

    "MODUL G: Czas dla warunkow pogodowych"
    czasDlaOsoby: warunki [
        (warunki isKindOf: Warunki) ifFalse: [
            self error: 'Blad: Argument musi byc obiektem klasy Warunki'.
        ].
        ^warunki modyfikujCzas: self czas dlaOdcinka: self
    ]

    czasDla: warunki [
        ^self czasDlaOsoby: warunki
    ]

    "Domyslne zachowania w anomaliach"
    modyfikujCzasDlaDeszczuMeteorytow: czasWejsciowy [
        ^czasWejsciowy
    ]

    modyfikujCzasDlaZorzyPolarnej: czasWejsciowy [
        ^czasWejsciowy
    ]

    "MODUL 2: Operator + w klasie OdcinekPodrozy (dynamiczne rozpoznawanie typu)"
    + drugi [
        (drugi isKindOf: OdcinekPodrozy) ifTrue: [
            | nowaTrasa |
            nowaTrasa := Trasa new.
            nowaTrasa dodajOdcinek: self.
            nowaTrasa dodajOdcinek: drugi.
            ^nowaTrasa
        ].
        (drugi isKindOf: Trasa) ifTrue: [
            | nowaTrasa |
            nowaTrasa := Trasa new.
            nowaTrasa dodajOdcinek: self.
            nowaTrasa dodajWszystkie: drugi odcinki.
            ^nowaTrasa
        ].
        self error: 'Blad polaczenia: Oczekiwano obiektu OdcinekPodrozy lub Trasa'.
    ]
]


"1. Skafander Ares: darmowy, ale najwolniejszy"
OdcinekPodrozy subclass: SkafanderAres [
    opis [ ^'Skafander Ares' ]

    obliczCzas [
        ^(dystans * 15) rounded
    ]

    koszt [
        ^0
    ]
    
    emisjaCO2 [
        ^(dystans * 35) rounded
    ]

    modyfikujCzasDlaDeszczuMeteorytow: czasWejsciowy [
        "Deszcz meteorytow podwaja czas trasy skafandra"
        ^(czasWejsciowy * 2) rounded
    ]
]

"2. Lekki Lazik: wolny, ale tani (odpowiednik roweru)"
OdcinekPodrozy subclass: LekkiLazik [
    opis [ ^'Lekki Łazik' ]

    obliczCzas [
        ^((dystans * 5) + 2) rounded
    ]

    koszt [
        ^(dystans * 1) rounded
    ]
    
    emisjaCO2 [
        ^(dystans * 20) rounded
    ]

    modyfikujCzasDlaDeszczuMeteorytow: czasWejsciowy [
        "Deszcz meteorytow wydluza czas lazikowi o 50%"
        ^(czasWejsciowy * 1.5) rounded
    ]
]

"3. Prom Transportowy Ares: bardzo drogi (premium), szybki w prozni"
OdcinekPodrozy subclass: PromTransportowyAres [
    opis [ ^'Prom Transportowy Ares (Premium)' ]

    obliczCzas [
        ^((dystans * 0.5) + 15) rounded
    ]

    koszt [
        ^(350 + (dystans * 8)) rounded
    ]
    
    emisjaCO2 [
        ^(dystans * 300) rounded
    ]

    modyfikujCzasDlaDeszczuMeteorytow: czasWejsciowy [
        "Prom jest potezny i opancerzony - deszcz meteorytow mu nie szkodzi"
        ^czasWejsciowy
    ]

    modyfikujCzasDlaZorzyPolarnej: czasWejsciowy [
        "Prom zwalnia z powodu turystow chcacych ogladac zorze"
        ^(czasWejsciowy + 45) rounded
    ]
]

"4. Kolej Magnetyczna: mega szybka, ale tylko po terenie bazy (tunele), tansza od promu"
OdcinekPodrozy subclass: KolejMagnetyczna [
    opis [ ^'Kolej Magnetyczna Tuneli Bazy' ]

    obliczCzas [
        ^((dystans * 0.8) + 3) rounded
    ]

    koszt [
        ^(25 + (dystans * 1.5)) rounded
    ]
    
    emisjaCO2 [
        ^(dystans * 500) rounded
    ]

    modyfikujCzasDlaDeszczuMeteorytow: czasWejsciowy [
        "Kolej porusza sie w podziemnych tunelach"
        ^czasWejsciowy
    ]
]

"5. Cięzki Łazik Transportowy Ares: opancerzony pojazd towarowo-załogowy"
OdcinekPodrozy subclass: LazikMarsjanski [
    opis [ ^'Ciężki Łazik Transportowy Ares' ]

    obliczCzas [
        ^((dystans * 2.5) + 5) rounded
    ]

    koszt [
        ^(15 + (dystans * 2)) rounded
    ]
    
    emisjaCO2 [
        ^(dystans * 700) rounded
    ]

    modyfikujCzasDlaDeszczuMeteorytow: czasWejsciowy [
        "Ciezki pancerz - spowolnienie o 10%"
        ^(czasWejsciowy * 1.10) rounded
    ]
]

SkafanderAres subclass: Pieszo []
LekkiLazik subclass: Rower []
PromTransportowyAres subclass: Autobus []

Object subclass: Trasa [
    | odcinki |

    Trasa class >> new [
        | inst |
        inst := super new.
        inst initialize.
        ^inst
    ]

    initialize [
        odcinki := OrderedCollection new.
    ]

    odcinki [
        ^odcinki
    ]

    dodajOdcinek: odcinek [
        (odcinek isKindOf: OdcinekPodrozy) ifFalse: [
            self error: 'Blad: Oczekiwano obiektu klasy OdcinekPodrozy'.
        ].
        odcinki add: odcinek.
        ^self
    ]

    dodajWszystkie: kolekcjaOdcinkow [
        odcinki addAll: kolekcjaOdcinkow.
        ^self
    ]

    "MODUL 2: Operator + w klasie Trasa (dynamiczne rozpoznawanie typu argumentu)"
    + drugi [
        | nowaTrasa |
        nowaTrasa := Trasa new.
        nowaTrasa dodajWszystkie: odcinki.

        (drugi isKindOf: OdcinekPodrozy) ifTrue: [
            nowaTrasa dodajOdcinek: drugi.
            ^nowaTrasa
        ].

        (drugi isKindOf: Trasa) ifTrue: [
            nowaTrasa dodajWszystkie: drugi odcinki.
            ^nowaTrasa
        ].

        self error: 'Blad polaczenia: Oczekiwano obiektu OdcinekPodrozy lub Trasa'.
    ]

    "MODUL 3: Polimorficzna agregacja (inject:into:)"
    dystans [
        ^odcinki inject: 0 into: [ :suma :odcinek | suma + odcinek dystans ]
    ]

    czas [
        ^odcinki inject: 0 into: [ :suma :odcinek | suma + odcinek czas ]
    ]

    koszt [
        ^odcinki inject: 0 into: [ :suma :odcinek | suma + odcinek koszt ]
    ]
    emisjaCO2 [
        ^odcinki inject: 0 into: [ :suma :odcinek | suma + odcinek emisjaCO2 ]
    ]
    
    porownajEmisjeZ: innaTrasa [
        | e1 e2 |
        (innaTrasa isKindOf: Trasa) ifFalse: [
            self error: 'Blad: Argument musi byc obiektem klasy Trasa'.
        ].
        e1 := self emisjaCO2.
        e2 := innaTrasa emisjaCO2.

        (e1 < e2) ifTrue: [
            ^'Pierwsza trasa jest bardziej ekologiczna (' , e1 printString , ' g vs ' , e2 printString , ' g CO2)'
        ].
        (e1 > e2) ifTrue: [
            ^'Druga trasa jest bardziej ekologiczna (' , e1 printString , ' g vs ' , e2 printString , ' g CO2)'
        ].

        ^'Obie trasy maja identyczna emisje CO2: ' , e1 printString , ' g'
    ]

    "Zaawansowane mechanizmy kolekcji"
    listaDystansow [
        ^odcinki collect: [ :odcinek | odcinek dystans ]
    ]

    odcinkiKosmiczne [
        ^odcinki select: [ :odcinek | odcinek isKindOf: PromTransportowyAres ]
    ]

    odcinkiPowierzchniowe [
        ^odcinki reject: [ :odcinek | odcinek isKindOf: PromTransportowyAres ]
    ]

    znajdzOdcinekStartujacyZ: nazwaStacji [
        ^odcinki detect: [ :odcinek | odcinek poczatek = nazwaStacji ] ifNone: [ nil ]
    ]

    "Dynamiczne rozpoznawanie typu obiektu"
    rozpoznajTypObiektu: dowolnyObiekt [
        (dowolnyObiekt isKindOf: OdcinekPodrozy) ifTrue: [ 
            ^'Rozpoznano Odcinek Podróży: ' , dowolnyObiekt opis 
        ].
        (dowolnyObiekt isKindOf: Trasa) ifTrue: [ 
            ^'Rozpoznano Trasę: liczba etapów = ' , dowolnyObiekt odcinki size printString 
        ].
        (dowolnyObiekt isKindOf: Pasazer) ifTrue: [ 
            ^'Rozpoznano Pasażera: ' , dowolnyObiekt opisTaryfy 
        ].
        (dowolnyObiekt isKindOf: Warunki) ifTrue: [ 
            ^'Rozpoznano Warunki: ' , dowolnyObiekt nazwa 
        ].
        ^'Obiekt nieznany: ' , dowolnyObiekt class printString
    ]

    "MODUL F: Koszt dla pasazera"
    kosztDlaOsoby: pasazer [
        (pasazer isKindOf: Pasazer) ifFalse: [
            self error: 'Blad: Argument musi byc obiektem klasy Pasazer'.
        ].
        ^odcinki inject: 0 into: [ :suma :odcinek | suma + (odcinek kosztDlaOsoby: pasazer) ]
    ]

    kosztDla: pasazer [
        ^self kosztDlaOsoby: pasazer
    ]

    "MODUL G: Czas dla warunkow"
    czasDlaOsoby: warunki [
        (warunki isKindOf: Warunki) ifFalse: [
            self error: 'Blad: Argument musi byc obiektem klasy Warunki'.
        ].
        ^odcinki inject: 0 into: [ :suma :odcinek | suma + (odcinek czasDlaOsoby: warunki) ]
    ]

    czasDla: warunki [
        ^self czasDlaOsoby: warunki
    ]

    "MODUL I: Weryfikacja spojnosci punktow trasy"
    sprawdz [
        | bledy |
        bledy := self znajdzNieciaglosci.
        Transcript show: '[SYSTEM NAWIGACJI ARES - KONTROLA CIĄGŁOŚCI TRASY]'; cr.

        bledy isEmpty ifTrue: [
            Transcript show: 'Status: POŁĄCZENIE POPRAWNE'; cr.
            Transcript show: 'Wszystkie punkty przesiadkowe i śluzy dokujące są ze sobą zgodne. Trasa gotowa do realizacji!'; cr.
            ^true
        ].

        Transcript show: 'Status: ALARM NAWIGACYJNY - WYKRYTO NIEZGODNOŚĆ TRASY!'; cr.
        Transcript show: 'Wykryto przerwanie ciągłości podróży:'; cr.
        bledy do: [ :komunikat |
            Transcript show: komunikat; cr.
        ].
        ^false
    ]

    znajdzNieciaglosci [
        | wykryteBledy |
        wykryteBledy := OrderedCollection new.
        odcinki size < 2 ifTrue: [ ^wykryteBledy ].

        1 to: (odcinki size - 1) do: [ :i |
            | obecny kolejny |
            obecny := odcinki at: i.
            kolejny := odcinki at: (i + 1).
            (obecny koniec = kolejny poczatek) ifFalse: [
                wykryteBledy add: ('   ! BŁĄD na etapie ' , i printString , ' -> ' , (i + 1) printString , ':' , Character nl asString ,
                                  '     Odcinek ' , i printString , ' kończy się w: "' , obecny koniec , 
                                  '", a Odcinek ' , (i + 1) printString , ' rozpoczyna w: "' , kolejny poczatek , '".' , Character nl asString ,
                                  '     Brak połączenia transportowego między tymi punktami!').
            ].
        ].
        ^wykryteBledy
    ]

    drukuj [
        | numer |
        Transcript show: '============================================================'; cr.
        Transcript show: '              PLAN EKSPEDYCJI: ARES BASE LOGISTICS          '; cr.
        Transcript show: '============================================================'; cr.
        numer := 1.
        odcinki do: [ :odcinek |
            Transcript show: ('Etap ' , numer printString , ': ' , odcinek opis); cr.
            Transcript show: ('   Odcinek: ' , odcinek poczatek , ' -> ' , odcinek koniec); cr.
            Transcript show: ('   Dystans: ' , odcinek dystans printString , ' km | ' , 
                              'Czas: ' , odcinek czas printString , ' min | ' , 
                              'cena: ' , odcinek koszt printString , ' zl |'); cr.
            Transcript cr. "Extra enter pomiedzy etapami"
            numer := numer + 1.
        ].
        Transcript show: '------------------------------------------------------------'; cr.
        Transcript show: 'PODSUMOWANIE TRASY:'; cr.
        Transcript show: ('   Łączny dystans:   ' , self dystans printString , ' km'); cr.
        Transcript show: ('   Podstawowy czas:  ' , self czas printString , ' min'); cr.
        Transcript show: ('   Podstawowy koszt: ' , self koszt printString , ' zl'); cr.
        Transcript show: '============================================================'; cr.
    ]
]

| a b c d lewa prawa dluzsza calosc sprawdz blad |
sprawdz := [ :warunek :opis |
    warunek ifFalse: [ Error signal: opis ]
].

"1. Mini testy planera"
a := OdcinekPodrozy new ustawCzas: 5.
b := OdcinekPodrozy new ustawCzas: 10.
c := OdcinekPodrozy new ustawCzas: 15.
d := OdcinekPodrozy new ustawCzas: 20.

lewa := a + b.
prawa := c + d.
dluzsza := lewa + c.
calosc := lewa + prawa.

sprawdz value: (lewa isKindOf: Trasa) value: 'Typ wyniku Trasa'.
sprawdz value: (dluzsza odcinki asArray = (Array with: a with: b with: c)) value: 'Trasa + odcinek'.
sprawdz value: (calosc odcinki asArray = (Array with: a with: b with: c with: d)) value: 'Trasa + trasa'.
sprawdz value: (lewa odcinki asArray = (Array with: a with: b)) value: 'Niemutowalnosc lewej trasy'.
sprawdz value: (prawa odcinki asArray = (Array with: c with: d)) value: 'Niemutowalnosc prawej trasy'.

blad := false.
[ lewa + 7 ] on: Error do: [ :e | blad := true ].
sprawdz value: blad value: 'Wykrycie bledu dodawania liczby'.

"2. Testy pasazerow i taryf"
| tTest pTurysta pInzynier pGornik pPolitykMars pPolitykZiemia |
tTest := (PromTransportowyAres z: 'Mars' do: 'Ziemia' dystans: 100).
pTurysta := Turysta nazwa: 'Turysta Kowalski'.
pInzynier := InzynierBazyAres nazwa: 'Inz. Nowak'.
pGornik := GornikKolonijny nazwa: 'Gornik Wisniewski'.
pPolitykMars := Polityk naMarsa.
pPolitykZiemia := Polityk powrotNaZiemie.

sprawdz value: (tTest kosztDlaOsoby: pTurysta) = (tTest koszt) value: 'Turysta placi cene normalna'.
sprawdz value: (tTest kosztDlaOsoby: pInzynier) = 0 value: 'Inzynier podrozuje za darmo'.
sprawdz value: (tTest kosztDlaOsoby: pGornik) = ((tTest koszt * 0.5) rounded) value: 'Gornik ma 50% ulgi'.
sprawdz value: (tTest kosztDlaOsoby: pPolitykMars) = 0 value: 'Polityk na Marsa placi 0 zl'.
sprawdz value: (tTest kosztDlaOsoby: pPolitykZiemia) = ((tTest koszt * 2.5) rounded) value: 'Polityk na Ziemie placi 250%'.

"3. Testy zaawansowanych kolekcji i rozpoznawania typow"
sprawdz value: ((lewa rozpoznajTypObiektu: a) = 'Rozpoznano Odcinek Podróży: Odcinek standardowy') 
    value: 'Dynamiczne rozpoznawanie typu OdcinekPodrozy'.
sprawdz value: ((lewa rozpoznajTypObiektu: pTurysta) = 'Rozpoznano Pasażera: Turysta (taryfa normalna)') 
    value: 'Dynamiczne rozpoznawanie typu Pasazer'.


| e1 e2 e3 e3Alt e4 e5 e6 trasaGlowna trasaAlternatywna trasaBledna wOpt wBurza wDeszcz wZorza |

"Utworzenie etapow podrozy z Kopalni az na Ziemie"
e1 := SkafanderAres 
        z: 'Kopalnia' 
        do: 'Kwatery' 
        dystans: 2.

e2 := LekkiLazik 
        z: 'Kwatery' 
        do: 'Malownicza pustynia' 
        dystans: 15.

e3 := KolejMagnetyczna 
        z: 'Malownicza pustynia' 
        do: 'Mars' 
        dystans: 60.
        
e3Alt := LazikMarsjanski
    z: 'Malownicza pustynia'
    do: 'Mars'
    dystans: 60.

e4 := PromTransportowyAres 
        z: 'Mars' 
        do: 'Stacja Kosmiczna' 
        dystans: 120.

e5 := PromTransportowyAres 
        z: 'Stacja Kosmiczna' 
        do: 'Orbita' 
        dystans: 350.

e6 := PromTransportowyAres 
        z: 'Orbita' 
        do: 'Ziemia' 
        dystans: 100.

"Polaczenie wszystkich etapow w jedna ciagla trase"
trasaGlowna := e1 + e2 + e3 + e4 + e5 + e6.
trasaAlternatywna := e1 + e2 + e3Alt + e4 + e5 + e6.

Transcript cr.
"A. WYDRUK TRASY GLOWNEJ"
trasaGlowna drukuj.

Transcript cr.
"B. WERYFIKACJA SPOJNOSCI - TRASA POPRAWNA"
trasaGlowna sprawdz.

Transcript cr.
"C. WERYFIKACJA SPOJNOSCI - PRZYKLADOWA TRASA Z BLĘDEM (LUKA)"
"Przyklad: Zebranie etapow z pominieciem Kolei ze stacji Malownicza pustynia do kosmodromu Mars"
trasaBledna := e1 + e2 + e4 + e5 + e6.
trasaBledna sprawdz.

Transcript cr.
"D. TARYFY PASAZERSKIE - KosztDlaOsoby"
Transcript show: '[TERMINAL BILETOWY KOLONII MARS - NALICZANIE OPŁAT: KosztDlaOsoby]'; cr.
Transcript show: ('Koszt biletu normalnego: ' , trasaGlowna koszt printString , ' zl'); cr.
Transcript show: ('   * ' , pTurysta opisTaryfy , ': ' , (trasaGlowna kosztDlaOsoby: pTurysta) printString , ' zl'); cr.
Transcript show: ('   * ' , pInzynier opisTaryfy , ': ' , (trasaGlowna kosztDlaOsoby: pInzynier) printString , ' zl'); cr.
Transcript show: ('   * ' , pGornik opisTaryfy , ': ' , (trasaGlowna kosztDlaOsoby: pGornik) printString , ' zl'); cr.
Transcript show: ('   * ' , pPolitykMars opisTaryfy , ': ' , (trasaGlowna kosztDlaOsoby: pPolitykMars) printString , ' zl'); cr.
Transcript show: ('   * ' , pPolitykZiemia opisTaryfy , ': ' , (trasaGlowna kosztDlaOsoby: pPolitykZiemia) printString , ' zl'); cr.

Transcript cr.
"E. WPLYW WARUNKOW - CzasDlaOsoby"
wOpt := Warunki optymalne.
wBurza := Warunki burzaPylowa.
wDeszcz := Warunki deszczMeteorytow.
wZorza := Warunki zorzaPolarna.

Transcript show: '[CENTRUM KONTROLI MISJI - WARUNKI I CZAS PODRÓŻY: CzasDlaOsoby]'; cr.
Transcript show: ('Czas podróży w warunkach optymalnych: ' , trasaGlowna czas printString , ' min'); cr.

| czasBazowy cBurza cDeszcz cZorza opBurza opDeszcz opZorza |
czasBazowy := trasaGlowna czas.
cBurza := trasaGlowna czasDlaOsoby: wBurza.
opBurza := cBurza - czasBazowy.

cDeszcz := trasaGlowna czasDlaOsoby: wDeszcz.
opDeszcz := cDeszcz - czasBazowy.

cZorza := trasaGlowna czasDlaOsoby: wZorza.
opZorza := cZorza - czasBazowy.

Transcript show: ('   * ' , wBurza nazwa , ': OPÓŹNIENIE ' , opBurza printString , ' min -> Czas podróży ' , cBurza printString , ' min'); cr.
Transcript show: ('   * ' , wDeszcz nazwa , ': OPÓŹNIENIE ' , opDeszcz printString , ' min -> Czas podróży ' , cDeszcz printString , ' min'); cr.
Transcript show: ('   * ' , wZorza nazwa , ': OPÓŹNIENIE ' , opZorza printString , ' min -> Czas podróży ' , cZorza printString , ' min' , wZorza komentarzWidokowy); cr.

Transcript cr.
Transcript show: '[ANALIZA ŚLADU WĘGLOWEGO MISJI - MODUŁ E: Ekologia]'; cr.
Transcript show: ('   * Emisja Trasy 1 (z Koleją Magnetyczną): ' , trasaGlowna emisjaCO2 printString , ' g CO2'); cr.
Transcript show: ('   * Emisja Trasy 2 (z Ciężkim Łazikiem):   ' , trasaAlternatywna emisjaCO2 printString , ' g CO2'); cr.
Transcript show: ('   -> ' , (trasaGlowna porownajEmisjeZ: trasaAlternatywna)); cr.


Transcript show: '============================================================'; cr.
Transcript show: '             ZAKOŃCZENIE PREZENTACJI MISJI ARES             '; cr.
Transcript show: '============================================================'; cr.