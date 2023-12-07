import std.algorithm;
import std.conv;
import std.format;
import std.math;
import std.range;
import std.stdio;
import std.string;
import std.typecons;


enum string input = import("input.txt");

enum cards = "J23456789TQKA";
enum HandType : byte {
    HighCard,
    OnePair,
    TwoPairs,
    ThreeOfKind,
    FullHouse,
    FourOfKind,
    FiveOfKind
}

HandType handType(string hand) {
    auto data = hand.array().sort().group().array().sort!((a, b) => a[1] > b[1]);
    
    auto jIndex = data.countUntil!(a => a[0] == 'J');
    if (jIndex != -1) {
        auto firstNonJIndex = data.countUntil!(a => a[0] != 'J');
        if (firstNonJIndex != -1) {
            data[firstNonJIndex][1] += data[jIndex][1];
            data = data.remove(jIndex);
        }
    }

    if (data[0][1] == 5) return HandType.FiveOfKind;
    else if (data[0][1] == 4) return HandType.FourOfKind;
    else if (data[0][1] == 3 && data[1][1] == 2) return HandType.FullHouse;
    else if (data[0][1] == 3) return HandType.ThreeOfKind;
    else if (data[0][1] == 2 && data[1][1] == 2) return HandType.TwoPairs;
    else if (data[0][1] == 2) return HandType.OnePair;
    return HandType.HighCard;
}

void main() {
    auto lines = input.split("\r\n");

    int result = 0;
    auto data = lines.map!((line) {
            auto l = line.split();
            return tuple(l[0], l[1].to!int);
        })
        .array()
        .sort!((a, b) {
            if (a[0].handType < b[0].handType) return true;
            if (a[0].handType > b[0].handType) return false;
            for (int i = 0; i < a[0].length; i++) {
                if (cards.countUntil(a[0][i]) < cards.countUntil(b[0][i])) return true;
                if (cards.countUntil(a[0][i]) > cards.countUntil(b[0][i])) return false;
            }
            return false;
        });
    
    for (int i = 0; i < data.length; i++) {
        result += (i + 1) * data[i][1];
    }

    writeln("Result: ", result);
}
