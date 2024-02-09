#!/bin/sh

awk '
{
    var = ""
    split($0, chars, "")
    for (i=1; i <= length($0);i ++) {
        if(match(chars[i], /([0-9])/))
        var = var chars[i]
    }
    split(var, vars, "")
    printf("%s%s\n",vars[1],  vars[length(vars)])

}
' input | (while read line; do
    count=$(($count+1))
    sum=$(($sum + $line))
done && echo $sum && echo $count)
