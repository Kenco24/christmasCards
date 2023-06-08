import os


with open('employee.txt', 'r') as file:
    names = file.read().splitlines()


with open('template.txt', 'r') as file:
    template = file.read()



for name in names:

    card_template = template.replace('NAME', name)

    card_filename = f'christmasCards/Christmas_Card_For_{name}.txt'


    with open(card_filename, 'w') as file:
        file.write(card_template)



