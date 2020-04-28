# Nasm examples

*Requirements: POSIX make*

Run on macOS:

`make fibonacci.exe && ./fibonacci.exe`

Run on linux: 
```sh
$ nasm -f elf64 echo.nasm
$ cc -static echo.o -o echo.exe
```

Run in Docker:

`docker build -t nasm . && docker run -it nasm` and then run the commands above.
