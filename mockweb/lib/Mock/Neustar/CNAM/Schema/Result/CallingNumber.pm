use utf8;
package Mock::Neustar::CNAM::Schema::Result::CallingNumber;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Mock::Neustar::CNAM::Schema::Result::CallingNumber

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<calling_number>

=cut

__PACKAGE__->table("calling_number");

=head1 ACCESSORS

=head2 id

  data_type: 'varchar'
  is_nullable: 0
  size: 24

=head2 calling_name

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 presentation_id

  data_type: 'int'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "varchar", is_nullable => 0, size => 24 },
  "calling_name",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "presentation_id",
  { data_type => "int", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 presentation_id

Type: belongs_to

Related object: L<Mock::Neustar::CNAM::Schema::Result::PresentationIndicator>

=cut

__PACKAGE__->belongs_to(
  "presentation",
  "Mock::Neustar::CNAM::Schema::Result::Presentation",
  "presentation_id" ,
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2021-11-24 12:21:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FQSyhV3JYeWiPdTLZG1gng


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
