FILES=*.js *.css *.html *.cgi lib  .htaccess ../source/images
JSFILES=source/*.js
CSSFILES=source/*.css

BETA_HOST=gigo.com
BETA_DIR=/var/www/beta.validator.test-ipv6.com

PROD_HOST=bender.gigo.com
PROD_DIR=/var/www/validator.test-ipv6.com/

default:: beta

test:
	perl  ./validate.cgi "server=vm1.test-ipv6.com&plugin=dns_ds_v4ns"
	echo 'url=http%3A%2F%2Fipv6.test-ipv6.com%2Fimages-nc%2Fknob_green.png' | perl  ./urlvalidate.cgi

beta:
	make DESTHOST=$(BETA_HOST) DESTDIR=$(BETA_DIR) install
	
prod:
	make DESTHOST=$(PROD_HOST) DESTDIR=$(PROD_DIR) install

sudoers:
	sudo cp fsky-validator.sudoers /etc/sudoers.d/fsky-validator
	sudo chmod 0440 /etc/sudoers.d/fsky-validator


install: index.js index.css
	ssh -t $(DESTHOST) mkdir -p $(DESTDIR)/cache
	ssh -t $(DESTHOST) "ls -ld $(DESTDIR)/cache | cut -f1 | grep drwsrwxrwx || sudo chmod 4777 $(DESTDIR)/cache"
	rsync -av $(FILES) $(DESTHOST):$(DESTDIR)/  --delete


index.js: $(JSFILES)
	cat $(JSFILES) > index.js
	 
index.css: $(CSSFILES)
	cat $(CSSFILES) > index.css

debug:
	echo 'url=http%3A%2F%2Fipv6.test-ipv6.com%2Fimages-nc%2Fknob_green.png' | ./urlvalidate.cgi
	
	