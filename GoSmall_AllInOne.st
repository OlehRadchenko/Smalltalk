Object subclass: OdcinekPodrozy [
    | poczatek koniec dystans czasBazowy |

    OdcinekPodrozy class >> new [
        | inst |
        inst := super new.
        inst initialize.
        ^inst
    ]

    "Konstruktor pomocniczy z parametrami"
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

    "Gettery i Settery"
    poczatek [ ^poczatek ]
    poczatek: nazwa [ poczatek := nazwa. ^self ]

    koniec [ ^koniec ]
    koniec: nazwa [ koniec := nazwa. ^self ]

    dystans [ ^dystans ]
    dystans: km [ dystans := km. ^self ]

    ustawCzas: min [ czasBazowy := min. ^self ]

    "Polimorficzne metody - nadpisywane w klasach potomnych"
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

    opis [
        ^'Odcinek standardowy'
    ]

    "MODUŁ 2: Operator + w klasie OdcinekPodrozy"
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

"Klasa potomna 1: Skafander Ares (pieszy ruch w skafandrze ciśnieniowym)"
OdcinekPodrozy subclass: SkafanderAres [
    opis [ ^'Skafander Ares' ]

    obliczCzas [
        ^(dystans * 15) rounded
    ]

    koszt [
        ^0
    ]
]

"Klasa potomna 2: Lekki Łazik"
OdcinekPodrozy subclass: LekkiLazik [
    opis [ ^'Lekki Lazik' ]

    obliczCzas [
        ^((dystans * 4) + 1) rounded
    ]

    koszt [
        ^(dystans * 0.5) rounded
    ]
]

"Klasa potomna 3: Prom Transportowy Ares"
OdcinekPodrozy subclass: PromTransportowyAres [
    opis [ ^'Prom Transportowy Ares' ]

    obliczCzas [
        ^((dystans * 2) + 5) rounded
    ]

    koszt [
        ^(4.80 + (dystans * 0.5)) rounded
    ]
]

"Zachowanie zgodności z nazwami z zadania"
SkafanderAres subclass: Pieszo []
LekkiLazik subclass: Rower []
PromTransportowyAres subclass: Autobus []

"Opcjonalne dodatkowe klasy kosmiczne bazy ARES"
OdcinekPodrozy subclass: LazikMarsjanski [
    opis [ ^'Ciezki Lazik Transportowy Ares' ]
    obliczCzas [ ^((dystans * 6) + 3) rounded ]
    koszt [ ^(dystans * 1.2) rounded ]
]

OdcinekPodrozy subclass: KolejMagnetyczna [
    opis [ ^'Kolej Magnetyczna Tuneli Bazy' ]
    obliczCzas [ ^((dystans * 1.5) + 2) rounded ]
    koszt [ ^(3.00 + (dystans * 0.4)) rounded ]
]


"======================================================================
 MODUŁ 2 & MODUŁ 3: Klasa Trasa jako Agregator i Operator +
======================================================================"

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
        odcinki add: odcinek.
        ^self
    ]

    dodajWszystkie: kolekcjaOdcinkow [
        odcinki addAll: kolekcjaOdcinkow.
        ^self
    ]

    "MODUŁ 2: Operator + w klasie Trasa"
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

    "MODUŁ 3: Agregacja polimorficzna"
    dystans [
        ^odcinki inject: 0 into: [ :suma :odcinek | suma + odcinek dystans ]
    ]

    czas [
        ^odcinki inject: 0 into: [ :suma :odcinek | suma + odcinek czas ]
    ]

    koszt [
        ^odcinki inject: 0 into: [ :suma :odcinek | suma + odcinek koszt ]
    ]

    drukuj [
        | numer |
        Transcript show: '--------- TRASA ---------'; cr.
        numer := 1.
        odcinki do: [ :odcinek |
            Transcript show: (numer printString , '. ' , odcinek opis); cr.
            Transcript show: ('   ' , odcinek poczatek , ' -> ' , odcinek koniec); cr.
            Transcript show: ('   ' , odcinek dystans printString , ' km | ' , 
                              odcinek czas printString , ' min | ' , 
                              odcinek koszt printString , ' zl'); cr.
            numer := numer + 1.
        ].
        Transcript show: '-------------------------'; cr.
        Transcript show: ('Dystans: ' , self dystans printString , ' km'); cr.
        Transcript show: ('Czas:    ' , self czas printString , ' min'); cr.
        Transcript show: ('Koszt:   ' , self koszt printString , ' zl'); cr.
        Transcript show: '-------------------------'; cr.
    ]
]

