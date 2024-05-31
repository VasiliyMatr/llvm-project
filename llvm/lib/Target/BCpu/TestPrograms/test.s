	.text
	.file	"test.ll"
	.globl	do_math_1                       ; -- Begin function do_math_1
	.type	do_math_1,@function
do_math_1:                              ; @do_math_1
; %bb.0:
	ADDi r1 r1 -16
	STi r8 r1 12
	ADD r2 r8 r9
	STi r9 r1 8
	STi r10 r1 4
	ADD r2 r2 r10
	STi r11 r1 0
	ADD r2 r2 r11
	LDi r8 r1 16
	ADD r2 r2 r8
	LDi r8 r1 20
	ADD r15 r2 r8
	ADDi r1 r1 16
	BR r0
.Lfunc_end0:
	.size	do_math_1, .Lfunc_end0-do_math_1
                                        ; -- End function
	.globl	do_math_2                       ; -- Begin function do_math_2
	.type	do_math_2,@function
do_math_2:                              ; @do_math_2
; %bb.0:
	ADDi r1 r1 -16
	STi r8 r1 12
	STi r9 r1 8
	ADD r2 r8 r9
	STi r10 r1 4
	ADD r2 r2 r10
	STi r11 r1 0
	ADD r2 r2 r11
	LDi r8 r1 16
	ADD r15 r2 r8
	ADDi r1 r1 16
	BR r0
.Lfunc_end1:
	.size	do_math_2, .Lfunc_end1-do_math_2
                                        ; -- End function
	.globl	call_math                       ; -- Begin function call_math
	.type	call_math,@function
call_math:                              ; @call_math
; %bb.0:
	ADDi r1 r1 -16
	STi r0 r1 12                            ; 4-byte Folded Spill
	STi r3 r1 8                             ; 4-byte Folded Spill
	MOVli r2 6
	STi r2 r1 4
	MOVli r2 5
	STi r2 r1 0
	MOVli r8 1
	MOVli r9 2
	MOVli r10 3
	MOVli r11 4
	BL r0 do_math_1
	ADDi r3 r15 0
	MOVli r2 50
	STi r2 r1 0
	MOVli r8 10
	MOVli r9 20
	MOVli r10 30
	MOVli r11 40
	BL r0 do_math_2
	ADD r15 r3 r15
	LDi r3 r1 8                             ; 4-byte Folded Reload
	LDi r0 r1 12                            ; 4-byte Folded Reload
	ADDi r1 r1 16
	BR r0
.Lfunc_end2:
	.size	call_math, .Lfunc_end2-call_math
                                        ; -- End function
	.section	".note.GNU-stack","",@progbits
