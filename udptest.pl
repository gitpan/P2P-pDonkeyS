#! /usr/bin/perl -w

use strict;
use Socket;
use IO::Socket::INET;
use IO::Multiplex;
use Data::Hexdumper;
use P2P::pDonkey::Meta ':all';
use P2P::pDonkey::Packet ':all';

my @procTable;          # array of packet processing functions

my ($servPort, $servIP) = (4665, '127.0.0.1');
my $servAddr = sockaddr_in($servPort,inet_aton($servIP));

my $port = 4667;
my $udp = IO::Socket::INET->new(Proto=>"udp", LocalPort=>$port, Reuse=>1)
    or die "can't create socket: $!";

my $mux = new IO::Multiplex;
$mux->add($udp);
$mux->set_callback_object(__PACKAGE__);

sub Send {
#    $mux->write($udp, packUDPHeader . packBody(@_), $servAddr);
    send($udp, packUDPHeader . packBody(@_), 0, $servAddr);
}

print "Press <Ctrl-C> to exit.\n";

Send(PT_UDP_SERVERSTATUSREQ, 1234);
Send(PT_UDP_GETSOURCES, '3cefcffaaa02c8c15a8376070690b029');
Send(PT_UDP_GETSERVERINFO);
Send(PT_UDP_NEWSERVER, unpack('L', inet_aton('176.16.4.41')), 4661);
Send(PT_UDP_GETSERVERLIST);

$mux->loop;

sub mux_input {
    my $self = shift;
    my $mux  = shift;
    my $fh   = shift;
    my $data = shift;  # Scalar reference to the input

    my @d;
    my ($pt, $plen);
    my $off = 0;

    print hexdump(data => $$data);

######### UDP ########
    if (unpackUDPHeader($$data, $off)) {
        @d = unpackBody(\$pt, $$data, $off);
        $plen = $off - 1;
    }
    $$data = '';
    my ($port, $iaddr) = sockaddr_in($mux->{_fhs}{$fh}{udp_peer});
    my $peeraddr  = inet_ntoa($iaddr);
    my $peerport  = $port;

    #### process unpacked data
    if (@d) {
        print sprintf("$peeraddr:$peerport -> %s(0x%02x) [%d]\n", PacketTagName($pt), $pt, $plen);
        my $f = $procTable[$pt];
        if ($f) {
#            if ($off != $fplen) {
#                LOG $self, ": there are left ", $fplen - $off, " unpacked bytes in packet\n";
#            }
            &$f($self, @d);
        } else {
            print "$peeraddr:$peerport: dropped: no processing function for 0x$pt\n";
        }
    } else {
        print "$peeraddr:$peerport: dropped: incorrect packet format for 0x$pt\n";
    }
}

