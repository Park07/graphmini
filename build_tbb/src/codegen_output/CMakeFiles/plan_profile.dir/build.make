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
include src/codegen_output/CMakeFiles/plan_profile.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include src/codegen_output/CMakeFiles/plan_profile.dir/compiler_depend.make

# Include the progress variables for this target.
include src/codegen_output/CMakeFiles/plan_profile.dir/progress.make

# Include the compile flags for this target's objects.
include src/codegen_output/CMakeFiles/plan_profile.dir/flags.make

src/codegen_output/CMakeFiles/plan_profile.dir/codegen:
.PHONY : src/codegen_output/CMakeFiles/plan_profile.dir/codegen

src/codegen_output/CMakeFiles/plan_profile.dir/cmake_pch.hxx.pch: src/codegen_output/CMakeFiles/plan_profile.dir/flags.make
src/codegen_output/CMakeFiles/plan_profile.dir/cmake_pch.hxx.pch: src/codegen_output/CMakeFiles/plan_profile.dir/cmake_pch.hxx.cxx
src/codegen_output/CMakeFiles/plan_profile.dir/cmake_pch.hxx.pch: src/codegen_output/CMakeFiles/plan_profile.dir/cmake_pch.hxx
src/codegen_output/CMakeFiles/plan_profile.dir/cmake_pch.hxx.pch: src/codegen_output/CMakeFiles/plan_profile.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/Users/williampark/GraphMini/build_tbb/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object src/codegen_output/CMakeFiles/plan_profile.dir/cmake_pch.hxx.pch"
	cd /Users/williampark/GraphMini/build_tbb/src/codegen_output && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -Winvalid-pch -Xclang -emit-pch -Xclang -include -Xclang /Users/williampark/GraphMini/build_tbb/src/codegen_output/CMakeFiles/plan_profile.dir/cmake_pch.hxx -x c++-header -MD -MT src/codegen_output/CMakeFiles/plan_profile.dir/cmake_pch.hxx.pch -MF CMakeFiles/plan_profile.dir/cmake_pch.hxx.pch.d -o CMakeFiles/plan_profile.dir/cmake_pch.hxx.pch -c /Users/williampark/GraphMini/build_tbb/src/codegen_output/CMakeFiles/plan_profile.dir/cmake_pch.hxx.cxx

src/codegen_output/CMakeFiles/plan_profile.dir/cmake_pch.hxx.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/plan_profile.dir/cmake_pch.hxx.i"
	cd /Users/williampark/GraphMini/build_tbb/src/codegen_output && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -Winvalid-pch -Xclang -emit-pch -Xclang -include -Xclang /Users/williampark/GraphMini/build_tbb/src/codegen_output/CMakeFiles/plan_profile.dir/cmake_pch.hxx -x c++-header -E /Users/williampark/GraphMini/build_tbb/src/codegen_output/CMakeFiles/plan_profile.dir/cmake_pch.hxx.cxx > CMakeFiles/plan_profile.dir/cmake_pch.hxx.i

src/codegen_output/CMakeFiles/plan_profile.dir/cmake_pch.hxx.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/plan_profile.dir/cmake_pch.hxx.s"
	cd /Users/williampark/GraphMini/build_tbb/src/codegen_output && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -Winvalid-pch -Xclang -emit-pch -Xclang -include -Xclang /Users/williampark/GraphMini/build_tbb/src/codegen_output/CMakeFiles/plan_profile.dir/cmake_pch.hxx -x c++-header -S /Users/williampark/GraphMini/build_tbb/src/codegen_output/CMakeFiles/plan_profile.dir/cmake_pch.hxx.cxx -o CMakeFiles/plan_profile.dir/cmake_pch.hxx.s

src/codegen_output/CMakeFiles/plan_profile.dir/plan_profile.cpp.o: src/codegen_output/CMakeFiles/plan_profile.dir/flags.make
src/codegen_output/CMakeFiles/plan_profile.dir/plan_profile.cpp.o: /Users/williampark/GraphMini/src/codegen_output/plan_profile.cpp
src/codegen_output/CMakeFiles/plan_profile.dir/plan_profile.cpp.o: src/codegen_output/CMakeFiles/plan_profile.dir/cmake_pch.hxx
src/codegen_output/CMakeFiles/plan_profile.dir/plan_profile.cpp.o: src/codegen_output/CMakeFiles/plan_profile.dir/cmake_pch.hxx.pch
src/codegen_output/CMakeFiles/plan_profile.dir/plan_profile.cpp.o: src/codegen_output/CMakeFiles/plan_profile.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/Users/williampark/GraphMini/build_tbb/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object src/codegen_output/CMakeFiles/plan_profile.dir/plan_profile.cpp.o"
	cd /Users/williampark/GraphMini/build_tbb/src/codegen_output && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -Winvalid-pch -Xclang -include-pch -Xclang /Users/williampark/GraphMini/build_tbb/src/codegen_output/CMakeFiles/plan_profile.dir/cmake_pch.hxx.pch -Xclang -include -Xclang /Users/williampark/GraphMini/build_tbb/src/codegen_output/CMakeFiles/plan_profile.dir/cmake_pch.hxx -MD -MT src/codegen_output/CMakeFiles/plan_profile.dir/plan_profile.cpp.o -MF CMakeFiles/plan_profile.dir/plan_profile.cpp.o.d -o CMakeFiles/plan_profile.dir/plan_profile.cpp.o -c /Users/williampark/GraphMini/src/codegen_output/plan_profile.cpp

