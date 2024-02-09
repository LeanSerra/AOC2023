use std::env;
use std::fmt;
use std::fs::File;
use std::io;
use std::io::BufRead;
use std::path::Path;

#[derive(Copy, Clone)]
struct MazeNode {
    line: i32,
    column: i32,
    left: bool,
    right: bool,
    top: bool,
    bottom: bool,
}

enum MazeCord {
    Left = 1,
    Right = 2,
    Top = 3,
    Bottom = 4,
}

impl fmt::Display for MazeNode {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "({}, {}), l:{}, r:{}, t:{}, b:{}",
            self.line, self.column, self.left, self.right, self.top, self.bottom
        )
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        println!("Usage: {} <input_file>\n", args[0]);
        return;
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

    map_pipes(
        node_matrix.clone(),
        &mut node_matrix,
        line_lenght,
        line_count,
    );

    println!("Line Lenght: {line_lenght}");
    println!("Line Count: {line_count}");

    let s_node: MazeNode =
        node_matrix[s_node_location_line as usize][s_node_location_column as usize];

    println!("{s_node}");

    let mut loop_lenght: i32 = 0;

    if s_node.left {
        loop_lenght = get_loop_lenght(node_matrix, s_node, MazeCord::Left);
    } else if s_node.right {
        loop_lenght = get_loop_lenght(node_matrix, s_node, MazeCord::Right);
    } else if s_node.top {
        loop_lenght = get_loop_lenght(node_matrix, s_node, MazeCord::Top);
    } else if s_node.bottom {
        loop_lenght = get_loop_lenght(node_matrix, s_node, MazeCord::Bottom);
    }

    println!("Steps until farthest point: {}", (loop_lenght) / 2);
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

fn map_pipes(
    copy_matrix: Vec<Vec<MazeNode>>,
    mapeable_matrix: &mut Vec<Vec<MazeNode>>,
    line_lenght: usize,
    line_count: usize,
) {
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
    node_matrix: Vec<Vec<MazeNode>>,
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
            entered_from = MazeCord::Bottom;
        }
        MazeCord::Bottom => {
            curr_node = node_matrix[s_node.line as usize + 1][s_node.column as usize];
            entered_from = MazeCord::Top;
        }
    }

    while curr_node.column != s_node.column || curr_node.line != s_node.line {
        i += 1;
        match entered_from {
            MazeCord::Left => {
                if curr_node.right {
                    curr_node = node_matrix[curr_node.line as usize][curr_node.column as usize + 1];
                    entered_from = MazeCord::Left;
                } else if curr_node.top {
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
