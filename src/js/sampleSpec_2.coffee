'use strict'

window.sampleSpecs ?= {}
window.sampleSpecs['under-the-snow'] = '''
PARAM

camera 9 7
scale 5
start_location 25 13 entry
inventory_size_max 5
health_max 3


COLORS

0 rgba 0 0 0 0
1 rgba 211 84 0 1
2 rgba 255 186 115 1
3 rgba 166 12 0 1
4 rgba 224 224 224 1
5 rgba 180 180 180 1
6 rgba 255 125 115 1
7 rgba 191 58 48 1
8 rgba 166 84 0 1
9 rgba 255 78 64 1
a rgba 255 183 0 1
b rgba 255 129 0 1
c rgba 255 19 0 1
d rgba 210 229 208 1
e rgba 255 215 115 1
f rgba 164 201 161 1
g rgba 166 119 0 1
h rgba 204 232 255 1
i rgba 191 120 48 1
j rgba 91 127 0 1
k rgba 255 216 0 1
l rgba 198 106 0 1


PLAYER

left
0000111000
0001111100
0000336000
0000666000
0000006000
0006666000
0060666000
0000666000
0000606000
0006606000

down
0001110000
0011111000
0003330000
0006660000
0000600000
0066666000
0066666000
0006660000
0006060000
0006060000

up
0001110000
0011111000
0006660000
0006660000
0000600000
0066666000
0066666000
0006660000
0006060000
0006060000

right
0001110000
0011111000
0006330000
0006660000
0006000000
0006666000
0006660600
0006660000
0006060000
0006066000

health
0000000000
0000000000
0000000000
0000110000
0001111000
0001111000
0000110000
0000000000
0000000000
0000000000

OBJECTS

key
2222222222
2222222222
2222222222
2222222222
222222bb22
2b2b2b22b2
2bbbbb22b2
222222bb22
2222222222
2222222222

bug blocking
2272222722
2272222722
222c33c222
2727337272
272c33c272
2277777722
2227777222
2273773722
2272222722
2722222272

bug:1
2722222272
2272222722
222c33c222
7227337227
272c33c272
2277777722
2227777222
2273773722
2722222272
2722222272

radx-unpowered
2222222222
2222222222
22222cccc2
22222c22c2
222g888882
2ccg8g8882
2ccg8g8g82
222gggggg2
2222222222
2222222222

bed blocking
2222222222
2222222222
99999999ee
99999999ee
99999999ee
ccccccccee
ccccccccee
iiiiiiiiii
8822222288
8822222288

purifier blocking
2222227722
222227aa72
2777277a72
273727aa72
2737277a72
273777aa72
2737377772
2733333372
2777777772
2722222272

radio1-unpowered blocking
2222222222
2222222c22
2222222c22
2222222c22
2333333332
236763gg32
2376733g32
2367633332
2333333332
2222222222

radio2-unpowered blocking
2222222222
2222222c22
2222222c22
2222222c22
2333333332
236763gg32
2376733g32
2367633332
2333333332
2222222222

door blocking
8833333388
83aaaaa3b8
83aaaaaa38
83aaaaaa38
83abaaaa38
83abaaaa38
83aaaaaab8
83aaaaaa38
83aaaaa388
8833333388

rat blocking
2622622222
2266622222
2767222222
7666222226
2266222266
6666666662
2266666662
2266666666
2262622626
2222222222

rat:1
2622622222
2266622222
2767222222
7666222262
6666222262
2266666662
2266666662
2266666666
2262622626
2222222222

radx-powered
2222222222
2222222222
22222cccc2
22222c22c2
222b888882
2ccb8b8882
2ccb8b8b82
222bbbbbb2
2222222222
2222222222

table blocking
2222222222
2222222222
2222222222
8888888888
8888888888
iiiiiiiiii
8822222288
8222222228
8222222228
8222222228

purifier-water blocking
2222227722
222227aa72
2777277a72
273727hh72
2737277h72
273777hh72
2737377772
2733333372
2777777772
2722222272

radio1-powered blocking
2222222222
2222222c22
2222222c22
2222222c22
2333333332
236763bb32
2376733b32
2367633332
2333333332
2222222222

radio2-powered blocking
2222222222
2222222c22
2222222c22
2222222c22
2333333332
236763bb32
2376733b32
2367633332
2333333332
2222222222

floor
2222222222
2222222222
2222222222
2222222222
2222222222
2222222222
2222222222
2222222222
2222222222
2222222222

win
2222222222
2222222222
2222222222
2222222222
2222222222
2222222222
2222222222
2222222222
2222222222
2222222222

pickaxe
2222222222
2223333222
2233322222
2338222222
2332822222
2322282222
2322228222
2222222822
2222222222
2222222222

drill-unpowered
2222222222
2222222222
2222222882
223g228228
23igig8i28
3gigig8i28
23igig8i28
223g228228
2222222882
2222222222

chair blocking
222222ccc2
222222c8c2
222222c822
222222c822
222222c822
22ccccc822
2c88888822
2282222822
2282222822
2282222822

purifier-rad blocking
2222227722
222227aa72
2777277a72
273727jj72
2737277j72
273777jj72
2737377772
2733333372
2777777772
2722222272

eye
2222222222
2222222222
2b22b22b22
22aaaaa222
2a2bbb2a22
a2bbcbb2a2
2a2bbb2a22
22aaaaa222
2222222222
2222222222

dirt1 blocking
8228888888
8888882288
8888828888
8888888888
8228888888
8822888822
8888888888
8888822888
8828888888
8888888888

crowbar
2222222222
2222222222
2233222222
2322322222
2322232222
2222223222
2222222322
2222222232
2222222222
2222222222

drill-powered
2222222222
2222222222
2222222882
223b228228
23ibib8i28
3bibib8i28
23ibib8i28
223b228228
2222222882
2222222222

wall1 blocking
3333333333
33kkkkk3kk
3k3aaaa3aa
3ka3333333
3ka33aaaaa
3333a3llll
3ka3al3333
3ka3333222
3ka3al3222
3ka3al3222

wall2 blocking
3333al3222
3ka3al3222
3ka3333222
3ka3al3222
3ka3al3222
3333al3222
3ka3al3222
3ka3333222
3ka3al3222
3ka3al3222

wall3 blocking
3333al3222
3ka3al3222
3ka3333222
3ka3al3333
3ka3a3l3ll
33333aa3aa
3ka3333333
3k3a3aaaa3
33kk3kkkk3
3333333333

ladder-down1
2232222232
2232222232
2237777732
2232222232
2237777732
2232222232
2237777732
2232222232
2222222222
2222222222

ladder-down2
2232222232
2232222232
2237777732
2232222232
2237777732
2232222232
2237777732
2232222232
2222222222
2222222222

minerals blocking
8988888888
8888898888
8888999889
9888898899
8889888889
8899988888
8889888888
8888888988
8988889998
9998888988

jane blocking
222ccc2222
2226662222
2226662222
222c6c2222
222bbb2222
226bbb6222
2223332222
2223332222
2226262222
2226262222

battery
2222222222
222bbbb222
222baab222
22bbbbbb22
22baaaab22
22baggab22
22baaaab22
22baggab22
22baaaab22
22bbbbbb22

wall0 blocking
3333333333
kk3kkkk3kk
aa3aaaa3aa
3333333333
3aaaa3aaaa
3llll3llll
3333333333
2222222222
2222222222
2222222222

wall8 blocking
2333333332
33kkkkkk33
3k3aaaa3k3
3ka3333ak3
3ka3ll3ak3
3ka3ll3ak3
3ka3333ak3
3k3aaaa3k3
33kkkkkk33
2333333332

wall4 blocking
2222222222
2222222222
2222222222
3333333333
ll3llll3ll
aa3aaaa3aa
3333333333
aaaa3aaaa3
kkkk3kkkk3
3333333333

granite blocking
8888888888
8838888888
8333888338
8333388388
8838888888
8888888888
8888883388
8338833388
3338888338
8888888888

mr-white1 blocking
2222222222
22e666e222
22e666e222
2222622222
22gg6gg222
226ggg3322
226ggg6322
2229292322
2226262322
2262262222

mr-white2 blocking
2222222222
22e666e222
22e666e222
2222622222
22gg6gg222
226ggg3322
226ggg6322
2229292322
2226262322
2262262222

medpack
2222222222
2222222222
22eeeee222
22eecee722
22eccce722
22eecee722
22eeeee722
2227777722
2222222222
2222222222

wall7 blocking
3333333333
kk3kkkkk33
aa3aaaa3k3
3333333ak3
3aaaa33333
3lll3a3ak3
3333la3ak3
2223la3ak3
2223la3ak3
2223la3333

wall6 blocking
2223la3ak3
2223333ak3
2223la3ak3
2223la3ak3
2223la3333
2223la3ak3
2223333ak3
2223la3ak3
2223la3ak3
2223la3333

wall5 blocking
2223la3ak3
2223333ak3
2223la3ak3
3333la3ak3
ll3l3a3333
aa3aa33ak3
3333333ak3
aaaa3aa3k3
kkkk3kkk33
3333333333

skull
2222222222
2222222222
2262222262
2266666622
2226666622
2227767722
2226666622
2227766222
2222277222
2222222222

dirt2 blocking
8288888888
8888888828
8888828888
8288888888
8888888888
8882888882
8888888888
8828888288
8888888888
8888888888

bottle-water
2222222222
2222882222
2222882222
2222992222
2229999222
2229hh9222
2229hh9222
2229hh9222
2229hh9222
2229999222

bottle-rad
2222222222
2222882222
2222882222
2222992222
2229999222
2229jj9222
2229jj9222
2229jj9222
2229jj9222
2229999222

bottle-empty
2222222222
2222882222
2222882222
2222992222
2229999222
2229229222
2229229222
2229229222
2229229222
2229999222

mushroom1
2222222222
2222222222
2227777222
22777b7722
227b77b722
2277gg7722
2222gg2222
2222gg2222
2222222222
2222222222

mushroom2
2222222222
27b7222222
7b77722222
77g7b22222
22g2222222
2222277722
222277b7b2
222277g772
222222g222
2222222222

snow
4444454444
4444444444
4454444544
4544444444
4544454454
4444544454
4444444444
4544544454
4445444554
4444444444

snow-trampled
4444454444
4444444444
4554444544
4544554444
4544554554
4444544554
4445444444
5545554454
5545455554
4444445544

snow-rad
ddddd5dddd
ddfddddfdd
df5ddff5dd
d5fdddfddd
d5fdd5dd5d
dfdd5ffdfd
dddddfdddd
d5dd5ddf5d
ddd5dfd55d
ffddddfddd

snow-rad-trampled
ddd5d5dddd
55d5dddfdd
df55dfd5d5
d5d5ddfdd5
d5ddd5555d
dfd55ff5fd
ddd55dd5dd
d5555ddd5d
d555dfd555
fdddddfddd

tree blocking
ddddd53ddd
ddfd3d3fdd
df5dd335dd
d533d3dddd
ddd333dd5d
dfdd3333fd
dddd33dddd
d5dd33df5d
ddd333dd5d
fd333333dd

ladder-up1
4444454444
4444444444
4454444544
4534444344
4538888354
4837777384
8838888388
8837777388
4838888384
4488888844

ladder-up2
4444454444
4444444444
4454444544
4534444344
4538888354
4837777384
8838888388
8837777388
4838888384
4488888844




SETS

Walls = wall0 wall1 wall2 wall3 wall4 wall5 wall6 wall7 wall8

ENTERRULES

eye -> floor ; give 1 eye
crowbar -> floor ; give 9 crowbar
drill-unpowered -> floor ; give 1 drill-unpowered
radx-unpowered -> floor ; give 1 radx-unpowered
pickaxe -> floor ; give 32 pickaxe
bottle-empty -> floor ; give 1 bottle-empty
battery -> floor ; give 1 battery

snow -> snow-trampled
snow-rad -> snow-rad-trampled ; hurt 1 ; message "This heavily\\nradiated snow hurts"

ladder-down1 -> ladder-down1 ; teleport surface 26 12
ladder-down2 -> ladder-down2 ; teleport surface 1 0
ladder-up1 -> ladder-up1 ; teleport entry 0 1
ladder-up2 -> ladder-up2 ; teleport section2 40 17

win -> floor ; message "I have found a stash\\nto last a lifetime"

USERULES

ladder-down1 eye -> ladder-down1 ; message "Ladder goes to\\nthe surface"
ladder-down2 eye -> ladder-down2 ; message "Ladder goes to\\nthe surface"
ladder-up1 eye -> ladder-up1 ; message "Ladder to\\nunderground"
ladder-up2 eye -> ladder-up2 ; message "Ladder to\\nunderground"

skull eye -> skull ; message "Skull"
key eye -> key ; message "Key"
floor eye -> floor ; message "Floor"
dirt1 eye -> dirt1 ; message "Dirt"
dirt2 eye -> dirt2 ; message "Dirt"
minerals eye -> minerals ; message "Minerals"
granite eye -> granite ; message "Granite"
bug eye -> bug ; message "Sleeping bug"
rat eye -> rat ; message "Sleeping rat"
pickaxe eye -> pickaxe ; message "Pickaxe"
crowbar eye -> crowbar ; message "Crowbar"
jane eye -> jane ; message "So you have heard my distress signals"
mr-white1 eye -> mr-white1 ; message "Mr White looks\\nthirsty"
mr-white2 eye -> mr-white2 ; message "Mr White"
radx-unpowered eye -> radx-unpowered ; message "Unpowered RADX"
radx-powered eye -> radx-powered ; message "Powered RADX"
drill-unpowered eye -> drill-unpowered ; message "Unpowered drill"
drill-powered eye -> drill-powered ; message "Powered drill"
battery eye -> battery ; message "Battery"
medpack eye -> medpack ; message "Med pack"
bed eye -> bed ; message "Bed"
table eye -> table ; message "Table"
chair eye -> chair ; message "Chair"
Walls eye -> _terrain ; message "Wall"
bottle-empty eye -> bottle-empty ; message "Empty bottle"
bottle-water eye -> bottle-water ; message "Bottle of water"
bottle-rad eye -> bottle-rad ; message "Bottle of irradiated\\nwater"
purifier eye -> purifier ; message "Empty purifier"
purifier-water eye -> purifier-water ; message "Purifier"
purifier-rad eye -> purifier-rad ; message "Purifier"
mushroom1 eye -> mushroom1 ; message "Big mushroom"
mushroom2 eye -> mushroom2 ; message "Mushrooms"
snow eye -> snow ; message "Snow"
snow-trampled eye -> snow-trampled ; message "Trampled snow"
snow-rad eye -> snow-rad ; message "Irradiated snow"
snow-rad-trampled eye -> snow-rad-trampled ; message "Irradiated trampled\\nsnow"
tree eye -> tree ; message "Dead tree"
radio1-unpowered eye -> radio1-unpowered ; message "Radio unpowered"
radio1-powered eye -> radio1-powered ; message "Radio there is a\\nfaint signal"
radio2-unpowered eye -> radio2-unpowered ; message "Radio unpowered"
radio2-powered eye -> radio2-powered ; message "Radio the signal is\\nstronger here"

dirt1 pickaxe -> floor ; consume
dirt2 pickaxe -> floor ; consume
minerals pickaxe -> floor ; consume
granite pickaxe -> granite ; message "Need a drill"

floor radx-unpowered -> radx-unpowered ; consume
floor drill-unpowered -> drill-unpowered ; consume
radx-unpowered battery -> floor ; give 1 radx-powered ; consume
drill-unpowered battery -> floor ; give 1 drill-powered ; consume

dirt1 drill-powered -> floor ; consume ; give 1 drill-unpowered
dirt2 drill-powered -> floor ; consume ; give 1 drill-unpowered
minerals drill-powered -> floor ; consume ; give 1 drill-unpowered
granite drill-powered -> floor ; consume ; give 1 drill-unpowered

rat crowbar -> floor
bug crowbar -> floor ; hurt 1 ; consume

drill-unpowered battery -> floor ; give 1 drill-powered ; consume
radio1-unpowered battery -> radio1-powered ; consume ; message "You can hear a faint\\ndistress signal"
radio2-unpowered battery -> radio2-powered ; consume ; message "You hear the same\\nsignal, but stronger"

floor bottle-water -> floor ; heal 1
mr-white1 bottle-water -> mr-white2 ; give 1 key , 1 bottle-empty ; consume ; message "Thanks! Here take this\\nkey I found! I don't know\\nwhat it opens but maybe\\nyou will find out"
mr-white1 bottle-rad -> mr-white1 ; message "This water is\\nnot pure"

snow-rad radx-powered -> snow ; give 1 radx-unpowered ; consume
snow-rad-trampled radx-powered -> snow-trampled ; give 1 radx-unpowered ; consume

snow bottle-empty -> snow-trampled ; give 1 bottle-rad ; consume
snow-rad bottle-empty -> snow-rad-trampled ; give 1 bottle-rad ; consume
purifier bottle-rad -> purifier-rad ; give 1 bottle-empty ; consume
purifier-rad battery -> purifier-water ; consume
purifier-water bottle-empty -> purifier ; give 1 bottle-water ; consume

door key -> floor ; consume


LEGEND

* eye
a radx-unpowered
b bug
B battery
c chair
C crowbar
d dirt1
D dirt2
e bed
f floor
g granite
i drill-unpowered
j jane
l ladder-down1
L ladder-down2
m minerals
M mr-white1
o ladder-up1
O ladder-up2
p purifier
P pickaxe
r rat
R door
s snow
S snow-rad
t tree
T table
u mushroom1
U mushroom2
w bottle-water
W bottle-empty
x radio1-unpowered
y radio2-unpowered
Z win


0 wall0
1 wall1
2 wall2
3 wall3
4 wall4
5 wall5
6 wall6
7 wall7
8 wall8

LEVELS

entry
lddddddddddddddddmdDddgddddddddddddd
fffDddddddDddmmddddddddddddddddddddd
BdbDdd000dddddddddgdfffTcBdddddddddd
ddfffffffffffffffffffffffffddddddddd
ddd4dddd44dDfdddddddddddmmfddddddddd
ddddDddgddddfddddddddddgddfddddddddd
dDddDdddddDDfdddddddddDDddfddddddddd
dddufdfffffff6ddddDDDddDrrrdgDdddddd
ddmUudfdDdd2f6dddddddBfffrrddmdddddd
ddduUffDdgd2f6dddDdddmdDmmmdgddddddd
dDdddfdDdgd2fdddDDddddddDDdddddddddd
ddDfffmdddd2fddddddd1000007dgddddddd
dfBfmdDDddDdfdd00ddd2fTcfe6dd0000007
dfDDddmmddddffffffffffff*fffffffBBC6
dfddDDDddddddgdd4ddd2ffffx6dd2ffaiP6
dBbdDddggDdddgddDddd2fffWp6dd3444445
ddddddddDDdddddddddd3444445ddddddddd


section2
ddddddddddggggddggdDddmgddddddddddddddddfB
d10000007gggddddfddfdgfdDDfdddddddddddmmff
d2wwffww6ggdddugggffdgggddfddffdddgggddddd
d2wfBBfwZddfUdgddggggdDgddddddddddddddddDD
d2BBffBB6ggffggddddDmdddgdddDddfffdddmddmm
d2wBBBBw6dgRDgdmddgdddffffdmdfdddfddddddDm
d34444445mgfggggdddggdfdDddddddddddgggdddd
dddddgggdDgfggddDmddddfffBBfddm100000007dd
ddggddddggddgddffgggdDfddddfddd2efffMBy6dd
ggggmgggddddggffddddddddBrffddd2Tffffff6dd
ddddgggddddddgffddmddgdddgdfddD34444ff45dd
ddddggDfddffgddfdDDddddddddfmdddDddffcdddd
ddddgfdddddggddfddffdfffrfudfddddfffffdddd
dd100f007DdddddfddddDgfBbdddffdddddddfdddd
dd2efffT6ddddddfdddddddddddddfdddddddfdddd
dd2fjfff6ddddddfddddddudddddddduUudddfdddd
dd2BffffffdddddfddddddUfdduddfrffffffffffd
dd3444445fffffffddddgbbdddddddrrddddddfffd
ddddddddddddddddddddgBbdddddddddddddddddLd

surface
OssssSSttSSSSSSSSSSSSSSSSSSSSSS
SssssssSStSSSSSSSSSSSSSSSSSSSSS
tSsssSStSSSSSSSStSSSSSSSSSSSSSS
SStSsSSSSSttSSStSSSSSSSSSSSSSSS
SSStsSssssssssSSttSSSttSSSSSSSS
SStSssssSSSSSSSssSSSSSSSSSSSSSS
SSSSSStttSSStSSssstSSttSSSSSSSS
SSSSSSStSSSSsssssSSSSSSSStttSSS
SSSStssssSSSSSSSsssSSSSSSSSSSSS
SSSSSsssSSSSStSssSssttSSSSSSSSS
SSSSSSSSSSSSSStSSSsssSSSttSStSS
SSSSSSSSttSSSSStStSSSsssssstSSS
SStttSSSSSSSSSSSSSSStStssssssSS
SSSSSSSSSSSSSSSSSSSSSSSSSsosssS



'''
