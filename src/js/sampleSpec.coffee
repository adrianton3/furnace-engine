'use strict';

window.sampleSpec = '''
PARAM

camera 11 9
scale 8
start_location 11 11 entry

COLORS

0 rgb 0 0 0
1 rgb 40 40 40
2 rgb 80 80 80
3 rgb 120 120 120
4 rgb 160 160 160
5 rgb 200 200 200
6 rgb 230 230 230
7 rgb 255 255 255
L rgb 155 200 21
l rgb 181 230 29
p rgb 34 177 76
w rgb 0 183 239
W rgb 124 224 255
s rgb 255 248 178
t rgb 185 122 87
T rgb 235 219 109
g rgb 255 200 21
y rgb 255 242 0
r rgb 237 116 36
m rgb 130 101 115
M rgb 0 19 127
z rgb 255 0 106
d rgb 170 255 242
b rgb 0 148 255
B rgb 0 113 193
c rgb 91 46 1
C rgb 51 26 1


PLAYER
down
bbbbb
B7B7B
bbbbb
b777b
bbbbb

left
bbbbb
B7BBB
bbbbb
b77bb
bbbbb

up
bbbbb
BBBBB
bbbbb
bbbbb
bbbbb

right
bbbbb
BBB7B
bbbbb
bb77b
bbbbb

OBJECTS

grass
LlLLL
LlLLL
LLLlL
lLLlL
lLLLL

grass2
LlLLL
lLLlL
LLlLL
LlLLL
LLLlL

grass3
L3LLL
LL3LL
LLLLL
L3LLL
LLLLL

stone blocking
t444t
43344
43444
44334
t344t

stoneiron blocking
t444t
43544
45344
44354
t444t

stonediamond blocking
t444t
443d4
43444
44d44
t443t

tree blocking
LlllL
lllll
lllll
LlllL
LLtLL

tree2 blocking
LlllL
lllll
LlllL
LLtLL
LLtLL

pinetree blocking
LLpLL
LpppL
LpppL
pptpp
LLtLL

water blocking
WwWWW
wWWWW
WWwwW
wwWWw
WWWWW

water:1
WWwWW
WwWWW
WWWww
wwwWW
WWWWW

sandSE
LLLLs
LLLss
LsLss
LLssW
sssWW

sandS
LLLLL
LLLLL
LLLsL
LssLL
sssss

sandSW
sLLLL
sLLLL
ssLLL
WssLs
WWsss

sandW
sLLLL
sLLLL
ssLLL
sssLL
ssLLL

sandNW
WWsss
WsssL
ssLLL
sLsLL
sLLLL

sandN
sssss
LsLLs
LLLLL
LLLLL
LLLLL

sandE
LLLss
LLLss
LLLss
LLLLs
LLLLs

sandNE
sssWW
LLssW
LLLss
LLLLs
LLLLs

wood
LLLLL
LLLLL
TTTTL
Ltttt
TTTTL

iron
LLLLL
LLLLL
LLLLL
6666L
5555L

table blocking
LLLLL
TTTTL
TttTL
TTTTL
tLLtL

furnace blocking
L222L
23332
33233
31113
31113

furnacelit blocking
L222L
23332
33y33
3ygy3
3ryr3

furnacelit:1 blocking
L222L
23332
33y33
3ryr3
3grg3

door blocking
6ttt6
tTTTt
tTTTt
ttTTt
tTTTt

dooriron blocking
6ttt6
t121t
t121t
tt21t
t121t

floor
66666
65556
65556
65556
66666

wall blocking
22222
23332
23332
23332
22222

wallcorner blocking
32323
24342
33433
24342
32323

wallside blocking
44344
44344
33333
43444
43444

monster1 blocking
6zzz6
zzzzz
z0z0z
zzzzz
z6z6z

monster2 blocking
M666M
MMMMM
M7M7M
MMMMM
MMMMM

monster3 blocking
66m66
6mmm6
m7m7m
6mmm6
mm6mm

torch blocking
66y66
6ygy6
64446
66466
64446

cave
L444L
42224
42224
42224
42224

caveexit
24442
4WWW4
4LLL4
4LLL4
4LLL4

dirt
t3ttt
3tt3t
tt3tt
t3ttt
ttt3t

darkdirt
11111
11111
11111
11111
11111

darkstone
11111
11111
11111
11111
11111

darkdiamond
11111
11111
11111
11111
11111

darkiron
11111
11111
11111
11111
11111

pickaxe
LLLLL
LLLtL
LLtTT
LtLTL
tLLLL

pickaxestone
L33LL
LLL3L
LLtL3
LtLL3
tLLLL

pickaxewood
LTTLL
LLLTL
LLtLT
LtLLT
tLLLL

pickaxeiron
L66LL
LLL6L
LLtL6
LtLL6
tLLLL

sword
LLL45
LL454
5454L
L54LL
tL5LL

sworddiamond
LLL4d
LL4d4
54d4L
L54LL
tL5LL

diamond
LLLLL
LLdLL
LdwdL
LLdLL
LLLLL

goldkey
66666
6y66y
y6yyy
6y666
66666

ironkey
66666
61661
16111
61666
66666

flower
lLLrL
LLryr
LLLrL
lLLll
LLLlL

flower:1
lLrLL
LryrL
LLrLL
lLLll
LLLlL

cakeNW
66666
65556
65556
655y6
66csc

cakeSW
6cccr
67777
6CCCC
6CCCC
66666

cakeNE
66666
65556
y5556
s5556
scr66

cakeSE
crcc6
77776
CCCC6
CCCC6
66666


SETS
Keys = goldkey ironkey
Monsters = monster1 monster2 monster3
Grass = grass grass2 grass3


NEARRULES

darkdirt -> dirt
darkstone -> stone
darkdiamond -> stonediamond
darkiron -> stoneiron

ENTERRULES

cave -> cave ; teleport cave 7 9
caveexit -> caveexit ; teleport entry 5 5
Keys -> floor ; give 1 _terrain
grass3 -> grass3 ; checkpoint

USERULES

tree pickaxe -> grass ; give 3 wood ; consume
tree2 pickaxe -> grass ; give 2 wood ; consume
pinetree pickaxe -> grass ; give 2 wood ; consume
flower pickaxewood -> grass ; give 1 flower ; consume
furnacelit stone -> furnace ; give 9 pickaxestone ; consume
stone pickaxewood -> dirt ; give 1 stone ; consume
stone pickaxestone -> dirt ; give 1 stone ; consume
stone pickaxeiron -> dirt ; give 2 stone ; consume
stoneiron pickaxestone -> dirt ; give 1 stoneiron ; consume
stoneiron pickaxeiron -> dirt ; give 2 stoneiron ; consume
stonediamond pickaxeiron -> dirt ; give 1 diamond ; consume
door goldkey -> floor ; consume
dooriron ironkey -> floor ; consume
table wood -> table ; give 7 pickaxewood ; consume
table stone -> table ; give 1 furnace ; consume
furnace wood -> furnacelit ; consume
furnacelit stoneiron -> furnace ; give 1 iron ; consume
table iron -> table ; give 9 pickaxeiron ; consume
furnacelit diamond -> furnace ; give 3 sworddiamond ; consume
furnacelit iron -> furnace ; give 9 sword ; consume
monster1 sword -> floor ; consume
monster2 sword -> floor ; consume
Monsters sworddiamond -> floor ; consume
Grass flower -> flower ; consume
Grass furnace -> furnace ; consume


LEGEND

s stone
o stoneiron
d stonediamond
g grass
G grass2
r grass3
t tree
T tree2
p pinetree
w water
0 sandN
1 sandNW
2 sandW
3 sandSW
4 sandS
5 sandSE
6 sandE
7 sandNE
m table
D door
j floor
J wallside
Z wall
z wallcorner
e monster1
E monster2
c monster3
y torch
u cave
U caveexit
h dirt
q darkdirt
Q darkstone
a darkiron
A darkdiamond
F flower
k goldkey
K ironkey
X door
Y dooriron
8 cakeNW
9 cakeSW
R cakeSE
C cakeNE


LEVELS

entry
wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
ww1000000000000000000000000007wwwwwwwwwwwwwwwwwwwwww
ww2TttTtgggGGGrggGGgGpggGgggG6ww10000000000000000007
ww2gTuTtTgFGTGggggGGppGpprpgg6ww2gzZZZZZzZZZZZZZZZz6
ww2GtrFTtGGTtgGGggggrggpGppgg6ww2gZJJJJJzJJJJJzJJJJ6
ww2tTTGtTgGGgGtFggGGgpGpGpgpG6ww2gZjjKjjZjkjkjZjjjZ6
ww2gtgggGtgggGGggGGGggppggppg6ww2gzZZjZZzZZjZZzjjjZ6
ww2GgggTgGggggGGgpGGGrpGpppGGg00gyJJJXJJJJJYJJJyjyZ6
ww2rGttFGggmFgggggGGgGGGrGprggggjjejjjjjEjjjjjYjjjZ6
ww2ggTGtgggGGGrggGGrGggpGgggGgggjjejjjjjEjjjjjYjjjZ6
ww2ggtggggggGGgggGFgGGGGpggggg44gyzZZjZZzZZjZZzyjyZ6
ww2GgggggGGrggGGgggGGgggppggg6ww2gZJJYJJZJJXJJZZXZZ6
ww2grGGrggGGgGgggGGrggGgrggGG6ww2gZjkjkjZjKjKjZZYZZ6
ww2ggGGgGFgggGGGgggGGgggggGgg6ww2gzZZZZZzZZZZZzZcZZ6
ww2GgggggGrgggGGGTrGGrggGGrGG6ww2gJJJJJJJJJJJJJZjJZ6
ww2gttTrgggGGGrggGGrGpFgGgggG6ww344444444444444ZjjZ5
ww2rGGrrGGrgrggggrGggGGGrGrrg6wwwwwwwwwwwwwwwwwZjjZw
ww2grGGrggGGgGrggGGrggGgrggGG6wwwwwwwwwwwwwwwwwZjjZw
ww2grGggggggggGggggggGrggggGG6wwwwwwwwwwwwwwwwwZjjZw
ww2rggGgggggGrgggGgggggGrgggG6wwwwwwwwwwwwwwwwwZjjZw
ww2pzZZgZZzprggggrGgFGGppGrrg6wwwwwwwwwwwwwwwwwZjjZw
ww2gZJJEJJZppgGgggggGGGppppGG6wwwwwwwwwwww10000ZjjZ7
ww2rZjjjjjZggggggrGGGGGGrpppg6wwwwwwwwwwww2ZZZZZjjZ6
ww2rZjjkjjZgrgggrGGrGgGgrFgGG6wwwwwwwwwwww2ZJJJJjjZ6
ww2gzZZZZZzGGgrGGGGGgGrggggGG6wwwwwwwwwwww2Z8CjyjjZ6
ww2gJJJJJJJggGGGgGgGGGrGrgggG6wwwwwwwwwwww2Z9RjjjjZ6
ww2GGFrGGggggggggrGggGGGrGrrg6wwwwwwwwwwww2ZjjjyjjZ6
ww2GGGGrGGGGGGGGgggggGGggrgGG6wwwwwwwwwwww2ZZZZZZZZ6
ww3444444444444444444444444445wwwwwwwwwwww2JJJJJJJJ6
wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww3444444445
wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

cave
QQQQQQQQQqqQQQQ
QQQQaQQQQQQAQAQ
QAQQqQQQQQQQQQQ
QQQQQQQQqQQQQQQ
QQQQQQQQQQQQQQQ
QQqqQQQqQQQqQQQ
QQqQQQQqqQQQaaQ
QQaQQQQQqQQQQqQ
QQQQQQqqqQQQQqQ
QQqQQQqqqqQQQQQ
QQQQqQqUqQQQQQQ
QaQQQQQQQQQQqQQ



'''
