import re

file = open("input", "r")

count:int = 0

for line in file.readlines():
    line = re.sub(r'([C][a][r][d][ ]*[0-9]*:)', '', line)
    
    winners = line.split('|')[0]
    have = line.split('|')[1]

    winner_nums = winners.strip().replace('  ', ' ').split(' ')
    have_nums = have.strip().replace('  ', ' ').split(' ')

    card_value = 0

    for have in have_nums:
        if(have in winner_nums):
            card_value = 1 if card_value == 0 else card_value * 2
    count += card_value

print(count)