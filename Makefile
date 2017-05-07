# NOMAD-Radio makefile
# 27-04-2017
# Peter Blom

CC = gcc 

###
###  CFLAGS
###

#CFLAGS  = -std=c99

###
###  Include paths
###

CFLAGS += -I/usr/include
CFLAGS += -I/usr/local/include

CFLAGS += -Isrc
CFLAGS += -Ibladerf-src
CFLAGS += -Ibladerf-src/common

###
###  Libs
###

LIBS  = -L/usr/local/lib
LIBS += -lm
LIBS += -lpthread
LIBS += -lbladeRF

###
###  Dirs & Files
###

SRCDIR   = src
BLDDIR   = bld

BIN        = USB-Transmitter
ALLTARGETS = $(BIN)

# Grab all source files
SRC_FILES := $(shell find -name '*.c')

ifndef V
  QUIET_CC   = @echo ' CC   ' $<;
  QUIET_LINK = @echo ' LINK ' $@;
  QUIET_TEST = >/dev/null 2>&1
endif

SRC  := $(SRC_FILES)
SRC  := $(sort $(SRC))
OBJ  := $(patsubst %.c,$(BLDDIR)/%.o,$(SRC))
DEPS := $(patsubst %.o,%.d,$(OBJ))

# Create build directories
SRCDIRS := $(dir $(SRC))
SRCDIRS := $(sort $(SRCDIRS))
BLDDIRS := $(addprefix $(BLDDIR)/, $(SRCDIRS))
BLDDIRS := $(sort $(BLDDIRS))
MKBLDDIR = @mkdir -p

#$(info objects: $(OBJ))

###
###  Targets
###
.SECONDEXPANSION:

$(OBJ): $$(subst $(BLDDIR)/,,$$(patsubst %.o,%.c,$$@))
	$(MKBLDDIR) $(BLDDIRS)
	$(QUIET_CC)$(CC) $(CFLAGS) -c $< -o $@

USB-Transmitter: $(OBJ)
	$(QUIET_LINK)$(CC) $(LDOPTS) -o $(BIN) $(OBJ) $(LIBS)
	@echo ' Complete!';

# do not move the following line:
-include $(DEPS)

###
###  Common
###

all: $(ALLTARGETS)

#debug: CFLAGS += -g
#debug: $(ALLTARGETS)

clean:
	rm -f $(ALLTARGETS) *~ gmon*
	rm -rf $(BLDDIR)