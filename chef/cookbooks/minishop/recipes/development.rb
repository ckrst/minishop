docker_service 'default' do
  action [:create, :start]
end

# docker_image 'mysql' do
#     tag '5.6'
#     action :pull_if_missing
# end

# docker_image 'mariadb' do
# # docker_image 'bitnami/mariadb' do
#     tag 'latest'
#     action :pull_if_missing
#     read_timeout 240
# end

docker_image 'bitnami/mariadb' do
# docker_image 'bitnami/mariadb' do
    tag '10.3'
    action :pull_if_missing
    read_timeout 240
end

docker_image 'bitnami/opencart' do
    tag 'latest'
    action :pull_if_missing
end

docker_network 'opencart-tier'
# docker_network 'my_network' do
#   subnet '10.9.8.0/24'
#   gateway '10.9.8.1'
# end

docker_volume 'mariadb_data' do
  action :create
end

docker_volume 'opencart_data' do
  action :create
end


docker_container 'dbserver' do
    repo 'bitnami/mariadb'
    tag '10.3'
    port [
        '3306:3306'
    ]
    env [
        'MYSQL_ROOT_PASSWORD=ckrstadmin',
        'MYSQL_ALLOW_EMPTY_PASSWORD=yes',

        'ALLOW_EMPTY_PASSWORD=yes',

        'MARIADB_USER=bn_opencart',
        'MARIADB_DATABASE=bitnami_opencart'
    ]
    volumes 'mariadb_data:/bitnami'
    network_mode 'opencart-tier'
    action :run
end

docker_container 'webserver' do
    repo 'bitnami/opencart'
    tag 'latest'
    port [
        '80:80',
        '443:443'
    ]
    env [
        "ALLOW_EMPTY_PASSWORD=yes",

        "APACHE_ENABLE_CUSTOM_PORTS=no",
        "APACHE_HTTPS_PORT_NUMBER=443",
        "APACHE_HTTP_PORT_NUMBER=80",
        # "APACHE_HTTP_PORT_NUMBER=8080",

        "BITNAMI_APP_NAME=opencart",
        "BITNAMI_IMAGE_VERSION=3.0.3-2-debian-10-r47",

        # MYSQL
        "MYSQL_CLIENT_CREATE_DATABASE_NAME=",
        "MYSQL_CLIENT_CREATE_DATABASE_PASSWORD=",
        "MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES=ALL",
        "MYSQL_CLIENT_CREATE_DATABASE_USER=",
        "MYSQL_CLIENT_ENABLE_SSL=no",
        "MYSQL_CLIENT_SSL_CA_FILE=",

        # MARIADB
        "MARIADB_HOST=dbserver",
        "MARIADB_DATABASE=bitnami_opencart",
        "MARIADB_ROOT_PASSWORD=ckrstadmin",
        "MARIADB_PORT_NUMBER=3306",
        "MARIADB_ROOT_USER=root",

        # OPENCART
        "OPENCART_USERNAME=user",
        "OPENCART_PASSWORD=bitnami1",
        "OPENCART_EMAIL=user@example.com",
        # "OPENCART_HOST=localhost:8080",
        # "OPENCART_HOST=localhost",
        # "OPENCART_PORT=8080",
        "OPENCART_HTTP_TIMEOUT=120",

        "OPENCART_DATABASE_USER=bn_opencart",
        "OPENCART_DATABASE_PASSWORD=",
        "OPENCART_DATABASE_NAME=bitnami_opencart",

        # SMTP
        "SMTP_HOST=",
        "SMTP_PASSWORD=",
        "SMTP_PORT=",
        "SMTP_PROTOCOL=",
        "SMTP_USER="





    ]
    volumes 'opencart_data:/bitnami'
    network_mode 'opencart-tier'

    links ["dbserver:dbserver"]
end
