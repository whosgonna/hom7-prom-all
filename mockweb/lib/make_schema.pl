#!/usr/bin/env perl
use FindBin '$RealBin';
use local::lib "$RealBin/../local";

use DBIx::Class::Schema::Loader qw/ make_schema_at /;
make_schema_at(
    'Mock::Neustar::CNAM::Schema',
    { debug => 1,
      dump_directory => "$RealBin/../lib",
    },
    [ "dbi:SQLite:dbname=$RealBin/../data/data", undef, undef,
       #{ loader_class => 'Burnnote' } # optionally
    ],
);
