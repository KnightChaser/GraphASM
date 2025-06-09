; src/graph/graph_add_edge.asm

%include "src/graph/structs.inc"

extern malloc
extern exit

global graph_add_edge

section .text
;------------------------------------------------------------------------------
; void graph_add_edge(Graph *g, int64_t source, int64_t dest)
;   – adds an undirected edge: source→dest and dest→source
; Args:
;   RDI = Graph *g
;   RSI = source vertex (0 ≤ source < MAX_VERTICES)
;   RDX = destination vertex
; Returns: nothing; exits(1) on OOM
;------------------------------------------------------------------------------
graph_add_edge:
    push    rbp
    mov     rbp, rsp
    push    rbx             ; preserve Graph *base
    push    r12             ; preserve source vertex
    push    r13             ; preserve destination vertex

    mov     rbx, rdi        ; rbx <- Graph *g
    mov     r12, rsi        ; r12 <- source vertex
    mov     r13, rdx        ; r13 <- destination vertex

    ; allocate node for source -> dest
    mov     rdi, ADJNODE_SIZE
    call    malloc
    test    rax, rax
    je      .oom

    ; rax = new AdjNode* for source -> dest
    mov     [rax + ADJNODE_VERTEX], r13
    ; link into head of adjList[source]
    mov     rdx, [rbx + GRAPH_ADJ_LISTS + r12 * 8] ; rdx = adjLists[source]
    mov     [rax + ADJNODE_NEXT], rdx              ; set next pointer
    mov     [rbx + GRAPH_ADJ_LISTS + r12 * 8], rax ; adjLists[source] = new node

    ; allocate node for dest -> source (since this graph is undirected)
    mov     rdi, ADJNODE_SIZE
    call    malloc
    test    rax, rax
    je      .oom

    ; rax = new AdjNode* for dest -> source
    mov     [rax + ADJNODE_VERTEX], r12
    ; link into head of adjList[dest]
    mov     rdx, [rbx + GRAPH_ADJ_LISTS + r13 * 8] ; rdx = adjLists[dest]
    mov     [rax + ADJNODE_NEXT], rdx              ; set next pointer
    mov     [rbx + GRAPH_ADJ_LISTS + r13 * 8], rax ; adjLists[dest] = new node

    pop     r13
    pop     r12
    pop     rbx
    pop     rbp
    ret

.oom:
    mov     rdi, 1
    call    exit
