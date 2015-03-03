rebuild:
	bundle exec nanoc compile
	bundle exec nanoc view

publish:
	bundle exec rake publish
