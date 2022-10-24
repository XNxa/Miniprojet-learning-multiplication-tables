# Miniprojet-learning-multiplication-tables

I did this project during my first year at Enseeiht. It's a quick project in Ada to put into practice imperative programming notions.

## Goal

The purpose of this code is to allow a user to study the multiplication tables using a console interface.

## Features

* Choose the table to be reviewed between 1 and 10.
* Put multiplications randomly, avoiding to put twice in a row the same multiplication.
* Count the number of errors and give an indication to the user at the end of the game to know if he/she should rework or not.
* Time the answer to each question and offer the user to revise a table if his answer time was higher than the average of his times.
* At the end of each game, ask the user if they wish to replay.

## Running the program

### On Linux/Unix based ditributions

To compile the *.adb* file you must install Ada Compiler :

```BASH
sudo apt install gnat
```

Then compile it with :

```BASH
gnatmake -gnatwa multiplications.adb
```

You can run it with :

```BASH
./multiplications
```

### In Online ide

You can run the program online [here](https://www.jdoodle.com/ia/xQz) and click run.

#### Warning

Running the program this way makes it particularly slow. This can cause problems especially for the measurement of response times.
