; src/auxiliary/queue/structs.inc

struc Node
    .data    resq 1    ; 8 byte: stored integer
    .next    resq 1    ; 8 byte: pointer to the next Node
endstruc

%define NODE_DATA Node.data
%define NODE_NEXT Node.next
%define NODE_SIZE 16  ; Size of the Node structure (8 bytes for data + 8 bytes for next pointer)

struc Queue
    .front   resq 1    ; 8 byte: pointer to the front Node
    .rear    resq 1    ; 8 byte: pointer to the rear Node
    .count   resq 1    ; 8 byte: count of elements in the Queue
endstruc

%define QUEUE_FRONT Queue.front
%define QUEUE_REAR  Queue.rear
%define QUEUE_COUNT Queue.count
%define QUEUE_SIZE  24  ; Size of the Queue structure (8 bytes for front
                        ;                            + 8 bytes for rear
                        ;                            + 8 bytes for count)
