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
CMAKE_SOURCE_DIR = /Users/williampark/GraphMini/build_tbb/_deps/cxxopts-subbuild

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/williampark/GraphMini/build_tbb/_deps/cxxopts-subbuild

# Utility rule file for cxxopts-populate.

# Include any custom commands dependencies for this target.
include CMakeFiles/cxxopts-populate.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/cxxopts-populate.dir/progress.make

CMakeFiles/cxxopts-populate: CMakeFiles/cxxopts-populate-complete

CMakeFiles/cxxopts-populate-complete: cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-install
CMakeFiles/cxxopts-populate-complete: cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-mkdir
CMakeFiles/cxxopts-populate-complete: cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-download
CMakeFiles/cxxopts-populate-complete: cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-update
CMakeFiles/cxxopts-populate-complete: cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-patch
CMakeFiles/cxxopts-populate-complete: cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-configure
CMakeFiles/cxxopts-populate-complete: cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-build
CMakeFiles/cxxopts-populate-complete: cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-install
CMakeFiles/cxxopts-populate-complete: cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-test
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --blue --bold --progress-dir=/Users/williampark/GraphMini/build_tbb/_deps/cxxopts-subbuild/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Completed 'cxxopts-populate'"
	/opt/homebrew/bin/cmake -E make_directory /Users/williampark/GraphMini/build_tbb/_deps/cxxopts-subbuild/CMakeFiles
	/opt/homebrew/bin/cmake -E touch /Users/williampark/GraphMini/build_tbb/_deps/cxxopts-subbuild/CMakeFiles/cxxopts-populate-complete
	/opt/homebrew/bin/cmake -E touch /Users/williampark/GraphMini/build_tbb/_deps/cxxopts-subbuild/cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-done

cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-update:
.PHONY : cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-update

cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-build: cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-configure
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --blue --bold --progress-dir=/Users/williampark/GraphMini/build_tbb/_deps/cxxopts-subbuild/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "No build step for 'cxxopts-populate'"
	cd /Users/williampark/GraphMini/build_tbb/_deps/cxxopts-build && /opt/homebrew/bin/cmake -E echo_append
	cd /Users/williampark/GraphMini/build_tbb/_deps/cxxopts-build && /opt/homebrew/bin/cmake -E touch /Users/williampark/GraphMini/build_tbb/_deps/cxxopts-subbuild/cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-build

cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-configure: cxxopts-populate-prefix/tmp/cxxopts-populate-cfgcmd.txt
cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-configure: cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-patch
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --blue --bold --progress-dir=/Users/williampark/GraphMini/build_tbb/_deps/cxxopts-subbuild/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "No configure step for 'cxxopts-populate'"
	cd /Users/williampark/GraphMini/build_tbb/_deps/cxxopts-build && /opt/homebrew/bin/cmake -E echo_append
	cd /Users/williampark/GraphMini/build_tbb/_deps/cxxopts-build && /opt/homebrew/bin/cmake -E touch /Users/williampark/GraphMini/build_tbb/_deps/cxxopts-subbuild/cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-configure

cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-download: cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-gitinfo.txt
cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-download: cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-mkdir
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --blue --bold --progress-dir=/Users/williampark/GraphMini/build_tbb/_deps/cxxopts-subbuild/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Performing download step (git clone) for 'cxxopts-populate'"
	cd /Users/williampark/GraphMini/build_tbb/_deps && /opt/homebrew/bin/cmake -DCMAKE_MESSAGE_LOG_LEVEL=VERBOSE -P /Users/williampark/GraphMini/build_tbb/_deps/cxxopts-subbuild/cxxopts-populate-prefix/tmp/cxxopts-populate-gitclone.cmake
	cd /Users/williampark/GraphMini/build_tbb/_deps && /opt/homebrew/bin/cmake -E touch /Users/williampark/GraphMini/build_tbb/_deps/cxxopts-subbuild/cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-download

cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-install: cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-build
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --blue --bold --progress-dir=/Users/williampark/GraphMini/build_tbb/_deps/cxxopts-subbuild/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "No install step for 'cxxopts-populate'"
	cd /Users/williampark/GraphMini/build_tbb/_deps/cxxopts-build && /opt/homebrew/bin/cmake -E echo_append
	cd /Users/williampark/GraphMini/build_tbb/_deps/cxxopts-build && /opt/homebrew/bin/cmake -E touch /Users/williampark/GraphMini/build_tbb/_deps/cxxopts-subbuild/cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-install

cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-mkdir:
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --blue --bold --progress-dir=/Users/williampark/GraphMini/build_tbb/_deps/cxxopts-subbuild/CMakeFiles --progress-num=$(CMAKE_PROGRESS_6) "Creating directories for 'cxxopts-populate'"
	/opt/homebrew/bin/cmake -Dcfgdir= -P /Users/williampark/GraphMini/build_tbb/_deps/cxxopts-subbuild/cxxopts-populate-prefix/tmp/cxxopts-populate-mkdirs.cmake
	/opt/homebrew/bin/cmake -E touch /Users/williampark/GraphMini/build_tbb/_deps/cxxopts-subbuild/cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-mkdir

cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-patch: cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-patch-info.txt
cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-patch: cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-update
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --blue --bold --progress-dir=/Users/williampark/GraphMini/build_tbb/_deps/cxxopts-subbuild/CMakeFiles --progress-num=$(CMAKE_PROGRESS_7) "No patch step for 'cxxopts-populate'"
	/opt/homebrew/bin/cmake -E echo_append
	/opt/homebrew/bin/cmake -E touch /Users/williampark/GraphMini/build_tbb/_deps/cxxopts-subbuild/cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-patch

cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-update:
.PHONY : cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-update

cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-test: cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-install
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --blue --bold --progress-dir=/Users/williampark/GraphMini/build_tbb/_deps/cxxopts-subbuild/CMakeFiles --progress-num=$(CMAKE_PROGRESS_8) "No test step for 'cxxopts-populate'"
	cd /Users/williampark/GraphMini/build_tbb/_deps/cxxopts-build && /opt/homebrew/bin/cmake -E echo_append
	cd /Users/williampark/GraphMini/build_tbb/_deps/cxxopts-build && /opt/homebrew/bin/cmake -E touch /Users/williampark/GraphMini/build_tbb/_deps/cxxopts-subbuild/cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-test

cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-update: cxxopts-populate-prefix/tmp/cxxopts-populate-gitupdate.cmake
cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-update: cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-update-info.txt
cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-update: cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-download
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --blue --bold --progress-dir=/Users/williampark/GraphMini/build_tbb/_deps/cxxopts-subbuild/CMakeFiles --progress-num=$(CMAKE_PROGRESS_9) "Performing update step for 'cxxopts-populate'"
	cd /Users/williampark/GraphMini/build_tbb/_deps/cxxopts-src && /opt/homebrew/bin/cmake -Dcan_fetch=YES -DCMAKE_MESSAGE_LOG_LEVEL=VERBOSE -P /Users/williampark/GraphMini/build_tbb/_deps/cxxopts-subbuild/cxxopts-populate-prefix/tmp/cxxopts-populate-gitupdate.cmake

CMakeFiles/cxxopts-populate.dir/codegen:
.PHONY : CMakeFiles/cxxopts-populate.dir/codegen

cxxopts-populate: CMakeFiles/cxxopts-populate
cxxopts-populate: CMakeFiles/cxxopts-populate-complete
cxxopts-populate: cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-build
cxxopts-populate: cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-configure
cxxopts-populate: cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-download
cxxopts-populate: cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-install
cxxopts-populate: cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-mkdir
cxxopts-populate: cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-patch
cxxopts-populate: cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-test
cxxopts-populate: cxxopts-populate-prefix/src/cxxopts-populate-stamp/cxxopts-populate-update
cxxopts-populate: CMakeFiles/cxxopts-populate.dir/build.make
.PHONY : cxxopts-populate

# Rule to build all files generated by this target.
CMakeFiles/cxxopts-populate.dir/build: cxxopts-populate
.PHONY : CMakeFiles/cxxopts-populate.dir/build

CMakeFiles/cxxopts-populate.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/cxxopts-populate.dir/cmake_clean.cmake
.PHONY : CMakeFiles/cxxopts-populate.dir/clean

CMakeFiles/cxxopts-populate.dir/depend:
	cd /Users/williampark/GraphMini/build_tbb/_deps/cxxopts-subbuild && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/williampark/GraphMini/build_tbb/_deps/cxxopts-subbuild /Users/williampark/GraphMini/build_tbb/_deps/cxxopts-subbuild /Users/williampark/GraphMini/build_tbb/_deps/cxxopts-subbuild /Users/williampark/GraphMini/build_tbb/_deps/cxxopts-subbuild /Users/williampark/GraphMini/build_tbb/_deps/cxxopts-subbuild/CMakeFiles/cxxopts-populate.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : CMakeFiles/cxxopts-populate.dir/depend

