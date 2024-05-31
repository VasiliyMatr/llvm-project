	.text
	.file	"top"
	.globl	_start                          ; -- Begin function _start
	.type	_start,@function
_start:                                 ; @_start
; %bb.0:
	ADDi r1 r1 -4
	STi r0 r1 0                             ; 4-byte Folded Spill
	BL r0 app
	LDi r0 r1 0                             ; 4-byte Folded Reload
	ADDi r1 r1 4
	BR r0
.Lfunc_end0:
	.size	_start, .Lfunc_end0-_start
                                        ; -- End function
	.globl	complMulRe                      ; -- Begin function complMulRe
	.type	complMulRe,@function
complMulRe:                             ; @complMulRe
; %bb.0:
	ADDi r1 r1 -16
	STi r9 r1 8
	STi r8 r1 12
	STi r10 r1 4
	STi r11 r1 0
	LDi r2 r1 0
	LDi r8 r1 8
	MUL_FIXED r2 r8, r2
	LDi r8 r1 4
	LDi r9 r1 12
	MUL_FIXED r8 r9, r8
	SUB r15 r8 r2
	ADDi r1 r1 16
	BR r0
.Lfunc_end1:
	.size	complMulRe, .Lfunc_end1-complMulRe
                                        ; -- End function
	.globl	complMulIm                      ; -- Begin function complMulIm
	.type	complMulIm,@function
complMulIm:                             ; @complMulIm
; %bb.0:
	ADDi r1 r1 -16
	STi r9 r1 8
	STi r8 r1 12
	STi r10 r1 4
	STi r11 r1 0
	LDi r2 r1 4
	LDi r8 r1 8
	MUL_FIXED r2 r8, r2
	LDi r8 r1 0
	LDi r9 r1 12
	MUL_FIXED r8 r9, r8
	ADD r15 r8 r2
	ADDi r1 r1 16
	BR r0
.Lfunc_end2:
	.size	complMulIm, .Lfunc_end2-complMulIm
                                        ; -- End function
	.globl	complSq                         ; -- Begin function complSq
	.type	complSq,@function
complSq:                                ; @complSq
; %bb.0:
	ADDi r1 r1 -8
	STi r9 r1 0
	STi r8 r1 4
	LDi r2 r1 0
	MUL_FIXED r2 r2, r2
	LDi r8 r1 4
	MUL_FIXED r8 r8, r8
	ADD r15 r8 r2
	ADDi r1 r1 8
	BR r0
.Lfunc_end3:
	.size	complSq, .Lfunc_end3-complSq
                                        ; -- End function
	.globl	calcMandIterRe                  ; -- Begin function calcMandIterRe
	.type	calcMandIterRe,@function
calcMandIterRe:                         ; @calcMandIterRe
; %bb.0:
	ADDi r1 r1 -20
	STi r0 r1 16                            ; 4-byte Folded Spill
	STi r9 r1 8
	STi r8 r1 12
	STi r10 r1 4
	STi r11 r1 0
	LDi r9 r1 8
	LDi r8 r1 12
	ADDi r10 r8 0
	ADDi r11 r9 0
	BL r0 complMulRe
	LDi r2 r1 4
	ADD r15 r15 r2
	LDi r0 r1 16                            ; 4-byte Folded Reload
	ADDi r1 r1 20
	BR r0
.Lfunc_end4:
	.size	calcMandIterRe, .Lfunc_end4-calcMandIterRe
                                        ; -- End function
	.globl	calcMandIterIm                  ; -- Begin function calcMandIterIm
	.type	calcMandIterIm,@function
calcMandIterIm:                         ; @calcMandIterIm
; %bb.0:
	ADDi r1 r1 -20
	STi r0 r1 16                            ; 4-byte Folded Spill
	STi r9 r1 8
	STi r8 r1 12
	STi r10 r1 4
	STi r11 r1 0
	LDi r9 r1 8
	LDi r8 r1 12
	ADDi r10 r8 0
	ADDi r11 r9 0
	BL r0 complMulIm
	LDi r2 r1 0
	ADD r15 r15 r2
	LDi r0 r1 16                            ; 4-byte Folded Reload
	ADDi r1 r1 20
	BR r0
.Lfunc_end5:
	.size	calcMandIterIm, .Lfunc_end5-calcMandIterIm
                                        ; -- End function
	.globl	app                             ; -- Begin function app
	.type	app,@function
app:                                    ; @app
; %bb.0:
	ADDi r1 r1 -96
	STi r0 r1 92                            ; 4-byte Folded Spill
	STi r3 r1 88                            ; 4-byte Folded Spill
	STi r4 r1 84                            ; 4-byte Folded Spill
	STi r5 r1 80                            ; 4-byte Folded Spill
	STi r6 r1 76                            ; 4-byte Folded Spill
	STi r7 r1 72                            ; 4-byte Folded Spill
	WINDOW_CREATE
	MOVli r2 20
	STi r2 r1 68
	MOVli r2 16874
	STi r2 r1 60
	MOVhi r2 65535
	ORi r2 r2 17911
	STi r2 r1 64
	MOVli r4 0
	MOVli r6 399
	MOVli r5 1
	MOVhi r3 4
	MOVli r7 256
