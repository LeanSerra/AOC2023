use std::env;
use std::fmt;
use std::fs::File;
use std::io;
use std::io::BufRead;
use std::ops::IndexMut;
use std::path::Path;

#[derive(Copy, Clone)]
struct MazeNode {
    line: i32,
    column: i32,
    left: bool,
    right: bool,
    top: bool,
    bottom: bool,
    is_in_loop: bool,
    is_outside: bool,
    going_up: bool,
}

enum MazeCord {
    Left = 1,
    Right = 2,
    Top = 3,
    Bottom = 4,
}

impl fmt::Display for MazeNode {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let mut print_str;
        print_str = format!("{}", "");

        if self.is_in_loop {
            print_str = format!("{}{}", print_str, Colors::OKGREEN);
        } else if self.is_outside {
            print_str = format!("{}{}", print_str, Colors::FAIL);
        } else {
            print_str = format!("{}{}", print_str, Colors::OKBLUE);
        }

        if self.top && self.bottom {
            print_str = format!("{}{}", print_str, "│");
        } else if self.left && self.right {
            print_str = format!("{}{}", print_str, "─");
        } else if self.bottom && self.right {
            print_str = format!("{}{}", print_str, "┌");
        } else if self.bottom && self.left {
            print_str = format!("{}{}", print_str, "┐");
        } else if self.top && self.right {
            print_str = format!("{}{}", print_str, "└");
        } else if self.top && self.left {
            print_str = format!("{}{}", print_str, "┘");
        } else {
            print_str = format!("{}{}", print_str, "■");
        }

        print_str = format!("{}{}", print_str, Colors::ENDC);

        write!(f, "{}", print_str)
    }
}

enum Colors {
    // HEADER,
    OKBLUE,
    // OKCYAN,
    OKGREEN,
    // WARNING,
    FAIL,
    ENDC,
    // BOLD,
    // UNDERLINE,
}

impl Colors {
    fn as_str(&self) -> &'static str {
        match self {
            // Colors::HEADER => "\x1b[95m",
            Colors::OKBLUE => "\x1b[94m",
            // Colors::OKCYAN => "\x1b[96m",
            Colors::OKGREEN => "\x1b[92m",
            // Colors::WARNING => "\x1b[93m",
            Colors::FAIL => "\x1b[91m",
            Colors::ENDC => "\x1b[0m",
            // Colors::BOLD => "\x1b[1m",
            // Colors::UNDERLINE => "\x1b[4m",
        }
    }
}

impl fmt::Display for Colors {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}", self.as_str())
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let mut visualization_flag: bool = false;
    if args.len() < 2 {
        println!("Usage: {} <input_file>\n", args[0]);
        println!("--viz for map visualization\n");
        return;
    } else if args.len() == 3 {
        if args[2] == "--viz" {
            visualization_flag = true;
        }
    }

    let mut node_matrix: Vec<Vec<MazeNode>> = Vec::new();
    let mut s_node_location_line: i32 = i32::MAX;
    let mut s_node_location_column: i32 = i32::MAX;

    let mut line_lenght: usize = 0;
    let mut line_count: usize = 0;

    load_pipes(
        args[1].clone(),
        &mut node_matrix,
        &mut line_count,
        &mut line_lenght,
        &mut s_node_location_line,
        &mut s_node_location_column,
    );

    map_pipes(&mut node_matrix, line_lenght, line_count);

    println!("Line Lenght: {line_lenght}");
    println!("Line Count: {line_count}");

    let s_node: MazeNode =
        node_matrix[s_node_location_line as usize][s_node_location_column as usize];

    let mut loop_lenght: i32 = 0;

    if s_node.left {
        loop_lenght = get_loop_lenght(&mut node_matrix, s_node, MazeCord::Left);
    } else if s_node.right {
        loop_lenght = get_loop_lenght(&mut node_matrix, s_node, MazeCord::Right);
    } else if s_node.top {
        loop_lenght = get_loop_lenght(&mut node_matrix, s_node, MazeCord::Top);
    } else if s_node.bottom {
        loop_lenght = get_loop_lenght(&mut node_matrix, s_node, MazeCord::Bottom);
    }

    let inside_count = get_inside_count(&mut node_matrix, line_count, line_lenght);

    if visualization_flag {
        print_map_visualization(node_matrix);
    }
    println!("Steps until farthest point: {}", (loop_lenght) / 2);
    println!("Number of pipes inside: {}", inside_count);
}

fn read_lines<P>(file_name: P) -> io::Result<io::Lines<io::BufReader<File>>>
where
    P: AsRef<Path>,
{
    let file = File::open(file_name)?;
    Ok(io::BufReader::new(file).lines())
}

