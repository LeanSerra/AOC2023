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
		s_a_node_list := getANodes(&s_node_list)
		steps_until_Z := make([]int, 0, len(s_a_node_list))

		for i := 0; i < len(s_a_node_list); i++ {
			for j := 0; ; j++ {
				if dir[j%len(dir)] == 'R' {
					if s_node_list[s_a_node_list[i].right_location].name[2] == 'Z' {
						steps_until_Z = append(steps_until_Z, j+1)
						break
					}
					s_a_node_list[i] = s_node_list[s_a_node_list[i].right_location]
				} else {
					if s_node_list[s_a_node_list[i].left_location].name[2] == 'Z' {
						steps_until_Z = append(steps_until_Z, j+1)
						break
					}
					s_a_node_list[i] = s_node_list[s_a_node_list[i].left_location]
				}
			}
		}
		fmt.Println(steps_until_Z)
		lcm := leastCommonMultiple(steps_until_Z[0], steps_until_Z[1])
		for i := 2; i < len(steps_until_Z); i++ {
			lcm = leastCommonMultiple(lcm, steps_until_Z[i])
		}
		fmt.Println(lcm)
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

func getANodes(node_list *[]dest_node) []dest_node {
	a_nodes := make([]dest_node, 0, 5)
	for i := 0; i < len((*node_list)); i++ {
		cur_node := (*node_list)[i]
		if cur_node.name[2] == 'A' {

			a_nodes = append(a_nodes, cur_node)
		}
	}
	return a_nodes
}

func leastCommonMultiple(a, b int) int {
	var num int
	var den int
	if a > b {
		num = a
		den = b
	} else {
		num = b
		den = a
	}
	rem := num % den
	for rem != 0 {
		num = den
		den = rem
		rem = num % den
	}
	gcd := den
	var lcm int = a * b / gcd
	return lcm
}
