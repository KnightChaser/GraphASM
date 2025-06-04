; src/auxiliary/stack/stack_push.asm

%include "src/auxiliary/stack/structs.inc"

extern malloc
extern exit

global stack_push

section .text
;------------------------------------------------------------------------------
; void stack_push(Stack *s, int64_t value)
;  – allocates a Node, sets data & next, pushes onto stack
; Args:
;  RDI = pointer to Stack
;  RSI = int64_t value to push
;------------------------------------------------------------------------------
stack_push:
    push    rbp
    mov     rbp, rsp
    push    rbx        ; Save rbx for stack pointer
    mov     rbx, rdi   ; rbx <- s (Stack *)

    ; RSI holds the value;
    mov     rdx, rsi   ; rdx <- value (int64_t)
    push    rdx

    ; malloc a new node
    mov     rdi, NODE_SIZE
    call    malloc
    test    rax, rax
    je      .oom
    pop     rdx        ; Restore value from stack

    ; set up the new node and link it in reverse so stack pop works easily and correctly.
    ;
    ; Example:
    ; stack_push(10) => 10->NULL
    ; stack_push(20) => 20->10->NULL
    ; stack_push(30) => 30->20->10->NULL
    ; stack_push(40) => 40->30->20->10->NULL

    mov     [rax + NODE_DATA], rdx    ; newNode->data = value (int64_t)
    mov     rcx, [rbx + STACK_TOP]    ; rcx <- s->top (Node *)
    mov     [rax + NODE_NEXT], rcx    ; newNode->next = s->top (Previous top node)
    mov     [rbx + STACK_TOP], rax    ; s->top = newNode       (New top node)
    inc     qword [rbx + STACK_COUNT] ; s->size++

    pop     rbx       ; Restore rbx
    pop     rbp
    ret

.oom:
    ; malloc failed -> exit(1)
    mov     rdi, 1
    call    exit
