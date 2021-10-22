local snippets = require('m.snippets.util')
local copy = snippets.copy
local snip = snippets.snip

local ls = require('luasnip')
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node

local nl = t{'', ''}

ls.snippets.make = {

  snip{
    name='CC rule', trig='^cc', regTrig=true,
    i(1), t': ', i(2), t{'', '\t$(CC) $(CFLAGS) -c -o $@ $<'},
  },

  snip{
    name='CXX rule', trig='^cxx', regTrig=true,
    i(1), t': ', i(2), t{'', '\t$(CXX) $(CXXFLAGS) -c -o $@ $<'},
  },

  snip{
    name='CC template', trig='^CC', regTrig=true,
    t{
      'TARGET   = '}, i(1, 'main'), t{'',
      'SOURCES  = '}, i(2, 'main.c'), t{'',
      'CFLAGS   = '}, i(3, '-std=c99 -Wall -Wextra -pedantic -g'), t{'',
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
    name='CXX template', trig='^CXX', regTrig=true,
    t{
      'TARGET   = '}, i(1, 'main'), t{'',
      'SOURCES  = '}, i(2, 'main.cpp'), t{'',
      'CXXFLAGS = '}, i(3, '-std=c++17 -Wall -Wextra -g'), t{'',
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

}
