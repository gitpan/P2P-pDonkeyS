use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'		=> 'P2P::pDonkeyS',
    'VERSION_FROM'	=> 'pdonkeys',
    'PREREQ_PM'		=> {
						'DBI' => 1.32,
						'LWP::UserAgent' => 2.0,
						'Data::Hexdumper' => 1.0,
						'Tie::IxHash' => 1.21,
						'P2P::pDonkey::Packet' => 0.04,
					   },
	EXE_FILES	=> ['pdonkeys'],
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT => 'Set of tools for eDonkey peer2peer protocol.',
       AUTHOR     => 'Alexey Klimkin <klimkin at cpan.org>') : ()),
);
