use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'		=> 'Sys::Lastlog',
    'VERSION_FROM'	=> 'Lastlog.pm',
    'PREREQ_PM'		=> {Test::More => undef},
    ($] >= 5.005 ?    
      (ABSTRACT_FROM => 'Lastlog.pm', 
       AUTHOR     => 'jns@gellyfish.com') : ()),
);
