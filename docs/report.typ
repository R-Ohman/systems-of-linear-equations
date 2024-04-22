#set heading(
  numbering: "1.",
)

#show heading.where(level: 1): set block(above: 1.75em, below: 1.25em)
#show heading.where(level: 1): set text(size: 14pt)

#show figure.caption: it => [
  #if it.supplement == [Figure] [
    Rysunek  #it.counter.display()#it.separator #it.body
  ] else if it.supplement == [Table] [
    Tabela  #it.counter.display()#it.separator #it.body
  ] else [
    #it.supplement #it.numbering#it.separator #it.body
  ]
]

#set page(
  paper: "a4",
  margin: 2cm,
  footer: context [
    #set text(8pt)
    *Projekt 2* - sprawozdanie
    #h(1fr)
    #if counter(page).get().first() > 1 [
      #counter(page).display(
        "1 / 1",
        both: true
      )
    ]
  ]
)

#let creationDate = datetime.today()

#align(right)[
    #stack(
      image("images/pg.jpg", width: 15%)
    )
  ]
#align(center)[
  #stack(
    dir: ttb,
    text(size: 24pt, weight: "semibold")[Układy równań liniowych],
    v(10pt),
    text(size: 14pt)[Metody Numeryczne - Projekt 2],
    v(20pt),
    text(size: 12pt)[Ruslan Rabadanov 196634],
    v(10pt),
    text(size: 12pt)[#creationDate.display("[day]-[month]-[year]")]
  )
]

#v(10pt)

#outline(
  title: "Spis treści",
)

#v(10pt)

= Wstęp

Projekt ma na celu zaimplementowanie oraz porównanie różnych iteracyjnych metod rozwiązywania układów równań liniowych oraz metody faktoryzacji LU. 
  
W ramach projektu zostały zaimplementowane metody Jacobiego i Gaussa-Seidela, a także metoda faktoryzacji LU bez korzystania z zewnętrznych bibliotek do obliczeń macierzowych.
  
Następnie przeprowadzono testy wydajnościowe, które umożliwiły porównanie czasu potrzebnego do rozwiązania układów równań liniowych w zależności od zastosowanej metody i rozmiaru danych.

Do realizacji tego zadania użyto języka programowania Python oraz biblioteki Matplotlib do wizualizacji wyników. Wszystkie operacje na macierzach wykonano przy użyciu własnoręcznie napisanej klasy `Matrix`.

Zgodnie z treścią #underline[Zadania A] na początku projektu utworzono układ równań liniowych reprezentowany przez macierze $A$ i $B$. 

Macierz $A$ jest kwadratową macierzą pasmową o wymiarach $N #sym.times N$ dla $N = 9 c d = 934$, gdzie $a_1 = 5 + 6 = 11$, $a_2 = a_3 = -1$. $a_1$ to główna przekątna, $a_2$ to przekątne przesunięte o 1 względem głównej przekątnej itd. Dodatkowo, mamy wektor $B$ o długości $N$, którego $n$-ty element jest równy $sin(n #sym.dot (f + 1)) = sin(7n)$

