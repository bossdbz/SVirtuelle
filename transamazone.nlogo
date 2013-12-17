breed [familles famille]
breed [troupeaux troupeau]
globals[ eleveurAplanteur planteurAeleveur sansTerreAeleveur sansTerreAplanteur eleveurAsansTerre planteurAsansterre]


familles-own [strategie lots liste-lots argent nb-jeunes nb-adultes embauche?  nbrEmployé estEmployé  employeur ctask  ]

patches-own [ couverture-vegetale proprieté age dureeAbandon productif nb-boeufs coutBase ]



to setup
  clear-all
  ;;__clear-all-and-reset-ticks
  
  ;;set size 1
  resize-world -38 38 -18 18
  ;set-patch-size 5
  reset-ticks
  
  ;connaitre les différents changements
  set eleveurAplanteur 0
  set planteurAeleveur 0
  set sansTerreAeleveur 0
  set sansTerreAplanteur 0
  set eleveurAsansTerre 0
  set planteurAsansterre 0 
  
  
  
  ask patches [ 
    

    if (pxcor >= -38 and pycor  >= 10  and pycor  <= 18 ) or (pxcor >= -38 and pycor  >= -18  and pycor  <= -10 )
    [
      setForet
    ] 
    
    if (pxcor >= -38 and pxcor <= -28 and pycor  >= -9  and pycor  <= 9 ) or (pxcor >= 28 and pxcor <= 38 and pycor  >= -9  and pycor  <= 9 )
    [    
      setJachere
    ]
    
    if (pxcor >= -27 and pxcor <= 27 and pycor  >= -9  and pycor  <= 9 ) 
    [    
      setPature
    ]
    
    if (pxcor >= -27 and pxcor <= -25 and pycor = 9) or 
       (pxcor >= -20 and pxcor <= -19 and pycor = 9) or
       (pxcor >= -10 and pxcor <= -10 and pycor = 9) or
       (pxcor >= 0 and pxcor <= 4 and pycor = 9) or
       (pxcor >= 10 and pxcor <= 12 and pycor = 9) or
       
       (pxcor >= 10 and pxcor <= 17 and pycor = -9) or
       (pxcor >= -14 and pxcor <= -13 and pycor = -9) or
       (pxcor >= -5 and pxcor <= -1 and pycor = -9) or
       (pxcor >= -24 and pxcor <= -20 and pycor = -9) or
       (pxcor >= 5 and pxcor <= 7 and pycor = -9) or
       
       (pxcor >= -20 and pxcor <= -17 and pycor = -13)
    
    [ 
      setCultureAnnuelle
    ]    
    
    if (pxcor >= -20 and pxcor <= -17 and pycor = 15)
    [ 
      setCulturePerenne  
    ]
    
    
    if (pycor = 0 );and pxcor >= -38)
    [
     set couverture-vegetale "Trans" 
     set pcolor red 
     set coutBase "null"
    ]
    
     ifelse (pycor > 0 and pycor <= 3 ) or (pycor < 0 and pycor >= -3 ) 
    [
      set coutBase cout-proche-amazone
    ]
    [

      set coutBase cout-base 
    ]
    
     
     
   
  ]
  
  
  
  
    
 
  ;creation des 3 types de familles différentes
  create-familles numberFamilles [
    
   
    setxy random-xcor random-ycor
    
    let strat random 3
    
   
    let x random-xcor 
    
     ;ne pas tomber sur 0 en absicsse
    if x = 0 [
       let s random 2 
       if s = 0 [ set x 2]
       if s = 1 [set x -2]
    ]
    
    let y random-xcor
    setxy x y
    let lieu patch x y
    
    ;le planteur
    if strat = 0 [ 
      set strategie "planteur"
      set lots 1
      set argent argentBasePlanteur
      set shape "house"
      set color blue
      set ctask "go-planteur"
      set liste-lots (list lieu)  
      ask lieu[ set proprieté 1]
      
      set nbrEmployé 0
      set embauche? 0
       set size 0.9
      ]
    
    ;l'eleveur
    if strat = 1 [ 
      set strategie "eleveur" 
      set lots 1
      set argent argentBaseEleveur
      set shape "house"
      set color yellow
      set ctask "go-eleveur"
       set liste-lots (list lieu)  
      ask lieu[ set proprieté 1]

      set nbrEmployé 0
      set embauche? 0
      set size 0.9
      ]
    
    ;le sans-terre
    if strat = 2 [
       set strategie "sans-terre" 
       set lots 0
       set argent argentBaseSansTerre
       set shape "person"
       set color white
       set ctask "go-sans-terre"
       set employeur ""
       set size 0.6
       ]
    
    
    set nb-jeunes random 5
    set estEmployé 0
    let nb-max 1
    let adultes random 4
    set nb-adultes nb-max + adultes
    
    
  ]
  

   
  reset-ticks
  
  

  
  
  
