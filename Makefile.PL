use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'		=> 'Sys::Lastlog',
    'VERSION_FROM'	=> 'lib/Sys/Lastlog.pm',
    'PREREQ_PM'		=> {Test::More => undef},
    ($] >= 5.005 ?    
      (ABSTRACT_FROM => 'lib/Sys/Lastlog.pm', 
       AUTHOR     => 'jns@gellyfish.com') : ()),
);
