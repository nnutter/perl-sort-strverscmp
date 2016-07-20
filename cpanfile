requires 'perl', '5.010001';

on 'develop' => sub {
    requires 'Minilla';
};

on 'test' => sub {
    requires 'Test::More', '0.98';
};
