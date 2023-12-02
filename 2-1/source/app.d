import std.algorithm;
import std.format;
import std.range;
import std.stdio;
import std.string;


enum string input = import("input.txt");

void main() {
    auto lines = input.split("\r\n");

    string wordBuffer;
    int numberBuffer;

    int gameNumber;

    int result = 0;

    lineLoop:
    foreach (line; lines) {
        line.formattedRead("%s %d", wordBuffer, numberBuffer);
        gameNumber = numberBuffer;

        string data = line.split(":")[1];
        string[] sets = data.split(";");
        foreach (set; sets) {
            string[] picks = set.split(",");
            foreach (pick; picks) {
                pick.strip.formattedRead("%d %s", numberBuffer, wordBuffer);
                final switch (wordBuffer) {
                    case "red":
                        if (numberBuffer > 12) continue lineLoop;
                        break;
                    case "green":
                        if (numberBuffer > 13) continue lineLoop;
                        break;
                    case "blue":
                        if (numberBuffer > 14) continue lineLoop;
                        break;
                }
            }
        }
    
        result += gameNumber;
    }

    writeln("Result: ", result);
}
