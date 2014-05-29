=head1 LICENSE

Copyright [2009-2014] EMBL-European Bioinformatics Institute

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut

package EnsEMBL::Web::Component::Location::Region;

sub content {
  my $self         = shift;
  my $object       = $self->object;
  my $slice        = $object->slice;
  my $length       = $slice->length;
  my $image_config = $object->get_imageconfig('cytoview');

  $image_config->set_parameters({
    container_width => $length,
    image_width     => $self->image_width || 800,
    slice_number    => '1|2'
  });

  $image_config->modify_configs(
    [ 'user_data' ],
    { strand => 'r' }
  );

  $self->_attach_das($image_config);

  $image_config->_update_missing($object);

  my $image = $self->new_image($slice, $image_config, $object->highlights);

  return if $self->_export_image($image);

  $image->imagemap         = 'yes';
  $image->{'panel_number'} = 'top';
  $image->set_button('drag', 'title' => 'Click or drag to centre display');

  return $image->render;

}

1;