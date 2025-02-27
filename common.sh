#!/bin/bash

print_info() {
	echo -e "\033[1;32m[INFO] $1\033[0m"
}

print_error() {
	echo -e "\033[1;31m[ERROR] $1\033[0m"
}

print_warning() {
	echo -e "\033[1;33m[WARNING] $1\033[0m"
}
