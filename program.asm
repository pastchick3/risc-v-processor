ld x5, 0(x0)
ld x6, 1(x0)

// and x5, x6, x7
// sd x7, 2(x0)

// or x5, x6, x7
// sd x7, 3(x0)

// add x5, x6, x7
// sd x7, 4(x0)

// sub x5, x6, x7
// sd x7, 5(x0)

// beq x5, x6, 2
// sd x5, 6(x0)

// Skip `sd x6, 7(x0)`.
// beq x5, x5, 2
// sd x6, 7(x0)
// sd x6, 8(x0)
