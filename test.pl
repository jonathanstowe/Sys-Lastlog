
use Test;
BEGIN { plan tests => 5 };
use Sys::Lastlog;
ok(1);

my $ll;

eval 
{
  $ll = Sys::Lastlog->new();
};
if ( $@ )
{
  ok(0);
}
else
{
  ok(2);
}

my $llent;

eval
{
  $llent = $ll->getlluid($>);
};
if ( $@ )
{
  ok(0);
}
else
{
  ok(3);
}

eval
{
  $llent = $ll->getllnam((getpwuid($>))[0])
};
if ( $@ )
{
  ok(0);
}
else
{
  ok(4);
}
eval
{
   my $t = $llent->ll_line();
};
if ( $@ )
{

  print $@;
  ok(0);
}
else
{
  ok(5);
}
