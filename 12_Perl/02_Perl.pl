use strict;
use Memoize;

sub normalize_count_f {
    my $line = $_[0];
    my @groups = @{ $_[1]};

    for my $i (0..scalar @groups) {
        $line = join(",", $line, $groups[$i]);
    }
    return $line;
}


sub pound {
    my $line       = $_[0];
    my $next_group = $_[1];
    my @groups     = @{ $_[2] };

    my $this_group = substr( $line, 0, $next_group );
    $this_group =~ s/(?<!%)[?]/#/g;

    if ( $this_group ne "#" x $next_group ) {
        return 0;
    }
    if ( length($line) eq $next_group ) {
        if ( scalar @groups == 1 ) {
            return 1;
        }
        else {
            return 0;
        }
    }
    my $char_that_follows = substr( $line, $next_group, 1 );

    if ( $char_that_follows eq '?' || $char_that_follows eq '.' ) {
        shift(@groups);
        return count_valid( substr( $line, $next_group + 1 ), \@groups );
    }
    return 0;
}

sub count_valid {
    my $line   = $_[0];
    my @groups = @{ $_[1] };
    my $out    = 0;

    if ( scalar @groups == 0 ) {
        if ( index( $line, '#' ) == -1 ) {
            return 1;
        }
        else {
            return 0;
        }
    }
    if ( length($line) eq 0 ) {
        return 0;
    }
    my $next_char  = substr( $line, 0, 1 );
    my $next_group = $groups[0];

    if ( $next_char eq '#' ) {
        $out = pound( $line, $next_group, \@groups );
    }
    if ( $next_char eq '.' ) {
        $out = count_valid( substr( $line, 1 ), \@groups );
    }
    if ( $next_char eq '?' ) {
        $out = count_valid( substr( $line, 1 ), \@groups ) +
          pound( $line, $next_group, \@groups );
    }
    return $out;
}

sub main {

    my $file = $ARGV[0] or die "Usage $0 <input_file>";
    open my $info, $file or die "Could not open $file: $!";

    memoize('count_valid', NORMALIZER => 'normalize_count_f');

    my $valid_count = 0;

    while ( my $line = <$info> ) {
        my @line_parts     = split( ' ', $line );
        my $original_line  = $line_parts[0];
        my $original_line2 = $line_parts[1];

        for my $i ( 0 .. 3 ) {
            $line_parts[0] = $line_parts[0] . "?" . $original_line;
            $line_parts[1] = $line_parts[1] . "," . $original_line2;
        }

        my @groups_arr;

        for my $num ( split( ',', $line_parts[1] ) ) {
            push( @groups_arr, $num );
        }

        $valid_count += count_valid( $line_parts[0], \@groups_arr );

    }
    print $valid_count. "\n";
    close $info;

}

main()