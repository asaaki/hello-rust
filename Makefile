CC?                 ?= clang
RUSTC               ?= rustc
ifneq ($(shell uname -s),Darwin)
C_LIBS               = -lm -lrt -ldl -lpthread
endif
EXECUTABLE           = chello
C_SRC_DIR            = c_src
RUST_ENV            ?= debug
ifeq ($(RUST_ENV),release)
CARGO_ENV_FLAG       = --release
endif
RUST_LIB_FILE        = libhello.a
RUST_LIB_TARGET_DIR  = target
RUST_LIB_DIR         = $(RUST_LIB_TARGET_DIR)/$(RUST_ENV)
RUST_LIB             = $(RUST_LIB_DIR)/$(RUST_LIB_FILE)
RUST_LIB_LINK        = $(RUST_LIB_FILE:lib%.a=-l%)
RUST_SRC_DIR         = src
RUST_LIB_HEADER_DIR  = $(RUST_SRC_DIR)/include

all: rustlib $(EXECUTABLE)

release:
	@$(MAKE) RUST_ENV=release

$(EXECUTABLE): %: $(C_SRC_DIR)/%.c rustlib
	$(CC) $(C_SRC_DIR)/$@.c \
		-I $(RUST_LIB_HEADER_DIR) \
		-L $(RUST_LIB_DIR) $(RUST_LIB_LINK) $(C_LIBS) \
		-o $@

rustlib: $(RUST_LIB)

$(RUST_LIB): FORCE
	cargo build $(CARGO_ENV_FLAG)

run:
	./$(EXECUTABLE)

clean:
	rm -rf $(EXECUTABLE) $(RUST_LIB_TARGET_DIR)

FORCE:

.PHONY: all clean list run
