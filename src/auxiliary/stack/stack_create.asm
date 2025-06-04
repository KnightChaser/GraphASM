; src/auxiliary/stack/stack_create.asm

%include "src/auxiliary/stack/structs.inc"

extern malloc
extern exit

global stack_create

section .text
;------------------------------------------------------------------------------
; Stack *stack_create(void)
;  – allocates a Stack, zeroes its fields
; Returns:
;  RAX = pointer to new Stack, or exits(1) on OOM
;------------------------------------------------------------------------------
stack_create:
    push    rbp
    mov     rbp, rsp

    ; Allocate memory for the Stack structure
    mov     rdi, STACK_SIZE    ; Size of the Stack structure, not how many elements can be stored
    call    malloc
    test    rax, rax
    je      .oom

    ; zero
    mov    qword [rax + STACK_TOP], 0
    mov    qword [rax + STACK_COUNT], 0

    pop    rbp
    ret

.oom:
    ; malloc failed -> exit(1)
    mov     rdi, 1
    call    exit