end

;initialisation des sols

to setForet
  set couverture-vegetale "foret" 
  set pcolor scale-color green 30 0 90
  set age 0
  set dureeAbandon 0   
end  

to setJachere
  set couverture-vegetale "jachere" 
  set pcolor orange
  set age 0
  set dureeAbandon 0   
end  

to setPature
  set couverture-vegetale "pature" 
  set pcolor scale-color green 30 0 50
  set age 0
  set dureeAbandon 0   
end  

to setcultureAnnuelle
  set couverture-vegetale "culture-annuelle" 
  set pcolor yellow 
  set age 0
  set dureeAbandon 0   
end  

to setCulturePerenne
  set couverture-vegetale "culture-perenne" 
  set pcolor scale-color green 9 0 50
  set age 0
  set dureeAbandon 0
  set productif 0
end  


to setArbreValeur
  set shape "triangle 2"
  set size 1
  set color green
    
  let initialisation 1
  let x random-xcor 
  let y random-xcor 
  setxy x y
end


to setCacao
  set couverture-vegetale "cacao" 
  set pcolor brown
  set age 0
  set dureeAbandon 0   
end


; l'evolution de la couverture au cours du temps
to evolution
   set age ticks / 30  ; 1 an = 30 ticks
   if (ticks mod 30) = 0
   [
     set dureeAbandon dureeAbandon + 1   
   ]
   
   if couverture-vegetale = "jachere" and dureeAbandon >= 30
   [
      setForet
   ]
   
   if couverture-vegetale = "culture-annuelle" and dureeAbandon >= 1
   [
      setJachere
   ]
   
   if couverture-vegetale = "pature" and dureeAbandon >= 5
   [
       setJachere
   ]
   
   if couverture-vegetale = "culture-perenne" and dureeAbandon >= 5
   [
      setJachere
   ]
   
   if couverture-vegetale = "culture-perenne" and dureeAbandon >= 3
   [
      set productif 1
   ]

   
end  
  
;etat entretenir,  entretient du sol , des plantation ou des paturages
to entretenir 
  
  ifelse ( ticks mod 30 ) = 0 
  [
    set ctask "bilan"
  ]
  [
   ;;regarde s'il peut embaucher
   embauche    
    
    ;;entretient 
    if couverture-vegetale = "foret" or couverture-vegetale = "jachere"
    [ brulis patch-here ]
   
   
    if( couverture-vegetale = "culture-annuelle" and strategie = "planteur") or
      ( couverture-vegetale = "cacao" and strategie = "planteur")
    [
      ;;travaille le cacao
      travail-cacao
      
      ]
    
    if ((couverture-vegetale = "culture-annuelle" and strategie = "eleveur")or
      ( couverture-vegetale = "pature" and strategie = "eleveur"))
    [
       ;;travaille les troupeaux
       travail-pature
      ]
    
     if( couverture-vegetale = "pature" and strategie = "planteur")
     [
      ;;travaille le cacao
      setCacao
      travail-cacao
      
      ]
    
     if( couverture-vegetale = "cacao" and strategie = "eleveur")
     [
      ;;travaille le cacao
      setPature
      travail-pature
      
      ]
    
  ]
  
end

