import os, atexit, readline

history = os.getenv('HOME') + '/.cache/python_history'

try:
    readline.read_history_file(history)
except IOError:
    pass

atexit.register(readline.write_history_file, history)

del os, atexit, readline, history
