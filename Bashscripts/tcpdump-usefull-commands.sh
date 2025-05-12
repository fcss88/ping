# Traffic filtering for a specific host and port
tcpdump -i eth0 host 192.168.1.100 and port 443

# write to a file trace (use Wireshark)
tcpdump -i eth0 -w capture.pcap
tcpdump -r capture.pcap

# show headers only
tcpdump -i eth0 -q

# dns traffic for analysis
tcpdump -i eth0 -n udp port 53

# show only specific protocol without null ack-packets
tcpdump -i eth0 'tcp port 80 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)'
