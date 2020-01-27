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
	RUBYOPT='-W:no-deprecated -W:no-experimental' rspec

test-m:
	RUBYOPT='-W:no-deprecated -W:no-experimental' rspec spec/models

test-c:
	RUBYOPT='-W:no-deprecated -W:no-experimental' rspec spec/controllers

push:
	git push -u origin $(B)

.PHONY:	test
