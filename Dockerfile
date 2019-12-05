# Unofficial fivefilters Full-Text RSS service
# Enriches third-party RSS feeds with full text articles
# https://bitbucket.org/fivefilters/full-text-rss

FROM	alpine/git as gitsrc
WORKDIR /ftr
RUN	git clone https://bitbucket.org/fivefilters/full-text-rss.git . && \
		git reset --hard 384d52fd83361ffd6e7f28bd39b322970a015a28


FROM	alpine/git as gitconfig
WORKDIR	/ftr-site-config
RUN	git clone https://github.com/fivefilters/ftr-site-config . && \
		git reset --hard 8e6f5b09786555a26bc46b37dbd71b306e2c4312


FROM	php:apache

COPY --from=gitsrc /ftr /var/www/html
COPY --from=gitconfig /ftr-site-config/.* /ftr-site-config/* /var/www/html/site_config/standard/

RUN		mkdir -p /var/www/html/cache/rss && \
			chmod -Rv 777 /var/www/html/cache && \
			chmod -Rv 777 /var/www/html/site_config

VOLUME	/var/www/html/cache

COPY	custom_config.php /var/www/html/

HEALTHCHECK CMD curl -f localhost || exit 1;
