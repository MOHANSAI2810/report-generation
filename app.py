from flask import Flask, render_template, send_file, request
import mysql.connector
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
    selected_range = None
    start_date = None
    end_date = None
    expense_data = []
    category_totals = {}
    user_ids = []
    no_records_message = None

    # Fetch all unique user IDs
    with get_db_connection() as connection:
        with connection.cursor(dictionary=True) as cursor:
            cursor.execute("SELECT DISTINCT user_id FROM expenses")
            user_ids = [row['user_id'] for row in cursor.fetchall()]

    if request.method == 'POST':
        selected_user_id = request.form.get('user_id')
        selected_range = request.form.get('range')
        start_date = request.form.get('start_date')
        end_date = request.form.get('end_date')

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
                    elif selected_range == "Custom Date" and start_date and end_date:
                        sql += " AND e.date BETWEEN %s AND %s"
                        params.extend([start_date, end_date])

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
        selected_range=selected_range,
        start_date=start_date,
        end_date=end_date,
        no_records_message=no_records_message
    )

if __name__ == '__main__':
    app.run(debug=True)
