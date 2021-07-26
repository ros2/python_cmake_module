# Copyright 2016 Open Source Robotics Foundation, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


###############################################################################
#
# CMake module for providing extra information about the Python interpreter.
#
# Output Targets:
# - PythonExtra::Interpreter - an executable target that will invoke a version of Python
#     matching CMAKE_BUILD_TYPE on platforms where that matters
#
# Output variables:
# - PythonExtra_FOUND: True if a Python executable was found
#
# Advanced Output variables
# - PythonExtra_EXECUTABLE: a path to a python interpreter
# - PythonExtra_EXECUTABLE_DEBUG: If the CMAKE_BUILD_TYPE is Debug and WIN32 is true
#    then this will be a path to a debug build of the Python interpreter.
#
# Example usage:
#
#   find_package(python_cmake_module REQUIRED)
#   find_package(PythonExtra MODULE)
#   # use PythonExtra::Interpreter
#
# Note on Python3
#   This module requires that `find_package(Python3 REQUIRED COMPONENTS Interpreter)` be called,
#   and will call it if not present.
#   If more components from FindPython3.cmake are needed, then find it manually before finding
#   this module.
#   Example:
#
#     find_package(python_cmake_module REQUIRED)
#     find_package(Python3 REQUIRED COMPONENTS Interpreter Development NumPy)
#     find_package(PythonExtra MODULE)
#     # use PythonExtra::Interpreter
#
###############################################################################

# lint_cmake: -convention/filename, -package/stdargs

if(PythonExtra_FOUND)
  return()
endif()

if(Python3_FOUND AND NOT TARGET Python3::Interpreter)
  message(FATAL_ERROR "PythonExtra requires Python3 to be found with the Interpreter component")
elseif(NOT Python3_FOUND)
  find_package(Python3 REQUIRED COMPONENTS Interpreter)
endif()

get_target_property(PythonExtra_EXECUTABLE Python3::Interpreter IMPORTED_LOCATION)

add_executable(PythonExtra::Interpreter IMPORTED)
set_property(TARGET PythonExtra::Interpreter
  PROPERTY IMPORTED_LOCATION "${PythonExtra_EXECUTABLE}")

# Set the location to the debug interpretter on Windows if it exists
if(WIN32)
  get_target_property(PythonExtra_EXECUTABLE PythonExtra::Interpreter IMPORTED_LOCATION)
  get_filename_component(_python_executable_dir "${PythonExtra_EXECUTABLE}" DIRECTORY)
  get_filename_component(_python_executable_name "${PythonExtra_EXECUTABLE}" NAME_WE)
  get_filename_component(_python_executable_ext "${PythonExtra_EXECUTABLE}" EXT)
  set(PythonExtra_EXECUTABLE_DEBUG "${_python_executable_dir}/${_python_executable_name}_d${_python_executable_ext}")
  if(EXISTS "${PythonExtra_EXECUTABLE_DEBUG}")
    set_target_property(PythonExtra::Interpreter IMPORTED_LOCATION_Debug "${PythonExtra_EXECUTABLE_DEBUG}")
    set(PythonExtra_EXECUTABLE_DEBUG "${PythonExtra_EXECUTABLE_DEBUG}")
  elseif(CMAKE_BUILD_TYPE STREQUAL "Debug")
    message(FATAL_ERROR "${PythonExtra_EXECUTABLE_DEBUG} doesn't exist and Debug build required")
  endif()
  unset(_python_executable_dir)
  unset(_python_executable_name)
  unset(_python_executable_ext)
endif()

include(FindPackageHandleStandardArgs)
set(_required_vars
  PythonExtra_EXECUTABLE)
if(WIN32 AND "${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
  list(APPEND _required_vars PythonExra_EXECUTABLE_DEBUG)
endif()
# Use PythonExtra::Interpreter instead of these variables
mark_as_advanced(
  PythonExtra_EXECUTABLE
  PythonExtra_EXECUTABLE_DEBUG)
find_package_handle_standard_args(PythonExtra
  REQUIRED_VARS ${_required_vars}
)
unset(_required_vars)
