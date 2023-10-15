                        #package R::CLI::SlotsShort;  #Короткие слоты? Укорочение слотов? Будем смотреть..
                        #Первым делом cокращаю все переносы строк, разбавляющие вид кода. 


use 5.010;
use strict;
use warnings;
use Exporter;
our @ISA = qw/Exporter/;
our @EXPORT = qw/slots_short slots_unshort/;

use List::MoreUtils qw/uniq/;

use constant {          # Не приходилось пользоваться таким способом формировать конфиги. 
                        # Видимо, для крупных массивов кода это даже очень удобно.
                        # В 19-й СТРОКЕ задействовал константу: добавил флаг отладки:
    
    OPTION_DELIMITER => ',',
    OTLADKA => 1,
};


#------------------------------
# Public API
#------------------------------

sub slots_unshort($) {
    my $data = shift;   # недолюбливаю этот "VAR = shift;". Перлу не хватает
                        # автоимпорта поименованных переменных внутрь функций. 
                        # But it is a Perl.
    my @result;
    my @data = split OPTION_DELIMITER, $data;  

    foreach my $element (@data) {   
                        # "el1" поменял на "element1". Путаюсь я в коротких именах.
                        ########### OTLADKA ########:
                        print $element."\n" if OTLADKA;
                        ########### /OTLADKA ########:
        if ($element =~ m/^\s*\d+\s*$/) {
            push @result, $element;
        }               #end "if space_surrounded_digit_found"

                        ####################
                        # Тут становится ясно, что на входе какой-то текст, разделённый запятыми,
                        # и в нём мы ищем примерно такое: 
                        #    23 , 33, 5-4   , 8 , 4-11, 4, 54 , 23 , 3-8 , 1-1 , 2-2 , 
                        # При этом варианты 2-2 - нечто особенное.
                        ###################

        elsif ($element =~ m/^\s*(\d+)-(\d+)\s*$/) {
                        ########### OTLADKA ########:
                        print "minus found! " if OTLADKA;
                        ########### /OTLADKA ########:

            my @elements = get_element($1,$2);
                        ########### OTLADKA ########:
                        #print "array dump: ".Dumper \@elements."\n" if OTLADKA;
                        ########### /OTLADKA ########:

            push @result, @elements;
        }               #end "if minusFound"

        else { return }
    }                   #end foreach

                        ########### OTLADKA ########:
                        print "\nresult before return: ". @result if OTLADKA;
                        ########### /OTLADKA ########:

    return @result;
}


#------------------------------
sub slots_short(@) {
    my @array = @_;
    my $result = '';

                        # в небольших проектах мне вот так больше нравится: 
                        # однострочная проверка и коммент - что внутри этой проверки:
    foreach (@array) { return undef if (not $_ =~ m/^\d+$/);} #if not is_numeric(@array)
                        #
                        #Так было:
    #return undef if not is_numeric(@array);
                        # 
                        # Это просто нелюбовь к выносу одноразовой мелочи из основной ф-ции.
                        # Впрочем, 

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
    my $second = shift; # let here will be "first" and "second" instead of $el1 and $el2

    ($first, $second) = ($second, $first) if $second < $first; 
    return $first if $second == $first;
                        # Продрались сквозь перевёрнутыфе ифы: 
                        # То есть надо чтобы первым шёл меньший. Если одинаковые, вернём первый.
                        # Видимо, это хороший вариант, когда одинаковые :)

    my @rsl;            # <--- but suddenly, "road salary layer" initialised! 
                        # and it will filled with all int values between interval?
                        # if first=12, second=2, we will have sorted array of "2,3,4,5,6,7,8,9,10,11,12" 
                        # what for, interesting?

    for (my $i = $first; $i <= $second; $i++) {
        push @rsl, $i;  # Ну, то есть набили массив всеми int между полученными на
    }                   # входе функции.  Имея вход (2,5), делаем массив (2,3,4,5)
                        # Любопытство раздирает: что же из этого клеится вне модуля?
    return @rsl;
}

#------------------------------
sub is_numeric (@) {    # Вот у объектно-ориентированно ужаленных программистов
    my @array = @_;     # вся жизнь состоит из раздувания текстов кода.
                        # Перед нами не переиспользуемая фция: её смысл это 
                        # один регексп. Она вызывается из slots_short().
                        # Наверное, 

    foreach (@array) { 
        return 0 if (not $_ =~ m/^\d+$/);
    }
    return 1;
} 

#------------------------------
sub is_stackable ($@) {     # Итак, мы принимаем внутрь скалярчик и массив...
    my $index = shift;      # Скалярчик будет индекс          
    my @array = @_;         # А массив - мы пока не знаем что там будет. Числа какие-то.

    return 0 if ($index + 2) >= scalar @array;
                            # Видимо, если индекс меньше, чем то, что лежит в массиве,
                            # То входные данные не соответствуют признаку Stackable.
                            # "Stackable". Вот как это по-русски понимать? 
                            # Давайте поймём как "годно для занесения в стек".

    my $ok = 0;             # Ну, стало быть, пока не ок.
    while ($index < scalar @array - 1) {

                            # Вот ключевой иф. Изящный, между прочим!
                            # Как бы проверяем: а последовательны ли целые
                            # числа в соседних ячейках массива: 
        if ($array[$index] + 1 == $array[$index + 1]) { # Н
            $index += 1; $ok += 1;  # Мне больше нравится $index++; но традиция есть традиция.
        }

        else { last }
    }

    return $index if $ok >= 2;
    return undef;

}

1;

__END__