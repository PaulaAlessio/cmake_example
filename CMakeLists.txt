#---------------------------------------------------------------
# Setting variable names
#---------------------------------------------------------------

# Specify the minimum version for CMake
cmake_minimum_required(VERSION 2.8)

# Project's name
project(myTestProject)

# Project's version
set(VERSION "1.0")

# Set the output folder where your program will be created
set(PROJECT_SOURCE_DIR ${CMAKE_SOURCE_DIR}/src)
set(CMAKE_BINARY_DIR ${CMAKE_SOURCE_DIR}/bin)
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR})
set(LIBRARY_OUTPUT_PATH ${CMAKE_BINARY_DIR})

# Include functions
include(CheckIncludeFiles)
include(CheckFunctionExists)


#---------------------------------------------------------------
# Check that all 
#---------------------------------------------------------------

# Check header files

# <string.h>
check_include_files(string.h HAVE_STRING_H)
if (NOT  HAVE_STRING_H)
   message(FATAL_ERROR "Header file: <string.h> not found. Exiting.")
endif()

# <stdio.h>
check_include_files(stdio.h HAVE_STDIO_H)
if (NOT  HAVE_STDIO_H)
   message(FATAL_ERROR "Header file: <stdio.h> not found. Exiting.")
endif()

# <stdlib.h>
check_include_files(stdlib.h HAVE_STDLIB_H)
if (NOT  HAVE_STDLIB_H)
   message(FATAL_ERROR "Header file: <stdlib.h> not found. Exiting.")
endif()

# Check standard library functions exist
# printf 
check_function_exists(printf HAVE_PRINTF)
if(NOT HAVE_PRINTF)
   message(FATAL_ERROR "Function printf not found. Exiting.")
endif(NOT HAVE_PRINTF)

# system 
check_function_exists(system HAVE_SYSTEM)
if(NOT HAVE_SYSTEM)
   message(FATAL_ERROR "Function system not found. Exiting.")
endif(NOT HAVE_SYSTEM)

#strcat
check_function_exists(system HAVE_STRCAT)
if(NOT HAVE_STRCAT)
   message(FATAL_ERROR "Function strcat not found. Exiting.")
endif(NOT HAVE_STRCAT)


#---------------------------------------------------------------
# Checking  dependencies
#---------------------------------------------------------------

# pandoc (maybe also pandoc-citeproc, check this)
set(PANDOC "pandoc" CACHE STRING "Some user-specified option")
find_program(HAVE_PANDOC ${PANDOC})
message("-- Check for pandoc: ${HAVE_PANDOC}")

# R
set(R "R" CACHE STRING "Some user-specified option")
find_program(R_EXEC ${R})
message("-- Check for R: ${R_EXEC}")

# Rscript (if we wanted to check Rscript)
#set(Rscript "Rscript" CACHE STRING "Some user-specified option")
#find_program(RSCRIPT_EXEC ${Rscript})
#message("-- Check for Rscript: ${RSCRIPT_EXEC}")

# Set variables if R packages are installed 
include(${CMAKE_SOURCE_DIR}/Rpkg_check.cmake)
if(R_EXEC)
   set_r_variables(${R_EXEC} )       
   find_r_package(rmarkdown ${R_EXEC})
   if (R_rmarkdown)
      set(HAVE_RPKG TRUE)
   else()
      set(HAVE_RPKG FALSE)
   endif()
endif(R_EXEC)

# If pandoc is not installed, set Rpkg variables to false
if (NOT HAVE_PANDOC)
  set(HAVE_RPKG FALSE)
endif()


#---------------------------------------------------------------
# Compiler flags, linker flags and rules
#---------------------------------------------------------------
# Create config.h file
CONFIGURE_FILE(${CMAKE_SOURCE_DIR}/config.h.in ${CMAKE_SOURCE_DIR}/config.h)

# Set compiler flags
set(CMAKE_C_FLAGS  "-Wall -O3 -std=c99")

# Set linker flags
set(CMAKE_C_LINK_FLAGS  "-lm")

# Include directories
include_directories("${CMAKE_SOURCE_DIR}/include" "${CMAKE_SOURCE_DIR}")

# Add executables 
add_executable(hello ${PROJECT_SOURCE_DIR}/test.c ${PROJECT_SOURCE_DIR}/myfun.c)
add_executable(hello2 ${PROJECT_SOURCE_DIR}/test2.c ${PROJECT_SOURCE_DIR}/myfun.c)


if ( NOT HAVE_RPKG )
   message("-- WARNING:  Package will be compiled but R script will not ")
   message("             be called. Something missing.")
   message("             Check that you have installed: ")
   message("               - R ")
   message("               - pandoc")
   message("               - R packages: rmarkdown, pheatmap")
endif() 
