install_nginx:
  pkg.installed:
    - name: nginx

nginx_config:
  file.managed:
    - name: /var/www/html/index.html
    - contents: |
        <h1>Managed by SaltStack IaC</h1>
    - require:
      - pkg: install_nginx

nginx_service:
  service.running:
    - name: nginx
    - enable: True
    - watch:
      - file: nginx_config
