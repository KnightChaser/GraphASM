; src/auxiliary/stack/stack_utils.asm

%include "src/auxiliary/stack/structs.inc"

global stack_peek
global stack_count
global stack_is_empty
global stack_print
global stack_destroy

extern printf
extern free
extern exit

section .rodata
    fmt_int:    db "%ld", 0
    fmt_sep:    db " -> ", 0
    fmt_nl:     db 10, 0

section .text
;------------------------------------------------------------------------------
; int64_t stack_peek(Stack *s)
;   – returns top value without popping, or exits(1) on underflow
; Args:
;   RDI = pointer to Stack
; Returns:
;   RAX = top int64 value
;------------------------------------------------------------------------------
stack_peek:
    push    rbp
    mov     rbp, rsp

    mov     rax, [rdi + STACK_TOP] ; rax <- s->top (Node *)
    test    rax, rax               ; check if stack is empty
    je      .peek_underflow

    mov     rax, [rax + NODE_DATA] ; rax <- s->top->data (int64_t)
    pop     rbp
    ret

.peek_underflow:
    ; stack is empty, exit with error
    mov     rdi, 1                 ; exit code 1
    call    exit

;------------------------------------------------------------------------------
; long stack_count(Stack *s)
;   – returns number of elements in stack
; Args:
;   RDI = pointer to Stack
; Returns:
;   RAX = count
;------------------------------------------------------------------------------
stack_count:
    push    rbp
    mov     rbp, rsp

    mov     rax, [rdi + STACK_COUNT] ; rax <- s->size (long)
    pop     rbp
    ret


;------------------------------------------------------------------------------
; int stack_is_empty(Stack *s)
;   – returns 1 if stack is empty, 0 otherwise
; Args:
;   RDI = pointer to Stack
; Returns:
;   RAX = 1 or 0
;------------------------------------------------------------------------------
stack_is_empty:
    push    rbp
    mov     rbp, rsp

    mov     rax, [rdi + STACK_COUNT] ; rax <- s->size (long)
    test    rax, rax                 ; check if size is 0
    setz    al                       ; set AL to 1 if size is 0, else 0
    movzx   rax, al                  ; zero-extend AL to RAX
    pop     rbp
    ret

;------------------------------------------------------------------------------
; void stack_print(Stack *s)
;   – prints “val_top -> next -> …” then newline
; Args:
;   RDI = pointer to Stack
;------------------------------------------------------------------------------
stack_print:
    push    rbp
    mov     rbp, rsp
    push    rbx                    ; save RBX for stack pointer
    mov     rbx, [rdi + STACK_TOP] ; rbx <- s->top (Node *) (current node pointer)

.print_loop:
    test    rbx, rbx   ; check if stack pointer is NULL
    jz      .print_done

    ; printf("%ld", rbx->data);
    mov     rsi, [rbx + NODE_DATA] ; rsi <- rbx->data (int64_t)
    lea     rdi, [rel fmt_int]
    xor     rax, rax
    call    printf

    ; advance to the next node
    mov     rbx, [rbx + NODE_NEXT] ; rbx <- rbx->next (Node *)
    test    rbx, rbx
    je      .print_done

    ; printf(" -> ");
    lea     rdi, [rel fmt_sep]
    xor     rax, rax
    call    printf

    jmp     .print_loop

.print_done:
    ; final newline
    lea     rdi, [rel fmt_nl]
    xor     rax, rax
    call    printf

    pop     rbx        ; restore RBX
    pop     rbp
    ret

;------------------------------------------------------------------------------
; void stack_destroy(Stack *s)
;  – walks through all nodes, frees each one, then frees the Stack struct
; Args:
;   RDI = pointer to Stack
;------------------------------------------------------------------------------
stack_destroy:
    push    rbp
    mov     rbp, rsp
    push    rbx        ; save RBX for stack pointer
    mov     rbx, rdi   ; rbx <- s (Stack *)

    ; load first node from s->top
    mov     rcx, [rbx + STACK_TOP]

.destroy_loop:
    test    rcx, rcx               ; if rcx == NULL, there is no more nodes to free
    je      .free_stack
    mov     rax, rcx               ; rax <- current node pointer
    mov     rcx, [rax + NODE_NEXT] ; load next node pointer
    mov     rdi, rax               ; rdi <- current node pointer (for free)
    push    rcx                    ; push rcx (next node pointer) onto the stack (caller-saved)
    call    free
    pop     rcx                    ; restore next node pointer from stack
    jmp     .destroy_loop

.free_stack:
    ; free the stack struct itself
    mov     rdi, rbx   ; rdi <- stack pointer (for free)
    call    free

    pop     rbx        ; restore RBX
    pop     rbp
    ret
