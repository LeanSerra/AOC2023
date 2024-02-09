use strict;
use warnings;
use Algorithm::Combinatorics qw(combinations);

sub is_valid {
    my @arg                    = split( ' ', $_[0] );
    my @string_to_validate_arr = split( '',  $arg[0] );
    my $validation_rule_str    = $arg[1];
    my @validation_rule_arr;

    for my $num ( split( ',', $validation_rule_str ) ) {
        push( @validation_rule_arr, $num );
    }

    my $current_c_num = shift(@validation_rule_arr);
    my $counter       = $current_c_num;

    for my $i ( 0 .. $#string_to_validate_arr ) {
        my $c = $string_to_validate_arr[$i];
        if ( $c eq '#' ) {
            $counter -= 1;
        }
        if ( $c eq '.' ) {
            if ( $counter == 0 ) {
                $current_c_num = shift(@validation_rule_arr);
                if ( !defined($current_c_num) ) {
                    return 1;
                }
            }
            if ( $counter < 0 ) {
                return -1;
            }
            $counter = $current_c_num;
        }
    }

    if ( $#validation_rule_arr ge 0 || $counter != 0 ) {
        return -1;
    }
    return 1;
}

sub main {

    my $file = $ARGV[0] or die "Usage $0 <input_file>";
    open my $info, $file or die "Could not open $file: $!";

    my $valid_count = 0;

    # $. -> line number
    while ( my $line = <$info> ) {
        my @line_parts = split( ' ', $line );

        my $broken_count      = 0;
        my $operational_count = 0;
        my $unknown_count     = 0;
        my $broken_real_count = 0;
        my @unknown_positions;

        for my $i ( 0 .. length($line) - 1 ) {
            my $char = substr( $line, $i, 1 );
            if ( $char eq '.' ) {
                $operational_count++;
            }
            if ( $char eq '#' ) {
                $broken_count++;
            }
            if ( $char eq '?' ) {
                push( @unknown_positions, $i );
                $unknown_count++;
            }
        }

        foreach my $ch ( split( ',', $line_parts[1] ) ) {
            $broken_real_count += $ch;
        }

        my $broken_to_insert      = $broken_real_count - $broken_count;
        my $operational_to_insert = $unknown_count - $broken_to_insert;

        my $comb_iter = combinations( \@unknown_positions, $broken_to_insert );

        while ( my $tuple = $comb_iter->next ) {
            my @chars = split( '', $line );

            for my $i ( 0 .. $broken_to_insert - 1 ) {
                $chars[ $tuple->[$i] ] = '#';
            }

            for my $i ( 0 .. length($line) - 1 ) {
                if ( $chars[$i] eq '?' ) {
                    $chars[$i] = '.';
                }
            }

            my $line_cpy = join( '', @chars );

            if ( is_valid($line_cpy) eq 1 ) {
                $valid_count += 1;
                print $line_cpy;
            }

        }

    }
    close $info;
    print "$valid_count\n";
}

main()
