package PerlChinaAdvent;

use Mojo::Base 'Mojolicious';
use PerlChinaAdvent::Entry qw/get_available_years/;

sub startup {
    my $c = shift;

    $c->plugin('DefaultHelpers');
    $c->plugin('TagHelpers');

    # header
    $c->hook(before_dispatch => sub {
        my $c = shift;

        my @years = get_available_years();
        $c->stash(all_years => \@years);

        my $is_disqus_on = 0;
        $c->stash(is_disqus_on => $is_disqus_on);
    });

    my $r = $c->routes;

    $r->get('/')->to('calendar#index');
    $r->get('/calendar/')->to('calendar#index');

    my $r_year = $r->get('/calendar/:year' => [year => qr/\d+/]);

    $r_year->get('/')->to('calendar#year');
    $r_year->get('/:day' => [day => qr/\d+/])->to('calendar#entry');
}

1;
