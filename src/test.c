// test.c -- testing cmake
//
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "myfun.h"
#include "config.h"

int main(int argc, char *argv[]) {

  // Checking the   
  if(argc != 2){
     printf("Usage: ./hello /GLOBAL/PATH/inputfile.Rmd \n");
     exit(EXIT_FAILURE);
  }
   
  printf("Version: %s\n",VERSION);
  printf("Hello World \n");
  printHola();
#ifdef HAVE_RPKG
  printf("R exists and has the necessary packages. \n");
  char * command = get_command(argv[1]);
  printf("Running command: %s \n", command);
  system(command);
#endif
  printf("End of the program\n");
  return(0);
}

