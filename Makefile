.PHONY: all deps compile test clean start doc

PROJECT = metatron
REBAR = rebar
DIALYZER = dialyzer

all: deps compile doc

deps:
	$(REBAR) get-deps

compile:
	$(REBAR) compile

test:
	$(REBAR) eunit skip_deps=true

clean:
	$(REBAR) clean
	rm -rf erl_crash.dump

run: all
	erl -pa ebin -pa deps/*/ebin -boot start_sasl -s metatron_app

doc:
	$(REBAR) doc skip_deps=true

build-plt:
	@$(DIALYZER) --build_plt --output_plt .$(PROJECT).plt \
	    --apps kernel stdlib sasl \
	    -r deps/cowboy deps/mimetypes deps/jsx

dialyze:
	@$(DIALYZER) --src src --plt .$(PROJECT).plt --no_native \
	    -Werror_handling -Wrace_conditions -Wunmatched_returns # -Wunderspecs
