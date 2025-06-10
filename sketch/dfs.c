// sketch/dfs.c
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#define MAX_VERTICES 100

// Stack structure
typedef struct Stack {
    int items[MAX_VERTICES];
    int top;
} Stack;

Stack *createStack() {
    Stack *stack = malloc(sizeof(Stack));
    if (!stack) {
        fprintf(stderr, "Failed to allocate memory for stack\n");
        exit(EXIT_FAILURE);
    }
    stack->top = -1;
    return stack;
}

bool isStackEmpty(Stack *stack) { return stack->top == -1; }

void stackPush(Stack *stack, int value) {
    if (stack->top >= MAX_VERTICES - 1) {
        fprintf(stderr, "Stack overflow\n");
        return;
    }
    stack->items[++stack->top] = value;
}

int stackPop(Stack *stack) {
    if (isStackEmpty(stack)) {
        fprintf(stderr, "Stack underflow\n");
        return -1; // Indicating an error
    }
    return stack->items[stack->top--];
}

// Node in adjacency list
typedef struct Node {
    int vertex;
    struct Node *next;
} Node;

// Graph structure
typedef struct Graph {
    int numVertices;              // Number of vertices
    Node *adjLists[MAX_VERTICES]; // Array of adjacency lists
    bool visited[MAX_VERTICES];   // Visited flag for each vertex
} Graph;

// Graph utilities
Node *createNode(int v) {
    Node *newNode = malloc(sizeof(Node));
    newNode->vertex = v;
    newNode->next = NULL;
    return newNode;
}

Graph *createGraph(int vertices) {
    Graph *graph = malloc(sizeof(Graph));
    graph->numVertices = vertices;
    for (int i = 0; i < vertices; i++) {
        graph->adjLists[i] = NULL;
        graph->visited[i] = false;
    }
    return graph;
}

void addEdge(Graph *graph, int src, int dest) {
    // src -> dest
    Node *node = createNode(dest);
    node->next = graph->adjLists[src];
    graph->adjLists[src] = node;

    // dest -> src (undirected)
    node = createNode(src);
    node->next = graph->adjLists[dest];
    graph->adjLists[dest] = node;
}

// Remove edge (start, end) from the graph
bool removeDirectedEdge(Graph *graph, int source, int destination) {
    Node **pp = &graph->adjLists[source];
    while (*pp) {
        Node *current = *pp;
        if (current->vertex == destination) {
            *pp = current->next; // Remove the node
            free(current);
            return true;
        } else {
            pp = &current->next; // Move to the next node
        }
    }
    return false; // Edge not found
}

// Remove edge (start, end) from the graph (undirected)
bool removeEdge(Graph *graph, int source, int destination) {
    bool removed = false;
    removed |= removeDirectedEdge(graph, source, destination);
    removed |= removeDirectedEdge(graph, destination, source);
    return removed;
}

// The DFS routine (using stacks)
void dfs(Graph *graph, int startVertex) {
    Stack *s = createStack();
    graph->visited[startVertex] = true;
    stackPush(s, startVertex);

    while (!isStackEmpty(s)) {
        int currentVertex = stackPop(s);
        printf("Visited %d\n", currentVertex);

        // push all unvisited neighbors
        for (Node *current = graph->adjLists[currentVertex]; current != NULL;
             current = current->next) {
            int adjVertex = current->vertex;
            if (!graph->visited[adjVertex]) {
                graph->visited[adjVertex] = true;
                stackPush(s, adjVertex);
            }
        }
    }
    free(s); // Free the stack memory
}

void printGraph(Graph *graph) {
    for (int v = 0; v < graph->numVertices; v++) {
        // Print the list header
        printf("[%d] -> ", v);

        // Walk the adjacency list
        Node *cur = graph->adjLists[v];
        while (cur) {
            printf("%d -> ", cur->vertex);
            cur = cur->next;
        }

        // End with NULL
        printf("NULL\n");
    }
}

int main(int argc, char *argv[]) {
    /*
     Example graph:
     0 - 1 - 2
     |   |
     3 - 4
         |
         5
    */
    Graph *graph = createGraph(6);
    addEdge(graph, 0, 1);
    addEdge(graph, 0, 3);
    addEdge(graph, 1, 2);
    addEdge(graph, 1, 4);
    addEdge(graph, 3, 4);
    addEdge(graph, 4, 5);
    removeEdge(graph, 1, 4);
    addEdge(graph, 4, 1); // Re-add edge to demonstrate undirected nature

    printf("\n");
    dfs(graph, 0); // Start DFS from vertex 0

    printf("\n");
    printGraph(graph); // Print the graph structure
    return 0;
}
