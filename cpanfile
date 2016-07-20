requires 'perl', '5.010001';

on 'develop' => sub {
    requires 'CPAN::Uploader';
    requires 'Minilla';
    requires 'Version::Next';
};

on 'test' => sub {
    requires 'Test::More', '0.98';
};
