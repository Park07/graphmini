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
include src/CMakeFiles/prof_runner.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include src/CMakeFiles/prof_runner.dir/compiler_depend.make

# Include the progress variables for this target.
include src/CMakeFiles/prof_runner.dir/progress.make

# Include the compile flags for this target's objects.
include src/CMakeFiles/prof_runner.dir/flags.make

src/CMakeFiles/prof_runner.dir/codegen:
.PHONY : src/CMakeFiles/prof_runner.dir/codegen

src/CMakeFiles/prof_runner.dir/cmake_pch.hxx.pch: src/CMakeFiles/prof_runner.dir/flags.make
src/CMakeFiles/prof_runner.dir/cmake_pch.hxx.pch: src/CMakeFiles/prof_runner.dir/cmake_pch.hxx.cxx
src/CMakeFiles/prof_runner.dir/cmake_pch.hxx.pch: src/CMakeFiles/prof_runner.dir/cmake_pch.hxx
src/CMakeFiles/prof_runner.dir/cmake_pch.hxx.pch: src/CMakeFiles/prof_runner.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/Users/williampark/GraphMini/build_tbb/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object src/CMakeFiles/prof_runner.dir/cmake_pch.hxx.pch"
	cd /Users/williampark/GraphMini/build_tbb/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -Winvalid-pch -Xclang -emit-pch -Xclang -include -Xclang /Users/williampark/GraphMini/build_tbb/src/CMakeFiles/prof_runner.dir/cmake_pch.hxx -x c++-header -MD -MT src/CMakeFiles/prof_runner.dir/cmake_pch.hxx.pch -MF CMakeFiles/prof_runner.dir/cmake_pch.hxx.pch.d -o CMakeFiles/prof_runner.dir/cmake_pch.hxx.pch -c /Users/williampark/GraphMini/build_tbb/src/CMakeFiles/prof_runner.dir/cmake_pch.hxx.cxx

src/CMakeFiles/prof_runner.dir/cmake_pch.hxx.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/prof_runner.dir/cmake_pch.hxx.i"
	cd /Users/williampark/GraphMini/build_tbb/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -Winvalid-pch -Xclang -emit-pch -Xclang -include -Xclang /Users/williampark/GraphMini/build_tbb/src/CMakeFiles/prof_runner.dir/cmake_pch.hxx -x c++-header -E /Users/williampark/GraphMini/build_tbb/src/CMakeFiles/prof_runner.dir/cmake_pch.hxx.cxx > CMakeFiles/prof_runner.dir/cmake_pch.hxx.i

src/CMakeFiles/prof_runner.dir/cmake_pch.hxx.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/prof_runner.dir/cmake_pch.hxx.s"
	cd /Users/williampark/GraphMini/build_tbb/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -Winvalid-pch -Xclang -emit-pch -Xclang -include -Xclang /Users/williampark/GraphMini/build_tbb/src/CMakeFiles/prof_runner.dir/cmake_pch.hxx -x c++-header -S /Users/williampark/GraphMini/build_tbb/src/CMakeFiles/prof_runner.dir/cmake_pch.hxx.cxx -o CMakeFiles/prof_runner.dir/cmake_pch.hxx.s

src/CMakeFiles/prof_runner.dir/prof_runner.cpp.o: src/CMakeFiles/prof_runner.dir/flags.make
src/CMakeFiles/prof_runner.dir/prof_runner.cpp.o: /Users/williampark/GraphMini/src/prof_runner.cpp
src/CMakeFiles/prof_runner.dir/prof_runner.cpp.o: src/CMakeFiles/prof_runner.dir/cmake_pch.hxx
src/CMakeFiles/prof_runner.dir/prof_runner.cpp.o: src/CMakeFiles/prof_runner.dir/cmake_pch.hxx.pch
src/CMakeFiles/prof_runner.dir/prof_runner.cpp.o: src/CMakeFiles/prof_runner.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/Users/williampark/GraphMini/build_tbb/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object src/CMakeFiles/prof_runner.dir/prof_runner.cpp.o"
	cd /Users/williampark/GraphMini/build_tbb/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -Winvalid-pch -Xclang -include-pch -Xclang /Users/williampark/GraphMini/build_tbb/src/CMakeFiles/prof_runner.dir/cmake_pch.hxx.pch -Xclang -include -Xclang /Users/williampark/GraphMini/build_tbb/src/CMakeFiles/prof_runner.dir/cmake_pch.hxx -MD -MT src/CMakeFiles/prof_runner.dir/prof_runner.cpp.o -MF CMakeFiles/prof_runner.dir/prof_runner.cpp.o.d -o CMakeFiles/prof_runner.dir/prof_runner.cpp.o -c /Users/williampark/GraphMini/src/prof_runner.cpp

