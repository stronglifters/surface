git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
git clone https://github.com/tpope/rbenv-ctags.git ~/.rbenv/plugins/rbenv-ctags
git clone https://github.com/rkh/rbenv-update.git ~/.rbenv/plugins/rbenv-update
git clone https://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash
rbenv update
rbenv install 2.2.2
rbenv global 2.2.2
gem install bundler --no-ri --no-rdoc
cd /vagrant
bundle install -j 2
if [ ! -f .env ]; then
  ln -s .env.example .env
fi
createdb
bundle exec rake db:create db:migrate db:seed
RAILS_ENV=test bundle exec rake db:create db:migrate db:seed
