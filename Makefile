CC?          ?= clang
RUSTC        ?= rustc
STRIP         = strip
OPTLVL       ?= 3
CFLAGS        = -O$(OPTLVL)
ifneq ($(shell uname -s),Darwin)
CLIBS         = -lm -lrt -ldl -lpthread
endif
RUSTFLAGS    ?= -C opt-level=$(OPTLVL)
EXECUTABLE    = chello
RUST_SOURCES  = $(shell find . -type f -iname "*.rs" -print)
RUST_LIBS     = $(RUST_SOURCES:%.rs=%.a)

all: $(RUST_LIBS) $(EXECUTABLE) list run

$(EXECUTABLE): %: %.c
	$(CC) $@.c \
		$(CFLAGS) \
		-L. $(RUST_LIBS:lib%.a=-l%) \
		$(CLIBS) \
		-o $@ && \
	$(STRIP) $@

$(RUST_LIBS): %.a: %.rs
	$(RUSTC) $(RUSTFLAGS) -o $@ $<

list:
	@ls -ahlF $(EXECUTABLE) $(RUST_LIBS)

run:
	./$(EXECUTABLE)

clean:
	rm -rf $(EXECUTABLE) $(RUST_LIBS)

.PHONY: all clean list run
