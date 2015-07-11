module Trixel.Types.Keyboard where

import Trixel.Types.Input exposing(Button)


a: Button
a =
 65


b: Button
b =
 66


c: Button
c =
 67


d: Button
d =
 68


e: Button
e = 
 69


f: Button
f = 
 70


g: Button
g = 
 71


h: Button
h = 
 72


i: Button
i = 
 73


j: Button
j = 
 74


k: Button
k = 
 75


l: Button
l = 
 76


m: Button
m = 
 77


n: Button
n = 
 78


o: Button
o = 
 79


p: Button
p = 
 80


q: Button
q = 
 81


r: Button
r = 
 82


s: Button
s = 
 83


t: Button
t = 
 84


u: Button
u = 
 85


v: Button
v = 
 86


w: Button
w = 
 87


x: Button
x = 
 88


y: Button
y = 
 89


z: Button
z = 
 90


ctrl: Button
ctrl = 
 17


shift: Button
shift = 
 16


tab: Button
tab = 
 9


{-| super,meta,windows are all the same -}
super: Button
super = 
 91


{-| super,meta,windows are all the same -}
meta: Button
meta = 
 91


{-| super,meta,windows are all the same -}
windows: Button
windows = 
 91


{-| A Button on mac keyboards. The same keycode as the windows/super/meta keys -}
commandLeft: Button
commandLeft =
 91


{-| A Button on mac keyboards. -}
commandRight: Button
commandRight =
 93


space: Button
space = 
 32


enter: Button
enter = 
 13


arrowRight: Button
arrowRight = 
 37


arrowLeft: Button
arrowLeft = 
 39


arrowUp: Button
arrowUp = 
 38


arrowDown: Button
arrowDown = 
 40


backspace: Button
backspace = 
 8


delete: Button
delete = 
 46


insert: Button
insert = 
 45


end: Button
end = 
 35


home: Button
home = 
 36


pageDown: Button
pageDown = 
 34


pageUp: Button
pageUp = 
 33


escape: Button
escape = 
 27


-- We don't define the F keys that are not availiable.
-- AKA, F1 is help, F3 is search.  F5 is refresh.
-- Those keys cannot be used.


f2: Button
f2 = 
 113


f4: Button
f4 = 
 115


f8: Button
f8 = 
 119


f9: Button
f9 = 
 120


f10: Button
f10 = 
 121


one: Button
one = 
 49


two: Button
two = 
 50


three: Button
three = 
 51


four: Button
four = 
 52


five: Button
five = 
 53


six: Button
six = 
 54


seven: Button
seven = 
 55


eight: Button
eight = 
 56


nine: Button
nine = 
 57


zero: Button
zero = 
 58