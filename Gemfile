source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'bundler', '~> 1.16.2'

gem 'rails', '= 5.2.0'

install_if -> { RUBY_PLATFORM =~ /(darwin|linux)/i } do
  gem 'bootsnap', '~> 1.2.0', require: false
end

# gem 'bcrypt',                 '~> 3.1.7' # has_secure_password
# gem 'byebug',                 '~> 10.0.0', group: [:development, :test], platforms: [:mri, :mingw, :x64_mingw]
# gem 'capistrano-rails',       group: :development # deployment
# gem 'jbuilder',               '~> 2.5'
# gem 'mini_magick',            '~> 4.8' # ActiveStorage
# gem 'mini_racer',             platforms: :ruby
# gem 'redis',                  '~> 4.0' # Action Cable
# gem 'tzinfo-data',            platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'brakeman',                 '~> 4.3.0', group: [:development]
gem 'capybara',                 '~> 3.1.1', group: [:test]
gem 'dawnscanner',              '~> 1.6.8', group: [:development], require: false
gem 'factory_bot_rails',        '~> 4.10.0', group: [:development, :test]
gem 'font-awesome-sass',        '~> 5.0.13'
gem 'listen',                   '>= 3.1.5', '< 3.2', group: [:development]
gem 'pg',                       '~> 1.0.0'
gem 'pry-rails',                '= 0.3.6', group: [:development, :test]
gem 'puma',                     '~> 3.11.2'
gem 'rails-controller-testing', '>= 1.0.2', group: [:test]
gem 'rspec-rails',              '~> 3.7.2', group: [:development, :test]
gem 'rubocop',                  '~> 0.56.0', group: [:development, :test]
gem 'sass-rails',               '~> 5.0.7'
gem 'selenium-webdriver',       '~> 3.12.0', group: [:test]
gem 'spring',                   '~> 2.0.2', group: [:development]
gem 'spring-commands-rspec',    '~> 1.0.4', group: [:development]
gem 'spring-watcher-listen',    '~> 2.0.1', group: [:development]
gem 'uglifier',                 '~> 4.1.10'
gem 'web-console',              '~> 3.6.2', group: [:development]
