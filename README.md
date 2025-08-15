## `GraphASM` 🌐

> A dynamic adjacency-list (undirected) **graph** implemented in **Assembly** (x86\_64 NASM, System V AMD64 ABI) with a C-based interactive CLI.
> Supports creation, edge insertion/removal, BFS, DFS, and adjacency-list dumps without BS.

### Preview

![image](https://github.com/user-attachments/assets/d200368e-d143-4d86-973d-40eba5934d6b)

### File Structure

```
.
├── Makefile               # build rules (NASM + GCC)
├── main.c                 # interactive CLI in C
├── README.md              # this documentation
└── src
    ├── auxiliary
    │   ├── queue
    │   │   ├── structs.inc       # Queue struct offsets
    │   │   ├── queue_create.asm
    │   │   ├── queue_enqueue.asm
    │   │   ├── queue_dequeue.asm
    │   │   └── queue_utils.asm
    │   └── stack
    │       ├── structs.inc       # Stack struct offsets
    │       ├── stack_create.asm
    │       ├── stack_push.asm
    │       ├── stack_pop.asm
    │       └── stack_utils.asm
    └── graph
        ├── structs.inc              # Graph & AdjNode layouts
        ├── graph_create.asm         # malloc & init Graph
        ├── graph_add_edge.asm       # insert undirected edge
        ├── graph_remove_edge.asm    # remove undirected edge
        ├── graph_reset_visited.asm  # zero out visited[] (internal utility)
        ├── graph_bfs.asm            # BFS traversal
        ├── graph_dfs.asm            # DFS traversal
        └── graph_print.asm          # dump adjacency lists
```

(`/sketch` directory is not included in this project. It's just an example C source code of BFS/DFS algorithms for undirected graphs represented as adjacency lists. I referenced them before digging into the Assembly implementation.)

### Build & Run

```bash
make clean && make
./graphasm
```

### CLI Commands

* `add <u> <v>`      — add undirected edge `u<->v`
* `remove <u> <v>`   — remove undirected edge `u<->v`
* `bfs <start>`      — breadth‐first search from `start`
* `dfs <start>`      — depth‐first search from `start`
* `print`            — print each adjacency list (`[i] -> v1 -> … -> NULL`)
* `help`             — show this help message
* `exit`             — quit the program

### Bounds & Errors

* Vertices are **0 ≤ v < numVertices** (default: 10).
* `add u v`: if either vertex is out of bounds, the operation is a **no-op** (silent).
* `remove u v`: returns a boolean (printed by the CLI). If either vertex is out of bounds, it will return **no** (0).
* `bfs start` / `dfs start`: if `start` is out of bounds, the traversal is a **no-op** (silent).

### License & Contributions

Released under the **MIT License**.
Contributions, issues, and pull requests are welcome! Let’s keep it lean and mean! >_<
