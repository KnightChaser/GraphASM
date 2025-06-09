; src/graph/graph_create.asm

%include "src/graph/structs.inc"

extern malloc
extern exit

global graph_create

section .text
;------------------------------------------------------------------------------
; Graph *graph_create(int64_t vertices)
;   – allocates a Graph struct of fixed size GRAPH_SIZE,
;     - sets numVertices
;     - initializes adjLists[i]=NULL and visited[i]=0
; Args:
;   RDI = number of vertices (int64_t, ≤ MAX_VERTICES)
; Returns:
;   RAX = pointer to new Graph, or exits(1) on OOM
;------------------------------------------------------------------------------
graph_create:
    push    rbp
    mov     rbp, rsp
    push    rbx             ; preserve %rbx, will hold the vertex count
    push    r12             ; preserve %r12, will hold the Graph pointer (Graph *)
 
    mov     rbx, rdi        ; rbx <- number of vertices
    mov     rdi, GRAPH_SIZE
    call    malloc
    test    rax, rax
    je      .oom

    mov     r12, rax        ; r12 <- pointer to new Graph
    mov     [r12 + GRAPH_NUM_VERTICES], rbx

    ; Initialize adjacency list head to NULL
    xor     rcx, rcx

.loop_init_adj:
    cmp     rcx, rbx        ; if i >= numVertices, break
    jge     .init_visited
    ; Compute address = graph_ptr + GRAPH_ADJ_LISTS + i * sizeof(AdjList *) (= 8)
    mov     rax, r12
    add     rax, GRAPH_ADJ_LISTS
    mov     rdx, rcx
    shl     rdx, 3          ; rdx = i * sizeof(AdjList *) (8 bytes)
    add     rax, rdx        ; %rax <- &adjLists[i]
    mov     qword [rax], 0  ; set adjLists[i] = NULL
    inc     rcx
    jmp     .loop_init_adj

.init_visited:
    xor     rcx, rcx        ; %rcx = 0 (loop index i = 0)

.loop_init_visited:
    cmp     rcx, rbx        ; if i >= numVertices, break
    jge     .done_init
    ; Compute address = graph_ptr + GRAPH_VISITED + i
    mov     rax, r12
    add     rax, GRAPH_VISITED
    add     rax, rcx        ; %rax <- &visited[i]
    mov     byte [rax], 0   ; set visited[i] = 0
    inc     rcx
    jmp     .loop_init_visited


.done_init:
    mov     rax, r12        ; return pointer to Graph
    pop     r12             ; restore %r12
    pop     rbx             ; restore %rbx
    pop     rbp
    ret

.oom:
    mov     rdi, 1
    call    exit
