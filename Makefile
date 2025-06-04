# Makefile — build everything under project-root
ASM      := nasm
ASMFLAGS := -f elf64
CC       := gcc
CFLAGS   := -no-pie -fno-pie
LDFLAGS  := -z noexecstack

SRCDIR       := src
QUEUE_DIR    := $(SRCDIR)/auxiliary/queue
STACK_DIR    := $(SRCDIR)/auxiliary/stack
GRAPH_DIR    := $(SRCDIR)/graph
OBJDIR       := build
OBJS         := \
    $(OBJDIR)/main.o \
    $(OBJDIR)/queue_create.o   \
    $(OBJDIR)/queue_dequeue.o  \
    $(OBJDIR)/queue_enqueue.o  \
    $(OBJDIR)/queue_utils.o    \
    $(OBJDIR)/stack_create.o   \
    $(OBJDIR)/stack_pop.o      \
    $(OBJDIR)/stack_push.o     \
    $(OBJDIR)/stack_utils.o

.PHONY: all clean

all: graph

# Ensure build directory exists
$(OBJDIR):
	mkdir -p $@

# Compile C main into build/main.o
$(OBJDIR)/main.o: main.c | $(OBJDIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Assemble Queue modules
$(OBJDIR)/queue_create.o: $(QUEUE_DIR)/queue_create.asm $(QUEUE_DIR)/structs.inc | $(OBJDIR)
	$(ASM) $(ASMFLAGS) $< -o $@
 
$(OBJDIR)/queue_dequeue.o: $(QUEUE_DIR)/queue_dequeue.asm $(QUEUE_DIR)/structs.inc | $(OBJDIR)
	$(ASM) $(ASMFLAGS) $< -o $@
 
$(OBJDIR)/queue_enqueue.o: $(QUEUE_DIR)/queue_enqueue.asm $(QUEUE_DIR)/structs.inc | $(OBJDIR)
	$(ASM) $(ASMFLAGS) $< -o $@
 
$(OBJDIR)/queue_utils.o: $(QUEUE_DIR)/queue_utils.asm $(QUEUE_DIR)/structs.inc | $(OBJDIR)
	$(ASM) $(ASMFLAGS) $< -o $@


# Assemble Stack modules
$(OBJDIR)/stack_create.o: $(STACK_DIR)/stack_create.asm $(STACK_DIR)/structs.inc | $(OBJDIR)
	$(ASM) $(ASMFLAGS) $< -o $@

$(OBJDIR)/stack_pop.o: $(STACK_DIR)/stack_pop.asm $(STACK_DIR)/structs.inc | $(OBJDIR)
	$(ASM) $(ASMFLAGS) $< -o $@

$(OBJDIR)/stack_push.o: $(STACK_DIR)/stack_push.asm $(STACK_DIR)/structs.inc | $(OBJDIR)
	$(ASM) $(ASMFLAGS) $< -o $@

$(OBJDIR)/stack_utils.o: $(STACK_DIR)/stack_utils.asm $(STACK_DIR)/structs.inc | $(OBJDIR)
	$(ASM) $(ASMFLAGS) $< -o $@

# # Assemble Graph modules (BFS/DFS placeholders)
# $(OBJDIR)/graph_bfs.o: $(GRAPH_DIR)/bfs.asm $(GRAPH_DIR)/structs.inc | $(OBJDIR)
# 	$(ASM) $(ASMFLAGS) $< -o $@
# 
# $(OBJDIR)/graph_dfs.o: $(GRAPH_DIR)/dfs.asm $(GRAPH_DIR)/structs.inc | $(OBJDIR)
# 	$(ASM) $(ASMFLAGS) $< -o $@

# Link everything into final binary
graph: $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

clean:
	rm -rf $(OBJDIR) graph

