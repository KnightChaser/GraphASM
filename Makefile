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
    $(OBJDIR)/main.o                \
    $(OBJDIR)/queue_create.o        \
    $(OBJDIR)/queue_dequeue.o       \
    $(OBJDIR)/queue_enqueue.o       \
    $(OBJDIR)/queue_utils.o         \
    $(OBJDIR)/stack_create.o        \
    $(OBJDIR)/stack_pop.o           \
    $(OBJDIR)/stack_push.o          \
    $(OBJDIR)/stack_utils.o         \
		$(OBJDIR)/graph_add_edge.o      \
		$(OBJDIR)/graph_bfs.o           \
		$(OBJDIR)/graph_create.o        \
		$(OBJDIR)/graph_destroy.o       \
		$(OBJDIR)/graph_dfs.o           \
		$(OBJDIR)/graph_print.o         \
		$(OBJDIR)/graph_remove_edge.o   \
		$(OBJDIR)/graph_reset_visited.o \


.PHONY: all clean

all: graphasm

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

# Assemble Graph modules
$(OBJDIR)/graph_add_edge.o: $(GRAPH_DIR)/graph_add_edge.asm $(GRAPH_DIR)/structs.inc | $(OBJDIR)
	$(ASM) $(ASMFLAGS) $< -o $@

$(OBJDIR)/graph_bfs.o: $(GRAPH_DIR)/graph_bfs.asm $(GRAPH_DIR)/structs.inc $(QUEUE_DIR)/structs.inc | $(OBJDIR)
	$(ASM) $(ASMFLAGS) $< -o $@

$(OBJDIR)/graph_create.o: $(GRAPH_DIR)/graph_create.asm $(GRAPH_DIR)/structs.inc | $(OBJDIR)
	$(ASM) $(ASMFLAGS) $< -o $@

$(OBJDIR)/graph_destroy.o: $(GRAPH_DIR)/graph_destroy.asm $(GRAPH_DIR)/structs.inc | $(OBJDIR)
	$(ASM) $(ASMFLAGS) $< -o $@

$(OBJDIR)/graph_dfs.o: $(GRAPH_DIR)/graph_dfs.asm $(GRAPH_DIR)/structs.inc $(STACK_DIR)/structs.inc | $(OBJDIR)
	$(ASM) $(ASMFLAGS) $< -o $@

$(OBJDIR)/graph_print.o: $(GRAPH_DIR)/graph_print.asm $(GRAPH_DIR)/structs.inc | $(OBJDIR)
	$(ASM) $(ASMFLAGS) $< -o $@

$(OBJDIR)/graph_remove_edge.o: $(GRAPH_DIR)/graph_remove_edge.asm $(GRAPH_DIR)/structs.inc | $(OBJDIR)
	$(ASM) $(ASMFLAGS) $< -o $@

$(OBJDIR)/graph_reset_visited.o: $(GRAPH_DIR)/graph_reset_visited.asm $(GRAPH_DIR)/structs.inc | $(OBJDIR)
	$(ASM) $(ASMFLAGS) $< -o $@

# Link everything into final binary
graphasm: $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

clean:
	rm -rf $(OBJDIR) graphasm

