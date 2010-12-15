source 'http://rubygems.org' 

gem 'rails', '3.0.0'

if defined?(JRUBY_VERSION)

  gem 'activerecord-jdbc-adapter', '0.9.4'
  gem 'activerecord-jdbcmysql-adapter'
  gem 'jruby-openssl'
  gem 'jruby-rack'
  gem 'warbler'
else
  gem 'mysql'
  #gem 'mysql2
  #gem 'mysql2', "0.2.3"
  gem 'unicorn'
  gem 'system_timer'
  gem 'roo', "1.3.11"
end

gem 'mongrel'
gem "transitions", :require => ["transitions", "active_record/transitions"]
gem 'redis'


# Deploy with Capistrano
# gem 'capistrano'

# gem 'authlogic'

gem 'authlogic', :git => 'git://github.com/odorcicd/authlogic.git', :branch => 'rails3'  #hmm
#gem 'cancan'
gem 'formtastic'
gem 'compass', ">= 0.10.5"
gem 'fancy-buttons'
gem 'haml'

gem 'adhearsion', ">= 1.0.0" 

#
# gem fastercsv ?

unless defined?(JRUBY_VERSION)
  group  :test, :cucumber do
    gem "autotest"
    gem 'capybara'
    gem 'webrat'
    gem 'database_cleaner'
    gem 'factory_girl'
    gem 'factory_girl_rails'
    gem 'cucumber-rails'
    gem "cucumber"
    gem "launchy"
    gem "rspec-rails", ">= 2.0.0.beta.20"
  end
end
