import os

def rename(path):
    if not os.path.isdir(path):
        print(f'{path} is not a dir')
        return
    for file in os.listdir(path):
        if(os.path.isdir(f'{path}/{file}')):
            rename(f'{path}/{file}')
        else:
            if file.endswith('movement.json'):
                name_split = file.split('_')
                try:
                    new_name = name_split[0] + name_split[1] + '_' + name_split[2] + '.json'
                    os.rename(f'{path}/{file}', f'{path}/{new_name}')
                except:
                    print(name_split)


def main():

    for directory in os.listdir():
        rename(directory)


if __name__ == "__main__":
    main()
