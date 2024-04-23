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

#v(40pt)

#outline(
  title: "Spis treści",
)

#v(30pt)

= Wstęp

Projekt ma na celu zaimplementowanie oraz porównanie dwóch iteracyjnych metod rozwiązywania układów równań liniowych (Jacobiego i Gaussa-Seidela) oraz metody faktoryzacji LU. 
  
Do realizacji tego zadania użyto języka programowania Python oraz biblioteki Matplotlib do wizualizacji wyników. Wszystkie operacje na macierzach wykonano przy użyciu własnoręcznie napisanej klasy `Matrix`.

Zgodnie z treścią #underline[Zadania A] na początku projektu utworzono układ równań liniowych reprezentowany przez macierze $A$ i $B$. 

Macierz $A$ jest macierzą systemową o wymiarach $N #sym.times N$ dla $N = 9 c d = 934$, gdzie główna przekątna ($a_1$) przyjmuje wartości $11$, a dwie przesunięte przekątnę ($a_2$ i $a_3$) przyjmują wartości _-1_. Dodatkowo, mamy wektor pobudzenia $B$ o długości $N$, którego $n$-ty element jest równy $sin(7n)$.

#v(25pt)

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
          
#align(center)[Pierwszy uklad równań liniowych]

#pagebreak()

= Rozwiązywanie domyślnego układu równań liniowych

W ramach #underline[Zadania B] zaimplementowano metody Jacobiego i Gaussa-Seidela, które zostały wykorzystane do rozwiązania układu równań liniowych opisanego we wstępie tego sprawozdania.

#v(10pt)
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
  caption: [Porównanie metod Jacobiego, Gaussa-Seidela i faktoryzacji LU dla pierwszego układu równań]
)
#v(10pt)
Dla przedstawionego układu równań liniowych metoda Jacobiego wymagała 17 iteracji, podczas gdy metoda Gaussa-Seidela tylko 14 iteracji. Wyniki te wskazują, że metoda Gaussa-Seidela jest szybsza od metody Jacobiego (5.497 s vs 6.463 s). Z wykresu widać, że po szóstej iteracji spadek błędu obliczeniowego dla metody Jacobiego spowalnia w porównaniu z metodą Gaussa-Seidela.

<TaskB>
#figure(
  image("images/chart1_1.png"),
  caption: [Porównanie normy residuum w zależności od iteracji dla metod Jacobiego i Gaussa-Seidela]
)
#v(40pt)
= Rozwiązywanie alternatywnego układu równań liniowych

W ramach #underline[Zadania C] i #underline[Zadania D] wygenerowano alternatywny układ równań liniowych, który różni się od domyślnego układu równań liniowych opisanego we wstępie jedynie wartościami elementów macierzy systemowej $A$. Jedyną zmianą było ustawienie wartości głównej przekątnej na $a_1 = 3$. Wektor pobudzenia $B$ pozostaje bez zmian.

#pagebreak()

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
#align(center)[Drugi uklad równań liniowych]

<TaskC>
#figure(
  image("images/chart2_1.png"),
  caption: [Porównanie normy residuum w zależności od iteracji dla metod Jacobiego i Gaussa-Seidela dla drugiego układu równań]
)

Jak widać z wykresu, dla alternatywnego układu równań liniowych ani metoda Jacobiego, ani metoda Gaussa-Seidela nie były w stanie znaleźć poprawnego rozwiązania. Błąd obliczeń dla obu metod wzrastał już od pierwszych iteracji, osiągając minimalną normę residuum na poziomie $10^(0)$ do $10^(1)$, co wskazuje na to, że metody te nie są zbieżne dla tego układu równań. Szczególnie w przypadku metody Gaussa-Seidela błąd 
 znowu osiągnął wartość graniczną szybciej, niż w metodzie Jacobiego.

<TaskD>
W #underline[Zadaniu D], dla metody faktoryzacji LU, błąd obliczeń wyniósł $1.954704687433127$#sym.times$10^(-12)$, co wskazuje na bardzo wysoką dokładność tej metody dla tego układu równań, chociaż kosztem czasu obliczeń (58.93s).

//#pagebreak()
#v(10pt)
= Zależność czasu obliczeń od rozmiaru macierzy

W ramach #underline[Zadania E] przeprowadzono testy wydajnościowe dla metod Jacobiego, Gaussa-Seidela i faktoryzacji LU dla układów równań liniowych o różnych rozmiarach.

Testy wydajnościowe przeprowadzono dla macierzy kwadratowych o rozmiarach $N = {100, 200, ..., 700, 800, 1000, 1200, 1500}$. Dla każdego rozmiaru macierzy wygenerowano układ równań liniowych zgodnie z opisem we wstępie tego sprawozdania.

<TaskE>
#figure(
  image("images/chart4.png"),
  caption: [Porównanie czasu obliczeń w zależności od rozmiaru macierzy dla metod Jacobiego, Gaussa-Seidela i faktoryzacji LU]
) 

Z wykresu widać, że metoda faktoryzacji LU jest znacznie wolniejsza od metod iteracyjnych, co staje się szczególnie zauważalne dla dużych macierzy. Metoda Gaussa-Seidela jest trochę szybsza od metody Jacobiego dla wszystkich badanych rozmiarów macierzy.

#v(20pt)
= Podsumowanie


W ramach projektu zaimplementowano metody Jacobiego i Gaussa-Seidela oraz metodę faktoryzacji LU. Przeprowadzone testy wydajnościowe pozwoliły na porównanie czasu obliczeń rozwiązań układów równań liniowych w zależności od zastosowanej metody oraz rozmiaru macierzy.

Podczas testów wydajnościowych zauważono, że metoda faktoryzacji LU jest znacznie wolniejsza od metod iteracyjnych (nawet 20 razy wolniejsza w przypadku macierzy $2000 #sym.times 2000$), co wynika ze złożoności obliczeniowej ($O(n^3)$ vs $O(n^2)$). Metoda Gaussa-Seidela okazała się o kilkanaście procent szybsza od metody Jacobiego. Pomimo to, metoda faktoryzacji LU była najdokładniejsza, co można zaobserwować na przykładzie alternatywnego układu równań liniowych, który się nie zbiegał dla metod iteracyjnych.

W celu przyspieszenia obliczeń można zastosować hybrydowe metody rozwiązywania układów równań przy wykorzystaniu gotowych narzędzi i szybszego języka programowania. Na przykład, można rozpocząć od metody Gaussa-Seidela, a w przypadku braku zbieżności (co można stwierdzić, zauważając, że błąd zamiast maleć przy kolejnych iteracjach wzrasta) można przejść do metody faktoryzacji LU. Takie podejście pozwala uzyskać dokładne wyniki dla układów równań, które nie zbiegają dla metod iteracyjnych. Dodatkowo, należy korzystać z zewnętrznych bibliotek do obliczeń macierzowych (np. NumPy) lub wykorzystać inny, szybszy od Pythona, język programowania.
