use Bot::BasicBot;
use warnings;

package Synopsebot {
    use parent Bot::BasicBot;

    sub said {
        my ($self, $args) = @_;
        if ($args->{body} eq 'synopsebot: botsnack!') {
            return "om nom nom"
        }
        if ($args->{body} =~ m{S32/(\w+)\:(\d+)}) {
            return "Link: http://perlcabal.org/syn/S32/$1.html#line_$2"
        }
        if ($args->{body} =~ /S99:(\w+.*)/) {
            my $name = $1;
            $name =~ s/ /_/g;
            return "Link: http://perlcabal.org/syn/S99.html#$name"
        }
        if ($args->{body} =~ /S(\d\d)\:(\d+)/) {
            return
                unless $2 <= 9999;
            return "Link: http://perlcabal.org/syn/S$1.html#line_$2"
        }
        if ($args->{body} =~ /#(\d{5,})/) {
            return
                unless 18400 <= $1 && $1 < 200000;
            return "Link: https://rt.perl.org/rt3//Public/Bug/Display.html?id=$1"
        }
    }
}

my $bot = Synopsebot->new(
    server => "irc.freenode.net",
    port   => "6667",
    channels => ["#perl6", "#moarvm"],
    
    nick      => "synopsebot",
    username  => "synopsebot",
    name      => "blame tadzik",
);
$bot->run();
