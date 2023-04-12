package mockweb;

use Dancer2;
use Dancer2::Plugin::DBIC;
use FindBin '$RealBin';
use Try::Tiny::Warnings ':all';
use Data::Dumper;

set serializer => 'JSON';

my $sqlite_dsn = "dbi:SQLite:dbname=$RealBin/../data/mockweb.db";
setting('plugins')->{'DBIC'}->{'default'}->{'dsn'} = $sqlite_dsn;
my $valid_key = $ENV{CNAM_API_KEY} // config->{api_key};

our $VERSION = '0.1';


get  '/ecid/v1/identity' => sub { get_caller_name('get') };
post '/ecid/v1/identity' => sub { get_caller_name('post') };

sub get_caller_name {
    validate_api_key();
    my $method  = shift;
    my $calling_party =  body_parameters->get('calling_party')
                      // query_parameters->get('calling_party');

    if ( !$calling_party ) {
        error "No calling number found";
        status 400;
        halt ();
    }
    info "Initial calling Number: $calling_party";
    $calling_party = to_e164( $calling_party );
    info "Normalized calling Number: $calling_party";

    my $txn_id =  body_parameters->get('txn_id')
               // query_parameters->get('txn_id')
               // '';

    my $result = schema->resultset('CallingNumber')->find( 
        {
            id => $calling_party
        }, { 
            prefetch => 'presentation' 
        } 
    );

    if ( !$result ) {
        #{"status":"ok","txn_id":"abcdefg","cnam":{"calling_name_status":"unavailable"}}
        my $return = {
            status => 'ok',
            cnam   => {
                calling_name_status => 'unavailable'
            }
        };

        if ( $txn_id ) {
            $return->{txn_id} = $txn_id;
        }
        return $return;
    } 
    
    my $calling_name = $result->calling_name;
    my $presentation = $result->presentation->val;

    info "Caller name [$calling_name]. Presentation[$presentation]";

    my $return = {
        status => 'ok',
        cnam   => {
            calling_name_status    => 'available',
            calling_name           => $calling_name,
            presentation_indicator => $presentation,
        }
    };
    if ( $txn_id ) {
        $return->{txn_id} = $txn_id;
    }
    info to_json($return);
    return $return;
}

sub to_e164 {
    my $num = shift;
    if ( $num =~ /^\+/ ) {
        info "Calling Number starts with '+'. Consider it already normalized";
        return $num;
    }
    if ( $num =~ /^1?(\d*)/ ) {
        info "Calling number is all digits. May start with 1.  Normliaze:";
        my $norm = "+1$1";
        info "Normalized to $norm";
        return $norm;
    }
    warning "$num doesn't really look like a phone number. Leave it alone";
    return $num;

}


sub validate_api_key {
    my $api_key      = query_parameters->get('api_key') // "empty";

    if ( query_parameters->get('api_key')  ne $valid_key ) {
        error "API KEY is a mismatch. Expected [$valid_key].  Got $api_key";
        status 400;
        halt();
    }

}




sub make_schema {
    try_warnings {
        schema->deploy( { add_drop_table => 0 } );
    }
    catch {
        die($_);  ## if try_warnings was a fatal error, then *actually* die.
    }
    catch_warnings {
        info "exception when deploying DB (possibly already exists, which is OK)";
    };

    schema->resultset('Presentation')
          ->update_or_create( { val => 'restricted' } );
    schema->resultset('Presentation')
          ->update_or_create( { val => 'allowed' } );

    my $allowed    = schema->resultset('Presentation')
                           ->find({ val => 'allowed' });
    my $restricted = schema->resultset('Presentation')
                           ->find({ val => 'restricted' });

    schema->resultset('CallingNumber')->update_or_create({ 
        id           => '+18885432000', 
        calling_name => 'BCM ONE', 
        presentation => $allowed 
    });
    schema->resultset('CallingNumber')->update_or_create({ 
        id           => '+16127359309', 
        calling_name => 'KAUFMAN, BEN', 
        presentation => $allowed 
    });
    schema->resultset('CallingNumber')->update_or_create({ 
        id           => '+16137828111', 
        calling_name => 'BANK OF CANADA', 
        presentation => $allowed 
    });

}









true;