;embauche de main d'oeuvre
to embauche
   ;;embauche
    let r random 3;; 33% de chance en plus d'avoir assez d'argent
    if r = 0 and argent > PrixSeuilEmbauche and nbrEmployé = 0;; si on a pas d'employé et qu'on as assez d'argent et de la chance, on embauche
    [ set embauche? 1 ]    
    
    if nbrEmployé != 0 [ set embauche? 0]
  
end

;tracail le cacao
to travail-cacao
  ifelse couverture-vegetale != "cacao"
  [ setCacao]
  
  [
    set dureeAbandon 0
    
    let recoltes 0
    let entretient  random-normal (nb-adultes * 5) nb-adultes + random 25 
    
  if age >= 3 [
    ;;les recoltes n'ont lieu que si le cacao a plus de 3 ans
    set recoltes random-normal (nb-adultes * 10) nb-adultes + random 50      
    
      ]
  
  set argent argent + recoltes - entretient
  ]
   
  
end


;travail les pature
to travail-pature
  
   ifelse couverture-vegetale != "pature"
  [ setPature]
  
  [
    ;achete une bete / initialisation
   achatBoeufs 
    
    
    set dureeAbandon 0
    ;;recolte l'argent et paye
    let recoltes random-normal (nb-adultes * 2) nb-adultes / 2    
    let entretient  random-normal (nb-adultes * 2) nb-adultes / 2 
    let entretientBoeufs random-normal (nb-boeufs) (nb-boeufs / 2)
    set argent argent + recoltes - entretient - entretientBoeufs
   ]
  
  
end


;achete des boeufs
to achatBoeufs
   ;achete une bete si assez d'argent
  ifelse ( (nb-boeufs = 0) and (argent > 2500)) [ 
    ;;achete un pack de 5 boeufs
      set nb-boeufs 5
      set argent argent - 500
    ]
   
 [
  if (argent > 2000 )
  [
     let r random 5
     if( r = 0 ) [ ;
       ;si on a de l'argent et de la chance 20% 
       ;on achete un boeuf
       set argent argent - 100
       set nb-boeufs nb-boeufs + 1
       
        ]
     
  ]
 ]
 
  
end  


;deforeste la couverture (brule)
to brulis [ p ];découpe
  ask p [ setcultureAnnuelle ]
 
end

;;;;;;   Les etats initiaux ;;;;;;;;;;;;;;;;;;
to go-planteur
 set ctask "entretenir"  
end

to go-eleveur
  set ctask "entretenir"    
end

to go-sans-terre
  
    set ctask "chercheBoulot"  
 
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;les sans-terre recherchent un employeur
to chercheBoulot
  if ( ticks mod 30 ) = 0 
  [
     set ctask "bilan"
  ]
   let emp familles with [ embauche? = 1 ]  
   if any? emp[
     set emp one-of emp
     set estEmployé 1
     set color black
     ask emp [ set nbrEmployé 1]
     set employeur emp
     move-to emp
     set ctask "travaille " 
   ]
   
end


;ils ont trouvé un boulot, il partent travailler

to travaille 
  ;let emp min familles with
  let a random-normal (nb-adultes * 2 )  (nb-adultes / 2) 
  set argent argent + a + random 6
  ask employeur [ set argent argent - a ]
  
  if ( ticks mod 30 ) = 0 [
    set ctask "bilan" 
  ]
end



;calcul toutes les valeures et couts 
to-report valeurBoeufs [ nb ]
  report nb * 150
end

to-report valeurCacao[ nb ]
  report nb * 500
end  

to-report valeurLotCacao[ nb ]
  report nb * coutBase * 1.2
end 

to-report valeurLotPature[ nb ]
  report nb * coutBase * 1
end

to-report valeurLotCultureAnnuelle[ nb ]
  report nb * coutBase * 0.8
end 

to-report valeurLotJachere[ nb ]
  report nb * coutBase * 0.7
end 

to-report valeurLotForet[ nb ]
  report nb * coutBase * 0.6
end 

