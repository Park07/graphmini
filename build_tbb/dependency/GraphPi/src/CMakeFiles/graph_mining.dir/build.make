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
include dependency/GraphPi/src/CMakeFiles/graph_mining.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include dependency/GraphPi/src/CMakeFiles/graph_mining.dir/compiler_depend.make

# Include the progress variables for this target.
include dependency/GraphPi/src/CMakeFiles/graph_mining.dir/progress.make

# Include the compile flags for this target's objects.
include dependency/GraphPi/src/CMakeFiles/graph_mining.dir/flags.make

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/codegen:
.PHONY : dependency/GraphPi/src/CMakeFiles/graph_mining.dir/codegen

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/TestClass.cpp.o: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/flags.make
dependency/GraphPi/src/CMakeFiles/graph_mining.dir/TestClass.cpp.o: /Users/williampark/GraphMini/dependency/GraphPi/src/TestClass.cpp
dependency/GraphPi/src/CMakeFiles/graph_mining.dir/TestClass.cpp.o: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/Users/williampark/GraphMini/build_tbb/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object dependency/GraphPi/src/CMakeFiles/graph_mining.dir/TestClass.cpp.o"
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT dependency/GraphPi/src/CMakeFiles/graph_mining.dir/TestClass.cpp.o -MF CMakeFiles/graph_mining.dir/TestClass.cpp.o.d -o CMakeFiles/graph_mining.dir/TestClass.cpp.o -c /Users/williampark/GraphMini/dependency/GraphPi/src/TestClass.cpp

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/TestClass.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/graph_mining.dir/TestClass.cpp.i"
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/williampark/GraphMini/dependency/GraphPi/src/TestClass.cpp > CMakeFiles/graph_mining.dir/TestClass.cpp.i

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/TestClass.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/graph_mining.dir/TestClass.cpp.s"
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/williampark/GraphMini/dependency/GraphPi/src/TestClass.cpp -o CMakeFiles/graph_mining.dir/TestClass.cpp.s

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/graph.cpp.o: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/flags.make
dependency/GraphPi/src/CMakeFiles/graph_mining.dir/graph.cpp.o: /Users/williampark/GraphMini/dependency/GraphPi/src/graph.cpp
dependency/GraphPi/src/CMakeFiles/graph_mining.dir/graph.cpp.o: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/Users/williampark/GraphMini/build_tbb/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object dependency/GraphPi/src/CMakeFiles/graph_mining.dir/graph.cpp.o"
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT dependency/GraphPi/src/CMakeFiles/graph_mining.dir/graph.cpp.o -MF CMakeFiles/graph_mining.dir/graph.cpp.o.d -o CMakeFiles/graph_mining.dir/graph.cpp.o -c /Users/williampark/GraphMini/dependency/GraphPi/src/graph.cpp

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/graph.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/graph_mining.dir/graph.cpp.i"
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/williampark/GraphMini/dependency/GraphPi/src/graph.cpp > CMakeFiles/graph_mining.dir/graph.cpp.i

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/graph.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/graph_mining.dir/graph.cpp.s"
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/williampark/GraphMini/dependency/GraphPi/src/graph.cpp -o CMakeFiles/graph_mining.dir/graph.cpp.s

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/dataloader.cpp.o: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/flags.make
dependency/GraphPi/src/CMakeFiles/graph_mining.dir/dataloader.cpp.o: /Users/williampark/GraphMini/dependency/GraphPi/src/dataloader.cpp
dependency/GraphPi/src/CMakeFiles/graph_mining.dir/dataloader.cpp.o: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/Users/williampark/GraphMini/build_tbb/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object dependency/GraphPi/src/CMakeFiles/graph_mining.dir/dataloader.cpp.o"
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT dependency/GraphPi/src/CMakeFiles/graph_mining.dir/dataloader.cpp.o -MF CMakeFiles/graph_mining.dir/dataloader.cpp.o.d -o CMakeFiles/graph_mining.dir/dataloader.cpp.o -c /Users/williampark/GraphMini/dependency/GraphPi/src/dataloader.cpp

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/dataloader.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/graph_mining.dir/dataloader.cpp.i"
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/williampark/GraphMini/dependency/GraphPi/src/dataloader.cpp > CMakeFiles/graph_mining.dir/dataloader.cpp.i

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/dataloader.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/graph_mining.dir/dataloader.cpp.s"
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/williampark/GraphMini/dependency/GraphPi/src/dataloader.cpp -o CMakeFiles/graph_mining.dir/dataloader.cpp.s

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/pattern.cpp.o: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/flags.make
dependency/GraphPi/src/CMakeFiles/graph_mining.dir/pattern.cpp.o: /Users/williampark/GraphMini/dependency/GraphPi/src/pattern.cpp
dependency/GraphPi/src/CMakeFiles/graph_mining.dir/pattern.cpp.o: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/Users/williampark/GraphMini/build_tbb/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building CXX object dependency/GraphPi/src/CMakeFiles/graph_mining.dir/pattern.cpp.o"
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT dependency/GraphPi/src/CMakeFiles/graph_mining.dir/pattern.cpp.o -MF CMakeFiles/graph_mining.dir/pattern.cpp.o.d -o CMakeFiles/graph_mining.dir/pattern.cpp.o -c /Users/williampark/GraphMini/dependency/GraphPi/src/pattern.cpp

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/pattern.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/graph_mining.dir/pattern.cpp.i"
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/williampark/GraphMini/dependency/GraphPi/src/pattern.cpp > CMakeFiles/graph_mining.dir/pattern.cpp.i

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/pattern.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/graph_mining.dir/pattern.cpp.s"
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/williampark/GraphMini/dependency/GraphPi/src/pattern.cpp -o CMakeFiles/graph_mining.dir/pattern.cpp.s

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/prefix.cpp.o: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/flags.make
dependency/GraphPi/src/CMakeFiles/graph_mining.dir/prefix.cpp.o: /Users/williampark/GraphMini/dependency/GraphPi/src/prefix.cpp
dependency/GraphPi/src/CMakeFiles/graph_mining.dir/prefix.cpp.o: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/Users/williampark/GraphMini/build_tbb/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Building CXX object dependency/GraphPi/src/CMakeFiles/graph_mining.dir/prefix.cpp.o"
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT dependency/GraphPi/src/CMakeFiles/graph_mining.dir/prefix.cpp.o -MF CMakeFiles/graph_mining.dir/prefix.cpp.o.d -o CMakeFiles/graph_mining.dir/prefix.cpp.o -c /Users/williampark/GraphMini/dependency/GraphPi/src/prefix.cpp

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/prefix.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/graph_mining.dir/prefix.cpp.i"
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/williampark/GraphMini/dependency/GraphPi/src/prefix.cpp > CMakeFiles/graph_mining.dir/prefix.cpp.i

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/prefix.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/graph_mining.dir/prefix.cpp.s"
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/williampark/GraphMini/dependency/GraphPi/src/prefix.cpp -o CMakeFiles/graph_mining.dir/prefix.cpp.s

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/schedule.cpp.o: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/flags.make
dependency/GraphPi/src/CMakeFiles/graph_mining.dir/schedule.cpp.o: /Users/williampark/GraphMini/dependency/GraphPi/src/schedule.cpp
dependency/GraphPi/src/CMakeFiles/graph_mining.dir/schedule.cpp.o: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/Users/williampark/GraphMini/build_tbb/CMakeFiles --progress-num=$(CMAKE_PROGRESS_6) "Building CXX object dependency/GraphPi/src/CMakeFiles/graph_mining.dir/schedule.cpp.o"
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT dependency/GraphPi/src/CMakeFiles/graph_mining.dir/schedule.cpp.o -MF CMakeFiles/graph_mining.dir/schedule.cpp.o.d -o CMakeFiles/graph_mining.dir/schedule.cpp.o -c /Users/williampark/GraphMini/dependency/GraphPi/src/schedule.cpp

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/schedule.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/graph_mining.dir/schedule.cpp.i"
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/williampark/GraphMini/dependency/GraphPi/src/schedule.cpp > CMakeFiles/graph_mining.dir/schedule.cpp.i

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/schedule.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/graph_mining.dir/schedule.cpp.s"
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/williampark/GraphMini/dependency/GraphPi/src/schedule.cpp -o CMakeFiles/graph_mining.dir/schedule.cpp.s

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/vertex_set.cpp.o: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/flags.make
dependency/GraphPi/src/CMakeFiles/graph_mining.dir/vertex_set.cpp.o: /Users/williampark/GraphMini/dependency/GraphPi/src/vertex_set.cpp
dependency/GraphPi/src/CMakeFiles/graph_mining.dir/vertex_set.cpp.o: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/Users/williampark/GraphMini/build_tbb/CMakeFiles --progress-num=$(CMAKE_PROGRESS_7) "Building CXX object dependency/GraphPi/src/CMakeFiles/graph_mining.dir/vertex_set.cpp.o"
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT dependency/GraphPi/src/CMakeFiles/graph_mining.dir/vertex_set.cpp.o -MF CMakeFiles/graph_mining.dir/vertex_set.cpp.o.d -o CMakeFiles/graph_mining.dir/vertex_set.cpp.o -c /Users/williampark/GraphMini/dependency/GraphPi/src/vertex_set.cpp

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/vertex_set.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/graph_mining.dir/vertex_set.cpp.i"
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/williampark/GraphMini/dependency/GraphPi/src/vertex_set.cpp > CMakeFiles/graph_mining.dir/vertex_set.cpp.i

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/vertex_set.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/graph_mining.dir/vertex_set.cpp.s"
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/williampark/GraphMini/dependency/GraphPi/src/vertex_set.cpp -o CMakeFiles/graph_mining.dir/vertex_set.cpp.s

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/motif_generator.cpp.o: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/flags.make
dependency/GraphPi/src/CMakeFiles/graph_mining.dir/motif_generator.cpp.o: /Users/williampark/GraphMini/dependency/GraphPi/src/motif_generator.cpp
dependency/GraphPi/src/CMakeFiles/graph_mining.dir/motif_generator.cpp.o: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/Users/williampark/GraphMini/build_tbb/CMakeFiles --progress-num=$(CMAKE_PROGRESS_8) "Building CXX object dependency/GraphPi/src/CMakeFiles/graph_mining.dir/motif_generator.cpp.o"
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT dependency/GraphPi/src/CMakeFiles/graph_mining.dir/motif_generator.cpp.o -MF CMakeFiles/graph_mining.dir/motif_generator.cpp.o.d -o CMakeFiles/graph_mining.dir/motif_generator.cpp.o -c /Users/williampark/GraphMini/dependency/GraphPi/src/motif_generator.cpp

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/motif_generator.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/graph_mining.dir/motif_generator.cpp.i"
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/williampark/GraphMini/dependency/GraphPi/src/motif_generator.cpp > CMakeFiles/graph_mining.dir/motif_generator.cpp.i

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/motif_generator.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/graph_mining.dir/motif_generator.cpp.s"
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/williampark/GraphMini/dependency/GraphPi/src/motif_generator.cpp -o CMakeFiles/graph_mining.dir/motif_generator.cpp.s

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/disjoint_set_union.cpp.o: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/flags.make
dependency/GraphPi/src/CMakeFiles/graph_mining.dir/disjoint_set_union.cpp.o: /Users/williampark/GraphMini/dependency/GraphPi/src/disjoint_set_union.cpp
dependency/GraphPi/src/CMakeFiles/graph_mining.dir/disjoint_set_union.cpp.o: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/Users/williampark/GraphMini/build_tbb/CMakeFiles --progress-num=$(CMAKE_PROGRESS_9) "Building CXX object dependency/GraphPi/src/CMakeFiles/graph_mining.dir/disjoint_set_union.cpp.o"
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT dependency/GraphPi/src/CMakeFiles/graph_mining.dir/disjoint_set_union.cpp.o -MF CMakeFiles/graph_mining.dir/disjoint_set_union.cpp.o.d -o CMakeFiles/graph_mining.dir/disjoint_set_union.cpp.o -c /Users/williampark/GraphMini/dependency/GraphPi/src/disjoint_set_union.cpp

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/disjoint_set_union.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/graph_mining.dir/disjoint_set_union.cpp.i"
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/williampark/GraphMini/dependency/GraphPi/src/disjoint_set_union.cpp > CMakeFiles/graph_mining.dir/disjoint_set_union.cpp.i

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/disjoint_set_union.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/graph_mining.dir/disjoint_set_union.cpp.s"
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/williampark/GraphMini/dependency/GraphPi/src/disjoint_set_union.cpp -o CMakeFiles/graph_mining.dir/disjoint_set_union.cpp.s

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/mpi_stubs.cpp.o: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/flags.make
dependency/GraphPi/src/CMakeFiles/graph_mining.dir/mpi_stubs.cpp.o: /Users/williampark/GraphMini/dependency/GraphPi/src/mpi_stubs.cpp
dependency/GraphPi/src/CMakeFiles/graph_mining.dir/mpi_stubs.cpp.o: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/Users/williampark/GraphMini/build_tbb/CMakeFiles --progress-num=$(CMAKE_PROGRESS_10) "Building CXX object dependency/GraphPi/src/CMakeFiles/graph_mining.dir/mpi_stubs.cpp.o"
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT dependency/GraphPi/src/CMakeFiles/graph_mining.dir/mpi_stubs.cpp.o -MF CMakeFiles/graph_mining.dir/mpi_stubs.cpp.o.d -o CMakeFiles/graph_mining.dir/mpi_stubs.cpp.o -c /Users/williampark/GraphMini/dependency/GraphPi/src/mpi_stubs.cpp

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/mpi_stubs.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/graph_mining.dir/mpi_stubs.cpp.i"
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/williampark/GraphMini/dependency/GraphPi/src/mpi_stubs.cpp > CMakeFiles/graph_mining.dir/mpi_stubs.cpp.i

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/mpi_stubs.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/graph_mining.dir/mpi_stubs.cpp.s"
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/williampark/GraphMini/dependency/GraphPi/src/mpi_stubs.cpp -o CMakeFiles/graph_mining.dir/mpi_stubs.cpp.s

