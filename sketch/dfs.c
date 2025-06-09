// sketch/dfs.c
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

// The DFS routine
void dfs(Graph *graph, int vertex) {
    graph->visited[vertex] = true;
    printf("Visited %d\n", vertex);
    for (Node *adj = graph->adjLists[vertex]; adj; adj = adj->next) {
        if (!graph->visited[adj->vertex]) {
            dfs(graph, adj->vertex);
        }
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
    Graph *g = createGraph(6);
    addEdge(g, 0, 1);
    addEdge(g, 0, 3);
    addEdge(g, 1, 2);
    addEdge(g, 1, 4);
    addEdge(g, 3, 4);
    addEdge(g, 4, 5);

    dfs(g, 0); // Start DFS from vertex 0
    return 0;
}
