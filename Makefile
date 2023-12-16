#Variables
VENV           = .venv
VENV_PYTHON    = $(VENV)/bin/python
SYSTEM_PYTHON  = $(or $(shell which python3.11), $(shell which python3), $(shell which python))
PYTHON         = $(or $(wildcard $(VENV_PYTHON)), $(SYSTEM_PYTHON))

build: .env .venv

.venv:
	([ '$(SKIP_VENV)' = '1' ] || [ -d '$(VENV)' ]) || $(SYSTEM_PYTHON) -m venv $(VENV)
	$(VENV_PYTHON) -m pip install --upgrade pip wheel setuptools pip-tools
	$(VENV_PYTHON) -m pip install poetry

.env:
	cp .env.dist .env

VENV_POETRY = $(VENV)/bin/poetry
POETRY      = $(or $(wildcard $(VENV_POETRY)), $(shell which poetry))

.PHONY: install-requirements
install-requirements: .venv
	$(POETRY) install --no-root


.PHONY: clean
clean:
	rm -rf $(VENV)
	find . -iname "*.pyc" -exec rm -rf {} +
	find . -iname "*.egg-info" -exec rm -rf {} +

BLACK = $(or $(wildcard $(VENV)/bin/black), $(shell which black))
RUFF  = $(or $(wildcard $(VENV)/bin/ruff), $(shell which ruff))
MYPY  = $(or $(wildcard $(VENV)/bin/mypy), $(shell which mypy))

.PHONY: format
format:
	$(BLACK) src/ test/
	$(RUFF) check --fix-only src/ test/

.PHONY: lint
lint:
	$(BLACK) --check src/ test/
	$(RUFF) check src/ test/
	$(MYPY) src/ test/

MUTMUT = $(or $(wildcard $(VENV)/bin/mutmut), $(shell which mutmut))
COVERAGE = $(or $(wildcard $(VENV)/bin/coverage), $(shell which coverage))

.PHONY: test
test:
	$(COVERAGE) run -m unittest

.PHONY: test-infection
test-infection:
	$(MUTMUT) run

.PHONY: show-mutations
show-mutations:
	$(MUTMUT) html
	cd html && echo "*" > .gitignore
	$(PYTHON) -m webbrowser -t file://$(CURDIR)/html/index.html

.PHONY: show-coverage
show-coverage:
	$(COVERAGE) html -d ".test-reports/coverage/"
	$(PYTHON) -m webbrowser -t file://$(CURDIR)/.test-reports/coverage/index.html

format-check:
	$(POETRY) run black --diff . || (echo "Black found code formatting issues. Please run 'black .' to format the code." && exit 1)

lint-check:
	$(POETRY) run ruff check src/ test/ || (echo "Linting issues found. Please address them before proceeding." && exit 1)
	$(POETRY) run black --check src/ test/ || (echo "Black found code formatting issues. Please run 'black .' to format the code." && exit 1)
	$(POETRY) run mypy src/ test/ || (echo "Mypy found type issues. Please address them before proceeding." && exit 1)
