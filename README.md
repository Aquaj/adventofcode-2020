# advent-of-code-2020
Advent of Code 2020 🎄 Ruby Solutions by `@Aquaj`

[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
Readme based on [Adrienne Tacke's AoC solutions repository](https://github.com/adriennetacke/advent-of-code-2020).

## What is Advent of Code?
[Advent of Code](http://adventofcode.com) is an online event created by [Eric Wastl](https://twitter.com/ericwastl).
Each year, starting on Dec 1st, an advent calendar of small programming puzzles are unlocked once a day at midnight
(EST/UTC-5). Developers of all skill sets are encouraged to solve them in any programming language they choose!

## Advent of Code 2020 Story
After saving Christmas five years in a row, you've decided to take a vacation at a nice resort on a tropical island.
Surely, Christmas will go on without you.

The tropical island has its own currency and is entirely cash-only. The gold coins used there have a little picture of a
starfish; the locals just call them stars. None of the currency exchanges seem to have heard of them, but somehow,
you'll need to find fifty of these coins by the time you arrive so you can pay the deposit on your room.

To save your vacation, you need to get all fifty stars by December 25th.

Collect stars by solving puzzles. Two puzzles will be made available on each day in the Advent calendar; the second
puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!

## Context

**Done during Le Wagon Bordeaux's [BICODE challenge](https://www.bicode.camp)**

**These were not written as example of clean or efficient code** but are simply my attempts at finding the answers to
each day's puzzle as quickly as possible. Performance logging was added simply as a fun way to compare implementations
with other BICODE competitors.

Days 1 through 11 included were done in one sitting during the night from the 10th to the 11th, other puzzles were done
each day at publishing time.

## Progress

| Day  | Part One | Part Two |
|---|:---:|:---:|
| ✔ [Day 1: Report Repair](day1.rb)| 🌟 | 🌟 |
| ✔ [Day 2: Password Philosophy](day2.rb)| 🌟 | 🌟 |
| ✔ [Day 3: Toboggan Trajectory](day3.rb)| 🌟 | 🌟 |
| ✔ [Day 4: Passport Processing](day4.rb)| 🌟 | 🌟 |
| ✔ [Day 5: Binary Boarding](day5.rb)| 🌟 | 🌟 |
| ✔ [Day 6: Custom Customs](day6.rb)| 🌟 | 🌟 |
| ✔ [Day 7: Handy Haversacks](day7.rb)| 🌟 | 🌟 |
| ✔ [Day 8: Handheld Halting](day8.rb)| 🌟 | 🌟 |
| ✔ [Day 9: Encoding Error](day9.rb)| 🌟 | 🌟 |
| ✔ [Day 10: Adapter Array](day10.rb)| 🌟 | 🌟 |
| ✔ [Day 11: Seating System](day11.rb)| 🌟 | 🌟 |
| ✔ [Day 12: Rain Risk](day12.rb)| 🌟 | 🌟 |
| ✔ [Day 13: Shuttle Search](day13.rb)| 🌟 | 🌟 |
| ✔ [Day 14: Docking Data](day14.rb)| 🌟 | 🌟 |
| ✔ [Day 15: Rambunctious Recitation](day15.rb)| 🌟 | 🌟 |
| ✔ [Day 16: Ticket Translation](day16.rb)| 🌟 | 🌟 |
| ✔ [Day 17: Conway Cubes](day17.rb)| 🌟 | 🌟 |
| ✔ [Day 18: Operation Order](day18.rb)| 🌟 | 🌟 |
| ✔ [Day 19: Monster Messages](day19.rb)| 🌟 | 🌟 |
| ✔ [Day 20: Jurassic Jigsaw](day20.rb)| 🌟 | 🌟 |
| ✔ [Day 21: Allergen Assessment](day21.rb)| 🌟 | 🌟 |
| ✔ [Day 22: Crab Combat](day22.rb)| 🌟 | 🌟 |
| ✔ [Day 23: Crab Cups](day23.rb)| 🌟 | 🌟 |
| ✔ [Day 24: Lobby Layout](day24.rb)| 🌟 | 🌟 |
| ✔ [Day 25: Combo Breaker](day25.rb)| 🌟 | 🌟 |

## Running the code

Each day computes and displays the answers to both of the day questions and their computing time in ms. To run it type `ruby day<number>.rb`.

If the session cookie value is provided through the SESSION env variable (dotenv is available to provide it) — it will
fetch the input from the website and store it as a file under the `inputs/` folder on its first run.
