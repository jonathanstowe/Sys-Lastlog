#!/usr/bin/perl -w
use strict;
use Test::More tests => 6;
use_ok('Sys::Lastlog');
my $ll;

ok($ll = Sys::Lastlog->new(),"Create object");

my ($llent,$lp);

ok($lp = $ll->lastlog_path(),"lastlog_path()");
diag( "_PATH_LASTLOG: " . $lp);
ok($llent = $ll->getlluid(0),"Get Entry by UID");
ok($llent = $ll->getllnam('root'),"Get Entry by logname");
ok(my $t = $llent->ll_line(),"Get ll_line");
