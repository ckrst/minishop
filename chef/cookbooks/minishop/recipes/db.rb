docker_service 'default' do
  action [:create, :start]
end

docker_image 'bitnami/mariadb' do
# docker_image 'bitnami/mariadb' do
    tag '10.3'
    action :pull_if_missing
    read_timeout 240
end

# docker_network 'opencart-tier'

docker_volume 'mariadb_data' do
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
    # network_mode 'opencart-tier'
    action :run
end
