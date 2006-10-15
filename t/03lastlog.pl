#!/usr/bin/perl -w
use strict;
use Test::More tests => 5;
use_ok('Sys::Lastlog');
my $ll;

ok($ll = Sys::Lastlog->new(),"Create object");

my $llent;

ok($llent = $ll->getlluid($>),"Get Entry by UID");
ok($llent = $ll->getllnam((getpwuid($>))[0]),"Get Entry by logname");
ok(my $t = $llent->ll_line(),"Get ll_line");
