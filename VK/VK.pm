package VK;

use URI;
use DDP;
use JSON::XS;
use AnyEvent::HTTP;

sub new {
    my ($class, %args) = @_;
    die "VK::new access_token is required" unless $args{access_token};
    my $self = bless {
        token => delete $args{access_token},
        v => "5.95",
        %args
    }, $class;
    $self->tags;
    return $self;
}

sub request {
    my $self = shift;
    my $cb = pop;
    my %args = @_;

    die "VK::request: no method given" unless $args{method};

    my $uri = URI->new(sprintf "https://api.vk.com/method/%s", $args{method});
    $uri->query_form(
        access_token => $self->{token},
        v => $self->{v},
        %{ $args{args} },
    );

    http_request(
        GET => "$uri",
        sub {
            my ($b, $h) = @_;
            unless ($h->{Status} == 200) {
                warn "$h{URL}: $h{Status} $h{Reason}";
                return $cb->(undef, "$h{Status} $h{Reason}");
            }

            my $data = JSON::XS::decode_json($b);
            if ($data->{error}) {
                p $data;
                return $cb->(undef, $b);
            }

            return $cb->($data->{response});
        },
    );
    return;
}

sub users_get {
    my $self = shift;
    my $cb = pop;
    my @uids = @_;

    return $cb->(undef, "no uids given") unless @uids;

    # Params:
    # photo_id verified sex bdate city country home_town has_photo photo_50 photo_100 photo_200_orig photo_200 photo_400_orig photo_max photo_max_orig
    # online domain has_mobile contacts site education universities schools status last_seen followers_count common_count occupation nickname relatives relation
    # personal connections exports activities interests music movies tv books games about quotes can_post can_see_all_posts can_see_audio can_write_private_message
    # can_send_friend_request is_favorite is_hidden_from_feed timezone screen_name maiden_name crop_photo is_friend friend_status career military blacklisted blacklisted_by_me);

    return $self->request(
        method => "users.get",
        args => {
            user_ids => join(",", @uids),
            fields => join(",", qw(first_name last_name sex bdate online city home_town universities status relation photo_max_orig )),
        },
        $cb,
    );
}

sub tags{
    my $self = shift;
    my $uri = URI->new("https://api.vk.com/method/streaming.getServerUrl");
    $uri->query_form(
                v => 5.95,
                access_token => "74c198fb74c198fb74c198fb75749e166a774c174c198fb2ecc459d39284f0741ddc759",
    );

    my $endpoint;
    my $key;
    my @text_tag;
    http_request
    GET => "$uri",
    sub {
        if ($_[1]{Status} == 200) {
            my $j = JSON::XS::decode_json($_[0]);
            $endpoint = $j->{response}->{endpoint};

            $key = $j->{response}->{key};

                        
            http_request
            GET => "https://$endpoint/rules?key=$key",
            sub {
                if ($_[1]{Status} == 200) {
                    my $N = JSON::XS::decode_json($_[0]);
                    #$self->{tags}= $N;
                    ##p $N; exit;
                    for my $val (@{$N->{rules}}) {
                        $self->{tags}{ $val->{tag} } = $val->{value};
                    }
                } else {
                    warn "$_[1]{Status} $_[1]{Reason}\n";
                }            

            };
        } else {
            warn "$_[1]{Status} $_[1]{Reason}\n";
        }    
    };
    return;
}

sub groups_get {
    my $self = shift;
    my $cb = pop;
    my @gids = @_;

    return $cb->(undef, "no gids given") unless @gids;

    return $self->request(
        method => "groups.getById",
        args => {
            group_ids => join(",", @gids),
            fields => join(",", qw(photo_100 name nickname screen_name home_town city)),
        },
        $cb,
    );
}

1;
