node default {
  # Создаём директорию приложения
  file { '/opt/iac-app':
    ensure => directory,
    mode   => '0755',
  }

  # Декларативно описываем конфигурационный файл с зависимостью от директории
  file { '/opt/iac-app/app.conf':
    ensure  => file,
    mode    => '0644',
    content => "app_name=wordpress\nenvironment=production\nmanaged_by=Puppet\n",
    require => File['/opt/iac-app'],
  }

  # Выводим информационное сообщение при применении каталога
  notify { 'App configuration applied successfully via Puppet!':
    require => File['/opt/iac-app/app.conf'],
  }
}
