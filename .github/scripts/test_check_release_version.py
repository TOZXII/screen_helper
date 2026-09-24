from pathlib import Path
import subprocess
import sys
import tempfile
import unittest


SCRIPT = Path(__file__).with_name("check_release_version.py").resolve()


class ReleaseVersionCheckTest(unittest.TestCase):
    def run_check(self, tag, pubspec):
        with tempfile.TemporaryDirectory() as directory:
            if pubspec is not None:
                Path(directory, "pubspec.yaml").write_text(pubspec, encoding="utf-8")
            return subprocess.run(
                [sys.executable, str(SCRIPT), tag],
                cwd=directory,
                capture_output=True,
                text=True,
                check=False,
            )

    def test_matching_versions(self):
        for version in ("1.2.3", "10.20.300", "1.2.3-rc.1", "1.2.3+4"):
            with self.subTest(version=version):
                result = self.run_check(version, f"name: screen_helper\nversion: {version}\n")
                self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_yaml_scalar_formatting(self):
        for field in (
            "version: '1.2.3'",
            'version: "1.2.3"',
            "version:\t1.2.3  # release version",
            'version: "1.2.3" # release version',
            "version: '1.2.3'  # release version",
            "version: 1.2.3  \r\n",
        ):
            with self.subTest(field=field):
                result = self.run_check("1.2.3", field)
                self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_mismatch_reports_both_versions_and_fails(self):
        result = self.run_check("1.2.4", "version: 1.2.3\n")
        self.assertEqual(result.returncode, 1)
        self.assertIn("::error file=pubspec.yaml::", result.stdout)
        self.assertIn("Release tag '1.2.4'", result.stdout)
        self.assertIn("pubspec.yaml version '1.2.3'", result.stdout)

    def test_comparison_does_not_normalize_versions(self):
        for tag, version in (
            ("v1.2.3", "1.2.3"),
            ("1.2.3", "1.2.3+4"),
            ("1.2.3", "1.2.3-rc.1"),
            ("1.2.3+4", "1.2.3+5"),
            ("1.2.03", "1.2.3"),
            ("", "1.2.3"),
        ):
            with self.subTest(tag=tag, version=version):
                result = self.run_check(tag, f"version: {version}\n")
                self.assertEqual(result.returncode, 1)
                self.assertIn("does not match", result.stdout)

    def test_missing_or_invalid_version_fails(self):
        for pubspec in (
            "name: screen_helper\n",
            "# version: 1.2.3\n",
            "dependencies:\n  dependency:\n    version: 1.2.3\n",
            "version:\n",
            'version: ""\n',
            'version: "1.2.3\n',
            "version: 1.2.3\nversion: 1.2.3\n",
            "version: 1.2.3\nversion:\n",
        ):
            with self.subTest(pubspec=pubspec):
                result = self.run_check("1.2.3", pubspec)
                self.assertEqual(result.returncode, 1)
                self.assertIn("::error file=pubspec.yaml::", result.stdout)
                self.assertIn("version: field", result.stdout)

    def test_missing_pubspec_fails(self):
        result = self.run_check("1.2.3", None)
        self.assertEqual(result.returncode, 1)
        self.assertIn("::error file=pubspec.yaml::Cannot read pubspec.yaml", result.stdout)


if __name__ == "__main__":
    unittest.main()
