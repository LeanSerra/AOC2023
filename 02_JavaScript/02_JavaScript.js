const fs = require('fs');
const readline = require('readline')

async function parseGameFile() {
    const fileStream = fs.createReadStream('input');
    
    const rl = readline.createInterface({
        input: fileStream,
    });

    let sumPowerOfCubes = 0;

    for await (const line of rl) {
        let red = 1;
        let green = 1;
        let blue = 1;
        
        sets = line.split(":")[1].split(";");
        sets.forEach(set => {


            balls = set.split(",");
            balls = balls.forEach(ball=> {
                ball = ball.trim();
                
                number = parseInt(ball.split(" ")[0]);
                color = ball.split(" ")[1].trim();

                switch (color) {
                    case "red":
                        if (number > red) {
                            red = number;
                        }
                        break;
                    case "green":
                        if(number > green) {
                            green = number;
                        }
                        break;
                    case "blue":
                        if(number > blue) {
                            blue = number;
                        }
                        break;
                    default:
                        break;
                }
            })
            
            
        });
        sumPowerOfCubes += red*green*blue;
    }
    console.log("The sum of powers is:", sumPowerOfCubes)
}

parseGameFile();