fn load_pipes(
    file_name: String,
    node_matrix: &mut Vec<Vec<MazeNode>>,
    line_count: &mut usize,
    line_lenght: &mut usize,
    s_node_location_line: &mut i32,
    s_node_location_column: &mut i32,
) {
    if let Ok(lines) = read_lines(file_name) {
        for (line, i) in lines.zip(0..) {
            *line_count += 1;
            if let Ok(ip) = line {
                *line_lenght = ip.len();
                let mut line_nodes: Vec<MazeNode> = Vec::new();
                for (node, j) in ip.chars().zip(0..) {
                    let mut node_struct: MazeNode = MazeNode {
                        line: (-1),
                        column: (-1),
                        left: (false),
                        right: (false),
                        top: (false),
                        bottom: (false),
                        is_in_loop: (false),
                        is_outside: (false),
                        going_up: (false),
                    };

                    match node {
                        '|' => {
                            node_struct = MazeNode {
                                line: (i),
                                column: (j),
                                left: (false),
                                right: (false),
                                top: (true),
                                bottom: (true),
                                is_in_loop: (false),
                                is_outside: (false),
                                going_up: (false),
                            }
                        }
                        '-' => {
                            node_struct = MazeNode {
                                line: (i),
                                column: (j),
                                left: (true),
                                right: (true),
                                top: (false),
                                bottom: (false),
                                is_in_loop: (false),
                                is_outside: (false),
                                going_up: (false),
                            }
                        }
                        'L' => {
                            node_struct = MazeNode {
                                line: (i),
                                column: (j),
                                left: (false),
                                right: (true),
                                top: (true),
                                bottom: (false),
                                is_in_loop: (false),
                                is_outside: (false),
                                going_up: (false),
                            }
                        }
                        'J' => {
                            node_struct = MazeNode {
                                line: (i),
                                column: (j),
                                left: (true),
                                right: (false),
                                top: (true),
                                bottom: (false),
                                is_in_loop: (false),
                                is_outside: (false),
                                going_up: (false),
                            }
                        }
                        '7' => {
                            node_struct = MazeNode {
                                line: (i),
                                column: (j),
                                left: (true),
                                right: (false),
                                top: (false),
                                bottom: (true),
                                is_in_loop: (false),
                                is_outside: (false),
                                going_up: (false),
                            }
                        }
                        'F' => {
                            node_struct = MazeNode {
                                line: (i),
                                column: (j),
                                left: (false),
                                right: (true),
                                top: (false),
                                bottom: (true),
                                is_in_loop: (false),
                                is_outside: (false),
                                going_up: (false),
                            }
                        }
                        '.' => {
                            node_struct = MazeNode {
                                line: (i),
                                column: (j),
                                left: (false),
                                right: (false),
                                top: (false),
                                bottom: (false),
                                is_in_loop: (false),
                                is_outside: (false),
                                going_up: (false),
                            }
                        }
                        'S' => {
                            node_struct = MazeNode {
                                line: (i),
                                column: (j),
                                left: (true),
                                right: (true),
                                top: (true),
                                bottom: (true),
                                is_in_loop: (true),
                                is_outside: (false),
                                going_up: (false),
                            };
                            *s_node_location_line = i;
                            *s_node_location_column = j;
                        }
                        _ => println!("Not a valid char: {node}\n"),
                    }
                    line_nodes.push(node_struct);
                }
                node_matrix.push(line_nodes);
            }
        }
    }
}

fn map_pipes(mapeable_matrix: &mut Vec<Vec<MazeNode>>, line_lenght: usize, line_count: usize) {
    let copy_matrix: Vec<Vec<MazeNode>> = mapeable_matrix.clone();

    for vector in mapeable_matrix.iter_mut() {
        for node in vector.iter_mut() {
            if node.left {
                if node.column > 0 {
                    let left_node: MazeNode =
                        copy_matrix[node.line as usize][node.column as usize - 1];
                    if !left_node.right {
                        node.left = false;
                    }
                } else {
                    node.left = false
                };
            }
            if node.right {
                if node.column < line_lenght as i32 - 1 {
                    let right_node: MazeNode =
                        copy_matrix[node.line as usize][node.column as usize + 1];
                    if !right_node.left {
                        node.right = false;
                    }
                } else {
                    node.right = false;
                }
            }
            if node.top {
                if node.line > 0 {
                    let top_node: MazeNode =
                        copy_matrix[node.line as usize - 1][node.column as usize];
                    if !top_node.bottom {
                        node.top = false;
                    }
                } else {
                    node.top = false;
                }
            }
            if node.bottom {
                if node.line < line_count as i32 - 1 {
                    let bottom_node: MazeNode =
                        copy_matrix[node.line as usize + 1][node.column as usize];
                    if !bottom_node.top {
                        node.bottom = false;
                    }
                } else {
                    node.bottom = false;
                }
            }
        }
    }

    std::mem::drop(copy_matrix);
}

