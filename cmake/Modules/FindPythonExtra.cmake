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
# - PYTHON_EXECUTABLE: a path to a python interpreter (deprecated; new code should use PythonExtra::Interpreter)
# - PYTHON_EXECUTABLE_DEBUG: If the CMAKE_BUILD_TYPE is Debug and WIN32 is true
#    then this will be a path to a debug build of the Python interpreter (deprecated; new code should use PythonExtra::Interpreter)
# - PythonExtra_POSTFIX: a postfix that downstream consumers can use as the DEBUG_POSTFIX property to a target
#
# Example usage:
#
#   find_package(python_cmake_module REQUIRED)
#   find_package(PythonExtra MODULE)
#   # use PythonExtra::Interpreter
#
# Note on FindPython3
#   This module will `find_package(Python3 REQUIRED COMPONENTS Interpreter)`
#   If more components from FindPython3.cmake are needed, then find them manually before
#   or after finding this module.
#
###############################################################################

# lint_cmake: -convention/filename, -package/stdargs

if(PythonExtra_FOUND)
  return()
endif()

find_package(Python3 REQUIRED COMPONENTS Interpreter)

get_target_property(PYTHON_EXECUTABLE Python3::Interpreter LOCATION)

add_executable(PythonExtra::Interpreter IMPORTED)
set_property(TARGET PythonExtra::Interpreter
  PROPERTY IMPORTED_LOCATION "${PYTHON_EXECUTABLE}")

set(PythonExtra_POSTFIX "")

# Set the location to the debug interpreter on Windows if it exists
if(WIN32)
  get_filename_component(_python_executable_dir "${PYTHON_EXECUTABLE}" DIRECTORY)
  get_filename_component(_python_executable_name "${PYTHON_EXECUTABLE}" NAME_WE)
  get_filename_component(_python_executable_ext "${PYTHON_EXECUTABLE}" EXT)
  set(PYTHON_EXECUTABLE_DEBUG "${_python_executable_dir}/${_python_executable_name}_d${_python_executable_ext}")
  if(EXISTS "${PYTHON_EXECUTABLE_DEBUG}")
    # TODO(clalancette): In theory we should be able to set the IMPORTED_LOCATION_Debug property,
    # and downstream users would automatically use that with the "Debug" configuration.
    # In practice we've found that this doesn't work as advertised in
    # https://cmake.org/cmake/help/latest/guide/importing-exporting/index.html#importing-libraries ,
    # so we are overriding IMPORTED_LOCATION.
    set_property(TARGET PythonExtra::Interpreter PROPERTY IMPORTED_LOCATION "${PYTHON_EXECUTABLE_DEBUG}")
    set(PythonExtra_POSTFIX "_d")
  elseif(CMAKE_BUILD_TYPE STREQUAL "Debug")
    message(WARNING "${PYTHON_EXECUTABLE_DEBUG} doesn't exist but a Windows Debug build requires it")
    unset(PYTHON_EXECUTABLE_DEBUG)
  endif()
  unset(_python_executable_dir)
  unset(_python_executable_name)
  unset(_python_executable_ext)
endif()

set(_required_vars
  PYTHON_EXECUTABLE)
if(WIN32 AND "${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
  list(APPEND _required_vars PYTHON_EXECUTABLE_DEBUG)
endif()
# Downstream users should use PythonExtra::Interpreter instead of these variables
mark_as_advanced(
  PYTHON_EXECUTABLE
  PYTHON_EXECUTABLE_DEBUG
  PythonExtra_POSTFIX)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(PythonExtra
  REQUIRED_VARS ${_required_vars}
)

unset(_required_vars)
