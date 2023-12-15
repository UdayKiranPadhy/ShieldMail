#Variables
VENV           = .venv
VENV_PYTHON    = $(VENV)/bin/python
SYSTEM_PYTHON  = $(or $(shell which python3.10), $(shell which python3), $(shell which python))
PYTHON         = $(or $(wildcard $(VENV_PYTHON)), $(SYSTEM_PYTHON))

build: .env vene activate install-requirements

vene:
	virtualenv -p python3.11 .venv

.PHONY: activate
activate: vene
	source .venv/bin/activate

.env:
	cp .env.dist .env

.PHONY: install-requirements
install-requirements:
	pip install --upgrade pip wheel setuptools pip-tools
	pip install poetry
	poetry install

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
	$(BLACK) src/ tests/
	$(RUFF) check --fix-only src/ tests/

.PHONY: lint
lint:
	$(BLACK) --check src/ tests/
	$(RUFF) check src/ tests/
	$(MYPY) src/

include Pipeline.mk