.PHONY: all deps compile test clean start

PROJECT = metatron
REBAR = rebar

all: deps compile

deps:
	$(REBAR) get-deps

compile:
	$(REBAR) compile

test:
	$(REBAR) eunit skip_deps=true

clean:
	$(REBAR) clean

run: all
	erl -pa ebin -pa deps/*/ebin -s metatron_app

