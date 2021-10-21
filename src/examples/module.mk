test-examples: test-example-java test-example-python  ## Test example code projects

test-example-java:  ## Test example Java project
	@echo "Verifying Java example..."
	cd src/examples/java && \
		docker-compose run example mvn test

test-example-python:  ## Test example Python project
	@echo "Verifying Python example..."
	cd src/examples/python && \
		docker-compose run example pytest