; effectue les opérations de ventes
to vend [ typeV nb ]
  let s 0
  if ( typeV = "boeufs" )[
    set s valeurBoeufs nb
    set argent argent + s 
  ] 
  if ( typeV = "cacao" )[
    set s valeurCacao nb
    set argent argent + s 
  ]  
  if ( typeV = "LotCacao" )[
    set s valeurLotCacao nb
    set argent argent + s 
  ]  
  if ( typeV = "lotPature" )[
    set s valeurLotPature nb
    set argent argent + s 
  ]
  if ( typeV = "LotCultureAnnuelle" )[
    set s valeurLotCultureAnnuelle nb
    set argent argent + s 
  ]  
  if ( typeV = "LotJachere" )[
    set s valeurLotJachere nb
    set argent argent + s 
  ]  
  if ( typeV = "LotForet" )[
    set s valeurLotForet nb
    set argent argent + s 
  ]  
end



; effectue les opérations d'acahats
to achete [ typeV nb ]
  let s 0
  if ( typeV = "boeufs" )[
    set s valeurBoeufs nb
    set argent argent - s 
  ] 
  if ( typeV = "cacao" )[
    set s valeurCacao nb
    set argent argent - s 
  ]  
  if ( typeV = "LotCacao" )[
    set s valeurLotCacao nb
    set argent argent - s 
  ]  
  if ( typeV = "lotPature" )[
      set s valeurLotPature nb
      set argent argent - s 
    ]
  
  if ( typeV = "LotCultureAnnuelle" )[
    set s valeurLotCultureAnnuelle nb
    set argent argent - s 
  ]  
  if ( typeV = "LotJachere" )[
    set s valeurLotJachere nb
    set argent argent - s 
  ]  
  if ( typeV = "LotForet" )[
    set s valeurLotForet nb
    set argent argent - s 
  ]  

  
end

;précise la methodes d'achats en fonction des différentes couverture végétales
to acheteSol
  if couverture-vegetale = "culture-perenne" and argent > ( coutBase * 1 - 1000 )
  [ achete "LotCultureAnnuelle" 1 ]
  if couverture-vegetale = "foret" and argent > ( valeurLotForet 1 - 1000 )
  [ achete "LotForet" 1 ]
  if couverture-vegetale = "culture-annuelle" and argent > ( valeurLotCultureAnnuelle 1 - 1000 )
  [ achete "LotCultureAnnuelle" 1 ]
  if couverture-vegetale = "jachere" and argent > ( valeurLotJachere 1 - 1000 )
  [ achete "LotJachere" 1 ]
  if couverture-vegetale = "cacao" and argent > ( valeurLotCacao 1 - 1000 )
  [ achete "LotCacao" 1 ]
  if couverture-vegetale = "pature" and argent > ( valeurLotPature 1 - 1000 )
  [ achete "lotPature" 1 ]
  
end



;;;---------------Définis toutes les stratégies des familles---------------------

;;;Celles des sans-terre
to strategieSansTerre 

   let a random 3
   ifelse ( argent > 2500 )[
     ifelse ( a = 0 )[
       set ctask "chercheBoulot"
     ]
     [
       set lots 1 
       let l one-of patches with [ proprieté = 0 ]
       move-to l 
       set shape "house"
       set liste-lots (list l)  
       ask l [ set proprieté 1]
       set nbrEmployé 0
       set embauche? 0
       
       if ( a = 1) [
         set strategie "eleveur"                     
         set color yellow
         set ctask "go-eleveur"
         
         acheteSol
         set sansTerreAeleveur sansTerreAeleveur + 1
       ]
       
       if ( a = 2 )
       [
         set strategie "planteur"
         set color blue
         set ctask "go-planteur" 
         acheteSol
         set sansTerreAplanteur sansTerreAplanteur + 1     
       ] 
     ]  
   ]
   [ set ctask "chercheBoulot" ]
end

