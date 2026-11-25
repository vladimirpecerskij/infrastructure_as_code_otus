$workers = lookup('nginx::worker_processes')
$db_host = lookup('app::db_host')

notify { "Hiera resolved: workers=${workers}, db_host=${db_host}": }
