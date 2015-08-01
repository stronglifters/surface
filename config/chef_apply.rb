execute "apt-get_update" do
  command "apt-get update -y"
end

execute "apt-get_upgrade" do
  command "apt-get upgrade -y"
end

packages = %w{
  build-essential
  curl
  exuberant-ctags
  git-core
  libcurl4-openssl-dev
  libffi-dev
  libreadline-dev
  libsqlite3-dev
  libssl-dev
  libxml2-dev
  libxslt1-dev
  libyaml-dev
  memcached
  python-software-properties
  redis-server
  software-properties-common
  sqlite3
  unzip
  zlib1g-dev
}

package packages do
  action :install
end

phantomjs = "phantomjs-1.9.8-linux-x86_64"
remote_file "/tmp/#{phantomjs}.tar.bz2" do
  source "https://bitbucket.org/ariya/phantomjs/downloads/#{phantomjs}.tar.bz2"
  action :create
end

bash "install_phantomjs" do
  user "root"
  cwd "/tmp"
  not_if { ::File.exist?("/usr/local/bin/phantomjs") }
  code <<-SCRIPT
    tar xvjf #{phantomjs}.tar.bz2
    mv #{phantomjs} /usr/local/share
  SCRIPT
end

link "/usr/local/bin/phantomjs" do
  to "/usr/local/share/bin/phantomjs"
end

bash "install postgres" do
  user "root"
  not_if { ::File.exist?("/etc/apt/sources.list.d/pgdg.list") }
  code <<-SCRIPT
    echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc \
      | apt-key add -
    apt-get update -y
    apt-get install -y postgresql-9.4 libpq-dev \
      postgresql-contrib-9.4 postgresql-client-common
  SCRIPT
end

bash "create_vagrant_db" do
  user "vagrant"
  code <<-SCRIPT
    createdb
  SCRIPT
end

execute "install_node" do
  command "curl -sL https://deb.nodesource.com/setup | bash -"
end

package ["nodejs"] do
  action :install
end

bash "create_postgres_user" do
  code <<-SCRIPT
    createuser -s -e -w vagrant
  SCRIPT
end

git "/usr/local/rbenv" do
  repository "https://github.com/sstephenson/rbenv.git"
  action :sync
end

bash "install_rbenv" do
  user "root"
  cwd "/tmp"
  not_if { ::File.exist?("/etc/profile.d/rbenv.sh") }
  code <<-EOH
    echo 'export RBENV_ROOT="/usr/local/rbenv"' >> /etc/profile.d/rbenv.sh
    echo 'export PATH="/usr/local/rbenv/bin:$PATH"' >> /etc/profile.d/rbenv.sh
    echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
  EOH
end

directory "/usr/local/rbenv/plugins" do
  action :create
end

git "/usr/local/rbenv/plugins/ruby-build" do
  repository "https://github.com/sstephenson/ruby-build.git"
  action :sync
end

bash "install_ruby" do
  user "root"
  not_if { ::File.exist?("/usr/local/rbenv/shims/ruby") }
  code <<-EOH
    source /etc/profile.d/rbenv.sh
    rbenv install 2.2.2
    rbenv global 2.2.2
  EOH
end

bash "install_bundler" do
  user "root"
  code <<-EOH
    source /etc/profile.d/rbenv.sh
    gem install bundler --no-ri --no-rdoc
  EOH
end

bash "copy_env_local" do
  user "vagrant"
  cwd "/vagrant"
  not_if { ::File.exist?("/vagrant/.env.local") }
  code <<-EOH
    cp .env.example .env.local
  EOH
end

service "redis-server" do
  action [:enable, :start]
end