;;Celle des éleveurs
to strategieEleveur 
  let a random 5
  ifelse ( argent < 2000) [
     ifelse (nb-boeufs <= 0) [
       vend "lotPature" 1
       set strategie "sans-terre" 
       set lots 0
       set shape "person"
       set color white
       set ctask "go-sans-terre"
       set employeur ""
       set size 0.6  
       
       set liste-lots ""          
       set nbrEmployé 0
       set embauche? 0    
       
       set eleveurAsansTerre eleveurAsansTerre + 1     
     ]
     [
      
         vend "boeufs" nb-boeufs
         set ctask "go-eleveur"
       ]
       
     ]
  
  [
    if argent > 6000[
      if a = 2[
        vend "boeufs" nb-boeufs
        set strategie "planteur"
        set lots 1
        set argent argentBasePlanteur
        set shape "house"
        set color blue
        set ctask "go-planteur"
        
        set nbrEmployé 0
        set embauche? 0
        set size 0.9 
        
        ;;passage en planteur
        set eleveurAplanteur eleveurAplanteur + 1          
      ] 
    ]
  ]
  
end
;Celle des planteurs
to strategiePlanteur 
  let a random 4
  
  ifelse ( argent > 2000) and ( argent < 3500)  [
    if a = 1[
      vend "lotCacao" lots
      set strategie "eleveur"
      
      set lots 0
      set shape "house"
      set color yellow
      set ctask "go-eleveur"
      set employeur ""
      set size 0.6  
              
      set nbrEmployé 0
      set embauche? 0  
      
      set planteurAeleveur planteurAeleveur + 1       
    ]
  ]
  [
    
      ifelse argent < 2000 [
        vend "lotCacao" 1
        set strategie "sans-terre" 
        set lots 0
        set shape "person"
        set color white
        set ctask "go-sans-terre"
        set employeur ""
        set size 0.6  
        
        set liste-lots ""          
        set nbrEmployé 0
        set embauche? 0 
        
        set planteurAsansterre planteurAsansterre + 1      
        
      ]
      [
        set ctask "go-planteur" 
      ]
     
    ]    
  
  
end
;;;;;;;;;;;---------------------------------------------------------



;;Le facteur malchance

to facteur-malchance
   set argent argent - random (nb-adultes * malchance + (argent / 20 ))
   
   ;si on est panteur et ben on paiera plus
   if(strategie = "planteur") [ 
     set argent argent - random (nb-adultes * malchance + (argent / 10 ))
      ] 
end




;;-------------L'état bilan----------------------------
;   Gères tous le schangements de stratégies des familles
;   Est appelé a la fin de chaque années ( 30 ticks)
;
;


to bilan
    
    let nourriture ( nb-adultes * ( random-normal 10 2 ) ) + ( nb-jeunes * ( random-normal 5 2 ) )
    set argent argent - nourriture
    
    ; facteur malchance
    if(strategie = "eleveur") or (strategie = "planteur") [facteur-malchance];
    
    if argent < 0[
       die
    ]
    
    ifelse strategie = "sans-terre"[
       strategieSansTerre 
    ]  
    
    [  
      ifelse strategie = "eleveur" [
        strategieEleveur               
      ]
      
      [
        strategiePlanteur
      ]
      
      
    ]
    
   
end



;; 
to go
  ;grass-grow
  ask patches [ evolution ]
  ask familles [run ctask]
  tick
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
1221
522
38
18
13.0
1
10
1
1
1
0
1
1
1
-38
38
-18
18
0
0
1
ticks
30.0

SLIDER
13
23
185
56
numberFamilles
numberFamilles
0
5000
1783
1
1
NIL
HORIZONTAL

BUTTON
39
446
102
479
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
35
499
98
532
NIL
go\n
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
1237
90
1387
108
NIL
11
0.0
1

TEXTBOX
1248
15
1398
132
      LEGENDE\nvert foncé - culture perenne\nvert normal - foret\nvert clair - patures\nrouge - transamazonie\njaune - culture annuelle\norange - jachere\ntriangle noir,rouge - troupeaux\ncarré blanc - lot\n
10
0.0
1

