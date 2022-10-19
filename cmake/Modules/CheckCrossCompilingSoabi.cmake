# Copyright 2022 Open Source Robotics Foundation, Inc.
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

function(CheckCrossCompilingSoabi)
  set(_python_code
    "from sysconfig import get_config_var"
    "print(get_config_var('SOABI'))"
  )
  if(NOT DEFINED PYTHON_SOABI AND DEFINED CMAKE_SYSROOT)
    message(FATAL_ERROR "We detected you defined a sysroot thus crosscompiling.\n"
      "You have to define the PYTHON_SOABI variable in the toolchain file, which looks like cpython-39-x86_64-linux-gnu or cpython-39-aarch64-linux-gnu.\n"
      ""
      "To find the correct PYTHON_SOABI value, you can execute the following from the target:\n"
      "python3 -c \"${_python_code}\"\n"
      ""
      "Run it with qemu with: (expecting aarch64 as your \n"
      "qemu-aarch64-static -L ${CMAKE_SYSROOT} ${CMAKE_SYSROOT}/usr/bin/python3 -c \"${_python_code}\"\n"
      ""
      "The toolchain should look like:\n"
      "set(PYTHON_SOABI cpython-39-aarch64-linux-gnu)\n"
    )
  endif()
endfunction()
