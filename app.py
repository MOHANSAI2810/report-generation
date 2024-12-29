from flask import Flask, render_template, send_file, request
import mysql.connector
import pandas as pd
from io import BytesIO
from reportlab.lib.pagesizes import letter
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Paragraph, Spacer
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.lib import colors
from datetime import datetime, timedelta

app = Flask(__name__)

# MySQL Database Configuration
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': 'root',
    'database': 'ProjectUFFT'
}

# Utility function to fetch database connection
def get_db_connection():
    return mysql.connector.connect(**DB_CONFIG)

@app.route('/', methods=['GET', 'POST'])
def index():
    selected_user_id = None
    selected_date = None
    selected_range = None
    selected_categories = []
    expense_data = []
    category_totals = {}
    user_ids = []
    category_names = []
    no_records_message = None

    # Fetch all unique user IDs and category names
    with get_db_connection() as connection:
        with connection.cursor(dictionary=True) as cursor:
            cursor.execute("SELECT DISTINCT user_id FROM expenses")
            user_ids = [row['user_id'] for row in cursor.fetchall()]

            cursor.execute("SELECT name FROM categories")
            category_names = [row['name'] for row in cursor.fetchall()]

    if request.method == 'POST':
        selected_user_id = request.form.get('user_id')
        selected_date = request.form.get('date')
        selected_range = request.form.get('range')
        selected_categories = request.form.getlist('categories')

        try:
            selected_user_id = int(selected_user_id)
        except (ValueError, TypeError):
            selected_user_id = None

        if selected_user_id:
            with get_db_connection() as connection:
                with connection.cursor(dictionary=True) as cursor:
                    sql = """
                        SELECT e.expense_id, c.name AS category, e.amount, e.date, e.description
                        FROM expenses e
                        JOIN categories c ON e.category_id = c.category_id
                        WHERE e.user_id = %s
                    """
                    params = [selected_user_id]

                    # Filter by range
                    if selected_range == "Week":
                        sql += " AND e.date >= %s"
                        params.append((datetime.now() - timedelta(days=7)).strftime('%Y-%m-%d'))
                    elif selected_range == "Month":
                        sql += " AND e.date >= %s"
                        params.append((datetime.now() - timedelta(days=30)).strftime('%Y-%m-%d'))
                    elif selected_range == "Year":
                        sql += " AND e.date >= %s"
                        params.append((datetime.now() - timedelta(days=365)).strftime('%Y-%m-%d'))

                    # Filter by specific date
                    if selected_date:
                        sql += " AND e.date = %s"
                        params.append(selected_date)

                    # Filter by selected categories
                    if selected_categories:
                        sql += " AND c.name IN (%s)" % ', '.join(['%s'] * len(selected_categories))
                        params.extend(selected_categories)

                    sql += " ORDER BY e.date"

                    cursor.execute(sql, tuple(params))
                    expenses = cursor.fetchall()

                    if expenses:
                        expense_data = [
                            {
                                'expense_id': exp['expense_id'],
                                'category': exp['category'],
                                'amount': exp['amount'],
                                'date': exp['date'].strftime("%d-%m-%Y"),
                                'description': exp['description'] or "N/A"
                            } for exp in expenses
                        ]

                        # Prepare data for chart
                        for exp in expenses:
                            category_totals[exp['category']] = category_totals.get(exp['category'], 0) + exp['amount']
                    else:
                        no_records_message = "No records found for the selected criteria."

    return render_template(
        'index.html',
        user_ids=user_ids,
        selected_user_id=selected_user_id,
        expenses=expense_data,
        category_totals=category_totals,
        category_names=category_names,
        selected_date=selected_date,
        selected_range=selected_range,
        no_records_message=no_records_message
    )

if __name__ == '__main__':
    app.run(debug=True)
