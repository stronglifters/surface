execute "apt-get update -y"
execute "curl -sL https://deb.nodesource.com/setup | bash -"

packages = %w{
  build-essential
  curl
  git-core
  libcurl4-openssl-dev
  libffi-dev
  libpq-dev
  libreadline-dev
  libssl-dev
  libxml2-dev
  libxslt1-dev
  libyaml-dev
  nodejs
  phantomjs
  postgresql
  postgresql-client-common
  postgresql-contrib
  python-software-properties
  redis-server
  zlib1g-dev
}

package packages

sql = "SELECT 1 FROM pg_roles WHERE rolname='ubuntu'"
create_user = "createuser -s -e -w ubuntu"
execute "psql postgres -tAc \"#{sql}\" | grep -q 1 || #{create_user}" do
  user "postgres"
end

sql = "SELECT 1 FROM pg_roles WHERE rolname='ubuntu'"
execute "createdb" do
  user "ubuntu"
  not_if { "psql postgres -tAc \"#{sql}\" | grep -q 1" }
end

git "/usr/local/rbenv" do
  repository "https://github.com/sstephenson/rbenv.git"
end

file "/etc/profile.d/rbenv.sh" do
  content <<-CONTENT
export RBENV_ROOT="/usr/local/rbenv"
export PATH="/usr/local/rbenv/bin:$PATH"
eval "$(rbenv init -)"
CONTENT
end

directory "/usr/local/rbenv/plugins"
git "/usr/local/rbenv/plugins/ruby-build" do
  repository "https://github.com/sstephenson/ruby-build.git"
end

ruby_version = `cat /vagrant/.ruby-version`.strip
bash "install_ruby" do
  user "root"
  not_if { ::Dir.exist?("/usr/local/rbenv/versions/#{ruby_version}") }
  code <<-EOH
source /etc/profile.d/rbenv.sh
rbenv install #{ruby_version}
rbenv global #{ruby_version}
EOH
end

bash "install_bundler" do
  user "root"
  code <<-EOH
source /etc/profile.d/rbenv.sh
gem install bundler --no-ri --no-rdoc
EOH
end

execute "cp .env.example .env.local" do
  user "ubuntu"
  cwd "/vagrant"
  not_if { ::File.exist?("/vagrant/.env.local") }
end

["redis-server", "postgresql"].each do |service_name|
  service service_name do
    action [:enable, :start]
  end
end
