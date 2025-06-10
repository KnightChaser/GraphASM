#include <stdbool.h>
#include <stdint.h>
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

// 3) Graph
typedef struct Graph Graph;
extern void graph_add_edge(Graph *g, int64_t src, int64_t dest);
extern int64_t graph_bfs(Graph *g, int64_t startVertex);
extern Graph *graph_create(int64_t numVertices);
extern void graph_print(Graph *g);
extern int64_t graph_remove_edge(Graph *g, int64_t src, int64_t dest);

int main(int argc, char *argv[]) {
    // Create the graph
    int numVertices = 10;
    Graph *g = graph_create(numVertices);
    if (!g) {
        fprintf(stderr, "Failed to create graph\n");
        return EXIT_FAILURE;
    }
    printf("Graph with %ld vertices created at %p\n",
           (long)*(int64_t *)((char *)g), // graph.numVertices RESB 1
           g);
    /*
    0 - 1 - 2
    |   |
    3 - 4
        |
        5
    */
    graph_add_edge(g, 0, 1);
    graph_add_edge(g, 0, 3);
    graph_add_edge(g, 1, 2);
    graph_add_edge(g, 1, 4);
    graph_add_edge(g, 3, 4);
    graph_add_edge(g, 4, 5);
    bool ok = graph_remove_edge(g, 0, 3);
    printf("Edge (0, 3) removed: %s\n", ok ? "true" : "false");
    graph_add_edge(g, 0, 3);
    printf("Edge (0, 3) added back\n");

    printf("\n");
    graph_bfs(g, 0);

    printf("\n");
    graph_print(g);

    return EXIT_SUCCESS;
}
