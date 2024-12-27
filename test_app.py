import unittest
from app import app, db
from unittest.mock import patch
import json
from io import BytesIO

class TestExpenseReport(unittest.TestCase):

    def setUp(self):
        self.app = app.test_client()
        # Consider using an in-memory database for testing (e.g., SQLite)

    def tearDown(self):
        # Clean up any resources (if needed)
        pass

    def test_index_route_get(self):
        response = self.app.get('/')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'Select User:', response.data)  # Check for the user selection form

    def test_index_route_post(self):
        data = {'user_id': 1}  # Replace with a valid user ID
        response = self.app.post('/', data=data)
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'Expense Report for User 1', response.data)  # Check for user-specific report

    def test_index_route_invalid_user_id(self):
        data = {'user_id': 'invalid'}
        response = self.app.post('/', data=data)
        self.assertEqual(response.status_code, 200)  # Assuming the application handles invalid input gracefully
        # Check for appropriate error message or lack of data

    def test_download_csv(self):
        user_id = 1  # Replace with a valid user ID
        response = self.app.get(f'/download/csv?user_id={user_id}')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.content_type, 'text/csv; charset=utf-8')
        # Perform basic content checks (e.g., check for expected headers)

    def test_download_excel(self):
        user_id = 1
        response = self.app.get(f'/download/excel?user_id={user_id}')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.content_type, 
                         'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')

    def test_download_pdf(self):
        user_id = 1
        response = self.app.get(f'/download/pdf?user_id={user_id}')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.content_type, 'application/pdf')

    @patch('app.db.session.query')
    def test_no_expenses_for_user(self, mock_query):
        mock_query.return_value.join.return_value.filter.return_value.all.return_value = []
        response = self.app.get('/')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'No expenses found for the selected user.', response.data)

    @patch('app.db.session.query')
    def test_database_error(self, mock_query):
        mock_query.side_effect = Exception("Database error")
        response = self.app.get('/')
        self.assertEqual(response.status_code, 500)  # Assuming the application handles database errors

    def test_chart_js_data(self):
        # Simulate a response with category totals
        response = self.app.get('/')  # Assuming the route returns category totals in JSON
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.data)
        self.assertIn('category_totals', data)
        # Check that category_totals is a dictionary with valid data

    def test_empty_category_totals(self):
        # Simulate a response with empty category totals
        response = self.app.get('/')  # Assuming the route handles this case
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.data)
        self.assertIn('category_totals', data)
        self.assertEqual(data['category_totals'], {})

    def test_csv_content(self):
        # Simulate user selection
        user_id = 1  # Replace with a valid user ID
        response = self.app.get(f'/download/csv?user_id={user_id}')
        csv_data = response.data.decode('utf-8')
        # Check for expected headers and sample data in the CSV content

    def test_excel_content(self):
        user_id = 1
        response = self.app.get(f'/download/excel?user_id={user_id}')
        # Perform basic checks on the Excel content (e.g., check for sheet names)

    def test_pdf_content(self):
        user_id = 1
        response = self.app.get(f'/download/pdf?user_id={user_id}')
        # Perform basic checks on the PDF content (e.g., check for expected text)

    # Add more tests for specific edge cases or complex scenarios as needed

if __name__ == '__main__':
    unittest.main()