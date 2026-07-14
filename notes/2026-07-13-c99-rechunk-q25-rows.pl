#!/usr/bin/env perl
use strict;
use warnings;
use File::Basename qw(basename);

# Mechanically split generated Q25 row-certificate modules so that Lean never
# elaborates too many expensive LegalPair certificates in one process.  The
# script writes temporary files beside their destinations, on the repository
# filesystem rather than /tmp, and atomically renames them into place.

my ($lean_root, $legal_cap) = @ARGV;
die "usage: $0 LEAN_ROOT LEGAL_CAP\n" unless defined $lean_root && defined $legal_cap;
die "LEGAL_CAP must be positive\n" unless $legal_cap =~ /^\d+$/ && $legal_cap > 0;

my $rows_dir = "$lean_root/RelativeConicArcs/Q25PairRows";
opendir my $dh, $rows_dir or die "opendir $rows_dir: $!\n";
my @files = sort grep { /^R_\d{3}_C_\d{3}_\d{3}(?:_P_\d{2})?\.lean$/ } readdir $dh;
closedir $dh;

my ($split_files, $new_files, $legal_total) = (0, 0, 0);

for my $name (@files) {
    $name =~ /^R_(\d{3})_C_(\d{3})_(\d{3})(?:_P_\d{2})?\.lean$/
        or die "bad name $name\n";
    my ($b_text, $old_lo, $old_hi) = ($1, $2, $3);
    my $path = "$rows_dir/$name";

    open my $in, '<', $path or die "open $path: $!\n";
    my @lines = <$in>;
    close $in or die "close $path: $!\n";

    my (@header, @footer, @blocks, @current);
    my $phase = 'header';
    for my $line (@lines) {
        if ($phase eq 'header') {
            if ($line =~ /^theorem /) {
                $phase = 'blocks';
                @current = ($line);
            } else {
                push @header, $line;
            }
        } elsif ($phase eq 'blocks') {
            if ($line =~ /^theorem /) {
                push @blocks, [@current];
                @current = ($line);
            } elsif ($line =~ /^end RelativeConicArcs\.Q25PairCertificate/) {
                push @blocks, [@current] if @current;
                @current = ();
                $phase = 'footer';
                push @footer, $line;
            } else {
                push @current, $line;
            }
        } else {
            push @footer, $line;
        }
    }
    die "unterminated blocks in $path\n" unless $phase eq 'footer';

    my $legal = grep { join('', @$_) =~ /exact Or\.inr/ } @blocks;
    $legal_total += $legal;
    next if $legal <= $legal_cap;

    my @parts;
    my (@part, $part_legal);
    $part_legal = 0;
    for my $block (@blocks) {
        my $is_legal = join('', @$block) =~ /exact Or\.inr/ ? 1 : 0;
        if (@part && $part_legal + $is_legal > $legal_cap) {
            push @parts, [@part];
            @part = ();
            $part_legal = 0;
        }
        push @part, $block;
        $part_legal += $is_legal;
    }
    push @parts, [@part] if @part;

    my @imports;
    my $part_no = 0;
    for my $part (@parts) {
        ++$part_no;
        my ($first) = $$part[0][0] =~ /^theorem row_\d+_(\d+) /;
        my ($last) = $$part[-1][0] =~ /^theorem row_\d+_(\d+) /;
        die "cannot recover theorem range in $path\n" unless defined $first && defined $last;

        my $first_block = join('', @{$$part[0]});
        $first_block =~ s/^  have _previous := row_\d+_\d+\n//m;
        $$part[0] = [split /(?<=\n)/, $first_block];

        my $new_stem = sprintf 'R_%s_C_%03d_%03d_P_%02d',
            $b_text, $first, $last, $part_no;
        my $new_path = "$rows_dir/$new_stem.lean";
        my $tmp_path = "$new_path.tmp.$$";
        open my $out, '>', $tmp_path or die "open $tmp_path: $!\n";
        print {$out} @header;
        for my $block (@$part) {
            print {$out} @$block;
        }
        print {$out} @footer;
        close $out or die "close $tmp_path: $!\n";
        rename $tmp_path, $new_path or die "rename $tmp_path -> $new_path: $!\n";
        push @imports, "import RelativeConicArcs.Q25PairRows.$new_stem\n";
        ++$new_files;
    }

    my $aggregate = "$rows_dir/R_$b_text.lean";
    open my $ain, '<', $aggregate or die "open $aggregate: $!\n";
    local $/;
    my $aggregate_text = <$ain>;
    close $ain or die "close $aggregate: $!\n";
    my $old_stem = $name;
    $old_stem =~ s/\.lean$//;
    my $needle = "import RelativeConicArcs.Q25PairRows.$old_stem\n";
    my $replacement = join('', @imports);
    die "missing aggregate import $needle in $aggregate\n"
        unless $aggregate_text =~ s/^\Q$needle\E/$replacement/m;
    my $aggregate_tmp = "$aggregate.tmp.$$";
    open my $aout, '>', $aggregate_tmp or die "open $aggregate_tmp: $!\n";
    print {$aout} $aggregate_text;
    close $aout or die "close $aggregate_tmp: $!\n";
    rename $aggregate_tmp, $aggregate
        or die "rename $aggregate_tmp -> $aggregate: $!\n";

    unlink $path or die "unlink $path: $!\n";
    ++$split_files;
}

print "split_files=$split_files new_files=$new_files legal_total=$legal_total cap=$legal_cap\n";
