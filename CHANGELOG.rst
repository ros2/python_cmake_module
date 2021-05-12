^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Changelog for package python_cmake_module
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Forthcoming
-----------

0.8.1 (2021-03-18)
------------------
* Update maintainers (`#2 <https://github.com/ros2/python_cmake_module/issues/2>`_)
  Previous: @cottsay
  New: @sloretz
* Contributors: Shane Loretz

0.8.0 (2019-09-23)
------------------
* adding back CONTRIBUTING.md and LICENSE files
* 0.7.6
* 0.7.5
* 0.7.4
* 0.7.3
* 0.7.2
* 0.7.1
* 0.7.0
* Adds Python typesupport for Actions (`#21 <https://github.com/ros2/python_cmake_module/issues/21>`_)
  * Add _action.py.em; Makes rosidl_generator_py handle action files
  properly
  * Adds CMake pipeline bits for action generation.
  * Fixes all linter issues.
  * Attempts to fix CMake warnings in Windows.
* 0.6.2
* 0.6.1
* Update package maintainer (`#22 <https://github.com/ros2/python_cmake_module/issues/22>`_)
  Thank you to Mikael for his contributions
* 0.6.0
* 0.5.2
* 0.5.1
* 0.5.0
* 0.4.0
* update maintainer (`#255 <https://github.com/ros2/python_cmake_module/issues/255>`_)
* 0.0.3
* 0.0.2
* update schema url
* add schema to manifest files
* Windows python debug (`#153 <https://github.com/ros2/python_cmake_module/issues/153>`_)
  * added _d suffix to generated extensions
  * look for python debug interpreter
  * adding error message and PYTHON_DBG_EXECUTABLE variable
  * remove trailing whitespace
  * rename PYTHON_DBG_EXECUTABLE to PYTHON_EXECUTABLE_DEBUG
  * quote entire error message
  * cmake3.5 remove trailing whitespace
* remove trailing spaces from comparisons, obsolete quotes and explicit variable expansion
* require CMake 3.5
* Merge pull request `#152 <https://github.com/ros2/python_cmake_module/issues/152>`_ from ros2/python35
  require Python 3.5
* require Python 3.5
* fix using only SOABI on Python 3.5, remove obsolete MULTIARCH
* fix indentation
* fix required vars of PythonExtra on Windows
* use CTest BUILD_TESTING
* consistent output
* Added support for exposing type support through Python extensions
* Contributors: Alexis Pojomovsky, Dirk Thomas, Esteve Fernandez, Jacob Perron, Mikael Arguedas, Scott K Logan, Shane Loretz, Steven! Ragnarök, William Woodall
