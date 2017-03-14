UNAWARD         segment para 'CODE'            ; Это так - 
                assume  cs:UNAWARD,ds:UNAWARD  ; полемика...
org 100h

main:
  
  mov  al,01Ch
  call _readcmos
  mov  al,021h ;fake 'nike'
  mov  bl,al

  mov  al,01Dh
  call _readcmos
  xor  ah,ah
  mov  al,024h ;fake 'nike'

  mov  bh,al ; now BX - psw hash

  mov cx,65535
  mov bx,20h

_all_pass:
  inc  bx
  push bx
  push cx
    

  mov  cx,6
  lea  bp,mins
  add  bp,10
_find_minus:  
    mov  dx,word ptr [bp]
    cmp  bx,dx
    ja   _found_minus
    add  bp,-2
  loop _find_minus
_found_minus:
  sub bx,dx

; cx - psw length

_print_psw:
    lea  bp,[step]
    mov  dx,cx
    dec  dx
    shl  dx,1
    add  bp,dx

    push cx
    mov  cx,05Eh 
    _find_step:
      mov  ax,word ptr [bp]
      mul  cx
      mov  tempword,ax
      mov  tempword+2,dx
      cmp  tempword,bx
      jbe  _found_step
    loop _find_step     
_found_step:
    mov  ax,word ptr [bp]
    mul  cx
    mov  tempword,ax
    mov  tempword+2,dx
    sub  bx,tempword
    add  cx,020h
    mov  byte ptr printch,cl
    mov  dx,offset printch
    mov  ah,09h
    int  21h           ; Выводим текст.

    pop  cx

  loop _print_psw  

  mov  dx,offset newline
  mov  ah,09h
  int  21h           ; переводим строчку
  pop  cx
  pop  bx

  loop _all_pass

ret



_readcmos:
  out 70h,al
  nop
  nop
  nop
  in  al,71h
ret

mins dw 32,160,672,2720,10912,43680
step dw  1,  4, 16,  64,  256, 1024
psw  db 8 dup(' '), 0Dh, 0Ah, '$'
newline db 0Dh, 0Ah, '$'
printch db ' ', '$'
tempword dw 0

UNAWARD         ends
                end     main
