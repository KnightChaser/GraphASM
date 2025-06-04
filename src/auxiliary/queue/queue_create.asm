; src/auxiliary/queue/queue_create.asm

%include "src/auxiliary/queue/structs.inc"

extern malloc
extern exit

global queue_create

section .text
;------------------------------------------------------------------------------
; Queue *queue_create(void)
;  – allocates a Queue, zeroes its fields
; Returns:
;  RAX = pointer to new Queue, or exits(1) on OOM
;------------------------------------------------------------------------------
queue_create:
    push  rbp
    mov   rbp, rsp

    ; Allocate memory for the Queue structure
    mov   rdi, QUEUE_SIZE
    call  malloc
    test  rax, rax
    je    .oom

    ; zero memory front & rear
    mov   qword [rax + QUEUE_FRONT], 0
    mov   qword [rax + QUEUE_REAR], 0
    mov   qword [rax + QUEUE_COUNT], 0

    pop   rbp
    ret

.oom:
    ; If malloc failed, exit with status 1
    mov   rdi, 1
    call  exit