fn get_loop_lenght(
    node_matrix: &mut Vec<Vec<MazeNode>>,
    s_node: MazeNode,
    initial_direction: MazeCord,
) -> i32 {
    let mut curr_node: MazeNode;
    let mut entered_from: MazeCord;
    let mut i: i32 = 0;
    match initial_direction {
        MazeCord::Left => {
            curr_node = node_matrix[s_node.line as usize][s_node.column as usize - 1];
            entered_from = MazeCord::Right;
        }
        MazeCord::Right => {
            curr_node = node_matrix[s_node.line as usize][s_node.column as usize + 1];
            entered_from = MazeCord::Left;
        }
        MazeCord::Top => {
            curr_node = node_matrix[s_node.line as usize - 1][s_node.column as usize];
            node_matrix[curr_node.line as usize]
                .index_mut(curr_node.column as usize)
                .going_up = true;
            entered_from = MazeCord::Bottom;
        }
        MazeCord::Bottom => {
            curr_node = node_matrix[s_node.line as usize + 1][s_node.column as usize];
            entered_from = MazeCord::Top;
        }
    }

    while curr_node.column != s_node.column || curr_node.line != s_node.line {
        node_matrix[curr_node.line as usize]
            .index_mut(curr_node.column as usize)
            .is_in_loop = true;
        i += 1;
        match entered_from {
            MazeCord::Left => {
                if curr_node.right {
                    curr_node = node_matrix[curr_node.line as usize][curr_node.column as usize + 1];
                    entered_from = MazeCord::Left;
                } else if curr_node.top {
                    node_matrix[curr_node.line as usize]
                        .index_mut(curr_node.column as usize)
                        .going_up = true;
                    curr_node = node_matrix[curr_node.line as usize - 1][curr_node.column as usize];
                    entered_from = MazeCord::Bottom;
                } else if curr_node.bottom {
                    curr_node = node_matrix[curr_node.line as usize + 1][curr_node.column as usize];
                    entered_from = MazeCord::Top;
                }
            }
            MazeCord::Right => {
                if curr_node.left {
                    curr_node = node_matrix[curr_node.line as usize][curr_node.column as usize - 1];
                    entered_from = MazeCord::Right;
                } else if curr_node.top {
                    node_matrix[curr_node.line as usize]
                        .index_mut(curr_node.column as usize)
                        .going_up = true;
                    curr_node = node_matrix[curr_node.line as usize - 1][curr_node.column as usize];
                    entered_from = MazeCord::Bottom;
                } else if curr_node.bottom {
                    curr_node = node_matrix[curr_node.line as usize + 1][curr_node.column as usize];
                    entered_from = MazeCord::Top;
                }
            }
            MazeCord::Top => {
                if curr_node.left {
                    curr_node = node_matrix[curr_node.line as usize][curr_node.column as usize - 1];
                    entered_from = MazeCord::Right;
                } else if curr_node.right {
                    curr_node = node_matrix[curr_node.line as usize][curr_node.column as usize + 1];
                    entered_from = MazeCord::Left;
                } else if curr_node.bottom {
                    curr_node = node_matrix[curr_node.line as usize + 1][curr_node.column as usize];
                    entered_from = MazeCord::Top;
                }
            }
            MazeCord::Bottom => {
                node_matrix[curr_node.line as usize]
                    .index_mut(curr_node.column as usize)
                    .going_up = true;
                if curr_node.left {
                    curr_node = node_matrix[curr_node.line as usize][curr_node.column as usize - 1];
                    entered_from = MazeCord::Right;
                } else if curr_node.right {
                    curr_node = node_matrix[curr_node.line as usize][curr_node.column as usize + 1];
                    entered_from = MazeCord::Left;
                } else if curr_node.top {
                    curr_node = node_matrix[curr_node.line as usize - 1][curr_node.column as usize];
                    entered_from = MazeCord::Bottom;
                }
            }
        }
    }

    return i + 1;
}

fn get_inside_count(
    node_matrix: &mut Vec<Vec<MazeNode>>,
    line_count: usize,
    line_lenght: usize,
) -> i32 {
    let mut inside_count: i32 = 0;
    for i in 0..line_count {
        for j in 0..line_lenght {
            let node = node_matrix[i][j];
            if !node.is_in_loop {
                let mut found_node_in_loop: bool = false;
                for k in j + 1..line_lenght {
                    let closest_node = node_matrix[i][k];
                    if closest_node.is_in_loop {
                        found_node_in_loop = true;
                        if closest_node.going_up {
                            inside_count += 1;
                            node_matrix[i].index_mut(j).is_outside = false;
                        } else {
                            node_matrix[i].index_mut(j).is_outside = true;
                        }
                        break;
                    }
                }
                if !found_node_in_loop {
                    node_matrix[i].index_mut(j).is_outside = true;
                }
            }
        }
    }
    return inside_count;
}

fn print_map_visualization(node_matrix: Vec<Vec<MazeNode>>) {
    for vector in node_matrix {
        for node in vector.iter() {
            print!("{}", node);
        }
        print!("\n");
    }
}
