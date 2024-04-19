# Assembly assignments
> For the Computer Organisation course at TU Delft

# How to run
`nameofprogram` = output <br>
`nameofyoursource` = assembly source
```bash
$ gcc -no-pie -o nameofyourprogram nameofyoursource.s
$ ./nameofyourprogram
```

## debugging
```bash
$ gcc -no-pie -g -o nameofyourprogram nameofyoursource.s
$ gdb ./nameofyourprogram
```




