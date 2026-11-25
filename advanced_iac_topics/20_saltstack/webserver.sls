install_nginx:
  pkg.installed:
    - name: nginx

create_index_html:
  file.managed:
    - name: /var/www/html/index.html
    - contents: |
        <h1>Configured by SaltStack State!</h1>
    - require:
      - pkg: install_nginx

ensure_nginx_running:
  service.running:
    - name: nginx
    - enable: True
    - watch:
      - file: create_index_html
