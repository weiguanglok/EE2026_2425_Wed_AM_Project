# EE2026_2425_Wed_Team_13_AM_Project

This repository serves as a central hub for all code and documentation related to the EE2026 project.

Done using Vivaldo 2018.2

# Bob's Adventure

## What is it?
- In Bob’s Adventure, Bob faces AI Biche in a timed Rock, Paper, Scissors (RPS) battle. Bob has 10 seconds to pick a move.
- Winning damages Biche, while losing triggers a parry phase to avoid damage. An LED indicator shifts toward the loser each round.
- The game ends when the led reaches either end of the board.

![image](https://github.com/user-attachments/assets/8fc8567f-d4e3-4686-867e-e395dfd36320)

Fig 1.0. Overall hardware configuaration of BASYS 3 Board. 


## How to start?

### Start Phase
- On the start screen, use BtnU and BtnD to move the selector arrow between "Start" and "Guide."
- Press BtnC to confirm your choice.
- In the Guide, switch between pages with BtnR and BtnL; exit anytime by pressing BtnC.
- To begin the game, select "Start" with the arrow and confirm by pressing BtnC.

![image](https://github.com/user-attachments/assets/99c3d8f8-3703-4ace-ba3c-b849fc5b80b7)

Fig 2.0. Main screen with the selector arrow (blue arrow on the left).


![image](https://github.com/user-attachments/assets/cb2c621e-9a64-4b5c-88b8-5dd337f45d6a)

Fig 2.1. Page one of the guide screen

### Idle Phase
- Both characters display idle animations during the game. Refer to Fig 3.0 left screen.

### Ability Select Phase
- Press BtnU to start a round, opening the selector screen and a 10-second countdown timer.
- Use BtnR and BtnL to toggle between the different skills.
- Then, press BtnC to confirm the skill.
- The timer is displayed on the Basys board’s seven-segment display, using two digits to represent the remaining time left.
- If time runs out, the current highlighted skill is auto-selected.

![image](https://github.com/user-attachments/assets/c9a8ad67-5f17-4093-b646-654b8a18ef45)

Fig. 3.0. The left screen shows Biche’s animation, the center shows the countdown, and the right displays the skill selector. 

- AI Biche will pick a random skill using a Linear Feedback Shift Register (LFSR) module.
- It is programmed such that it will pick a different ability as the player to avoid a draw scenario.
- A time delay using counters is created so that the player can see the abilities chosen by Bob and Biche.
- The system then determines the winner based on both choices.

![image](https://github.com/user-attachments/assets/cd8f60d4-508b-47b5-8e21-3686f37998cc)

Fig. 3.1. Selector Screen


![image](https://github.com/user-attachments/assets/1be3a757-21e6-4178-8472-112e7a99659c)

Fig. 3.2. Simplified Logic for AI selection ability (for scissors)


### Animation Phase
- In the battle phase, each character performs unique attack animations for each of the three options based on the abilities selected.
- There are also animations for blocking and taking damage.

![image](https://github.com/user-attachments/assets/4f3f286c-dad5-4a7e-8c52-83ca7f7b309b)![image](https://github.com/user-attachments/assets/16721eca-a790-4512-bccc-29a1bda0f41e)![image](https://github.com/user-attachments/assets/13671e3c-7d9f-4561-af34-3759dabbc981)

Fig 4.0. - 4.2. Attack Animation – Paper, Rock, Scissors (left to right)


### Parry Phase
- If the player **loses** the RPS round, the parry stage begins.
- To succeed, press BtnU, BtnD, BtnR, or BtnL at the correct time when the red arrows touch the parry zone, achieving at least 8 successful parries.
- Press the correct direction when the arrow is in the box. The arrow sequence is pseudo random based on the move selected.
- If the parry is successful, “PARRY” will be shown. Else “MISS” will be shown.

![image](https://github.com/user-attachments/assets/2e1a03b2-d6c6-48ef-9a9e-a63c108dd4d5)![image](https://github.com/user-attachments/assets/fbd99207-4900-4f93-934e-fef31d2f6149)![image](https://github.com/user-attachments/assets/c9e57797-cd13-4904-8e27-05db70aeae5b)

Fig 5.0. - 5.2. Parry screen - Default, Miss, Parry (left to right)

- The seven-segment display will be updated with the number of successful parry with a maximum of 9

![image](https://github.com/user-attachments/assets/4cf239a5-da9d-41fd-9d53-dc9cf687d88e)

Fig 5.3. Current number of successful parries on seven-segment display

- At the end of the stage, the winner of the round is decided. The led will shift towards the loser.
- **However**, a successful parry keeps the LED indicator unchanged

![image](https://github.com/user-attachments/assets/cf096a27-8b22-45cb-835b-616de3a8c334)

Fig 5.4. The led movement


### Ending Phase
- When the LED indicator reaches either end (LED15 or LED0), the game ends.
- A scrolling indicator indicating the winner will be displayed on the seven-segment display and the OLED display until BtnU is pressed.
- Pressing BtnU will return to the start screen and one can play again.

![image](https://github.com/user-attachments/assets/b048e54a-d72a-40d5-868e-b037500f99d4)

Fig 6.0. Snippets of the scrolling text when player wins.


![image](https://github.com/user-attachments/assets/e60271ec-da91-456b-8361-81921cc1e1b1)

Fig 6.1. Snippets of the scrolling text when bot wins.

> To demonstrate the endgame sequence, turn on sw14. This will move the LED indicator one step before the player wins. In this setup, the indicator remains unchanged if the bot wins, but if the player wins, the game enters the ending sequence.
> Otherwise, turn on sw1 to set up the scenario where the player is one step from losing.