src/codegen_output/CMakeFiles/plan_profile.dir/plan_profile.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/plan_profile.dir/plan_profile.cpp.i"
	cd /Users/williampark/GraphMini/build_tbb/src/codegen_output && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -Winvalid-pch -Xclang -include-pch -Xclang /Users/williampark/GraphMini/build_tbb/src/codegen_output/CMakeFiles/plan_profile.dir/cmake_pch.hxx.pch -Xclang -include -Xclang /Users/williampark/GraphMini/build_tbb/src/codegen_output/CMakeFiles/plan_profile.dir/cmake_pch.hxx -E /Users/williampark/GraphMini/src/codegen_output/plan_profile.cpp > CMakeFiles/plan_profile.dir/plan_profile.cpp.i

src/codegen_output/CMakeFiles/plan_profile.dir/plan_profile.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/plan_profile.dir/plan_profile.cpp.s"
	cd /Users/williampark/GraphMini/build_tbb/src/codegen_output && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -Winvalid-pch -Xclang -include-pch -Xclang /Users/williampark/GraphMini/build_tbb/src/codegen_output/CMakeFiles/plan_profile.dir/cmake_pch.hxx.pch -Xclang -include -Xclang /Users/williampark/GraphMini/build_tbb/src/codegen_output/CMakeFiles/plan_profile.dir/cmake_pch.hxx -S /Users/williampark/GraphMini/src/codegen_output/plan_profile.cpp -o CMakeFiles/plan_profile.dir/plan_profile.cpp.s

# Object files for target plan_profile
plan_profile_OBJECTS = \
"CMakeFiles/plan_profile.dir/plan_profile.cpp.o"

# External object files for target plan_profile
plan_profile_EXTERNAL_OBJECTS =

src/codegen_output/libplan_profile.a: src/codegen_output/CMakeFiles/plan_profile.dir/cmake_pch.hxx.pch
src/codegen_output/libplan_profile.a: src/codegen_output/CMakeFiles/plan_profile.dir/plan_profile.cpp.o
src/codegen_output/libplan_profile.a: src/codegen_output/CMakeFiles/plan_profile.dir/build.make
src/codegen_output/libplan_profile.a: src/codegen_output/CMakeFiles/plan_profile.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --bold --progress-dir=/Users/williampark/GraphMini/build_tbb/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Linking CXX static library libplan_profile.a"
	cd /Users/williampark/GraphMini/build_tbb/src/codegen_output && $(CMAKE_COMMAND) -P CMakeFiles/plan_profile.dir/cmake_clean_target.cmake
	cd /Users/williampark/GraphMini/build_tbb/src/codegen_output && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/plan_profile.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/codegen_output/CMakeFiles/plan_profile.dir/build: src/codegen_output/libplan_profile.a
.PHONY : src/codegen_output/CMakeFiles/plan_profile.dir/build

src/codegen_output/CMakeFiles/plan_profile.dir/clean:
	cd /Users/williampark/GraphMini/build_tbb/src/codegen_output && $(CMAKE_COMMAND) -P CMakeFiles/plan_profile.dir/cmake_clean.cmake
.PHONY : src/codegen_output/CMakeFiles/plan_profile.dir/clean

src/codegen_output/CMakeFiles/plan_profile.dir/depend:
	cd /Users/williampark/GraphMini/build_tbb && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/williampark/GraphMini /Users/williampark/GraphMini/src/codegen_output /Users/williampark/GraphMini/build_tbb /Users/williampark/GraphMini/build_tbb/src/codegen_output /Users/williampark/GraphMini/build_tbb/src/codegen_output/CMakeFiles/plan_profile.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : src/codegen_output/CMakeFiles/plan_profile.dir/depend

