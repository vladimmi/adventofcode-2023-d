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

    int[string] maxCubes;

    int result = 0;

    foreach (line; lines) {
        maxCubes = [
            "red": 0,
            "green": 0,
            "blue": 0
        ];

        string data = line.split(":")[1];
        string[] sets = data.split(";");
        foreach (set; sets) {
            string[] picks = set.split(",");
            foreach (pick; picks) {
                pick.strip.formattedRead("%d %s", numberBuffer, wordBuffer);
                if (numberBuffer > maxCubes[wordBuffer]) {
                    maxCubes[wordBuffer] = numberBuffer;
                }
            }
        }
    
        result += maxCubes["red"] * maxCubes["green"] * maxCubes["blue"];
    }

    writeln("Result: ", result);
}
