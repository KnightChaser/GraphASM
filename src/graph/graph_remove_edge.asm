; src/graph/graph_remove_edge.asm

%include "src/graph/structs.inc"

extern free

global graph_remove_edge

section .text
;------------------------------------------------------------------------------
; int64_t graph_remove_edge(Graph *g, int64_t src, int64_t dest)
;   – removes edges src->dest and dest->src (undirected)
;   – returns 1 if any removal succeeded
;   - returns 0 if any src or dest is out of [0, MAX_VERTICES) (invalid)
; Args:
;   RDI = Graph*      (pointer to Graph)
;   RSI = src index
;   RDX = dest index
; Returns:
;   RAX = 1 (true) if removed at least one, 
;         0 (false) otherwise
;------------------------------------------------------------------------------
graph_remove_edge:
    push    rbp
    mov     rbp, rsp
    push    rbx             ; preserve %rbx, save Graph*
    push    r12             ; preserve %r12, save src
    push    r13             ; preserve %r13, save dest
    mov     rbx, rdi        ; rbx <- Graph*
    mov     r12, rsi        ; r12 <- src index
    mov     r13, rdx        ; r13 <- dest index
    xor     rax, rax        ; rax <- 0 (no edges removed yet)

    mov     rcx, [rbx + GRAPH_NUM_VERTICES] ; rcx = numVertices
    cmp     r12, rcx
    jae     .bad_arg       ; if src >= numVertices, exit(1)
    cmp     r13, rcx
    jae     .bad_arg       ; if dest >= numVertices, exit(1)

    ; helper macro: remomve one direction edge (r12 -> r13) using pptr in %rdx
    %macro REM_DIR 0
        lea    rdx, [rbx + GRAPH_ADJ_LISTS + r12 * 8] ; rdx = &g->adjLists[src]
    %%remove_loop:
        mov    rcx, [rdx]                  ; rcx = *pptr (%rcx works as current node pointer)
        test   rcx, rcx                    ; check if pptr is NULL
        je     %%done
        mov    r10, [rcx + ADJNODE_VERTEX] ; r10 = cur->vertex
        cmp    r10, r13                    ; compare vertex with dest index
        jne    %%next                    ; if not equal, go to next

        ; unlink: *pptr = cur->next then free cur
        mov    r10, [rcx + ADJNODE_NEXT]   ; r10 = cur->next
        mov    [rdx], r10                  ; *pptr = cur->next
        mov    rdi, rcx                    ; rdi = cur (to free)
        call   free
        mov    rax, 1                      ; set rax to 1 (edge removed)
        jmp    %%done
    %%next:
        ; pptr = &cur->next and continue loop
        lea    rdx, [rcx + ADJNODE_NEXT]
        jmp    %%remove_loop
    %%done:
    %endmacro

    ; remove src -> dest
    REM_DIR

    ; swap src/dest and remove dest->src (vice versa)
    xchg    r12, r13
    REM_DIR

    ; restore registers and return
    pop     r13
    pop     r12
    pop     rbx
    pop     rbp
    ret

.bad_arg:
    ; invalid vertex index -> no-op and return 0
    pop     r13
    pop     r12
    pop     rbx
    pop     rbp
    xor     rax, rax  ; rax <- 0 (no edges removed)
    ret
