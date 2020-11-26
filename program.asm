ld x6, 0(x0)
nop
ld x7, 1(x0)

and x5, x6, x7
sd x5, 2(x0)

or x5, x6, x7
sd x5, 3(x0)

add x5, x6, x7
sd x5, 4(x0)

sub x5, x6, x7
sd x5, 5(x0)

beq x6, x7, 4
sd x6, 6(x0)

// Skip `sd x7, 7(x0)`.
beq x6, x6, 4
sd x7, 7(x0)
sd x7, 8(x0)
