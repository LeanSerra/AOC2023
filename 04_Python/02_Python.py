import re

file = open("input", "r")

count = 0
cards: list = []
card_amount: list = []
final_card_amount = 0
for i, line in enumerate(file.readlines()):
    cards.append(line)
    card_amount.append(1)

for card_num, card in enumerate(cards):
    winner_count = 0
    for i in range(card_amount[card_num]):
        if winner_count == 0:
            line = re.sub(r"([C][a][r][d][ ]*[0-9]*:)", "", card)

            winners = line.split("|")[0]
            have = line.split("|")[1]

            winner_nums = winners.strip().replace("  ", " ").split(" ")
            have_nums = have.strip().replace("  ", " ").split(" ")

            for have in have_nums:
                if have in winner_nums:
                    winner_count += 1
        for j in range(card_num, card_num + winner_count):
            card_amount[j + 1] += 1
        if i == card_amount[card_num] - 1:
            winner_count = 0


for i, amount in enumerate(card_amount):
    final_card_amount += amount

print(final_card_amount)
