cmake_minimum_required(VERSION 3.10)

project(PROJECT_NAME)

# Set the standard to c++14
set(CMAKE_CXX_STANDARD 14)

# Require that it be this and not something else
# even in the case there is no c++14 support
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Make sure it uses -std=c++14 rather than -std=gnu++14)
set(CMAKE_CXX_EXTENSIONS OFF)


if(MSVC)
  add_compile_options(/W4)
else()
  add_compile_options(-Wall -Wextra -pedantic)
endif()

# See here https://cmake.org/cmake/help/latest/command/find_package.html
find_package(GSL REQUIRED)
# See here https://cmake.org/cmake/help/latest/module/FindGSL.html
link_libraries(GSL::gsl GSL::gslcblas)

add_executable(executable_name example.cpp)
