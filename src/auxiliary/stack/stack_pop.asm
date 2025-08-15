; src/auxiliary/stack/stack_pop.asm

%include "src/auxiliary/stack/structs.inc"

extern free
extern exit

global stack_pop

section .text
;------------------------------------------------------------------------------
; int64_t stack_pop(Stack *s)
;  – pops top node, returns its data, frees the node
; Args:
;   RDI = pointer to Stack
; Returns:
;   RAX = popped int64_t value, or exits(1) on underflow
;------------------------------------------------------------------------------
stack_pop:
    push    rbp
    mov     rbp, rsp
    push    rbx         ; save RBX for stack pointer
    mov     rbx, rdi    ; rbx <- s (Stack *)

    ; load top node pointer
    mov     rax, [rbx + STACK_TOP]
    test    rax, rax
    je      .underflow

    ; pop top node
    mov     rdx, [rax + NODE_DATA]    ; rdx <- (node->data)
    mov     rcx, [rax + NODE_NEXT]    ; rcx <- (node->next)
    mov     [rbx + STACK_TOP], rcx    ; s->top = node->next (Update stack top pointer)
    dec     qword [rbx + STACK_COUNT] ; Decrement stack size
    mov     rdi, rax                  ; rdi <- node pointer (for free)
    push    rdx                       ; Push the popped value onto the stack for return
    call    free                      ; Free the popped node
    pop     rdx                       ; Restore value from stack

    ; return the popped value
    mov     rax, rdx                  ; rax <- popped value
    pop     rbx                       ; restore RBX
    pop     rbp
    ret

.underflow:
    mov     rdi, 1
    call    exit
