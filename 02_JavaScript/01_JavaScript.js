const fs = require('fs');
const readline = require('readline')

const maxRed = 12;
const maxGreen = 13;
const maxBlue = 14;

async function parseGameFile() {
    const fileStream = fs.createReadStream('input');
    
    const rl = readline.createInterface({
        input: fileStream,
    });

    let gameIDSum = 0;

    for await (const line of rl) {
        valid = true;

        gameID = parseInt(line.split(" ")[1].replace(":", ""));

        sets = line.split(":")[1].split(";");
        sets.forEach(set => {
            balls = set.split(",");
            balls = balls.forEach(ball=> {
                ball = ball.trim();
                
                number = parseInt(ball.split(" ")[0]);
                color = ball.split(" ")[1].trim();

                switch (color) {
                    case "red":
                        if(number > maxRed) valid=false;
                        break;
                    case "green":
                        if(number > maxGreen) valid=false;
                        break;
                    case "blue":
                        if(number > maxBlue) valid=false;
                        break;
                    default:
                        break;
                }
            })
        });
        if(valid) {
            console.log("gameID:", gameID, "is valid");
            gameIDSum += gameID;
        } else {
            console.log("gameID:", gameID, "is not valid");
        }
    }
    console.log("The sum of valid gameIDs is:", gameIDSum)
}

parseGameFile();