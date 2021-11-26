# advent-of-code-2020
Advent of Code 2020 🎄 Ruby Solutions by `@Aquaj`

Readme based on [Adrienne Tacke's AoC solutions repository](https://github.com/adriennetacke/advent-of-code-2020).

[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## What is Advent of Code?
[Advent of Code](http://adventofcode.com) is an online event created by [Eric Wastl](https://twitter.com/ericwastl).
Each year, starting on Dec 1st, an advent calendar of small programming puzzles are unlocked once a day at midnight
(EST/UTC-5). Developers of all skill sets are encouraged to solve them in any programming language they choose!

## Advent of Code 2020 Story
```adventofcode
After saving Christmas five years in a row, you've decided to take a
vacation at a nice resort on a tropical island. Surely, Christmas will go
on without you.

The tropical island has its own currency and is entirely cash-only. The
gold coins used there have a little picture of a starfish; the locals just
call them stars. None of the currency exchanges seem to have heard of them,
but somehow, you'll need to find fifty of these coins by the time you
arrive so you can pay the deposit on your room.

To save your vacation, you need to get all fifty stars by December 25th.

Collect stars by solving puzzles. Two puzzles will be made available on
each day in the Advent calendar; the second puzzle is unlocked when you
complete the first. Each puzzle grants one star. Good luck!
```
## Context

**Done during Le Wagon Bordeaux's [BICODE challenge](https://www.bicode.camp)**

**These were not written as example of clean or efficient code** but are simply my attempts at finding the answers to
each day's puzzle as quickly as possible. Performance logging was added simply as a fun way to compare implementations
with other BICODE competitors.

Days 1 through 11 included were done in one sitting during the night from the 10th to the 11th, other puzzles were done
each day at publishing time.

## Puzzles

| Day  | Part One | Part Two | Solutions
|---|:---:|:---:|:---:|
| ✔ [Day 1: Report Repair](https://adventofcode.com/2020/day/1)| 🌟 | 🌟 |[Solution](day-01.rb)
| ✔ [Day 2: Password Philosophy](https://adventofcode.com/2020/day/2)| 🌟 | 🌟 |[Solution](day-02.rb)
| ✔ [Day 3: Toboggan Trajectory](https://adventofcode.com/2020/day/3)| 🌟 | 🌟 |[Solution](day-03.rb)
| ✔ [Day 4: Passport Processing](https://adventofcode.com/2020/day/4)| 🌟 | 🌟 |[Solution](day-04.rb)
| ✔ [Day 5: Binary Boarding](https://adventofcode.com/2020/day/5)| 🌟 | 🌟 |[Solution](day-05.rb)
| ✔ [Day 6: Custom Customs](https://adventofcode.com/2020/day/6)| 🌟 | 🌟 |[Solution](day-06.rb)
| ✔ [Day 7: Handy Haversacks](https://adventofcode.com/2020/day/7)| 🌟 | 🌟 |[Solution](day-07.rb)
| ✔ [Day 8: Handheld Halting](https://adventofcode.com/2020/day/8)| 🌟 | 🌟 |[Solution](day-08.rb)
| ✔ [Day 9: Encoding Error](https://adventofcode.com/2020/day/9)| 🌟 | 🌟 |[Solution](day-09.rb)
| ✔ [Day 10: Adapter Array](https://adventofcode.com/2020/day/10)| 🌟 | 🌟 |[Solution](day-10.rb)
| ✔ [Day 11: Seating System](https://adventofcode.com/2020/day/11)| 🌟 | 🌟 |[Solution](day-11.rb)
| ✔ [Day 12: Rain Risk](https://adventofcode.com/2020/day/12)| 🌟 | 🌟 |[Solution](day-12.rb)
| ✔ [Day 13: Shuttle Search](https://adventofcode.com/2020/day/13)| 🌟 | 🌟 |[Solution](day-13.rb)
| ✔ [Day 14: Docking Data](https://adventofcode.com/2020/day/14)| 🌟 | 🌟 |[Solution](day-14.rb)
| ✔ [Day 15: Rambunctious Recitation](https://adventofcode.com/2020/day/15)| 🌟 | 🌟 |[Solution](day-15.rb)
| ✔ [Day 16: Ticket Translation](https://adventofcode.com/2020/day/16)| 🌟 | 🌟 |[Solution](day-16.rb)
| ✔ [Day 17: Conway Cubes](https://adventofcode.com/2020/day/17)| 🌟 | 🌟 |[Solution](day-17.rb)
| ✔ [Day 18: Operation Order](https://adventofcode.com/2020/day/18)| 🌟 | 🌟 |[Solution](day-18.rb)
| ✔ [Day 19: Monster Messages](https://adventofcode.com/2020/day/19)| 🌟 | 🌟 |[Solution](day-19.rb)
| ✔ [Day 20: Jurassic Jigsaw](https://adventofcode.com/2020/day/20)| 🌟 | 🌟 |[Solution](day-20.rb)
| ✔ [Day 21: Allergen Assessment](https://adventofcode.com/2020/day/21)| 🌟 | 🌟 |[Solution](day-21.rb)
| ✔ [Day 22: Crab Combat](https://adventofcode.com/2020/day/22)| 🌟 | 🌟 |[Solution](day-22.rb)
| ✔ [Day 23: Crab Cups](https://adventofcode.com/2020/day/23)| 🌟 | 🌟 |[Solution](day-23.rb)
| ✔ [Day 24: Lobby Layout](https://adventofcode.com/2020/day/24)| 🌟 | 🌟 |[Solution](day-24.rb)
| ✔ [Day 25: Combo Breaker](https://adventofcode.com/2020/day/25)| 🌟 | 🌟 |[Solution](day-25.rb)

## Running the code

Each day computes and displays the answers to both of the day questions and their computing time in ms. To run it type `ruby day<number>.rb`.

If the session cookie value is provided through the SESSION env variable (dotenv is available to provide it) — it will
fetch the input from the website and store it as a file under the `inputs/` folder on its first run.
