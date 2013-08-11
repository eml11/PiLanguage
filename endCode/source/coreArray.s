.globl core_arrayAllocate
.globl core_arraySetattr
.globl core_arrayGetattr

core_arrayAllocate:
  pntr .req r0
  size .req r1
  NUL .req r4

  str size,[pntr,#0]
  mv r2,#1

  loopi$:
    str NUL,[pntr,r2]
    add r2,#1
    cmp r2,size
    beq next$
    b loopi$
  next$:
  .unreq pntr
  .unreq size
  .unreq NUL
  mov pc,lr

core_arraySetattr:
  pntr .req r0
  index .req r1
  value .req r2

  cmp index,[pntr]
  strls value,[pntr,index]
  .unreq pntr
  .unreq index
  .unreq value
  mov pc,lr

core_arrayGetattr:
  pntr .req r0
  index .req r1
  result .req r2

  cmp index,[pntr]
  ldrls result,[pntr,index]
  .unreq pntr
  .unreq index
  .unreq result
  mov pc,lr

core_arraySetslice:
  pntr .req r0
  startindex .req r1
  endindex .req r2
  mov r3,lr
  str r4,!memory location

  cmp endindex,[pntr]
  blls setslice
  .unreq pntr
  .unreq startrindex
  .unreq endindex
  ldr ,r4 !from memory location
  mov pc,r3

setslice:
  loopi$:
    pop {r4}
    str r4,[pntr,startindex]
    add startindex,#1
    cmp startindex,endindex
    beq next$
    b loopi$
  next$:
  mov pc,lr

core_arrayGetslice:
  pntr .req r0
  startindex .req r1
  endindex .req r2
  mov r3,lr
  str r4,!memory location

  cmp endindex,[pntr]
  blls getslice
  .unreq pntr
  .unreq startrindex
  .unreq endindex
  ldr ,r4 !from memory location
  mov pc,r3

getslice:
  loopi$:
    ldr r4,[pntr,startindex]
    push {r4}
    add startindex,#1
    cmp startindex,endindex
    beq next$
    b loopi$
  next$:
  mov pc,lr
