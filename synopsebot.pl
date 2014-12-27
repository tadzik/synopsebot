use Bot::BasicBot;
use warnings;

package Synopsebot {
    use parent Bot::BasicBot;

    sub said {
        my ($self, $args) = @_;
        if ($args->{body} eq 'synopsebot: botsnack!') {
            return "om nom nom"
        }
        if ($args->{body} =~ m{(S\d\d)(?:/(\w+))?\:(\d+)}) {
            my ($syn, $subsyn, $line) = ($1,$2,$3);
            return unless $line <= 9999;
            $syn .= "/$subsyn" if $subsyn;
            return "Link: http://perlcabal.org/syn/$syn.html#line_$line";
        }
        if ($args->{body} =~ m{(S\d\d)(?:/(\w+))?\:((?:\s\w+)+)}) {
            my ($syn, $subsyn, $word) = ($1,$2,$3);
            for ($word) { s/^\s*//; s/ /_/g; }
            $syn .= "/$subsyn" if $subsyn;
            return "Link: http://perlcabal.org/syn/$syn.html#$word";
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
