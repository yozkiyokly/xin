package R::CLI::SlotsShort;  #Короткие слоты? Видимо, укороченеие слотов. Будем смотреть..

use 5.010;
use strict;
use warnings;
use Exporter;
our @ISA = qw/Exporter/;
our @EXPORT = qw/slots_short slots_unshort/;

use List::MoreUtils qw/uniq/;

use constant {  # Не приходилось пользоваться таким способом формировать конфиги. 
                # наверное, для крупных массивов кода это даже очень удобно,
                # но тревожит разрастание сущностей, хотя то е дело привычки.
    
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

    foreach my $element (@data) {   #sorry, "el" transformed to "element". I hate short vars names.
        if ($element =~ m/^\s*\d+\s*$/) {
            push @result, $element;
        }

        elsif ($element =~ m/^\s*(\d+)-(\d+)\s*$/) {
            my @elements = get_element($1,$2);
            push @result, @elements;
        }

        else { return }
    }

    return @result;
}


#------------------------------
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

#------------------------------
sub get_element ($$) {  #so, just two elements here can be... ok, let be two.
    my $first = shift;
    my $second = shift;  # of two elements, let here will be "first" and "second" instead of $el1 and $el2

    ($first, $second) = ($second, $first) if $second < $first; 
    return $first if $second == $first;
    # Продрались сквозь перевёрнутыфе ифы: 
    # То есть надо чтобы первым шёл меньший, а если одинаковые, так можно возвращать:
    # видимо, это идеальный вариант, когда одинаковые.

    my @rsl;    # but suddenly, "road salary layer" initialised! 
                # and it will filled with all int values between interval?
                # if first=12, second=2, we will have sorted array of "2,3,4,5,6,7,8,9,10,11,12" 
                # what for, interesting?

    for (my $i = $first; $i <= $second; $i++) {
        push @rsl, $i;
    }

    return @rsl;
}

#------------------------------
sub is_numeric (@) {
    my @array = @_;

    foreach (@array) { 
        return 0 if (not $_ =~ m/^\d+$/);
    }
    return 1;
}

#------------------------------
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