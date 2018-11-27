import os
import sys

print(sys.version)

env_var = os.getenv('TEST_VAR')

if env_var:
	print(env_var)
else:
	print('TEST_VAR not found') 
