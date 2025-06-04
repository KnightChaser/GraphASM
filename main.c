#include <stdio.h>
#include <stdlib.h>

// == Assembly-implemented routines ==
// 1) Stack
typedef struct Stack Stack;
extern Stack *stack_create(void);
extern void stack_push(Stack *s, int64_t value);
extern int64_t stack_pop(Stack *s);
extern int64_t stack_peek(Stack *s);
extern long stack_count(Stack *s);
extern int stack_is_empty(Stack *s);
extern void stack_print(Stack *s);
extern void stack_destroy(Stack *s);

// 2) Queue
typedef struct Queue Queue;
extern Queue *queue_create(void);
extern void queue_enqueue(Queue *q, int64_t value);
extern int64_t queue_dequeue(Queue *q);
extern int64_t queue_peek(Queue *q);
extern long queue_count(Queue *q);
extern int queue_is_empty(Queue *q);
extern void queue_print(Queue *q);
extern void queue_destroy(Queue *q);

int main(int argc, char *argv[]) {
    printf("Hello, World!\n");
    return EXIT_SUCCESS;
}
