# Nasm examples

*Requirements: POSIX make*

Run on macOS:

`make fibonacci.exe; ./fibonacci.exe`

Run on linux: 
`LINUX=1 make FORMAT=elf64  fibonacci.exe`

Run in Docker:

`docker build -t nasm .; docker run -it nasm` and then run the command above.