"======================================================================
 BLOK TESTÓW I PREZENTACJI
======================================================================"

Transcript show: '=================================================='; cr.
Transcript show: '   TEST 1: Mini testy planera (zgodne z instrukcją)'; cr.
Transcript show: '=================================================='; cr.

| a b c d lewa prawa dluzsza calosc sprawdz blad |
sprawdz := [ :warunek :opis |
    warunek ifFalse: [ Error signal: opis ]
].

a := OdcinekPodrozy new ustawCzas: 5.
b := OdcinekPodrozy new ustawCzas: 10.
c := OdcinekPodrozy new ustawCzas: 15.
d := OdcinekPodrozy new ustawCzas: 20.

lewa := a + b.
prawa := c + d.
dluzsza := lewa + c.
calosc := lewa + prawa.

sprawdz value: (lewa isKindOf: Trasa) value: 'Typ wyniku'.
sprawdz value: (dluzsza odcinki asArray = (Array with: a with: b with: c))
    value: 'Trasa + odcinek'.
sprawdz value: (calosc odcinki asArray = (Array with: a with: b with: c with: d))
    value: 'Trasa + trasa'.
sprawdz value: (lewa odcinki asArray = (Array with: a with: b))
    value: 'Zmieniona lewa trasa (niemutowalnosc)'.
sprawdz value: (prawa odcinki asArray = (Array with: c with: d))
    value: 'Zmieniona prawa trasa (niemutowalnosc)'.

blad := false.
[ lewa + 7 ] on: Error do: [ :e | blad := true ].
sprawdz value: blad value: 'Brak bledu dla liczby'.

Transcript show: 'Wszystkie testy poprawnosci ukonczone: OK!'; cr.
Transcript cr.

Transcript show: '=================================================='; cr.
Transcript show: '   TEST 2: Pełna Trasa Ekspedycji: MARS -> ZIEMIA '; cr.
Transcript show: '   (Kontynuacja Misji ARES BASE LOGISTICS)       '; cr.
Transcript show: '=================================================='; cr.

| e1 e2 e3 e4 e5 e6 e7 trasaMarsZiemia |

e1 := SkafanderAres 
        z: 'Baza Ares: Silosy Surowcowe (Uran/Tytan)' 
        do: 'Śluza Dokowa Sektora 1' 
        dystans: 1.

e2 := LekkiLazik 
        z: 'Śluza Dokowa Sektora 1' 
        do: 'Marsjański Kosmodrom Olympus' 
        dystans: 15.

e3 := PromTransportowyAres 
        z: 'Marsjański Kosmodrom Olympus' 
        do: 'Orbita Marsa (Stacja Phobos Gateway)' 
        dystans: 80.

e4 := PromTransportowyAres 
        z: 'Orbita Marsa (Stacja Phobos Gateway)' 
        do: 'Orbita Ziemi (Stacja Lunar-Earth Gateway)' 
        dystans: 500.

e5 := PromTransportowyAres 
        z: 'Orbita Ziemi (Stacja Lunar-Earth Gateway)' 
        do: 'Ziemski Kosmodrom Cape Canaveral' 
        dystans: 120.

e6 := LekkiLazik 
        z: 'Ziemski Kosmodrom Cape Canaveral' 
        do: 'Centrum Kontroli Misji Ziemia' 
        dystans: 10.

e7 := SkafanderAres 
        z: 'Centrum Kontroli Misji Ziemia' 
        do: 'Główny Terminal Raportowy Kolonii' 
        dystans: 1.

"Łączenie wszystkich etapów w jedną, ciągłą trasę operatorem +"
trasaMarsZiemia := e1 + e2 + e3 + e4 + e5 + e6 + e7.
trasaMarsZiemia drukuj.

Transcript cr.
Transcript show: 'Test obslugi blednego polaczenia z tekstem: '; cr.
[
    trasaMarsZiemia + 'Niewlasciwy obiekt ladowania'
] on: Error do: [ :err |
    Transcript show: ('Przechwycono oczekiwany blad: ' , err printString); cr.
].

Transcript show: '=== KONIEC DEMONSTRACJI MISJI ARES ==='; cr.
