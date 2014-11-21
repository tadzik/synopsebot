#!/usr/bin/env perl6

use v6;
use Net::IRC::Bot;

class SynopsesBot {
    multi method said ($e) {
        say $e;
        given $e.what {
            when /botsnack/ { $e.msg("om nom nom") }
            when m{ $<syn>=(S\d\d) [ '/' $<subsyn>=(\w+) ]? ':' [ $<line>=(\d+) | $<entry>=(\w+ % \s*) ] } {
                return unless $<line> < 9999;
                my $syn = $<subsyn> ?? "$<syn>/$<subsyn>" !! $<syn>;
                my $name = $<line> ?? "line_" ~ $<line> !! $<entry>.trans(" " => "_");
                $e.msg("Link: http://perlcabal.org/syn/$syn.html#$name");
            }
            when / '#' (\d ** 5..*) / {
                return unless 18400 <= $0 <= 200000;
                $e.msg("Link:  https://rt.perl.org/rt3//Public/Bug/Display.html?id=$0");
            }
        }
    }
}

my $bot = Net::IRC::Bot.new(
    server      => "irc.freenode.net",
    port        => 6667,
    channels    => ["#duff"],
    
    nick        => "jsdbot",
    username    => "jsdbot",
    name        => "blame PerlJam",

    modules => ( SynopsesBot.new ),
    :debug 
);
$bot.run();

