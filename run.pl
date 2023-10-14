#!/usr/bin/perl

# Это файл-запускалка. 
# Все отладочные выкрутасы и комментарии разбора кода  
# лежат в файле SlotsShort.pm, a asset.pl локально - лишь симлинк. 
# Они идентичны, а на гите лежат оба на случай, если потребуется рассмотреть 
# процесс разбора по отдельным коммитам. Мало ли вдруг это кому-то захочется.


use Data::Dumper qw(Dumper); # Чисто ради выпечатывания массивов
 


use lib './';
use SlotsShort qw (slots_unshort);
print "Go on, delayedDiskWrite!\n";

# Тестовый набор данных передаём прямо в вызове:
@unshorterArray= slots_unshort(' 23 , 33, 5-4   , 8 , 4-11, 4, 54 , 23 , 3-8 , 1-1 , 2-2 , ');
print "\ndumper arr print:\n";
print Dumper \@unshorterArray;
