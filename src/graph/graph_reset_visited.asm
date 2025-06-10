; src/graph/grpah_reset_visited.asm

%include "src/graph/structs.inc"

extern exit

global graph_reset_visited

section .text
;------------------------------------------------------------------------------
; void graph_reset_visited(Graph *g)
;  - Sets all vertices as not visited (false)
;  - If a specific graph traversal algorithm runs,
;    they interact with the visited state of vertices.
;    Thus, before a new traversal, this function should be called
;    for the correct algorithm behavior.
; Args:
;  - RDI = Graph* pointer
;------------------------------------------------------------------------------
graph_reset_visited:
    push    rbp
    mov     rbp, rsp
    push    rbx
    push    rcx

    mov     rbx, rdi          ; rbx = Graph* g
    xor     rcx, rcx          ; rcx = i = 0 (loop index)

.reset_loop:
    cmp     rcx, [rbx + GRAPH_NUM_VERTICES]
    jge     .done
    mov     byte [rbx + GRAPH_VISITED + rcx], 0 ; mark vertex as not visited
    inc     rcx
    jmp     .reset_loop
.done:
    pop     rcx
    pop     rbx
    pop     rbp
    ret
