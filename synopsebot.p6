#!/usr/bin/env perl6

use v6;
use Net::IRC::Bot;

class SynopsesBot {
    grammar Utterance {
        regex TOP { [<info> | .]* }

        proto token info {*}

        token info:sym<botsnack> {
            <<botsnack>>
        }

        token info:sym<Snn> {
            $<syn>=(S\d\d)
            [ '/' $<subsyn>=(\w+) ]?
            ':'
            [ $<line>=(\d+) | $<entry>=(\w+ % \s*) ]
        }

        token info:sym<RT> {
            '#' (\d ** 5..*)
        }
    }

    multi method said ($e) {
        my $actions = class Utterance::Actions {
            method info:sym<botsnack> ($/) {
                $e.msg("om nom nom");
            }

            method info:sym<Snn> ($/) {
                return unless $<line> < 9999;
                my $syn = $<subsyn> ?? "$<syn>/$<subsyn>" !! $<syn>;
                my $name = $<line> ?? "line_" ~ $<line> !! $<entry>.trans(" " => "_");
                $e.msg("Link: http://design.perl6.org/$syn.html#$name");
            }

            method info:sym<RT> ($/) {
                return unless 18400 <= $0 <= 200000;
                $e.msg("Link:  https://rt.perl.org/rt3//Public/Bug/Display.html?id=$0");
            }
        }

        Utterance.parse($e.what, :$actions)
            or die "Failed to parse '$e.what'";
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

