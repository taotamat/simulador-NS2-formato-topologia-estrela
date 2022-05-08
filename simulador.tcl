set val(chan)           Channel/WirelessChannel    ;# Type of channel
set val(prop)           Propagation/TwoRayGround   ;# Radio model (propagation)
set val(netif)          Phy/WirelessPhy            ;# NIC (Interface Card)
set val(mac)            Mac/802_11                 ;# Medium Access Control (MAC)
set val(ifq)            Queue/DropTail/PriQueue    ;# Type of queuing interface
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# Antenna Model
set val(ifqlen)         50                        ;# max packet in interface queue
set val(nn)             4                       ;# number of mobilenodes
set val(rp)             DSDV 

set ns [new Simulator]

set tracef [open wrls1.tr w]
$ns trace-all $tracef

set nf [open out.nam w]
$ns namtrace-all-wireless $nf 300 300

set topo  [new Topography]
$topo load_flatgrid 300 300
create-god $val(nn)

set switch [$ns node]
set host1 [$ns node]
set host2 [$ns node]
set host3 [$ns node]

set channel1 [new $val(chan)]
$ns node-config -adhocRouting $val(rp) \
                -llType $val(ll) \
                -macType $val(mac) \
                -ifqType $val(ifq) \
                -ifqLen $val(ifqlen) \
                -antType $val(ant) \
                -propType $val(prop) \
                -phyType $val(netif) \
                -topoInstance $topo \
                -agentTrace ON \
                -routerTrace ON \
                -macTrace ON \
                -movementTrace ON \
                -channel $channel1

set host4_AP [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]



#Labelling the nodes
$ns at 0.0 "$switch label Switch"
$ns at 0.0 "$host1 label Client1"
$ns at 0.0 "$host2 label Client2"
$ns at 0.0 "$host3 label Client3"
$ns at 0.0 "$host4_AP label Wifi"
$ns at 0.0 "$n1 label Client1"
$ns at 0.0 "$n2 label Client2"
$ns at 0.0 "$n3 label Client3"


$ns color switch Red
$ns color host1 Blue
$ns color host2 Green
$ns color host3 Yellow
$ns color host4_AP Violet 
$ns color n1 Pink
$ns color n2 Brown
$ns color n3 White

$ns duplex-link $switch $host1 10Mb 10ms DropTail
$ns duplex-link $switch $host2 10Mb 10ms DropTail
$ns duplex-link $switch $host3 10Mb 10ms DropTail
$ns duplex-link $switch $host4_AP 10Mb 10ms DropTail


$ns duplex-link-op $switch $host1 orient right-down
$ns duplex-link-op $switch $host2 orient left-down
$ns duplex-link-op $switch $host4_AP orient right
$ns duplex-link-op $switch $host3 orient left

$host4_AP random-motion 0

$ns initial_node_pos $n1 5
$ns initial_node_pos $n2 5
$ns initial_node_pos $n3 5
$ns initial_node_pos $host4_AP 10

$n1 set X_ 90.0
$n1 set Y_ 90.0
$n1 set Z_ 0.0

$n2 set X_ 100.0
$n2 set Y_ 10.0
$n2 set Z_ 0.0

$n3 set X_ 100.0
$n3 set Y_ -20.0
$n3 set Z_ 0.0

$ns at 0 "$n1 setdest 20.0 10.0 10.0"
$ns at 0 "$n2 setdest 280.0 280.0 50.0"
$ns at 0 "$n3 setdest 199.0 1.0 20.0"
$ns at 4 "$n2 setdest 150.0 150.0 50.0"

set udp1 [new Agent/UDP]
$ns attach-agent $switch $udp1

set udp2 [new Agent/UDP]
$ns attach-agent $switch $udp2

set udp3 [new Agent/UDP]
$ns attach-agent $switch $udp3

set udp4 [new Agent/UDP]
$ns attach-agent $host4_AP $udp4

set udp5 [new Agent/UDP]
$ns attach-agent $host4_AP $udp5

set udp6 [new Agent/UDP]
$ns attach-agent $host4_AP $udp6

set udp7 [new Agent/UDP]
$ns attach-agent $switch $udp7


set null1 [new Agent/Null]
$ns attach-agent $host1 $null1

set null2 [new Agent/Null]
$ns attach-agent $host2 $null2

set null3 [new Agent/Null]
$ns attach-agent $host3 $null3

set null4 [new Agent/Null]
$ns attach-agent $n1 $null4

set null5 [new Agent/Null]
$ns attach-agent $n2 $null5

set null6 [new Agent/Null]
$ns attach-agent $n3 $null6

set null7 [new Agent/Null]
$ns attach-agent $host4_AP $null7

 
$ns connect $udp1 $null1 
$ns connect $udp2 $null2 
$ns connect $udp3 $null3 
$ns connect $udp4 $null4 
$ns connect $udp5 $null5
$ns connect $udp6 $null6 
$ns connect $udp7 $null7
 

set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 500
$cbr1 set interval_ 0.009
$cbr1 attach-agent $udp1

set cbr2 [new Application/Traffic/CBR]
$cbr2 set packetSize_ 500
$cbr2 set interval_ 0.009   
$cbr2 attach-agent $udp2

set cbr3 [new Application/Traffic/CBR]
$cbr3 set packetSize_ 500
$cbr3 set interval_ 0.009   
$cbr3 attach-agent $udp3

set cbr4 [new Application/Traffic/CBR]
$cbr4 set packetSize_ 100
$cbr4 set interval_ 0.009   
$cbr4 attach-agent $udp4

set cbr5 [new Application/Traffic/CBR]
$cbr5 set packetSize_ 100
$cbr5 set interval_ 0.009   
$cbr5 attach-agent $udp5

set cbr6 [new Application/Traffic/CBR]
$cbr6 set packetSize_ 100
$cbr6 set interval_ 0.009   
$cbr6 attach-agent $udp6

set cbr7 [new Application/Traffic/CBR]
$cbr7 set packetSize_ 100
$cbr7 set interval_ 0.003 
$cbr7 attach-agent $udp7

$ns at 0.3 "$cbr1 start"
$ns at 4.5 "$cbr1 stop"

$ns at 0.31 "$cbr2 start"
$ns at 4.5 "$cbr2 stop"

$ns at 0.32 "$cbr3 start"
$ns at 4.5 "$cbr3 stop"

$ns at 0.32 "$cbr4 start"
$ns at 5.5 "$cbr4 stop"

$ns at 0.32 "$cbr5 start"
$ns at 5.5 "$cbr5 stop"

$ns at 0.32 "$cbr6 start"
$ns at 5.5 "$cbr6 stop"

$ns at 0.32 "$cbr7 start"
$ns at 5.5 "$cbr7 stop"

$ns at 6.0 "finish"


proc finish {} {
        global ns tracef nf
        $ns flush-trace
        close $tracef
        close $nf
        exec nam out.nam &
        exit 0
}


$ns run
