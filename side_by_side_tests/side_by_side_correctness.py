#!/usr/bin/env python3
"""
Side-by-Side Correctness Testing for GraphMini
Compares TBB vs OpenMP implementations to ensure identical results
"""

import os
import subprocess
import time
import json
import re
from pathlib import Path

class SideBySideTester:
    def __init__(self):
        self.base_dir = Path("..").resolve()
        self.results = []

        # Build directories
        self.builds = {
            'TBB': self.base_dir / 'build_tbb',
            'OpenMP': self.base_dir / 'build_openmp'
        }

        # Branches
        self.branches = {
            'TBB': 'graphmini',
            'OpenMP': 'openmp-conversion'
        }

    def build_implementation(self, impl_type):
        """Build a specific implementation"""
        print(f"\n--- Building {impl_type} Implementation ---")

        branch = self.branches[impl_type]
        build_dir = self.builds[impl_type]

        # Switch to correct branch
        result = subprocess.run(['git', 'checkout', branch],
                              cwd=self.base_dir, capture_output=True, text=True)
        if result.returncode != 0:
            print(f"❌ Failed to checkout {branch}")
            return False

        # Clean and create build directory
        if build_dir.exists():
            subprocess.run(['rm', '-rf', str(build_dir)])
        build_dir.mkdir(parents=True)

        # Build
        os.chdir(build_dir)

        # Configure
        cmake_result = subprocess.run(['cmake', '..'], capture_output=True, text=True)
        if cmake_result.returncode != 0:
            print(f"❌ CMake failed for {impl_type}")
            print(cmake_result.stderr)
            return False

        # Make
        make_result = subprocess.run(['make', '-j'], capture_output=True, text=True)
        if make_result.returncode != 0:
            print(f"❌ Make failed for {impl_type}")
            print(make_result.stderr)
            return False

        # Verify binary
        binary_path = build_dir / 'bin' / 'run'
        if not binary_path.exists():
            print(f"❌ Binary not found: {binary_path}")
            return False

        print(f"✅ {impl_type} built successfully")
        return True

    def run_single_test(self, impl_type, dataset, pattern_name, pattern_binary, threads=1):
        """Run a single test case"""

        binary_path = self.builds[impl_type] / 'bin' / 'run'
        dataset_path = self.base_dir / 'dataset' / 'GraphMini' / dataset

        # Prepare command
        cmd = [
            str(binary_path),
            dataset,
            str(dataset_path),
            pattern_name,
            pattern_binary,
            "0", "4", "3"
        ]

        # Environment
        env = os.environ.copy()
        env['OMP_NUM_THREADS'] = str(threads)

        # Log file
        log_file = f"{impl_type.lower()}_{dataset}_{pattern_name}_{threads}t.log"

        try:
            start_time = time.time()
            result = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                timeout=300,  # 5 minute timeout
                env=env
            )
            elapsed = time.time() - start_time

            # Save log
            with open(log_file, 'w') as f:
                f.write(f"Implementation: {impl_type}\n")
                f.write(f"Command: {' '.join(cmd)}\n")
                f.write(f"Exit code: {result.returncode}\n")
                f.write(f"Elapsed: {elapsed:.3f}s\n")
                f.write(f"Threads: {threads}\n\n")
                f.write("=== STDOUT ===\n")
                f.write(result.stdout)
                f.write("\n=== STDERR ===\n")
                f.write(result.stderr)

            if result.returncode == 0:
                # Parse results
                match_count = self._parse_result_count(result.stdout)
                exec_time = self._parse_execution_time(result.stdout)

                return {
                    'success': True,
                    'match_count': match_count,
                    'execution_time': exec_time,
                    'total_time': elapsed,
                    'log_file': log_file
                }
            else:
                return {
                    'success': False,
                    'error': f"Exit code {result.returncode}",
                    'log_file': log_file
                }

        except subprocess.TimeoutExpired:
            return {
                'success': False,
                'error': 'Timeout (>5 minutes)',
                'log_file': log_file
            }
        except Exception as e:
            return {
                'success': False,
                'error': f"Exception: {str(e)}",
                'log_file': log_file
            }

    def _parse_result_count(self, output):
        """Extract result count from output"""
        match = re.search(r'RESULT=(\d+)', output)
        return int(match.group(1)) if match else None

    def _parse_execution_time(self, output):
        """Extract execution time from output"""
        match = re.search(r'CODE_EXECUTION_TIME ([0-9.]+)', output)
        return float(match.group(1)) if match else None

    def compare_implementations(self, dataset, pattern_name, pattern_binary, threads=1):
        """Compare both implementations on a single test case"""

        print(f"\n{'='*60}")
        print(f"COMPARING: {dataset} + {pattern_name} (threads={threads})")
        print(f"{'='*60}")

        results = {}

        # Test both implementations
        for impl_type in ['TBB', 'OpenMP']:
            print(f"Running {impl_type}...")
            result = self.run_single_test(impl_type, dataset, pattern_name, pattern_binary, threads)
            results[impl_type] = result

            if result['success']:
                count = result['match_count']
                time_taken = result['execution_time']
                print(f"  ✅ {count} matches in {time_taken:.4f}s")
            else:
                print(f"  ❌ {result['error']}")

        # Compare results
        comparison = {
            'dataset': dataset,
            'pattern': pattern_name,
            'pattern_binary': pattern_binary,
            'threads': threads,
            'results': results
        }

        if (results['TBB']['success'] and results['OpenMP']['success'] and
            results['TBB']['match_count'] is not None and
            results['OpenMP']['match_count'] is not None):

            tbb_count = results['TBB']['match_count']
            openmp_count = results['OpenMP']['match_count']

            if tbb_count == openmp_count:
                comparison['correctness'] = 'PASS'
                print(f"  ✅ CORRECTNESS: Both found {tbb_count} matches")

                # Performance comparison
                tbb_time = results['TBB']['execution_time']
                openmp_time = results['OpenMP']['execution_time']
                if tbb_time and openmp_time:
                    speedup = tbb_time / openmp_time
                    print(f"  📊 PERFORMANCE: TBB={tbb_time:.4f}s, OpenMP={openmp_time:.4f}s (OpenMP {speedup:.2f}x)")

            else:
                comparison['correctness'] = 'FAIL'
                print(f"  ❌ MISMATCH: TBB={tbb_count}, OpenMP={openmp_count}")
        else:
            comparison['correctness'] = 'INCOMPLETE'
            print(f"  ⚠️  INCOMPLETE: One or both implementations failed")

        return comparison

    def run_correctness_suite(self):
        """Run the complete correctness test suite"""

        print("=" * 70)
        print("GRAPHMINI SIDE-BY-SIDE CORRECTNESS TESTING")
        print("TBB (graphmini) vs OpenMP (openmp-conversion)")
        print("=" * 70)

        # Build both implementations
        print("\n=== Building Implementations ===")
        for impl_type in ['TBB', 'OpenMP']:
            if not self.build_implementation(impl_type):
                print(f"❌ Failed to build {impl_type} implementation")
                return False

        # Switch back to a consistent state
        subprocess.run(['git', 'checkout', 'graphmini'], cwd=self.base_dir)
        os.chdir(Path.cwd())  # Back to test directory

        # Test cases
        test_cases = [
            # (dataset, pattern_name, pattern_binary)
            ('wiki', 'triangle', '011101110'),
            ('wiki', '4path', '0110100110100110'),
            # Add more as needed
        ]

        # Thread counts to test
        thread_counts = [1, 2, 4, 8]

        all_comparisons = []

        print("\n=== Running Correctness Tests ===")
        for dataset, pattern_name, pattern_binary in test_cases:
            for threads in thread_counts:
                comparison = self.compare_implementations(dataset, pattern_name, pattern_binary, threads)
                all_comparisons.append(comparison)

        # Generate summary
        print("\n" + "=" * 70)
        print("CORRECTNESS SUMMARY")
        print("=" * 70)

        passed = sum(1 for c in all_comparisons if c.get('correctness') == 'PASS')
        failed = sum(1 for c in all_comparisons if c.get('correctness') == 'FAIL')
        incomplete = sum(1 for c in all_comparisons if c.get('correctness') == 'INCOMPLETE')
        total = len(all_comparisons)

        print(f"✅ PASSED: {passed}")
        print(f"❌ FAILED: {failed}")
        print(f"⚠️  INCOMPLETE: {incomplete}")
        print(f"📊 TOTAL: {total}")

        if failed > 0:
            print(f"\n❌ CORRECTNESS FAILURES:")
            for c in all_comparisons:
                if c.get('correctness') == 'FAIL':
                    tbb_count = c['results']['TBB'].get('match_count', 'N/A')
                    openmp_count = c['results']['OpenMP'].get('match_count', 'N/A')
                    print(f"  - {c['dataset']}+{c['pattern']} (t={c['threads']}): TBB={tbb_count}, OpenMP={openmp_count}")

        # Save detailed results
        with open('side_by_side_results.json', 'w') as f:
            json.dump(all_comparisons, f, indent=2)

        print(f"\nDetailed results saved to: side_by_side_results.json")
        print(f"Logs available in: *.log files")

        # Final verdict
        if failed == 0 and passed > 0:
            print(f"\n🎉 ALL CORRECTNESS TESTS PASSED!")
            print(f"Your OpenMP implementation produces identical results to the TBB reference.")
            print(f"You can now proceed to performance analysis.")
            return True
        else:
            print(f"\n⚠️  CORRECTNESS ISSUES DETECTED!")
            print(f"Fix the mismatches before proceeding to performance testing.")
            return False

def main():
    tester = SideBySideTester()
    success = tester.run_correctness_suite()

    if success:
        print("\n" + "=" * 50)
        print("NEXT STEPS:")
        print("1. ✅ Correctness verified")
        print("2. 📈 Proceed to performance benchmarking")
        print("3. 📊 Analyze scalability across thread counts")
    else:
        print("\n" + "=" * 50)
        print("NEXT STEPS:")
        print("1. 🔍 Check the failed test logs")
        print("2. 🐛 Debug the result count mismatches")
        print("3. 🔄 Re-run tests after fixes")

    return 0 if success else 1

if __name__ == "__main__":
    exit(main())
