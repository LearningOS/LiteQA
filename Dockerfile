FROM jiting/rails-base:builder-latest AS Builder

FROM jiting/rails-base:production-latest

RUN apk add --no-cache \
	libffi-dev \
	vips-dev

COPY docker/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
