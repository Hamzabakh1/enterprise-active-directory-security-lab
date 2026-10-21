"""Generate deterministic, entirely fictional users for offline lab preparation."""
from __future__ import annotations

import argparse
import csv
from pathlib import Path

DISTRIBUTION = [
    ("IT", 30),
    ("Human Resources", 30),
    ("Finance", 30),
    ("Operations", 50),
    ("Engineering", 40),
    ("Management", 20),
]


def generate() -> list[dict[str, str]]:
    users = []
    number = 1
    for department, count in DISTRIBUTION:
        for _ in range(count):
            token = f"{number:04d}"
            users.append({"GivenName": "Lab", "Surname": f"User{token}",
                          "SamAccountName": f"lab.user{token}", "Department": department})
            number += 1
    return users


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if args.output.exists():
        raise SystemExit("Refusing to overwrite existing data")
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open("w", newline="", encoding="utf-8") as stream:
        writer = csv.DictWriter(stream, fieldnames=["GivenName", "Surname", "SamAccountName", "Department"])
        writer.writeheader()
        writer.writerows(generate())
    print(f"Generated {len(generate())} synthetic identities")


if __name__ == "__main__":
    main()
