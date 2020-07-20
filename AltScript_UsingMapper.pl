use strict;
use warnings;
use Bio::EnsEMBL::Registry;

my $registry_37 = 'Bio::EnsEMBL::Registry';

$registry_37->load_registry_from_db
(
	-host => 'ensembldb.ensembl.org', # alternatively 'useastdb.ensembl.org'
	-user => 'anonymous',
	-port => 3337
);

#my $slice_adaptor_37 = $registry_37->get_adaptor( 'Human', 'Core', 'Slice' );
#my $slice_37 = $slice_adaptor_37->fetch_by_region ('chromosome',$ARGV[0]);

my $asma = Bio::EnsEMBL::Registry->get_adaptor( "human", "core", "assemblymapper");
my $csa = Bio::EnsEMBL::Registry->get_adaptor( "human", "core", "coordsystem" );

my $chr_cs_38 = $csa->fetch_by_name('chromosome', 'GRCh38');
my $chr_cs_37 = $csa->fetch_by_name('chromosome', 'GRCh37');

my $asm_mapper = $asma->fetch_by_CoordSystems( $chr_cs_38 , $chr_cs_37 );

# Map to contig coordinate system from chromosomal
my @new_coords = $asm_mapper->map ($ARGV[0], $ARGV[1], $ARGV[2],1, $chr_cs_37, , ,1);

print "@new_coords \n ";
