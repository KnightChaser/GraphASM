; src/graph/graph_destroy.asm
%include "src/graph/structs.inc"

extern free

global graph_destroy

section .text
;------------------------------------------------------------------------------
; void graph_destroy(Graph *g)
;   – frees all adjacency nodes and then the Graph itself
;   – safe on empty lists
; Args:
;   RDI = Graph* g
;------------------------------------------------------------------------------
graph_destroy:
    push    rbp
    mov     rbp, rsp
    push    rbx             ; preserve %rbx, will hold the Graph pointer
    push    r12             ; preserve %r12, will hold the i (vertex index)
    push    r13             ; preserve %r13, will hold the current adjacency node (AdjNode *)

    mov     rbx, rdi        ; rbx <- Graph pointer (Graph *g)
    xor     r12, r12        ; r12 <- i (vertex index)

.next_vertex:
    cmp     r12, [rbx + GRAPH_NUM_VERTICES]
    jge     .free_graph

    ; r13 = g->adjLists[i]
    mov     r13, [rbx + GRAPH_ADJ_LISTS + r12 * 8]

.free_list:
    test    r13, r13
    jz      .inc_i
    ; keep next, free current
    mov     rdi, r13
    mov     r13, [r13 + ADJNODE_NEXT] ; r13 = next node
    call    free
    jmp     .free_list

.inc_i:
    inc     r12
    jmp     .next_vertex

.free_graph:
    mov     rdi, rbx
    call    free

    pop     r13             ; restore %r13
    pop     r12             ; restore %r12
    pop     rbx             ; restore %rbx
    pop     rbp
    ret
