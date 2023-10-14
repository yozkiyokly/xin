package R::CLI::SlotsShort;  #Короткие слоты? Видимо, укороченеие слотов. Будем смотреть..

use 5.010;
use strict;
use warnings;
use Exporter;
our @ISA = qw/Exporter/;
our @EXPORT = qw/slots_short slots_unshort/;

use List::MoreUtils qw/uniq/;

use constant {
    OPTION_DELIMITER => ',',
};

# Сокращаю все переносы строк, разбавляющие вид кода. 

#------------------------------
# Public API
#------------------------------

sub slots_unshort($) {
    my $data = shift;
    my @result;
    my @data = split OPTION_DELIMITER, $data;

    foreach my $el (@data) {
        if ($el =~ m/^\s*\d+\s*$/) {
            push @result, $el;

        }

        elsif ($el =~ m/^\s*(\d+)-(\d+)\s*$/) {
            my @el = get_element($1,$2);

            push @result, @el;

        }

        else { return }

    }

 

    return @result;

}

 

sub slots_short(@) {
    my @array = @_;

    my $result = '';

 

    return undef if not is_numeric(@array);

 

    for (my $index = 0; $index < scalar @array; $index++) {
        if (my $uindex = is_stackable($index, @array)) {
            $result .= $array[$index].'-'.$array[$uindex].',';

            $index = $uindex;

        }

        else {
            $result .= $array[$index] . ',';

        }

    }

 

    chop $result;

    return $result;

}

 

#------------------------------

# Helper functions

#------------------------------

 

sub get_element ($$) {
    my $el1 = shift;

    my $el2 = shift;

 

    ($el1, $el2) = ($el2, $el1) if $el2 < $el1;

    return $el1 if $el2 == $el1;

 

    my @rsl;

    for (my $i = $el1; $i <= $el2; $i++) {
        push @rsl, $i;

    }

 

    return @rsl;

}

 

sub is_numeric (@) {
    my @array = @_;

    foreach (@array) {
        return 0 if (not $_ =~ m/^\d+$/);

    }

    return 1;

}

 

sub is_stackable ($@) {
    my $index = shift;

    my @array = @_;

 

    return 0 if ($index + 2) >= scalar @array;

 

    my $ok = 0;

    while ($index < scalar @array - 1) {
        if ($array[$index] + 1 == $array[$index + 1]) {
            $index += 1; $ok += 1;

        }

        else { last }

    }

    return $index if $ok >= 2;

    return undef;

}

 

1;

__END__