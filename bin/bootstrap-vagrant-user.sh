set -e
cd $HOME
git clone https://github.com/sstephenson/rbenv.git $HOME/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> $HOME/.bash_profile
echo 'eval "$(rbenv init -)"' >> $HOME/.bash_profile
source $HOME/.bash_profile
git clone https://github.com/sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build
git clone https://github.com/tpope/rbenv-ctags.git $HOME/.rbenv/plugins/rbenv-ctags
git clone https://github.com/rkh/rbenv-update.git $HOME/.rbenv/plugins/rbenv-update
git clone https://github.com/sstephenson/rbenv-gem-rehash.git $HOME/.rbenv/plugins/rbenv-gem-rehash
rbenv update
rbenv install 2.2.2
rbenv global 2.2.2
gem install bundler --no-ri --no-rdoc
cd /vagrant
createdb
if [ ! -f .env ]; then
  ln -s .env.example .env
fi
bin/setup
RAILS_ENV=test bundle exec rake db:create db:migrate db:seed
