# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 4.0

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /opt/homebrew/bin/cmake

# The command to remove a file.
RM = /opt/homebrew/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/williampark/GraphMini

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/williampark/GraphMini/build_tbb

# Include any dependencies generated for this target.
include src/CMakeFiles/prep.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include src/CMakeFiles/prep.dir/compiler_depend.make

# Include the progress variables for this target.
include src/CMakeFiles/prep.dir/progress.make

# Include the compile flags for this target's objects.
include src/CMakeFiles/prep.dir/flags.make

src/CMakeFiles/prep.dir/codegen:
.PHONY : src/CMakeFiles/prep.dir/codegen

src/CMakeFiles/prep.dir/prep.cpp.o: src/CMakeFiles/prep.dir/flags.make
src/CMakeFiles/prep.dir/prep.cpp.o: /Users/williampark/GraphMini/src/prep.cpp
src/CMakeFiles/prep.dir/prep.cpp.o: src/CMakeFiles/prep.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/Users/williampark/GraphMini/build_tbb/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object src/CMakeFiles/prep.dir/prep.cpp.o"
	cd /Users/williampark/GraphMini/build_tbb/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT src/CMakeFiles/prep.dir/prep.cpp.o -MF CMakeFiles/prep.dir/prep.cpp.o.d -o CMakeFiles/prep.dir/prep.cpp.o -c /Users/williampark/GraphMini/src/prep.cpp

src/CMakeFiles/prep.dir/prep.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/prep.dir/prep.cpp.i"
	cd /Users/williampark/GraphMini/build_tbb/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/williampark/GraphMini/src/prep.cpp > CMakeFiles/prep.dir/prep.cpp.i

src/CMakeFiles/prep.dir/prep.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/prep.dir/prep.cpp.s"
	cd /Users/williampark/GraphMini/build_tbb/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/williampark/GraphMini/src/prep.cpp -o CMakeFiles/prep.dir/prep.cpp.s

# Object files for target prep
prep_OBJECTS = \
"CMakeFiles/prep.dir/prep.cpp.o"

# External object files for target prep
prep_EXTERNAL_OBJECTS =

bin/prep: src/CMakeFiles/prep.dir/prep.cpp.o
bin/prep: src/CMakeFiles/prep.dir/build.make
bin/prep: src/preprocess/libpreprocess.a
bin/prep: src/libcommon.a
bin/prep: /opt/homebrew/lib/libtbb.12.15.dylib
bin/prep: /opt/homebrew/lib/libtbbmalloc.2.15.dylib
bin/prep: src/CMakeFiles/prep.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --bold --progress-dir=/Users/williampark/GraphMini/build_tbb/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable ../bin/prep"
	cd /Users/williampark/GraphMini/build_tbb/src && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/prep.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/CMakeFiles/prep.dir/build: bin/prep
.PHONY : src/CMakeFiles/prep.dir/build

src/CMakeFiles/prep.dir/clean:
	cd /Users/williampark/GraphMini/build_tbb/src && $(CMAKE_COMMAND) -P CMakeFiles/prep.dir/cmake_clean.cmake
.PHONY : src/CMakeFiles/prep.dir/clean

src/CMakeFiles/prep.dir/depend:
	cd /Users/williampark/GraphMini/build_tbb && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/williampark/GraphMini /Users/williampark/GraphMini/src /Users/williampark/GraphMini/build_tbb /Users/williampark/GraphMini/build_tbb/src /Users/williampark/GraphMini/build_tbb/src/CMakeFiles/prep.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : src/CMakeFiles/prep.dir/depend

