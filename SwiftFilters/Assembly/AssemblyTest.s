//
//  AssemblyTest.s
//  imageFilters
//
//  Created by Lucas Cortes
//  Copyright © 2015. All rights reserved.
//

// p (float __attribute__((ext_vector_type(4)))) $q1
// p/d (unsigned char __attribute__((ext_vector_type(16)))) $q0
// p/x $s0

.globl	_processPixel
.align	2

_processPixel:
	.cfi_startproc

	sub	sp, sp, #16

;    Input registers
;    -----------------------------------
;    x0 Filter Matrix (3x3) pointer
;    x1 currentOriginalPixel pointer
;    x2 currentModifiedPixel
;    s0 factor
;    s1 bias
;    x3 imageWidth
;    x4 iterationAmount
;    x5 bytesPerPixel


    // --- Setup filter matrix registers and initial config ---

    //factor and bias
    dup v30.4s, v0.s[0]
    dup v31.4s, v1.s[0]

    //Filter Matrix
    ldr s0, [x0, #0]
    ldr s1, [x0, #4]
    ldr s2, [x0, #8]
    ldr s3, [x0, #12]
    ldr s4, [x0, #16]
    ldr s5, [x0, #20]
    ldr s6, [x0, #24]
    ldr s7, [x0, #28]
    ldr s8, [x0, #32]

    //propagate first word into every word in the register.
    dup v0.4s, v0.s[0]
    dup v1.4s, v1.s[0]
    dup v2.4s, v2.s[0]
    dup v3.4s, v3.s[0]
    dup v4.4s, v4.s[0]
    dup v5.4s, v5.s[0]
    dup v6.4s, v6.s[0]
    dup v7.4s, v7.s[0]
    dup v8.4s, v8.s[0]


    // --- Start main image loop ---

    mov x6, #0 //x6 -> Counter
    MainLoop:

    //Get pixels into registers
    ldr q9, [x1, #0]
    ldr q10, [x1, x3]
    add x7, x3, x3
    ldr q11, [x1, x7]

    //unpack byte to word

    //1
    eor v12.16b, v12.16b, v12.16b
    mov v12.b[0], v9.b[0]
    mov v12.b[4], v9.b[1]
    mov v12.b[8], v9.b[2]
    mov v12.b[12],v9.b[3]

    //2
    eor v13.16b, v13.16b, v13.16b
    mov v13.b[0], v9.b[4]
    mov v13.b[4], v9.b[5]
    mov v13.b[8], v9.b[6]
    mov v13.b[12],v9.b[7]

    //3
    eor v14.16b, v14.16b, v14.16b
    mov v14.b[0], v9.b[8]
    mov v14.b[4], v9.b[9]
    mov v14.b[8], v9.b[10]
    mov v14.b[12],v9.b[11]

    //4
    eor v15.16b, v15.16b, v15.16b
    mov v15.b[0], v10.b[0]
    mov v15.b[4], v10.b[1]
    mov v15.b[8], v10.b[2]
    mov v15.b[12],v10.b[3]

    //5
    eor v16.16b, v16.16b, v16.16b
    mov v16.b[0], v10.b[4]
    mov v16.b[4], v10.b[5]
    mov v16.b[8], v10.b[6]
    mov v16.b[12],v10.b[7]

    //6
    eor v17.16b, v17.16b, v17.16b
    mov v17.b[0], v10.b[8]
    mov v17.b[4], v10.b[9]
    mov v17.b[8], v10.b[10]
    mov v17.b[12],v10.b[11]

    //7
    eor v18.16b, v18.16b, v18.16b
    mov v18.b[0], v11.b[0]
    mov v18.b[4], v11.b[1]
    mov v18.b[8], v11.b[2]
    mov v18.b[12],v11.b[3]

    //8
    eor v19.16b, v19.16b, v19.16b
    mov v19.b[0], v11.b[4]
    mov v19.b[4], v11.b[5]
    mov v19.b[8], v11.b[6]
    mov v19.b[12],v11.b[7]

    //9
    eor v20.16b, v20.16b, v20.16b
    mov v20.b[0], v11.b[8]
    mov v20.b[4], v11.b[9]
    mov v20.b[8], v11.b[10]
    mov v20.b[12],v11.b[11]

    //Convert to float
    ucvtf v12.4s, v12.4s
    ucvtf v13.4s, v13.4s
    ucvtf v14.4s, v14.4s
    ucvtf v15.4s, v15.4s
    ucvtf v16.4s, v16.4s
    ucvtf v17.4s, v17.4s
    ucvtf v18.4s, v18.4s
    ucvtf v19.4s, v19.4s
    ucvtf v20.4s, v20.4s

    //multiply pixel with matrix element
    fmul v12.4s, v12.4s, v0.4s
    fmul v13.4s, v13.4s, v1.4s
    fmul v14.4s, v14.4s, v2.4s
    fmul v15.4s, v15.4s, v3.4s
    fmul v16.4s, v16.4s, v4.4s
    fmul v17.4s, v17.4s, v5.4s
    fmul v18.4s, v18.4s, v6.4s
    fmul v19.4s, v19.4s, v7.4s
    fmul v20.4s, v20.4s, v8.4s

    //add every component
    fadd v12.4s, v12.4s, v13.4s
    fadd v12.4s, v12.4s, v14.4s
    fadd v12.4s, v12.4s, v15.4s
    fadd v12.4s, v12.4s, v16.4s
    fadd v12.4s, v12.4s, v17.4s
    fadd v12.4s, v12.4s, v18.4s
    fadd v12.4s, v12.4s, v19.4s
    fadd v12.4s, v12.4s, v20.4s // v12 almost final pixel

    //multiply by factor and add bias
    fmul v12.4s, v12.4s, v30.4s
    fadd v12.4s, v12.4s, v31.4s

    //Convert float to uint
    fcvtau v12.4s, v12.4s

    //load 0 and 255 uint constants
    mov w10, #0
    mov w11, #255

    mov v28.s[0], w10 // 0
    mov v29.s[0], w11 // 255

    dup v28.4s, v28.s[0]
    dup v29.4s, v29.s[0]

    //get (min(max(pixel, 0.0), 255.0))
    umax v12.4s, v12.4s, v28.4s
    umin v12.4s, v12.4s, v29.4s

    //pack
    eor v13.16b, v13.16b, v13.16b

    mov v13.b[0], v12.b[0]
    mov v13.b[1], v12.b[4]
    mov v13.b[2], v12.b[8]
    mov v13.b[3], w11 //alpha should be 255

    //Save pixel in new image pointer
    str s13, [x2]

    //Increase pointers
    add x1, x1, x5
    add x2, x2, x5

    //Increment counter and loop
    add x6, x6, #1
    cmp x6, x4
    blt MainLoop

    //Increase stack pointer and return
	add	sp, sp, #16
	ret
	.cfi_endproc
