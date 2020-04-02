install:
	bundle install

dbm:
	RUBYOPT='-W:no-deprecated -W:no-experimental' rails db:migrate

dbs:
	RUBYOPT='-W:no-deprecated -W:no-experimental' rails db:seed

r:
	RUBYOPT='-W:no-deprecated -W:no-experimental' rails routes

psql:
	RUBYOPT='-W:no-deprecated -W:no-experimental' rails dbconsole

s:
	RUBYOPT='-W:no-deprecated -W:no-experimental' rails server

test:
	RUBYOPT='-W:no-deprecated -W:no-experimental' bundle exec rspec

test-m:
	RUBYOPT='-W:no-deprecated -W:no-experimental' bundle exec rspec spec/models

test-c:
	RUBYOPT='-W:no-deprecated -W:no-experimental' bundle exec rspec spec/controllers

test-f:
	RUBYOPT='-W:no-deprecated -W:no-experimental' bundle exec rspec spec/features

t:
	bundle exec rspec $(T)

push:
	git push -u origin $(B)

push-m:
	git push -u origin master

c:
	RUBYOPT='-W:no-deprecated -W:no-experimental' rails console

clean:
	rake assets:clobber

sq:
	bundle exec sidekiq -q default -q mailers

when:
	bundle exec whenever

redis:
	redis-server

ts-start:
	RUBYOPT='-W:no-deprecated -W:no-experimental' rake ts:start

ts-stop:
	RUBYOPT='-W:no-deprecated -W:no-experimental' rake ts:stop

deploy:
	RUBYOPT='-W:no-deprecated -W:no-experimental' bundle exec cap production deploy

ssh:
	ssh deployer@134.209.194.226 -p 2222

.PHONY:	test
