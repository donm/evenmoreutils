# evenmoreutils
General unix tools

- peeif - Pipe STDIN to any number of commands, but only if the exit status of
  the previous command was zero.  Behavior can also be inverted to "peeuntil".

- poptail - Print and remove the last lines (or bytes) from a file.  This is
  done without reading the whole file and without copying. Can be used with
  `parallel` to batch process the lines of a file.

## Examples

peeif and poptail can be used together to batch process the lines of a very large file.  By popping the lines off of the file as they are used, the whole process can be interrupted and resumed.  

First, make a command that "processes" lines from STDIN.  This will randomly fail one out of three times.   
```
$ echo '[[ $(( RANDOM % 3 )) != 0 ]] && xargs -I {} echo "processed: {}" || exit 1' > line_processor
$ echo "a line to process" | bash line_processor
processed: a line to process
```
Make a file of lines to process, then process them three at a time until the file is empty; store lines where `line_processor` fails in the "skipped" file.  
```
$ seq 10 > lines
$ while [[ -s lines ]]; do 
>     poptail -n3 lines | peeif -u "bash line_processor" "cat >> skipped"
> done
processed: 8
processed: 9
processed: 10
processed: 5
processed: 6
processed: 7
processed: 1
$ cat skipped
2
3
4
```
