---
title: Redirectors
published: 2024-06-18
description: "How redirectors works."
image: "./cover.png"
tags: [Fundamentals, Redirectors]
category: Linux
---

In the context of programming and operating systems, "STD" stands for "Standard."<br/>
It is commonly used to refer to standard data streams in Unix or Linux systems.

### Standard Data Streams

1. **`STDIN` Standard Input**
   - **Code**: `0`
   - **Description**: The default input data stream for commands and programs. By default, `STDIN` is the keyboard, meaning when a program expects input, it receives it from the keyboard unless redirected from a file or another stream.
2. **`STDOUT` Standard Output**
   - **Code**: `1`
   - **Description**: The default output data stream for commands and programs. By default, `STDOUT` is the screen or terminal. When a program generates output, it is displayed on the screen unless redirected to a file or another device.
3. **`STDERR` Standard Error**
   - **Code**: `2`
   - **Description**: The default error data stream for commands and programs. Like `STDOUT`, by default, `STDERR` is the screen or terminal. The difference is that `STDERR` is specifically used for error messages, separating them from normal output `STDOUT`.

## Redirection Operators

### `>` Redirecting Standard Output

Redirects the standard output of a command to a file. If the file exists, it is overwritten.

```bash

ls > filelist.txt
```

> This command saves the output of the `ls` command into the file `filelist.txt`.

### `>>` Appending Standard Output

Redirects the standard output of a command to a file, appending the output to the end of the file if it already exists.

```bash

echo "New line" >> filelist.txt
```

> This command appends "New line" to the end of the file `filelist.txt`.

### `2>` Redirecting Standard Error

Redirects the standard error output of a command to a file.

```bash

ls non_existent_file 2> errorlog.txt
```

> This command saves the error message generated by attempting to list a non-existent file in `errorlog.txt`.

### `&>` Redirecting Both Standard Output and Error

Redirects both the standard output and the standard error output to a file.

```bash

ls existing_file non_existent_file &> outputlog.txt
```

> This command saves both the listing of an existing file and the error message of a non-existent file in `outputlog.txt`.

### `<` Redirecting Standard Input

Redirects the standard input of a command from a file.

```bash

wc -l < filelist.txt
```

> This command counts the lines in `filelist.txt` using redirected input.

### Redirecting Standard Output and Standard Error Separately

```bash

ls existing_file non_existent_file > output.txt 2> error.txt
```

> This command saves the listing of an existing file in `output.txt` and the error message of a non-existent file in `error.txt`.

### Redirecting Standard Output and Standard Error to the Same File

```bash

ls existing_file non_existent_file > combined.txt 2>&1
```

> This command saves both the standard output and the error output in `combined.txt`.

### Using Pipes with Redirection

Combining pipes `|` with redirection to process data between multiple commands.

```bash

ls | grep "pattern" > result.txt
```

> This command lists the files and filters those that match "pattern", saving the result in `result.txt`.

### Reading from a File and Redirecting Output

```bash

sort < unsorted_list.txt > sorted_list.txt
```

> This command reads from `unsorted_list.txt`, sorts the content, and saves the output in `sorted_list.txt`.

### Redirecting STDERR to STDOUT

```bash

command 2>&1 | tee output_and_error.txt
```

> This command combines the error output with the standard output, passing it through `tee` to display on the screen and save in `output_and_error.txt`.

## Advanced Examples

### Ignoring Standard Error

Redirect the error output to `/dev/null` to ignore it.

```bash

ls non_existent_file 2> /dev/null
```

> This command attempts to list a non-existent file, but the error message is not displayed or saved.

### Combining Multiple Commands with Different Redirections

```bash

command1 > output.txt 2>&1 | command2 2> error_only.txt
```

> This example shows how you can redirect the output of one command, combining the standard and error output into `output.txt`, and then pass it to another command while saving only the errors of the second command in `error_only.txt`.
