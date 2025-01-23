.data
	N:       .dword 4096	// Number of elements in the vectors
	Alpha:   .dword 2      // scalar value
	
	.bss 
	X: .zero  32768        // vector X(4096)*8
	Y: .zero  32768        // Vector Y(4096)*8
        Z: .zero  32768        // Vector Y(4096)*8

	.arch armv8-a
	.text
	.align	2
	.global	main
	.type	main, %function
main:
.LFB6:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	mov	x1, 0
	mov	x0, 0
	bl	m5_dump_stats

	ldr     x4, N
    	ldr     x10, Alpha
    	ldr     x1, =X
    	ldr     x2, =Y
	ldr     x3, =Z

//---------------------- CODE HERE ------------------------------------
	scvtf d10,x10		// "convierto" el x10 en punto flotante
	mov x5, #0            // Inicializa i = 0 (contador)
	mov x8, x1            // Copio el inicio del arreglo X en x8
	mov x9, x2            // Copio el inicio del arreglo Y en x9
	mov x12, x3           // Copio el inicio del arreglo Z en x12

loop:
	ldur d6, [x8, #0]     // d6 carga el elemento X[i] (d = 64 bits punto flotante)
	ldur d7, [x9, #0]     // d7 carga el elemento Y[i]
	fmul d13, d10, d6     // d13 = alpha * X[i]
	fadd d14, d7, d13     // d14 = (alpha * X[i] + Y[i])
	stur d14, [x12, #0]   // Z[i] = d14
	// SUMO 8 PORQUE SON ELEMENTOS DE 64 Bits --> Uso 8 posiciones de memoria para 1 elemento.
	add x8, x8, #8        // x8 apunta al siguiente elemento de X (siguiente índice) 
	add x9, x9, #8        // x9 apunta al siguiente elemento de Y
	add x12, x12, #8      // x12 apunta al siguiente elemento de Z
	add x5, x5, #1        // i = i + 1
	cmp x5, x4            // Compara i con N
	b.ne loop             // Si i < N, repite el bucle

//---------------------- END CODE -------------------------------------

	mov 	x0, 0
	mov 	x1, 0
	bl	m5_dump_stats
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE6:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"
	.section	.note.GNU-stack,"",@progbits

