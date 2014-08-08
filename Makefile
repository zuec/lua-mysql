CC := gcc

ifeq ($(release), y)
    CFLAGS := -O2 -DNDEBUG
else
    CFLAGS := -g
endif

CFLAGS := $(CFLAGS) -Wall -Werror -fPIC

LUADIR := $(HOME)/workspace/lua-5.2.3

INCLUDE := -I$(LUADIR)/src
LIBS := -L$(LUADIR)/src -llua -lmysqlclient

TARGET := luamysql luamysql.so

.PHONY: all clean deps

all: deps $(TARGET)

luamysql: luamysql.o host.o
	$(CC) $(CFLAGS) $^ -o $@ $(LIBS)

luamysql.so: luamysql.o
	$(CC) $(CFLAGS) $^ -shared -o $@ $(LIBS)

deps:
	$(MAKE) posix MYCFLAGS="-fPIC -DLUA_USE_DLOPEN" MYLIBS="-ldl -Wl,-E" -C $(LUADIR)

.c.o:
	$(CC) $(CFLAGS) $(INCLUDE) -c $< -o $@

clean:
	$(MAKE) clean -C $(LUADIR)
	rm -f $(TARGET) *.o