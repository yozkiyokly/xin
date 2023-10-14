#!/usr/bin/perl

use Data::Dumper qw(Dumper); # Чисто ради выпечатывания массивов
 


use lib './';
use SlotsShort qw (slots_unshort);

print "go on, delayedDiskWrite!\n";
@unshorterArray= slots_unshort(' 23 , 33, 5-4   , 8 , 4-11, 4, 54 , 23 , 3-8 , 1-1 , 2-2 , ');
print "\ndirect array try:\n";
print @unshorterArray;
print "\nthen dumper arr print:\n";
print Dumper \@unshorterArray;
