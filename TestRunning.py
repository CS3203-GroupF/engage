import unittest

# Updated user data with correct credentials
user_data = {
    "Tarc0000": {"password": "0515", "position": "Advisor"},
    "Brau2699": {"password": "0427", "position": "Student"},
    "Virt7711": {"password": "0212", "position": "Staff"},
    "Jkzzf0000": {"password": "1121", "position": "Student"},
    "Bita4444": {"password": "0212", "position": "Staff"},
    "Tawk6133": {"password": "0819", "position": "Student"},
    "Jon4170": {"password": "0731", "position": "Student"},
    "Jott1010": {"password": "5512", "position": "Advisor"}
}

# Function to validate and return position
def get_position(username, password):
    # Check if the username follows the 4-letter, 4-number format
    if len(username) != 8 or not username[:4].isalpha() or not username[4:].isdigit():
        return "Invalid username format"
    
    # Check if the password is 4 digits
    if len(password) != 4 or not password.isdigit():
        return "Invalid password format"
    
    # Validate the user credentials
    if username in user_data and user_data[username]["password"] == password:
        return user_data[username]["position"]
    else:
        return "Invalid username or password"

# Unit test class
class TestLoginSystem(unittest.TestCase):
    
    def test_valid_credentials(self):
        self.assertEqual(get_position("Tarc0000", "0515"), "Advisor")
        self.assertEqual(get_position("Brau2699", "0427"), "Student")
        self.assertEqual(get_position("Virt7711", "0212"), "Staff")
        self.assertEqual(get_position("Jkzzf0000", "1121"), "Student")
        self.assertEqual(get_position("Bita4444", "0212"), "Staff")
        self.assertEqual(get_position("Tawk6133", "0819"), "Student")
        self.assertEqual(get_position("Jon4170", "0731"), "Student")
        self.assertEqual(get_position("Jott1010", "5512"), "Advisor")
    
    def test_wrong_credentials(self):
        # Wrong cases
        self.assertEqual(get_position("Jkzf0000", "1121"), "Invalid username or password")  # Jkzf vs Jkzzf
        self.assertEqual(get_position("Jon!4170", "0731"), "Invalid username format")  # Special character
        self.assertEqual(get_position("Jott1010", "55102"), "Invalid password format")  # Password too long

if __name__ == "__main__":
    unittest.main()