# evenmoreutils
General unix tools

- peeif - Pipe STDIN to any number of commands, but only if the exit status of
  the previous command was zero.  Behavior can also be inverted to "peeuntil".

- poptail - Print and remove the last lines (or bytes) from a file.  This is
  done without reading the whole file and without copying. Can be used with
  `parallel` to batch process the lines of a file.
