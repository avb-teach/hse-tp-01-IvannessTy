#!/bin/bash


input_dir="$1"
output_dir="$2"
max_depth_param=""

if [ "$#" -eq 4 ]; then
    if [ "$3" != "--max_depth" ]; then
        echo "Использование: $0 <path_input_dir> <path_output_dir> опционально: --max_depth N (N-целое число)"
        exit 1
    fi
    if [[ ! "$4" =~ ^[0-9]+$ ]]; then
        echo "Ошибка: параметр --max_depth должен быть целым числом."
        exit 1
    fi
    max_depth_param="$4"
fi

if [ ! -d "$input_dir" ]; then
    echo "Ошибка: входная директория '$input_dir' не найдена."
    exit 1
fi          

mkdir -p "$output_dir" || {
    echo "Не удалось создать выходную директорию"
    exit 1
}

get_unique_name() {
    local dir="$1"
    local filename="$2"

    local base="${filename%.*}"
    local ext="${filename##*.}"

    if [ "$base" = "$ext" ]; then
        ext=""
    else
        ext=".$ext"
    fi

    local newname="$filename"
    local counter=1

    while [ -e "$dir/$newname" ]; do
        newname="${base}${counter}${ext}"
        counter=$((counter + 1))
    done
    echo "$newname"
}


find "$input_dir" -maxdepth "$max_depth_param" -type f | while read -r filepath; do
    filename=$(basename "$filepath")
    unique_name=$(get_unique_name "$output_dir" "$filename")
    cp "$filepath" "$output_dir/$unique_name"
done
