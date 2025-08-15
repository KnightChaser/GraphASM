; src/auxiliary/queue/queue_utils.asm
%include "src/auxiliary/queue/structs.inc"

global queue_count
global queue_is_empty
global queue_peek
global queue_print
global queue_destroy

extern printf
extern free
extern exit

section .rodata
fmt_int:    db    "%ld", 0     ; Format for printing integers
fmt_sep:    db    " -> ", 0    ; Separator for queue elements
fmt_nl:     db    10 0         ; Newline character

section .text
;------------------------------------------------------------------------------
; long queue_count(Queue *q)
;   – returns q->count
; Args:
;   RDI = pointer to Queue
; Returns:
;   RAX = count
;------------------------------------------------------------------------------
queue_count:
    push    rbp
    mov     rbp, rsp
    mov     rax, [rdi + QUEUE_COUNT]  ; Load the count from the Queue structure
    pop     rbp
    ret

;------------------------------------------------------------------------------
; int queue_is_empty(Queue *q)
;   – returns 1 if empty, 0 otherwise
; Args:
;   RDI = pointer to Queue
; Returns:
;   RAX = 1 or 0
;------------------------------------------------------------------------------
queue_is_empty:
    push    rbp
    mov     rbp, rsp
    mov     rax, [rdi + QUEUE_COUNT]
    test    rax, rax                ; Check if count is zero
    setz    al                      ; Set AL to 1 if zero, 0 otherwise
    movzx   rax, al                 ; Zero-extend AL to RAX
    pop     rbp
    ret

;------------------------------------------------------------------------------
;int64_t queue_peek(Queue *q)
;    – returns the value at the front without removing it
; Args:
;   RDI = pointer to Queue
; Returns:
;   RAX = value at the front, or exits(1) on underflow
;------------------------------------------------------------------------------
queue_peek:
    push    rbp
    mov     rbp, rsp

    mov     rax, [rdi + QUEUE_FRONT]
    test    rax, rax
    je      .underflow

    mov     rax, [rax + NODE_DATA]   ; Load the data from the front node
    pop     rbp
    ret

.underflow:
    mov     edi, 1
    call    exit


;------------------------------------------------------------------------------
; void queue_print(Queue *q)
;   – prints “val1 -> val2 -> …” then newline
;   RDI = pointer to Queue
;------------------------------------------------------------------------------
queue_print:
    push    rbp
    mov     rbp, rsp
    push    rbx       ; Save rbx for use in the loop

    ; start pointer at front
    mov     rbx, [rdi + QUEUE_FRONT]

.print_loop:
    test    rbx, rbx
    jz      .print_done   ; If rbx is NULL, there is no more node to print

    ; printf("%ld", rbx->data);
    mov     rsi, [rbx + NODE_DATA]
    lea     rdi, [rel fmt_int]
    xor     rax, rax
    call    printf

    ; advance
    mov     rbx, [rbx + NODE_NEXT]
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

    pop     rbx       ; Restore rbx
    pop     rbp
    ret

;------------------------------------------------------------------------------
; void queue_destroy(Queue *q)
;   – frees every Node in the queue, then frees the Queue struct
;   RDI = pointer to Queue
;------------------------------------------------------------------------------
queue_destroy:
    push    rbp
    mov     rbp, rsp
    push    rbx            ; save RBX
    mov     rbx, rdi       ; RBX ← Queue* (save original pointer)

    ; walk & free all nodes
    mov     rcx, [rbx + QUEUE_FRONT]  ; RCX = current node
.destroy_loop:
    test    rcx, rcx
    je      .free_queue
    mov     rax, rcx                  ; RAX = node to free
    mov     rcx, [rax + NODE_NEXT]    ; RCX = next node
    push    rcx                       ; Save next node on stack (caller-saved)
    mov     rdi, rax                  ; RDI = node
    call    free
    pop     rcx                       ; Restore next node
    jmp     .destroy_loop

.free_queue:
    mov     rdi, rbx       ; RDI = original Queue*
    call    free           ; free the Queue struct

    pop     rbx            ; restore RBX
    pop     rbp
    ret

