#!/bin/sh

awk '
{
    var = ""
    split($0, chars, "")
    for (i=1; i <= length($0);i ++) {
        if(match(chars[i], /([0-9])/))
        var = var chars[i]
        switch(chars[i] chars[i+1] chars[i+2]) {
            case "one":
                var = var 1
                break
            case "two":
                var = var 2
                break
            case "six":
                var = var 6
                break
            default:
                break
        }
        switch(chars[i] chars[i+1] chars[i+2] chars[i+3]) {
            case "four":
                var = var 4
                break
            case "five":
                var = var 5
                break
            case "nine":
                var = var 9
            default:
                break
        }
        switch(chars[i] chars[i+1] chars[i+2] chars[i+3] chars[i+4]) {
            case "three":
                var = var 3
                break
            case "seven":
                var = var 7
                break
            case "eight":
                var = var 8
                break
            default:
                break
        }
    }
    split(var, vars, "")
    printf("%s%s\n", vars[1], vars[length(vars)])
}' input | (while read line; do
    count=$(($count+1))
    sum=$(($sum + $line))
done && echo $sum && echo $count)
