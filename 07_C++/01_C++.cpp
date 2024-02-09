#include <vector>
#include <fstream>
#include <sstream>
#include <array>
#include <iostream>
#include <cstring>
#include <map>
#include <algorithm>

enum hand_type
{
    five_of_a_kind = 6,
    four_of_a_kind = 5,
    full_house = 4,
    three_of_a_kind = 3,
    two_pair = 2,
    one_pair = 1,
    high_card = 0
};

typedef struct
{
    std::string cards;
    hand_type type;
    u_int16_t bid;
} card_hand;

void parseInputFile(const char *file_name, std::vector<card_hand> &card_hands);
hand_type getHandType(std::string hand);
bool compareHands(card_hand a, card_hand b);

int main(int argc, char const *argv[])
{
    if (argc < 2)
    {
        std::cout << "Usage " << argv[0] << " <input_file>" << std::endl;
        return 0;
    }
    std::vector<card_hand> card_hands = std::vector<card_hand>();

    parseInputFile(argv[1], card_hands);

    std::stable_sort(card_hands.begin(), card_hands.end(), compareHands);

    u_int32_t total_winnings = 0;

    for (size_t i = 0; i < card_hands.size(); i++)
    {
        std::cout << card_hands.at(i).cards << "\t" << card_hands.at(i).bid << "\t" << card_hands.at(i).type << "\t" << i + 1 << std::endl;
        total_winnings += card_hands.at(i).bid * (i + 1);
    }
    std::cout << total_winnings << std::endl;
    return 0;
}

void parseInputFile(const char *file_name, std::vector<card_hand> &card_hands)
{
    std::ifstream file(file_name);
    std::string line;

    if (file.is_open())
    {
        while (std::getline(file, line))
        {
            card_hand ch = {};

            std::string field;
            std::stringstream s(line);

            s >> field;
            ch.cards = field;
            ch.type = getHandType(field);
            s >> field;
            ch.bid = std::atoi(field.c_str());
            card_hands.push_back(ch);
        }
    }
}

hand_type getHandType(std::string hand)
{
    std::map<char, u_int8_t> dictionary = std::map<char, u_int8_t>();

    bool saw_three_flag = false;
    bool saw_two_flag = false;

    for (char c : hand)
    {
        dictionary[c]++;
    }

    for (auto const &[key, value] : dictionary)
    {
        if (value == 5)
            return five_of_a_kind;
        if (value == 4)
            return four_of_a_kind;
        if (value == 3)
        {
            if (saw_two_flag)
                return full_house;
            saw_three_flag = true;
        }
        if (value == 2)
        {
            if (saw_three_flag)
                return full_house;
            else
            {
                if (saw_two_flag)
                    return two_pair;
                saw_two_flag = true;
            }
        }
    }

    if (saw_three_flag)
        return three_of_a_kind;
    if (saw_two_flag)
        return one_pair;
    return high_card;
}

bool compareHands(card_hand a, card_hand b)
{
    std::map<char, int> card_value{
        {'A', 12},
        {'K', 11},
        {'Q', 10},
        {'J', 9},
        {'T', 8},
        {'9', 7},
        {'8', 6},
        {'7', 5},
        {'6', 4},
        {'5', 3},
        {'4', 2},
        {'3', 1},
        {'2', 0},
    };

    if (a.type != b.type)
    {
        return a.type < b.type ? true : false;
    }
    else
    {
        const char *a_cards = a.cards.c_str();
        const char *b_cards = b.cards.c_str();

        for (size_t i = 0; i < std::strlen(a_cards); i++)
        {
            if (card_value[a_cards[i]] < card_value[b_cards[i]])
            {
                return true;
            }
            else if (card_value[a_cards[i]] != card_value[b_cards[i]])
            {
                return false;
            }
        }
        return false;
    }
    return false;
}