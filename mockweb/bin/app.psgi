#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";


# use this block if you don't need middleware, and only have a single target Dancer app to run here
use mockweb;

mockweb::make_schema();

mockweb->to_app;

=begin comment
# use this block if you want to include middleware such as Plack::Middleware::Deflater

use mockweb;
use Plack::Builder;

builder {
    enable 'Deflater';
    mockweb->to_app;
}

=end comment

=cut

=begin comment
# use this block if you want to mount several applications on different path

use mockweb;
use mockweb_admin;

use Plack::Builder;

builder {
    mount '/'      => mockweb->to_app;
    mount '/admin'      => mockweb_admin->to_app;
}

=end comment

=cut

