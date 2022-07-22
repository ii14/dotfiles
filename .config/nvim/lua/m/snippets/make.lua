local snippets = require('m.snippets.util')
local copy = snippets.copy
local snip = snippets.snip
local begins = snippets.begins

local ls = require('luasnip')
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node

ls.add_snippets('make', {

  snip{
    name='CC rule', trig='cc',
    condition = begins'cc',
    i(1), t': ', i(2), t{'', '\t$(CC) $(CFLAGS) -c -o $@ $<'},
  },

  snip{
    name='CXX rule', trig='cxx',
    condition = begins'cxx',
    i(1), t': ', i(2), t{'', '\t$(CXX) $(CXXFLAGS) -c -o $@ $<'},
  },

  snip{
    name='CC template', trig='CC',
    condition = begins'CC',
    t{
      'TARGET   = '}, i(1, 'main'), t{'',
      'SOURCES  = '}, i(2, 'main.c'), t{'',
      'CFLAGS   = -std=c99 -Wall -Wextra -pedantic -g',
      'INCLUDE  =',
      'LDFLAGS  =',
      '',
      'OBJS     = $(addprefix build/,$(SOURCES:.c=.o))',
      'DEPS     = $(OBJS:.o=.d)',
      '',
      'all: $(TARGET)',
      '',
      'build/%.o: %.c',
      '\t@mkdir -p $(@D)',
      '\t$(CC) $(CFLAGS) $(INCLUDE) -c -MMD -o $@ $<',
      '',
      '$(TARGET): $(OBJS)',
      '\t@mkdir -p $(@D)',
      '\t$(CC) $(CFLAGS) -o $(TARGET) $(OBJS) $(LDFLAGS)',
      '',
      '-include $(DEPS)',
      '',
      'compile_commands.json: Makefile',
      '\tcompiledb -n make',
      '',
      '.PHONY: all clean info',
      '',
      'clean:',
      '\t@rm -rvf $(TARGET) $(OBJS) $(DEPS)',
      '',
      'info:',
      '\t@echo "[*] Target:       $(TARGET)"',
      '\t@echo "[*] Sources:      $(SOURCES)"',
      '\t@echo "[*] Objects:      $(OBJS)"',
      '\t@echo "[*] Dependencies: $(DEPS)"',
    },
  },

  snip{
    name='CXX template', trig='CXX',
    condition = begins'CXX',
    t{
      'TARGET   = '}, i(1, 'main'), t{'',
      'SOURCES  = '}, i(2, 'main.cpp'), t{'',
      'CXXFLAGS = -std=c++17 -Wall -Wextra -g',
      'INCLUDE  =',
      'LDFLAGS  =',
      '',
      'OBJS     = $(addprefix build/,$(SOURCES:.cpp=.o))',
      'DEPS     = $(OBJS:.o=.d)',
      '',
      'all: $(TARGET)',
      '',
      'build/%.o: %.cpp',
      '\t@mkdir -p $(@D)',
      '\t$(CXX) $(CXXFLAGS) $(INCLUDE) -c -MMD -o $@ $<',
      '',
      '$(TARGET): $(OBJS)',
      '\t@mkdir -p $(@D)',
      '\t$(CXX) $(CXXFLAGS) -o $(TARGET) $(OBJS) $(LDFLAGS)',
      '',
      '-include $(DEPS)',
      '',
      'compile_commands.json: Makefile',
      '\tcompiledb -n make',
      '',
      '.PHONY: all clean info',
      '',
      'clean:',
      '\t@rm -rvf $(TARGET) $(OBJS) $(DEPS)',
      '',
      'info:',
      '\t@echo "[*] Target:       $(TARGET)"',
      '\t@echo "[*] Sources:      $(SOURCES)"',
      '\t@echo "[*] Objects:      $(OBJS)"',
      '\t@echo "[*] Dependencies: $(DEPS)"',
    },
  },

})
