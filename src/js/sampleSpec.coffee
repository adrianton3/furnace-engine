'use strict';

window.sampleSpec = '''
PARAM

camera 7 7
scale 8
start_location 1 1 entry

COLORS

r rgb 230 10 50
G rgb 10 200 50
g rgb 60 255 100
T rgb 50 160 10
b rgb 10 50 230
w rgb 185 185 185
W rgb 255 255 255
l rgb 1 5 10
y rgb 250 240 30
s rgb 140 140 140
S rgb 80 80 80
D rgb 80 40 10
d rgb 120 60 20
p rgb 160 30 240
P rgb 140 10 220
c rgb 40 200 250
C rgb 20 120 160
o rgb 255 200 120


PLAYER
up
ppppp
pPPPp
pPPPp
pPPPp
ppppp

left
ppppp
pWPPp
pPPPp
pWWPp
ppppp

down
ppppp
pWPWp
pPPPp
pWWWp
ppppp

right
ppppp
pPPWp
pPPPp
pPWWp
ppppp

OBJECTS

stone blocking
dssSd
ssSss
sSssS
sssSs
dssSd

bush blocking
gTGTg
TTTTT
GTTTG
TTTTT
gTGTg

flower
ggygg
gyryg
ggygg
ggGgg
ggGgg

flower:1
gggyg
ggyry
gggyg
gGGgg
ggGgg

dirt
ddDdd
dddDd
dDddd
ddddd
DdddD

grass
ggggG
ggggG
Ggggg
GgGgg
ggGgg

pickaxe
GwwGG
GGGwG
GGdGw
GdGGw
dGGGG

void blocking
lllll
lllll
lllll
lllll
lllll

star blocking
lllll
lllWl
lllll
lllll
lllll

one
CcCcC
ccccc
CcccC
ccccc
CcCcC

two
CCCCC
CcCcC
CCcCC
CcCcC
CCCCC

tel2
googG
ogggG
ogoog
ogGgo
gooog


SETS

Collectible = stone grass

LEAVERULES

two -> one
one -> void

ENTERRULES

flower -> grass ; give 1 flower
tel2 -> tel2 ; teleport lev2 3 3

USERULES

Collectible pickaxe -> dirt ; give 1 _terrain ; consume
dirt Collectible -> _inventory ; consume
grass stone -> stone ; consume

LEGEND

s stone
d dirt
g grass
p pickaxe
b bush
f flower
v void
* star
1 one
2 two
t tel2

LEVELS

entry
ggdggdddddgv*v111vdgg
gggggdsssddg11111*dgg
dgbbgdssddgggv121vgtg
gfgbgddddggdgv1v*vdgg
ggdggdggggbbg*2v111gg
gdgggggfbbgddv212vvvd
gggdggdgggggdvvv1v*vv

lev2
ggdgfgggddggg
gdgdgggfdgggg
ggdsddddsdgdg
ggdssssddgggg
gfgdssssdgfdg
ggdfdddsdggdg
ggdggggdggggg



'''