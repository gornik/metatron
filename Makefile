.PHONY: all deps compile test clean

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

