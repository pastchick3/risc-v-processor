ld x6, 0(x0)
ld x7, 1(x0)

nop
nop

nop
nop

and x8, x6, x7
or x9, x6, x7

nop
nop

beq x6, x7, 8
sd x8, 2(x0)

beq x6, x6, 8
sd x9, 3(x0)
sd x9, 4(x0)
