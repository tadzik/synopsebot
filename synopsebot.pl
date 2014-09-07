use Bot::BasicBot;
use warnings;

package Synopsebot {
    use parent Bot::BasicBot;

    sub said {
        my ($self, $args) = @_;
        if ($args->{body} eq 'synopsebot: botsnack!') {
            return "om nom nom"
        }
        if ($args->{body} =~ /S(\d+)\:(\d+)/) {
            return "Link: http://perlcabal.org/syn/S$1.html#line_$2"
        }
        if ($args->{body} =~ /#(\d{4,})/) {
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
