; src/auxiliary/queue/queue_enqueue.asm
%include "src/auxiliary/queue/structs.inc"

extern malloc
extern exit

global queue_enqueue

section .text
;------------------------------------------------------------------------------
; void queue_enqueue(Queue *q, int64_t value)
;  – allocates a Node, sets data & next, links into q
; Args:
;  RDI = pointer to Queue
;  RSI = value to enqueue
;------------------------------------------------------------------------------
queue_enqueue:
    push    rbp
    mov     rbp, rsp
    push    rbx       ; Save rbx, which will be used for the queue pointer
    mov     rbx, rdi  ; rbx <- q* (queue pointer)
    mov     rdx, rsi  ; rdx <- value

    mov     rdx, rsi  ; rdx = value
    push    rdx       ; Save value on stack because malloc() modifies rdx

    ; malloc a new node
    mov     rdi, NODE_SIZE
    call    malloc
    test    rax, rax
    je      .oom
    pop     rdx       ; Restore value from stack

    ; init node: data = value, next = 0 (NULL)
    mov     [rax + NODE_DATA], rdx          ; Set node data
    mov     qword [rax + NODE_NEXT], 0      ; Set next pointer to NULL

    ; link into the queue
    mov     rcx, [rbx + QUEUE_REAR]   ; rcx <- q->rear (current rear node)
    test    rcx, rcx
    jz      .was_empty

    ; non-empty queue, link new node
    mov     [rcx + NODE_NEXT], rax    ; current rear's next <- new node
    jmp     .set_rear

.was_empty:
    ; empty queue, set front to new node
    mov     [rbx + QUEUE_FRONT], rax  ; q->front <- new node

.set_rear:
    ; set rear to new node
    mov     [rbx + QUEUE_REAR], rax   ; q->rear <- new node

    ; increment count
    inc     qword [rbx + QUEUE_COUNT] ; q->count++

    pop     rbx       ; Restore rbx
    pop     rbp       ; Restore rbp
    ret

.oom:
    ; If malloc failed, exit with status 1
    mov     rdi, 1
    call    exit
