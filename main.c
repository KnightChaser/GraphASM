// main.c

#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Assembly‐implemented routines
typedef struct Graph Graph;
extern Graph *graph_create(int64_t numVertices);
extern void graph_add_edge(Graph *g, int64_t src, int64_t dest);
extern int64_t graph_remove_edge(Graph *g, int64_t src, int64_t dest);
extern void graph_bfs(Graph *g, int64_t startVertex);
extern void graph_dfs(Graph *g, int64_t startVertex);
extern void graph_print(Graph *g);
extern void graph_reset_visited(Graph *g); // our helper to zero visited[]
extern void graph_destroy(Graph *g);

static void help(void) {
    puts("Commands:");
    puts("  add <u> <v>      — add undirected edge u<->v");
    puts("  remove <u> <v>   — remove undirected edge u<->v");
    puts("  bfs <start>      — breadth-first search from start");
    puts("  dfs <start>      — depth-first search from start");
    puts("  print            — dump adjacency lists");
    puts("  help             — show this message");
    puts("  exit             — quit");
}

static inline int in_range(long v, long n) { return (v >= 0 && v < n); }

int main(int argc, char *argv[]) {
    // change as desired
    const int64_t numVertices = 10;
    Graph *g = graph_create(numVertices);
    if (!g) {
        fprintf(stderr, "ERROR: could not create graph\n");
        return EXIT_FAILURE;
    }

    char line[128];
    printf("You can add edges from 0 to %ld.\n", numVertices - 1);
    help();

    while (true) {
        printf("graph> ");
        if (!fgets(line, sizeof line, stdin))
            break;
        line[strcspn(line, "\n")] = '\0';

        if (strncmp(line, "add ", 4) == 0) {
            // Add a new edge to the graph
            int64_t u, v;
            if (sscanf(line + 4, "%ld %ld", &u, &v) == 2) {
                if (!in_range(u, numVertices) || !in_range(v, numVertices)) {
                    puts("error: vertex out of range");
                } else {
                    graph_add_edge(g, u, v);
                    printf("added edge %ld<->%ld\n", u, v);
                }
            } else {
                puts("usage: add <u> <v>");
            }

        } else if (strncmp(line, "remove ", 7) == 0) {
            // Remove an edge from the graph
            int64_t u, v;
            if (sscanf(line + 7, "%ld %ld", &u, &v) == 2) {
                if (!in_range(u, numVertices) || !in_range(v, numVertices)) {
                    puts("removed edge (out of range): no");
                } else {
                    int64_t ok = graph_remove_edge(g, u, v);
                    printf("removed edge %ld<->%ld: %s\n", u, v,
                           ok ? "yes" : "no");
                }
            } else {
                puts("usage: remove <u> <v>");
            }

        } else if (strncmp(line, "bfs ", 4) == 0) {
            // Perform a breadth-first search (BFS) to the graph
            int64_t start;
            if (sscanf(line + 4, "%ld", &start) == 1) {
                if (!in_range(start, numVertices)) {
                    puts("error: start vertex out of range");
                } else {
                    printf("BFS from %ld:\n", start);
                    graph_bfs(g, start);
                }
            } else {
                puts("usage: bfs <start>");
            }

        } else if (strncmp(line, "dfs ", 4) == 0) {
            // Perform a depth-first search (DFS) to the graph
            int64_t start;
            if (sscanf(line + 4, "%ld", &start) == 1) {
                if (!in_range(start, numVertices)) {
                    puts("error: start vertex out of range");
                } else {
                    printf("DFS from %ld:\n", start);
                    graph_dfs(g, start);
                }
            } else {
                puts("usage: dfs <start>");
            }

        } else if (strcmp(line, "print") == 0) {
            // Print the adjacency lists of the graph
            graph_print(g);

        } else if (strcmp(line, "help") == 0) {
            // Show the help message
            help();

        } else if (strcmp(line, "exit") == 0) {
            // Exit the program
            printf("Bye! See you next time! >_<\n");
            break;

        } else if (line[0] != '\0') {
            printf("unknown command: '%s'\n", line);
        }
    }

    graph_destroy(g);
    return EXIT_SUCCESS;
}