$ A = mat(11, -1, -1, 0, dots.h, 0, 0, 0, 0;
        -1, 11, -1, -1, dots.h, 0, 0, 0, 0;
        -1, -1, 11, -1, dots.h, 0, 0, 0, 0;
        0, -1, -1, 11, dots.h, 0, 0, 0, 0;
        dots.v, dots.v, dots.v, dots.v, dots.down, dots.v, dots.v, dots.v, dots.v;
        0, 0, 0, 0, dots.h, 11, -1, -1, 0;
        0, 0, 0, 0, dots.h, -1, 11, -1, -1;
        0, 0, 0, 0, dots.h, -1, -1, 11, -1;
        0, 0, 0, 0, dots.h, 0, -1, -1, 11;
      )
  op(#h(10pt))
  B = mat(0.657;
          0.9906;
          0.8367;
          0.2709;
          dots.v;
          0.9728;
          0.8857;
          0.3627;
          -0.3388;
          ) $

#pagebreak()

= Porównanie metod rozwiązywania układów równań liniowych dla domyślnego układu równań

W ramach #underline[Zadania B] zaimplementowano metody Jacobiego i Gaussa-Seidela, które zostały wykorzystane do rozwiązania układu równań liniowych opisanego we wstępie tego sprawozdania.

#figure(
  table(
    columns: (1fr, 1fr, 1fr, 1.2fr),
    table.header(
      text(size: 12pt, weight: "semibold")[Metoda],
      text(size: 12pt, weight: "semibold")[Liczba iteracji],
      text(size: 12pt, weight: "semibold")[Czas obliczeń [s]],
      text(size: 12pt, weight: "semibold")[Norna residuum]
    ),
    text[Jacobi], text[17], text[6.463], text[8.243249338856146#sym.times$10^(-10)$],
    text[Gauss-Seidel], text[14], text[5.497], text[1.905168171052384#sym.times$10^(-10)$],
    text[Faktoryzacja LU], text[-], text[59.82], text[3.4073565309548815#sym.times$10^(-15)$]
  ),
  caption: [Porównanie metod Jacobiego, Gaussa-Seidela i faktoryzacji LU dla domyślnego układu równań]
)

Dla przedstawionego układu równań liniowych metoda Jacobiego wymagała 17 iteracji, podczas gdy metoda Gaussa-Seidela tylko 14 iteracji. Wyniki te wskazują, że metoda Gaussa-Seidela jest szybsza od metody Jacobiego (5.497 s vs 6.463 s). Z wykresu widać, że po szóstej iteracji spadek błędu obliczeniowego dla metody Jacobiego spowalnia w porównaniu z metodą Gaussa-Seidela.

<TaskB>
#figure(
  image("images/chart1_1.png"),
  caption: [Porównanie normy residuum w zależności od iteracji dla metod Jacobiego i Gaussa-Seidela]
)

= Porównanie metod rozwiązywania układów równań liniowych dla alternatywnego układu równań

W ramach #underline[Zadania C] i #underline[Zadania D] wygenerowano alternatywny układ równań liniowych, który różni się od domyślnego układu równań liniowych opisanego we wstępie jedynie wartościami elementów macierzy $A$. Jedyną zmianą było ustawienie wartości głównej przekątnej na $a_1 = 3$.

$ A = mat(3, -1, -1, 0, dots.h, 0, 0, 0, 0;
      -1, 3, -1, -1, dots.h, 0, 0, 0, 0;
      -1, -1, 3, -1, dots.h, 0, 0, 0, 0;
      0, -1, -1, 3, dots.h, 0, 0, 0, 0;
      dots.v, dots.v, dots.v, dots.v, dots.down, dots.v, dots.v, dots.v, dots.v;
      0, 0, 0, 0, dots.h, 3, -1, -1, 0;
      0, 0, 0, 0, dots.h, -1, 3, -1, -1;
      0, 0, 0, 0, dots.h, -1, -1, 3, -1;
      0, 0, 0, 0, dots.h, 0, -1, -1, 3;
      )
  op(#h(10pt))
  B = mat(0.657;
          0.9906;
          0.8367;
          0.2709;
          dots.v;
          0.9728;
          0.8857;
          0.3627;
          -0.3388;
          ) $

<TaskC>
#figure(
  image("images/chart2_1.png"),
  caption: [Porównanie normy residuum w zależności od iteracji dla metod Jacobiego i Gaussa-Seidela dla alternatywnego układu równań]
)

Niestety, dla alternatywnego układu równań liniowych ani metoda Jacobiego, ani metoda Gaussa-Seidela nie były w stanie znaleźć poprawnego rozwiązania. Błąd obliczeń dla obu metod wzrastał już od pierwszych iteracji, osiągając normę residuum na poziomie $10^(0)$ do $10^(1)$, co wskazuje na to, że metody te nie są zbieżne dla tego układu równań. Szczególnie w przypadku metody Gaussa-Seidela błąd wzrastał znacznie szybciej, co można zaobserwować na wykresie normy residuum w zależności od iteracji.

<TaskD>
W Zadaniu D, dla metody faktoryzacji LU, błąd obliczeń wyniósł $1.954704687433127$#sym.times$10^(-12)$, co wskazuje na bardzo wysoką dokładność tej metody dla tego układu równań, chociaż kosztem czasu obliczeń.

//#pagebreak()

= Czas obliczeń w zależności od rozmiaru macierzy

W ramach #underline[Zadania E] przeprowadzono testy wydajnościowe dla metod Jacobiego, Gaussa-Seidela i faktoryzacji LU dla układów równań liniowych o różnych rozmiarach.

Testy wydajnościowe przeprowadzono dla macierzy kwadratowych o rozmiarach $N = {100, 200, ..., 700, 800, 1000, 1200, 1500}$. Dla każdego rozmiaru macierzy wygenerowano układ równań liniowych zgodnie z opisem we wstępie tego sprawozdania.

<TaskE>
#figure(
  image("images/chart4.png"),
  caption: [Porównanie czasu obliczeń w zależności od rozmiaru macierzy dla metod Jacobiego, Gaussa-Seidela i faktoryzacji LU]
) 

Na wykresie czasu obliczeń w zależności od rozmiaru macierzy dla metod Jacobiego, Gaussa-Seidela i faktoryzacji LU można zauważyć, że metoda faktoryzacji LU jest zdecydowanie wolniejsza od metod iteracyjnych, co staje się szczególnie zauważalne dla dużych macierzy. Metoda Gaussa-Seidela jest trochę szybsza od metody Jacobiego dla wszystkich rozmiarów macierzy.

= Podsumowanie


W ramach projektu zaimplementowano metody Jacobiego i Gaussa-Seidela oraz metodę faktoryzacji LU. Przeprowadzone testy wydajnościowe pozwoliły na porównanie czasu obliczeń rozwiązań układów równań liniowych w zależności od zastosowanej metody oraz rozmiaru macierzy.

Podczas testów wydajnościowych zauważono, że metoda faktoryzacji LU jest znacznie wolniejsza od metod iteracyjnych (nawet 20 razy wolniejsza w przypadku macierzy $2000 #sym.times 2000$), co jest szczególnie istotne dla dużych macierzy. Metoda Gaussa-Seidela okazała się szybsza od metody Jacobiego dla wszystkich rozmiarów macierzy. Pomimo to, metoda faktoryzacji LU była najdokładniejsza, co można zaobserwować na przykładzie alternatywnego układu równań liniowych, który nie zbiegał dla metod iteracyjnych.

Wnioskiem ogólnym jest to, że przy rozwiązywaniu różnych klas układów równań liniowych zaleca się rozpoczęcie od metody Gaussa-Seidela, a w przypadku braku zbieżności (co można stwierdzić, zauważając, że błąd zamiast maleć przy kolejnych iteracjach wzrasta) można przejść do metody faktoryzacji LU. Takie podejście pozwala uzyskać dokładne wyniki w krótszym czasie, pod warunkiem, że układ równań jest zbieżny, oraz umożliwia uzyskanie wyników dla układów równań, które nie zbiegają dla metod iteracyjnych.

Dodatkowo, należy zauważyć, że zastosowanie zewnętrznych bibliotek do obliczeń macierzowych (np. NumPy) lub wykorzystanie szybszego języka do implementacji może znacząco przyspieszyć obliczenia, szczególnie istotne dla dużych macierzy. Testowana implementacja została napisana w czystym języku Python, który nie należy do szybkich języków, co znacząco wpłynęło na czas obliczeń, zwłaszcza dla metody faktoryzacji LU, która zajęła nawet 11 minut dla macierzy o rozmiarze $2000 #sym.times 2000$.