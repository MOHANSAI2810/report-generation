document.addEventListener('DOMContentLoaded', function () {
    if (groupedExpenses) {
        const labels = [];
        const data = [];

        // Consolidate data for the bar chart
        for (const userId in groupedExpenses) {
            const user = groupedExpenses[userId];
            for (const category in user.categories) {
                const label = `${user.user_name} - ${category}`;
                labels.push(label);
                data.push(user.categories[category]);
            }
        }

        // Render the bar chart
        const ctx = document.getElementById('barChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Expense Amount',
                    data: data,
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    borderColor: 'rgba(75, 192, 192, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { display: true },
                    tooltip: { enabled: true }
                },
                scales: {
                    y: { beginAtZero: true }
                }
            }
        });
    }
});
