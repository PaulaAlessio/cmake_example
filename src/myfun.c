#include <stdio.h>
#include <string.h>
#include "myfun.h"
#include "config.h"
#define CHAR_MAX 1000

// Print hello world in Spanish
void printHola(){
   printf("Hola Mundo\n");
}

// Get the command we want to run with Rscript
char *get_command(char filename[]){
  char command[CHAR_MAX] = R_EXEC; 
  strcat(command, " -e \"rmarkdown::render('"); 
  strcat(command,filename);
  strcat(command,"')\""); 
  char *str_command = command; 
  printf("command: %s \n", str_command);
  return str_command;
}

