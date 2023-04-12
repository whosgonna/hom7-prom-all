use utf8;
package Mock::Neustar::CNAM::Schema::Result::Presentation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Mock::Neustar::CNAM::Schema::Result::Presentation

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<presentation>

=cut

__PACKAGE__->table("presentation");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 val

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "val",
  { data_type => "varchar", is_nullable => 1, size => 32 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 calling_numbers

Type: has_many

Related object: L<Mock::Neustar::CNAM::Schema::Result::CallingNumber>

=cut

__PACKAGE__->has_many(
  "calling_numbers",
  "Mock::Neustar::CNAM::Schema::Result::CallingNumber",
  { "foreign.presentation_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2021-11-24 12:21:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3CZ/KNMINswasf2f7aBEyw

__PACKAGE__->add_unique_constraint([ 'val' ]);

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
