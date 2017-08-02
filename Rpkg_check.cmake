# Code taken from http://public.kitware.com/pipermail/cmake/2010-June/037468.html
# 
#  It defines the following help functions if R is found:
#
# set_r_variables(R_EXEC) - sets R_LIBS_USER - path to directory of user's R packages 
#                           (defined only if R is found) 
# FIND_R_PACKAGE(package,RSCRIPT)    - sets R_<PACKAGE> to ON if package is installed 
# INSTALL_R_PACKAGE(package)         - installs package in ${R_LIBS_USER}
# FIND_OR_INSTALL_R_PACKAGE(package) - finds package and installs it, if not found


include(FindPackageHandleStandardArgs)
# R_LIBS_USER is always defined within R, even if it is not explicitly set by the user
#Sets the variables: R_LIBS_USER
function(set_r_variables R_EXEC)
        execute_process(COMMAND "${R_EXEC}" "--slave" "-e" 
                "cat(Sys.getenv(\"R_LIBS_USER\"))"
                OUTPUT_VARIABLE _rlibsuser
                OUTPUT_STRIP_TRAILING_WHITESPACE)
        #string(REGEX REPLACE "[ ]*(R_LIBS_USER)[ ]*\n\"(.*)\"" "\\2"
        #        R_LIBS_USER ${_rlibsuser})
        string(REGEX REPLACE "[ ]*(R_LIBS_USER)[ ]*\n\"(.*)\"" "\\2"
                R_LIBS ${_rlibsuser})
        set(R_LIBS_USER ${R_LIBS} PARENT_SCOPE)
endfunction(set_r_variables)

# Checks 
function(find_r_package package R_EXEC)
        string(TOUPPER ${package} package_upper)
        if(NOT R_${package_upper})
                if(ARGC GREATER 1 AND ARGV1 STREQUAL "REQUIRED")
                        set(${package}_FIND_REQUIRED TRUE)
                endif()
                execute_process(COMMAND "${R_EXEC}" "--slave" "-e" 
                        "library('${package}')"
                        RESULT_VARIABLE _${package}_status 
                        ERROR_QUIET OUTPUT_QUIET)
                if(NOT _${package}_status)
                        set(R_${package_upper} TRUE CACHE BOOL 
                                "Whether the R package ${package} is installed")
                endif(NOT _${package}_status)
        endif(NOT R_${package_upper})
        find_package_handle_standard_args(R_${package} DEFAULT_MSG R_${package_upper})       
        if(R_${package_upper})
           set(R_${package} TRUE PARENT_SCOPE)
        endif()
endfunction(find_r_package)

function(install_r_package package R_EXEC R_LIBS_USER)
        message(STATUS "Installing R package ${package}...")
        execute_process(COMMAND "${R_EXEC}" "--slave" "-e"
                "install.packages('${package}','${R_LIBS_USER}','http://cran.r-project.org')"
                ERROR_QUIET OUTPUT_QUIET)
        message(STATUS "R package ${package} has been installed in ${R_LIBS_USER}")
endfunction(install_r_package)

function(find_or_install_r_package package R_EXEC R_LIBS_USER)
        find_r_package(${package} ${R_EXEC})
        string(TOUPPER ${package} package_upper)
        if(NOT R_${package_upper})
                install_r_package(${package} ${R_EXEC} ${R_LIBS_USER})
        endif()
endfunction(find_or_install_r_package)

