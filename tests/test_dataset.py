import importlib.util
import unittest
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("generate_synthetic_users", ROOT / "scripts/automation/generate_synthetic_users.py")
generator = importlib.util.module_from_spec(spec)
spec.loader.exec_module(generator)


class DatasetTests(unittest.TestCase):
    def test_200_unique_synthetic_identities(self):
        users = generator.generate()
        self.assertEqual(len(users), 200)
        self.assertEqual(len({u["SamAccountName"] for u in users}), 200)
        self.assertTrue(all(u["SamAccountName"].startswith("lab.") for u in users))

    def test_department_distribution(self):
        expected = dict(generator.DISTRIBUTION)
        actual = Counter(u["Department"] for u in generator.generate())
        self.assertEqual(actual, expected)


if __name__ == "__main__":
    unittest.main()