.LBB6_1:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB6_2 Depth 2
                                        ;       Child Loop BB6_4 Depth 3
                                        ;         Child Loop BB6_6 Depth 4
                                        ;           Child Loop BB6_8 Depth 5
	MOVhi r2 3
	STi r2 r1 52
	STi r2 r1 56
	STi r4 r1 48
	B .LBB6_2
.LBB6_13:                               ;   in Loop: Header=BB6_2 Depth=2
	WINDOW_UPDATE
	LDi r2 r1 48
	ADDi r2 r2 1
	STi r2 r1 48
	LDi r2 r1 56
	MOVhi r8 3
	MUL_FIXED r2 r2, r8
	DIV_FIXED r2 r2, r3
	STi r2 r1 56
	MUL_FIXED r2 r2, r8
	DIV_FIXED r2 r2, r3
	STi r2 r1 52
.LBB6_2:                                ;   Parent Loop BB6_1 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB6_4 Depth 3
                                        ;         Child Loop BB6_6 Depth 4
                                        ;           Child Loop BB6_8 Depth 5
	LDi r2 r1 48
	LDi r8 r1 68
	B.LE r8 r2 .LBB6_1
; %bb.3:                                ;   in Loop: Header=BB6_2 Depth=2
	STi r4 r1 36
	LDi r2 r1 56
	MOVhi r9 2
	DIV_FIXED r2 r2, r9
	LDi r8 r1 64
	SUB r2 r8 r2
	STi r2 r1 44
	LDi r2 r1 52
	DIV_FIXED r2 r2, r9
	LDi r8 r1 60
	SUB r2 r8 r2
	STi r2 r1 40
	B .LBB6_4
.LBB6_14:                               ;   in Loop: Header=BB6_4 Depth=3
	LDi r2 r1 36
	ADDi r2 r2 1
	STi r2 r1 36
.LBB6_4:                                ;   Parent Loop BB6_1 Depth=1
                                        ;     Parent Loop BB6_2 Depth=2
                                        ; =>    This Loop Header: Depth=3
                                        ;         Child Loop BB6_6 Depth 4
                                        ;           Child Loop BB6_8 Depth 5
	LDi r2 r1 36
	B.GT r2 r6 .LBB6_13
; %bb.5:                                ;   in Loop: Header=BB6_4 Depth=3
	STi r4 r1 28
	LDi r2 r1 36
	SHL r2 r2 16
	LDi r8 r1 56
	MUL_FIXED r2 r2, r8
	MOVhi r8 400
	DIV_FIXED r2 r2, r8
	LDi r8 r1 44
	ADD r2 r2 r8
	STi r2 r1 32
	B .LBB6_6
.LBB6_15:                               ;   in Loop: Header=BB6_6 Depth=4
	LDi r2 r1 12
	LDi r8 r1 28
	LDi r9 r1 36
	WINDOW_SET_PIXEL r9 r8 r2
	LDi r2 r1 28
	ADDi r2 r2 1
	STi r2 r1 28
.LBB6_6:                                ;   Parent Loop BB6_1 Depth=1
                                        ;     Parent Loop BB6_2 Depth=2
                                        ;       Parent Loop BB6_4 Depth=3
                                        ; =>      This Loop Header: Depth=4
                                        ;           Child Loop BB6_8 Depth 5
	LDi r2 r1 28
	B.GT r2 r6 .LBB6_14
; %bb.7:                                ;   in Loop: Header=BB6_6 Depth=4
	STi r4 r1 20
	STi r4 r1 16
	STi r4 r1 12
	STi r5 r1 8
	LDi r2 r1 28
	SHL r2 r2 16
	LDi r8 r1 52
	MUL_FIXED r2 r2, r8
	MOVhi r8 400
	DIV_FIXED r2 r2, r8
	LDi r8 r1 40
	ADD r2 r2 r8
	STi r2 r1 24
.LBB6_8:                                ;   Parent Loop BB6_1 Depth=1
                                        ;     Parent Loop BB6_2 Depth=2
                                        ;       Parent Loop BB6_4 Depth=3
                                        ;         Parent Loop BB6_6 Depth=4
                                        ; =>        This Inner Loop Header: Depth=5
	LDi r2 r1 8
	B.NE r2 r5 .LBB6_15
; %bb.9:                                ;   in Loop: Header=BB6_8 Depth=5
	LDi r9 r1 16
	LDi r8 r1 20
	BL r0 complSq
	B.LE r15 r3 .LBB6_11
; %bb.10:                               ;   in Loop: Header=BB6_8 Depth=5
	STi r4 r1 8
.LBB6_11:                               ;   in Loop: Header=BB6_8 Depth=5
	LDi r11 r1 24
	LDi r10 r1 32
	LDi r9 r1 16
	LDi r8 r1 20
	BL r0 calcMandIterRe
	STi r15 r1 4
	LDi r8 r1 20
	LDi r9 r1 16
	LDi r10 r1 32
	LDi r11 r1 24
	BL r0 calcMandIterIm
	STi r15 r1 0
	STi r15 r1 16
	LDi r2 r1 4
	STi r2 r1 20
	LDi r2 r1 12
	ADDi r2 r2 1
	STi r2 r1 12
	B.GT r7 r2 .LBB6_8
; %bb.12:                               ;   in Loop: Header=BB6_8 Depth=5
	STi r4 r1 8
	B .LBB6_8
.Lfunc_end6:
	.size	app, .Lfunc_end6-app
                                        ; -- End function
	.section	".note.GNU-stack","",@progbits
