// sketch/bfs.c
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#define MAX_VERTICES 100

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

// Queue data structure for BFS
typedef struct Queue {
    int items[MAX_VERTICES];
    int front;
    int rear;
} Queue;

Queue *createQueue() {
    Queue *q = malloc(sizeof(Queue));
    q->front = q->rear = -1;
    return q;
}

bool isQueueEmpty(Queue *q) { return q->front == -1; }

void enqueue(Queue *q, int value) {
    if (q->rear == MAX_VERTICES - 1) {
        fprintf(stderr, "Queue overflow\n");
        return;
    }

    if (isQueueEmpty(q)) {
        q->front = 0;
    }
    q->rear++;
    q->items[q->rear] = value;
}

int dequeue(Queue *q) {
    if (isQueueEmpty(q)) {
        fprintf(stderr, "Queue underflow\n");
        return -1;
    }

    // Such logic is required because the size of the queue is fixed finitely
    int item = q->items[q->front];
    if (q->front >= q->rear) {
        q->front = q->rear = -1; // Reset queue
    } else {
        q->front++;
    }
    return item;
}

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

    // Initialize adjacency lists and visited flags
    for (int i = 0; i < vertices; i++) {
        graph->adjLists[i] = NULL;
        graph->visited[i] = false;
    }
    return graph;
}

// Add edge (start, end) to the graph
void addEdge(Graph *graph, int source, int destination) {
    // Add edge from source to destination
    Node *newNode = createNode(destination);
    newNode->next = graph->adjLists[source];
    graph->adjLists[source] = newNode;

    // Since the graph is undirected, add edge from destination to source
    newNode = createNode(source);
    newNode->next = graph->adjLists[destination];
    graph->adjLists[destination] = newNode;
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

void bfs(Graph *graph, int startVertex) {
    Queue *q = createQueue();
    graph->visited[startVertex] = true;
    enqueue(q, startVertex);

    while (!isQueueEmpty(q)) {
        int currentVertex = dequeue(q);
        printf("Visited %d\n", currentVertex);

        // Traverse the adjacency list of the current vertex
        Node *temp = graph->adjLists[currentVertex];
        while (temp) {
            int adjVertex = temp->vertex;
            if (!graph->visited[adjVertex]) {
                graph->visited[adjVertex] = true;
                enqueue(q, adjVertex);
            }
            temp = temp->next;
        }
    }

    free(q);
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
    bfs(graph, 0); // Start BFS from vertex 0

    printf("\n");
    printGraph(graph);

    return 0;
}
