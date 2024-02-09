package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

type dest_node struct {
	name           string
	left           string
	right          string
	left_location  int
	right_location int
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage:", os.Args[0], "<input_file>")
		return
	}
	dir := ""
	s_node_list := make([]dest_node, 0, 10)

	read := readFile(os.Args[1], &dir, &s_node_list)
	if read == 1 {
		mapLocations(&s_node_list)
		cur_node := s_node_list[findNode(&s_node_list, "AAA")]

		for i := 0; ; i++ {
			fmt.Println(cur_node)
			if cur_node.name != "ZZZ" {
				if dir[i%len(dir)] == 'R' {
					cur_node = s_node_list[cur_node.right_location]
				} else {
					cur_node = s_node_list[cur_node.left_location]
				}
			} else {
				fmt.Println("Steps taken", i)
				break
			}
		}
	}
}

func readFile(file_path string, directions *string, node_list *[]dest_node) int {
	readfile, err := os.Open(file_path)
	i := 0
	if err != nil {
		return -1
	}

	var fileScanner *bufio.Scanner = bufio.NewScanner(readfile)
	fileScanner.Split(bufio.ScanLines)

	fileScanner.Scan()
	*directions = fileScanner.Text()

	for fileScanner.Scan() {
		var line string = fileScanner.Text()
		if line != "" {
			var ap_node dest_node

			line = strings.Replace(line, " ", "", -1)
			node_name := strings.Split(line, "=")[0]
			dest_nodes := strings.Split(strings.Split(line, "=")[1], ",")

			ap_node.name = node_name
			ap_node.left = strings.Replace(dest_nodes[0], "(", "", -1)
			ap_node.right = strings.Trim(strings.Replace(dest_nodes[1], ")", "", -1), " ")
			ap_node.left_location = 0
			ap_node.right_location = 0

			(*node_list) = append((*node_list), ap_node)
			i++
		}
	}
	return 1
}

func findNode(node_list *[]dest_node, node_target_name string) int {
	for i := 0; i < len((*node_list)); i++ {
		cur_node := (*node_list)[i]
		if cur_node.name == node_target_name {
			return i
		}
	}
	return 0xffff
}

func mapLocations(node_list *[]dest_node) {
	for i := 0; i < len((*node_list)); i++ {
		cur_node := &(*node_list)[i]
		cur_node.left_location = findNode(node_list, cur_node.left)
		cur_node.right_location = findNode(node_list, cur_node.right)
	}
}