# Object files for target graph_mining
graph_mining_OBJECTS = \
"CMakeFiles/graph_mining.dir/TestClass.cpp.o" \
"CMakeFiles/graph_mining.dir/graph.cpp.o" \
"CMakeFiles/graph_mining.dir/dataloader.cpp.o" \
"CMakeFiles/graph_mining.dir/pattern.cpp.o" \
"CMakeFiles/graph_mining.dir/prefix.cpp.o" \
"CMakeFiles/graph_mining.dir/schedule.cpp.o" \
"CMakeFiles/graph_mining.dir/vertex_set.cpp.o" \
"CMakeFiles/graph_mining.dir/motif_generator.cpp.o" \
"CMakeFiles/graph_mining.dir/disjoint_set_union.cpp.o" \
"CMakeFiles/graph_mining.dir/mpi_stubs.cpp.o"

# External object files for target graph_mining
graph_mining_EXTERNAL_OBJECTS =

lib/libgraph_mining.dylib: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/TestClass.cpp.o
lib/libgraph_mining.dylib: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/graph.cpp.o
lib/libgraph_mining.dylib: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/dataloader.cpp.o
lib/libgraph_mining.dylib: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/pattern.cpp.o
lib/libgraph_mining.dylib: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/prefix.cpp.o
lib/libgraph_mining.dylib: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/schedule.cpp.o
lib/libgraph_mining.dylib: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/vertex_set.cpp.o
lib/libgraph_mining.dylib: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/motif_generator.cpp.o
lib/libgraph_mining.dylib: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/disjoint_set_union.cpp.o
lib/libgraph_mining.dylib: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/mpi_stubs.cpp.o
lib/libgraph_mining.dylib: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/build.make
lib/libgraph_mining.dylib: /opt/homebrew/opt/libomp/lib/libomp.dylib
lib/libgraph_mining.dylib: dependency/GraphPi/src/CMakeFiles/graph_mining.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --bold --progress-dir=/Users/williampark/GraphMini/build_tbb/CMakeFiles --progress-num=$(CMAKE_PROGRESS_11) "Linking CXX shared library ../../../lib/libgraph_mining.dylib"
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/graph_mining.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
dependency/GraphPi/src/CMakeFiles/graph_mining.dir/build: lib/libgraph_mining.dylib
.PHONY : dependency/GraphPi/src/CMakeFiles/graph_mining.dir/build

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/clean:
	cd /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src && $(CMAKE_COMMAND) -P CMakeFiles/graph_mining.dir/cmake_clean.cmake
.PHONY : dependency/GraphPi/src/CMakeFiles/graph_mining.dir/clean

dependency/GraphPi/src/CMakeFiles/graph_mining.dir/depend:
	cd /Users/williampark/GraphMini/build_tbb && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/williampark/GraphMini /Users/williampark/GraphMini/dependency/GraphPi/src /Users/williampark/GraphMini/build_tbb /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src /Users/williampark/GraphMini/build_tbb/dependency/GraphPi/src/CMakeFiles/graph_mining.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : dependency/GraphPi/src/CMakeFiles/graph_mining.dir/depend

