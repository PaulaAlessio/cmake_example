
### Small cmake example

This small package illustrates how to use cmake. 

#### Installation 

To build and compile the code run: 

``` sh
cmake -H. -Bbuild
cd build 
make
```


**NOTE**: with the option `-D` you can set variables when you call cmake in the command line:

```sh
   -DCMAKE_C_COMPILE=gcc # sets the compiler
   -DR_EXEC=RBioC35      # sets R executable
```


#### Running program

Executables should be under the folder `./bin`. Run 

```sh 
./bin/hello  /PATH/TO/PROJECT/R/test.Rmd  # Creates  ./R/test.html from ./R/test.Rmd
./bin/hello2                              # Computes sqrt(2.0) to check -lm 
```


#### Description
Interesting files are, 

``` sh
   CMakeLists.txt
   config.h.in 
   Rpkg_check.cmake
```

* `CMakeLists.txt`: this file describes your project to CMake and affect its output.
  In this example, we first set the folder structure, then check 
  for header files and `stdlib` functions used. Then it checks 
  that `pandoc` and `R` are installed and that the package `rmarkdown`
  is installed in `R`. Then, the compiler flags, includes, linker flags, 
  rules and targets are added. 
* `config.h.in`: configure file. It will create the file `config.h`
   with `#define` statements. 
* `Rpkg_check.cmake`: file containing self-written functions. 
