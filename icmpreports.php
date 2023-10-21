<?php
// Database configuration
$db_host = 'localhost';
$db_name = 'icmp_tunneling';
$db_user = 'your_db_user';
$db_pass = 'your_db_password';

// Create a database connection
$mysqli = new mysqli($db_host, $db_user, $db_pass, $db_name);

// Check the connection
if ($mysqli->connect_error) {
    die("Connection failed: " . $mysqli->connect_error);
}

// Retrieve ICMP tunneling data from the database
$sql = "SELECT * FROM icmp_data";
$data_result = $mysqli->query($sql);

// Retrieve test logs
$sql = "SELECT * FROM test_log";
$test_log_result = $mysqli->query($sql);

echo "<html><head><title>ICMP Tunneling Report</title></head><body>";

if ($data_result->num_rows > 0) {
    echo "<h1>ICMP Tunneling Data Report</h1>";
    echo "<table border='1'>";
    echo "<tr><th>ID</th><th>Received Data</th></tr>";

    while ($row = $data_result->fetch_assoc()) {
        echo "<tr>";
        echo "<td>" . $row["id"] . "</td>";
        echo "<td>" . $row["received_data"] . "</td>";
        echo "</tr>";
    }

    echo "</table>";
} else {
    echo "<p>No data received.</p>";
}

if ($test_log_result->num_rows > 0) {
    echo "<h1>Test Log</h1>";
    echo "<table border='1'>";
    echo "<tr><th>Test Name</th><th>Result</th><th>Details</th></tr>";

    while ($row = $test_log_result->fetch_assoc()) {
        echo "<tr>";
        echo "<td>" . $row["test_name"] . "</td>";
        echo "<td>" . $row["result"] . "</td>";
        echo "<td>" . $row["details"] . "</td>";
        echo "</tr>";
    }

    echo "</table>";
} else {
    echo "<p>No test log entries.</p>";
}

echo "</body></html>";

$mysqli->close();
?>
