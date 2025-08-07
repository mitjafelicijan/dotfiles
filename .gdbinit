set pagination off
set style enabled on
set breakpoint pending on
set print symbol-filename on
set history save on
set history filename ~/.gdb_history

layout src

define hook-stop
  printf "\n\n\n"
  info locals
  refresh
end
