; src/auxiliary/stack/structs.inc

; A Node: holds a 64-bit integer and a pointer to the next Node
struc Node
    .data    resq 1    ; 8 bytes: stored int64_t
    .next    resq 1    ; 8 bytes: pointer to the next Node
endstruc

%define NODE_DATA   Node.data
%define NODE_NEXT   Node.next
%define NODE_SIZE   16        ; 8 bytes for data + 8 bytes for next pointer

; A Stack: holds a pointer to the top Node and a count of elements
struc Stack
    .top     resq 1    ; 8 bytes: pointer to top Node
    .count   resq 1    ; 8 bytes: number of elements in the stack
endstruc

%define STACK_TOP     Stack.top
%define STACK_COUNT   Stack.count
%define STACK_SIZE    16        ; 8 bytes for top + 8 bytes for count