src/CMakeFiles/prof_runner.dir/prof_runner.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/prof_runner.dir/prof_runner.cpp.i"
	cd /Users/williampark/GraphMini/build_tbb/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -Winvalid-pch -Xclang -include-pch -Xclang /Users/williampark/GraphMini/build_tbb/src/CMakeFiles/prof_runner.dir/cmake_pch.hxx.pch -Xclang -include -Xclang /Users/williampark/GraphMini/build_tbb/src/CMakeFiles/prof_runner.dir/cmake_pch.hxx -E /Users/williampark/GraphMini/src/prof_runner.cpp > CMakeFiles/prof_runner.dir/prof_runner.cpp.i

src/CMakeFiles/prof_runner.dir/prof_runner.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/prof_runner.dir/prof_runner.cpp.s"
	cd /Users/williampark/GraphMini/build_tbb/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -Winvalid-pch -Xclang -include-pch -Xclang /Users/williampark/GraphMini/build_tbb/src/CMakeFiles/prof_runner.dir/cmake_pch.hxx.pch -Xclang -include -Xclang /Users/williampark/GraphMini/build_tbb/src/CMakeFiles/prof_runner.dir/cmake_pch.hxx -S /Users/williampark/GraphMini/src/prof_runner.cpp -o CMakeFiles/prof_runner.dir/prof_runner.cpp.s

# Object files for target prof_runner
prof_runner_OBJECTS = \
"CMakeFiles/prof_runner.dir/prof_runner.cpp.o"

# External object files for target prof_runner
prof_runner_EXTERNAL_OBJECTS =

bin/prof_runner: src/CMakeFiles/prof_runner.dir/cmake_pch.hxx.pch
bin/prof_runner: src/CMakeFiles/prof_runner.dir/prof_runner.cpp.o
bin/prof_runner: src/CMakeFiles/prof_runner.dir/build.make
bin/prof_runner: src/libcommon.a
bin/prof_runner: src/codegen_output/libplan_profile.a
bin/prof_runner: /opt/homebrew/opt/libomp/lib/libomp.dylib
bin/prof_runner: /opt/homebrew/lib/libtbb.12.15.dylib
bin/prof_runner: /opt/homebrew/lib/libtbbmalloc.2.15.dylib
bin/prof_runner: src/CMakeFiles/prof_runner.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --bold --progress-dir=/Users/williampark/GraphMini/build_tbb/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Linking CXX executable ../bin/prof_runner"
	cd /Users/williampark/GraphMini/build_tbb/src && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/prof_runner.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/CMakeFiles/prof_runner.dir/build: bin/prof_runner
.PHONY : src/CMakeFiles/prof_runner.dir/build

src/CMakeFiles/prof_runner.dir/clean:
	cd /Users/williampark/GraphMini/build_tbb/src && $(CMAKE_COMMAND) -P CMakeFiles/prof_runner.dir/cmake_clean.cmake
.PHONY : src/CMakeFiles/prof_runner.dir/clean

src/CMakeFiles/prof_runner.dir/depend:
	cd /Users/williampark/GraphMini/build_tbb && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/williampark/GraphMini /Users/williampark/GraphMini/src /Users/williampark/GraphMini/build_tbb /Users/williampark/GraphMini/build_tbb/src /Users/williampark/GraphMini/build_tbb/src/CMakeFiles/prof_runner.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : src/CMakeFiles/prof_runner.dir/depend

