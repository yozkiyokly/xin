    my $first = 12;
    my $second = 2;  # of two elements, let here will be "first" and "second" instead of $el1 and $el2

    ($first, $second) = ($second, $first) if $second < $first; 
    return $first if $second == $first;
    # Продрались сквозь перевёрнутыфе ифы: 
    # То есть надо чтобы первым шёл меньший, а если одинаковые, так можно возвращать:
    # видимо, это идеальный вариант, когда одинаковые.

    my @rsl;    # but suddenly, "road salary layer" initialised! 
                #Let me rape this subroutine to understand this logic...

    for (my $i = $first; $i <= $second; $i++) {
        push @rsl, $i;
    }

    print @rsl;
