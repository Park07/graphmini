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
include src/CMakeFiles/profile.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include src/CMakeFiles/profile.dir/compiler_depend.make

# Include the progress variables for this target.
include src/CMakeFiles/profile.dir/progress.make

# Include the compile flags for this target's objects.
include src/CMakeFiles/profile.dir/flags.make

src/CMakeFiles/profile.dir/codegen:
.PHONY : src/CMakeFiles/profile.dir/codegen

src/CMakeFiles/profile.dir/profile.cpp.o: src/CMakeFiles/profile.dir/flags.make
src/CMakeFiles/profile.dir/profile.cpp.o: /Users/williampark/GraphMini/src/profile.cpp
src/CMakeFiles/profile.dir/profile.cpp.o: src/CMakeFiles/profile.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/Users/williampark/GraphMini/build_tbb/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object src/CMakeFiles/profile.dir/profile.cpp.o"
	cd /Users/williampark/GraphMini/build_tbb/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT src/CMakeFiles/profile.dir/profile.cpp.o -MF CMakeFiles/profile.dir/profile.cpp.o.d -o CMakeFiles/profile.dir/profile.cpp.o -c /Users/williampark/GraphMini/src/profile.cpp

src/CMakeFiles/profile.dir/profile.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/profile.dir/profile.cpp.i"
	cd /Users/williampark/GraphMini/build_tbb/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/williampark/GraphMini/src/profile.cpp > CMakeFiles/profile.dir/profile.cpp.i

src/CMakeFiles/profile.dir/profile.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/profile.dir/profile.cpp.s"
	cd /Users/williampark/GraphMini/build_tbb/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/williampark/GraphMini/src/profile.cpp -o CMakeFiles/profile.dir/profile.cpp.s

# Object files for target profile
profile_OBJECTS = \
"CMakeFiles/profile.dir/profile.cpp.o"

# External object files for target profile
profile_EXTERNAL_OBJECTS =

bin/profile: src/CMakeFiles/profile.dir/profile.cpp.o
bin/profile: src/CMakeFiles/profile.dir/build.make
bin/profile: src/libcommon.a
bin/profile: src/codegen/libcodegen.a
bin/profile: _deps/fmt-build/libfmt.a
bin/profile: /opt/homebrew/lib/libtbb.12.15.dylib
bin/profile: /opt/homebrew/lib/libtbbmalloc.2.15.dylib
bin/profile: src/libcommon.a
bin/profile: lib/libgraph_mining.dylib
bin/profile: /opt/homebrew/opt/libomp/lib/libomp.dylib
bin/profile: src/CMakeFiles/profile.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --bold --progress-dir=/Users/williampark/GraphMini/build_tbb/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable ../bin/profile"
	cd /Users/williampark/GraphMini/build_tbb/src && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/profile.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/CMakeFiles/profile.dir/build: bin/profile
.PHONY : src/CMakeFiles/profile.dir/build

src/CMakeFiles/profile.dir/clean:
	cd /Users/williampark/GraphMini/build_tbb/src && $(CMAKE_COMMAND) -P CMakeFiles/profile.dir/cmake_clean.cmake
.PHONY : src/CMakeFiles/profile.dir/clean

src/CMakeFiles/profile.dir/depend:
	cd /Users/williampark/GraphMini/build_tbb && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/williampark/GraphMini /Users/williampark/GraphMini/src /Users/williampark/GraphMini/build_tbb /Users/williampark/GraphMini/build_tbb/src /Users/williampark/GraphMini/build_tbb/src/CMakeFiles/profile.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : src/CMakeFiles/profile.dir/depend

