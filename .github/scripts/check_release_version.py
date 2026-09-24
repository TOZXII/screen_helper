"""Require an exact match between a release tag and pubspec.yaml's version."""

from pathlib import Path
import re
import sys


def fail(message):
    message = message.replace("%", "%25").replace("\r", "%0D").replace("\n", "%0A")
    print(f"::error file=pubspec.yaml::{message}")
    return 1


def check_release_version(tag):
    try:
        lines = Path("pubspec.yaml").read_text(encoding="utf-8").splitlines()
    except OSError as error:
        return fail(f"Cannot read pubspec.yaml: {error}")

    # Accept the usual single-line YAML scalars, including quotes and comments.
    # Fail closed for missing, duplicate, empty, or unsupported version fields.
    version_lines = [line for line in lines if re.match(r"^version[ \t]*:", line)]
    match = None
    if len(version_lines) == 1:
        match = re.fullmatch(
            r"""version[ \t]*:[ \t]*(?:"([^"]+)"|'([^']+)'|([^ \t'"]+))"""
            r"(?:[ \t]+#.*)?[ \t]*",
            version_lines[0],
        )
    if match is None:
        return fail("pubspec.yaml must contain exactly one non-empty, single-line version: field.")

    version = next(value for value in match.groups() if value is not None)
    if tag != version:
        return fail(
            f"Release tag '{tag}' does not match pubspec.yaml version '{version}'. "
            "Update pubspec.yaml or push a tag that exactly matches its version."
        )

    print(f"Release tag '{tag}' matches pubspec.yaml version '{version}'.")
    return 0


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit("Usage: python3 check_release_version.py RELEASE_TAG")
    sys.exit(check_release_version(sys.argv[1]))
