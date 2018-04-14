#!/usr/bin/perl -w

use strict;
use warnings;
use feature 'say';
use Tk;

my $mw = MainWindow->new;
$mw->Label(-text => 'Anagram')->pack;

my $font = $mw->fontCreate(
    -size => 15,
);

my $description = $mw->Label(
    -font => $font,
    -text => <<END,
Type something into the top bar and click Calculate Combinations
to see all the different arrangements of those characters.
END
)->pack;

my $in = $mw->Entry(
    -font => $font,
    -width => 40,
)->pack;

my $output_label = $mw->Label(
    -text => "Output",
)->pack;

my $out = $mw->Scrolled('Text',
    -wrap => 'none',
    -font => $font,
    -scrollbars => 'osoe',
    -width => 25,
    -height => 25,
)->pack;

my $button = $mw->Button(
    -font => $font,
    -text => 'Calculate Combinations',
    -command => sub { calc($in, $out) }
)->pack;

MainLoop;

sub pur;
sub pur {
    my $out_element = shift(@_);
    my $in_length = shift(@_);
    my @in;
    for (my $index = 0; $index <= $in_length; ++$index) {
        push (@in, shift(@_));
    }
    my @out = @_;
    if ($in_length == -1) {
        while ($#out + 1) {
            $out_element->insert("end", shift(@out));
        }
        $out_element->insert("end", "\n");
        return;
    }
    for (my $index = 0; $index <= $in_length; ++$index) {
        my @tmp_out = @out;
        my @tmp_in = @in;
        push (@tmp_out, $in[$index]);
        splice (@tmp_in, $index, 1);
        my @args;
        my $tmp_in_length = @tmp_in;
        $tmp_in_length -= 1;
        push (@args, $out_element);
        push (@args, $tmp_in_length);
        push (@args, @tmp_in);
        push (@args, @tmp_out);
        pur @args;
    }
}

sub calc {
    my ($in, $out) = @_;
    my $input = $in->get;
    my @input_array = split(//, "$input");
    my $input_length = $#input_array;
    my @args;
    push (@args, $out);
    push (@args, $input_length);
    push (@args, @input_array);
    $out->delete("1.0", "end");
    pur @args;
}