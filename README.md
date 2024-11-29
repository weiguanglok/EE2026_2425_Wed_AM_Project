# EE2026_2425_Wed_Team_13_AM_Project

This repository serves as a central hub for all code related to the EE2026 project.

Done using Vivaldo 2018.2

# Bob's Adventure

## What is it?
In Bob’s Adventure, Bob faces AI Biche in a timed Rock, Paper, Scissors (RPS) battle. Bob has 10 seconds to pick a move. 
Winning damages Biche, while losing triggers a parry phase to avoid damage. An LED indicator shifts toward the loser each round.
The game ends when it reaches either edge.

![image](https://github.com/user-attachments/assets/8fc8567f-d4e3-4686-867e-e395dfd36320)

Fig 1.0. Overall hardware configuaration of BAYES 3 Board. 


## How to start?
On the start screen, use BtnU and BtnD to move the selector arrow between "Start" and "Guide." Press BtnC to confirm your choice.
In the Guide, switch between pages with BtnR and BtnL; exit anytime by pressing BtnC.
To begin the game, select "Start" with the arrow and confirm by pressing BtnC.

![image](https://github.com/user-attachments/assets/99c3d8f8-3703-4ace-ba3c-b849fc5b80b7)

Fig 2.0. Main screen with the selector arrow (blue arrow on the left).


![image](https://github.com/user-attachments/assets/cb2c621e-9a64-4b5c-88b8-5dd337f45d6a)
Fig 2.1. Page one of the guide screen


Both characters display idle animations during the game. Refer to Fig 3.0 left screen.

Press BtnU to start a round, opening the selector screen and a 10-second countdown timer. Use BtnR and BtnL to toggle between the different skills. Then, press BtnC to confirm the skill. The timer is displayed on the Basys board’s seven-segment display, using two digits to represent the remaining time left. If time runs out, the current highlighted skill is auto-selected.
