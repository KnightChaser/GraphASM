; src/graph/graph_print.asm

%include "src/graph/structs.inc"

extern printf

global graph_print

section .rodata
fmt_header:  db "[%ld] -> ", 0
fmt_int:     db "%ld",      0
fmt_sep:     db " -> ",     0
fmt_null:    db "NULL",     0
fmt_nl:      db 10,         0

section .text
;------------------------------------------------------------------------------
; void graph_print(Graph *g)
;   – prints each adjacency list:
;     [i] -> v1 -> v2 -> … -> NULL
; Args:
;   RDI = Graph* pointer
;------------------------------------------------------------------------------
graph_print:
    push    rbp
    mov     rbp, rsp
    push    rbx          ; preserve %rbx, will hold Graph*
    push    r12          ; preserve %r12, will hold the current vertex index
    push    r13          ; preserve %r13, will hold the node cursor

    mov     rbx, rdi     ; rbx = Graph* g
    xor     r12, r12     ; r12 = current vertex index (i)

.print_next_list:
    ; print header "[i] -> "
    lea     rdi, [rel fmt_header]
    mov     rsi, r12
    xor     rax, rax
    call    printf

    ; load head of list: r13 = g->adjLists[i]
    mov     r13, [rbx + GRAPH_ADJ_LISTS + r12 * 8] ; r13 = g->adjLists[i]

.walk_list:
    test    r13, r13
    je      .print_null_and_nl

    ; print the vertex index
    lea     rdi, [rel fmt_int]
    mov     rsi, [r13 + ADJNODE_VERTEX]
    xor     rax, rax
    call    printf
    ; print separator " -> "
    lea     rdi, [rel fmt_sep]
    xor     rax, rax
    call    printf
    ; advance to next node
    mov     r13, [r13 + ADJNODE_NEXT] ; r13 = next node in the list
    jmp     .walk_list

.print_null_and_nl:
    ; print "NULL"
    lea     rdi, [rel fmt_null]
    xor     rax, rax
    call    printf
    ; print newline
    lea     rdi, [rel fmt_nl]
    xor     rax, rax
    call    printf

    ; advance i
    inc     r12
    ; if i < g->numVertices, continue
    cmp     r12, [rbx + GRAPH_NUM_VERTICES]
    jl      .print_next_list

    ; teardown
    pop     r13
    pop     r12
    pop     rbx
    pop     rbp
    ret
