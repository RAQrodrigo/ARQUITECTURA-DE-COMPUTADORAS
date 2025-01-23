	.data
	N:       .dword 64	
	t_amb:   .dword 25   
	n_iter:  .dword 10    
	fc_x:	 .dword 25
	fc_y: 	 .dword 10
	fc_temp: .dword 100
	
	.bss 
	x: .zero  262144    
	x_temp: .zero  262144    

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

	ldr     x0, N
    	ldr     x1, =x 
    	ldr     x2, =x_temp
    	ldr     x3, n_iter
	ldr     x4, t_amb
	ldr 	x25, fc_x
	ldr	x26, fc_y
	ldr 	x27, fc_temp
	
//---------------------- CODE HERE ------------------------------------
//Código en assembler
	scvtf d27,x27
	scvtf d4,x4		// transformo x4 en fp	
	
	mul x11,x25,x0
	add x11,x11,x26		// fc_x*N + fc_y
	mov x6,#0
	mul x12,x0,x0		// x12 = N*N

//init_array:
//	cmp x6,x12
//	b.ge init
//	add x10,x6,#0		// x10 = i
//	lsl x10,x10,#3		// x10 = i*8
//	add x10,x10,x1		// x10 = x[i]
//	stur d4,[x10,#0]	// x[i] = t_amb
//	add x6,x6,#1
//	b init_array

init:
	add x10,x11,#0
	lsl x10,x10,#3
	add x10,x10,x1
	stur d27,[x10,#0]	// x[fc_x*N + fc_y] = fc_temp

	mov x5,#0		// x5 = k, x3 = n_inter, Empiezo en 1 porque se hace n_inter - 1 veces.
loopK:
	mov x6,#0		// x6 = i = 0, x0 = N, Empiezo en 1 por el motivo anterior.
loopI:
	mov x7,#0		// x7 = j = 0, x0 = N.
loopJ:
				
if_0:				// if((i*N+j) != (fc_x*N+fc_y))
	mul x8,x6,x0		// x8 = i * N
	add x8,x8,x7		// x8 = (i * N) + j
	cmp x8,x11		// ((i * N) + j) != (fc_x*N+fc_y)) 
	b.eq end_sum	
	
	mov x15,#0		
	fmov d9, x15         // Convertir x0 a un valor flotante en d9
			    // sum = 0
				
if_1:				// if (i + 1 < N)
	add x10,x6,#1		// x10 = i + 1
	cmp x10,x0		// x10 >= N ?
	b.ge else1
				// sum = sum + x[(i+1)*N + j];
	mul x10,x10,x0		// x10 = (i+1)*N
	add x10,x10,x7		// x10 = (i+1)*N + j
	lsl x10,x10,#3		// x10 = ((i+1)*N + j)*8
	add x10,x10,x1		// calcula la posición de memoria --> son elementos de 64 bits por ende se multiplica por 8
	ldur d10,[x10,#0]	// d10 = x[(i+1)*N + j] --> utilizo d porque lo que hay dentro es un float
	fadd d9,d9,d10		// d9 = sum + x[(i+1)*N + j];
	b if_2
	
else1:
	fadd d9,d9,d4		// d9 = sum + t_amb
	
				
if_2:				// if(i - 1 >= 0)
	sub x10,x6,#1 		// x10 = i - 1
	cmp x10,#0		
	b.lt else2	
	
	mul x10,x10,x0		// x10 = (i - 1)*N
	add x10,x10,x7		// x10 = (i - 1)*N + j
	lsl x10,x10,#3		// ((i - 1)*N + j)*8
	add x10,x10,x1		// posición de memoria
	ldur d10,[x10,#0]	// d10 = x[(i - 1)*N + j]
	fadd d9,d9,d10		// x9 = sum + x[(i - 1)*N + j]
	b if_3
	
else2:
	fadd d9,d9,d4		// d9 = sum + t_amb
	
if_3:
	add x10,x7,#1		// x10 = j + 1
	cmp x10,x0		
	b.ge else3
	
	mul x10,x6,x0		// (i*N)	
	add x10,x10,x7		// (i*N) + j
	add x10,x10,#1		// (i*N) + j + 1
	lsl x10,x10,#3
	add x10,x10,x1
	ldur d10,[x10,#0]	// d10 = x[(i*N) + j + 1]
	fadd d9,d9,d10		// x9 = sum + x[i*N + j+1]
	b if_4
	
else3:
	fadd d9,d9,d4		// d9 = sum + t_amb
	
if_4:
	sub x10,x7,#1		// x10 = j - 1
	cmp x10,#0
	b.lt else4
	
	mul x10,x6,x0		// (i*N)
	add x10,x10,x7		// (i*N) + j
	sub x10,x10,#1		// (i*N) + j - 1
	lsl x10,x10,#3
	add x10,x10,x1
	ldur d10,[x10,#0]	// x[i*N + j-1]
	fadd d9,d9,d10		// sum + x[i*N + j-1]
	b sum_temp
	
else4:
	fadd d9,d9,d4		// d9 = sum + t_amb
	
sum_temp:
	mul x10,x6,x0		// i*N
	add x10,x10,x7		// i*N+j
	lsl x10,x10,#3
	add x10,x10,x2
	fmov d10, #4.0
	fdiv d9,d9,d10		// sum / 4;
	stur d9,[x10,#0]	// x_temp[i*N+j] = sum / 4
	
	
end_sum:			//for de i y for de j
	add x7,x7,#1
	cmp x7,x0
	b.ne loopJ		//j < N
	add x6,x6,#1
	cmp x6,x0
	b.ne loopI		//i < N

				
for_x:				// for (int i = 0; i < N*N; ++i)
	mov x6,#0		
	mul x12,x0,x0		// x12 = N*N
	
loop_tmp:
	cmp x6,x11		// i != fc_x*N+fc_y
	b.eq not_if
	add x10,x6,#0
	lsl x10,x10,#3
	add x10,x10,x2
	ldur d10,[x10,#0]
	add x10,x6,#0
	lsl x10,x10,#3
	add x10,x10,x1
	stur d10,[x10,#0]	// x[i] = x_tmp[i];
				
not_if:
	add x6,x6,#1		// i++
	cmp x6,x12		
	b.ne loop_tmp		// i != N*N
	
				
last_for:			// for de k
	add x5,x5,#1	
	cmp x5,x3
	b.ne loopK		// x5 < n_inter
		
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
