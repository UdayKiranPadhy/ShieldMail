
format-check:
	poetry run black --diff . || (echo "Black found code formatting issues. Please run 'black .' to format the code." && exit 1)

lint-check:
	poetry run ruff check src/ tests/ || (echo "Linting issues found. Please address them before proceeding." && exit 1)
	poetry run black --check src/ tests/ || (echo "Black found code formatting issues. Please run 'black .' to format the code." && exit 1)
	poetry run mypy src/ || (echo "Mypy found type issues. Please address them before proceeding." && exit 1)