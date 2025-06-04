; src/auxiliary/queue/queue_dequeue.asm
%include "src/auxiliary/queue/structs.inc"

extern free
extern exit

global queue_dequeue

section .text
;------------------------------------------------------------------------------
; int64_t queue_dequeue(Queue *q)
;   – removes front node, returns its data, frees node
; Args:
;   RDI = pointer to Queue
; Returns:
;   RAX = dequeued int64 value, or exits(1) on underflow
;------------------------------------------------------------------------------
queue_dequeue:
    push    rbp
    mov     rbp, rsp
    push    rbx
    mov     rbx, rdi ; rbx <- q* (queue pointer)

    ; load front node ptr
    mov     rax, [rbx + QUEUE_FRONT]
    test    rax, rax
    je      .underflow

    ; rax = node*, then extract value from it
    mov     rdx, [rax + NODE_DATA]   ; rdx <- node->data

    ; store the value to the stack for return
    push    rdx

    ; advance front pointer
    mov     rcx, [rax + NODE_NEXT]   ; rcx <- node->next
    mov     [rbx + QUEUE_FRONT], rcx ; q->front <- node->next
    test    rcx, rcx                 ; check if new front is NULL
    jne     .skip_clear_rear


    mov     qword [rbx + QUEUE_REAR], 0 ; if front is NULL, clear rear too

.skip_clear_rear:
    ; decrement count
    dec     qword [rbx + QUEUE_COUNT] ; q->count--

    ; free the node
    mov     rdi, rax                  ; rdi <- node* to free
    call    free

    ; return the dequeued value
    pop     rax                       ; rax <- dequeued value

    pop     rbx                       ; Restore rbx
    pop     rbp
    ret

.underflow:
    mov     edi, 1
    call    exit