PLOT
1109
537
1555
756
population
temps
nombre
0.0
0.0
0.0
0.0
true
true
"" ""
PENS
"éleveur" 1.0 0 -10263788 true "" "plot count familles with [ strategie = \"eleveur\"]"
"planteur" 1.0 0 -14985354 true "" "plot count familles with [ strategie = \"planteur\"]"
"sans-terre" 1.0 0 -2674135 true "" "plot count familles with [ strategie = \"sans-terre\"]"

PLOT
224
535
657
755
Argent moyen
temps
argent
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"éleveur" 1.0 0 -10263788 true "" "plot (sum [argent] of familles with [ strategie = \"eleveur\" ]  + 1 ) / ( count familles  with [ strategie = \"eleveur\"] + 1)"
"planteur" 1.0 0 -14985354 true "" "plot (sum [argent] of familles with [ strategie = \"planteur\" ] + 1 ) / ( count familles  with [ strategie = \"planteur\"] + 1 )"
"sans-terre" 1.0 0 -5298144 true "" "plot (sum [argent] of familles with [ strategie = \"sans-terre\" ] + 1 ) / ( count familles  with [ strategie = \"sans-terre\"] + 1  )"

PLOT
655
536
1108
758
Repartition surface
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"foret" 1.0 0 -15456499 true "" "plot count patches with [ couverture-vegetale = \"foret\"]"
"pature" 1.0 0 -13210332 true "" "plot count patches with [ couverture-vegetale = \"pature\"]"
"culture-perrenne" 1.0 0 -1184463 true "" "plot count patches with [ couverture-vegetale = \"culture-perenne\"]"
"jachere" 1.0 0 -955883 true "" "plot count patches with [ couverture-vegetale = \"jachere\"]"
"cacao" 1.0 0 -8431303 true "" "plot count patches with [ couverture-vegetale = \"cacao\"]"

SLIDER
20
84
192
117
cout-base
cout-base
0
5000
2000
1
1
NIL
HORIZONTAL

SLIDER
20
144
192
177
cout-proche-amazone
cout-proche-amazone
0
5000
4029
1
1
NIL
HORIZONTAL

SLIDER
31
191
203
224
PrixseuilEmbauche
PrixseuilEmbauche
0
10000
2633
1
1
NIL
HORIZONTAL

SLIDER
28
258
200
291
argentBasePlanteur
argentBasePlanteur
0
20000
3594
1
1
NIL
HORIZONTAL

SLIDER
22
318
194
351
argentBaseEleveur
argentBaseEleveur
0
20000
3200
1
1
NIL
HORIZONTAL

SLIDER
24
384
196
417
argentBaseSansTerre
argentBaseSansTerre
0
20000
2319
1
1
NIL
HORIZONTAL

PLOT
1356
381
1556
531
population totale
temps
nombre
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
" familles" 1.0 0 -16777216 true "" "plot count turtles"

SLIDER
4
563
114
596
malchance
malchance
0
100
50
1
1
NIL
HORIZONTAL

PLOT
1237
169
1572
360
Changements de stratégie
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"eleveur -> planteur" 1.0 0 -16777216 true "" "plot eleveurAplanteur"
"planteur -> eleveur" 1.0 0 -7500403 true "" "plot  planteurAeleveur"
"sans-terre -> eleveur" 1.0 0 -2674135 true "" "plot  sansTerreAeleveur"
"sans-terre -> planteur" 1.0 0 -15040220 true "" "plot  sansTerreAplanteur"
"eleveur -> sans-terre" 1.0 0 -6459832 true "" "plot  eleveurAsansTerre"
"planteur -> sans-terre" 1.0 0 -14454117 true "" "plot  planteurAsansterre"

PLOT
6
622
206
772
Deforestation
temps
%
0.0
0.0
0.0
100.0
true
true
"" ""
PENS
"def" 1.0 0 -8053223 true "" "plot (100 - ((( count patches with [ couverture-vegetale = \"foret\"]) / ( count patches )) * 100 ))"

MONITOR
1394
32
1579
113
annéé en cours :
ticks / 30
1
1
20

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.0.4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 1.0 0.0
0.0 1 1.0 0.0
0.2 0 1.0 0.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
