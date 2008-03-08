use Module::Build;
my $build = Module::Build->new(
	module_name => 'Number::Fraction',
	dist_version => '1.10',
	license => 'perl',
	requires => {
		perl		      => '5.6.0',
	},
	build_requires => {
		'Test::More'	      => 0,
	},
	build_recommends => {
		'Test::Pod'           => 0,
		'Test::Pod::Coverage' => 0,
	},
        create_makefile_pl => 'traditional'
);

$build->create_build_script;
