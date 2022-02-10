import os

path = os.getcwd()

files = []
for r, d, f in os.walk(path):
    for file in f:
        if file.endswith('.gd'):
            files.append(os.path.join(r, file))

lines_of_code = 0

for file in files:
    with open(file, 'r') as f:
        lines_of_code += len(f.readlines())

print(lines_of_code)
