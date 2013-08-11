.globl core_arrayAllocate
.globl core_arraySetattr
.globl core_arrayGetattr

core_arrayAllocate:
  pntr .req r0
  size .req r1

  str size,[pntr]
  mv r2,#1

  loopi$:
    str #0,[pntr,r2]
    add r2,#1
    cmp r2,size
    beq next$
    b loopi$
  next$:
  .unreq pntr
  .unreq size
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
  sourcepntr .req r3
  push {r4,r5,lr}  

  cmp endindex,[pntr]
  blls setslice
  .unreq pntr
  .unreq startrindex
  .unreq endindex
  .unreq sourcepntr
  pop {r4,r5,pc}

setslice:
  currentindex .req r5
  mov currentindex,#1
  loopi$:
    ldr r4,[sourcepntr,currentindex]
    str r4,[pntr,startindex]
    add startindex,#1
    add currentindex,#1
    cmp startindex,endindex
    beq next$
    b loopi$
  next$:
  mov pc,lr

core_arrayGetslice:
  pntr .req r0
  startindex .req r1
  endindex .req r2
  resultpntr .req r3
  push {r4,r5,lr}

  cmp endindex,[pntr]
  blls getslice
  .unreq pntr
  .unreq startrindex
  .unreq endindex
  .unreq resultpntr
  pop {r4,r5,pc}

getslice:
  mov r4,pntr
  mov r5,startindex
  mov r0,resultpntr
  mov r1,endindex
  sub r1,r5
  bl core_arrayAllocate
  mov pntr,r4
  mov startindex,r5
  currentindex .req r5
  mov currentindex,#1
  loopi$:
    ldr r4,[pntr,startindex]
    str r4,[resultpntr,currentindex]
    add startindex,#1
    add currentindex,#1
    cmp startindex,endindex
    beq next$
    b loopi$
  next$:
  mov pc,lr
