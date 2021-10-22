from art import logo
import random

play_again = True


 
while play_again:

  lives = 0
  random_num = random.randint(1,100)
  continue_game = True

  def difficulty_choice(question):
    """This function uses if statement to choose lives. Also a global variable"""
    if question == "easy":
      global lives
      lives += 10
    elif question == "hard":
      lives += 5

  def off_number(num):
    if num > random_num:
      print("Too high.\nGuess again.")
    elif num < random_num:
      print("Too low.\nGuess again.")

  def end_game(life):
    if life == 0:
      global lives
      global continue_game
      continue_game = False
      print(f"You have {lives} attempts left. You lose.")

  print("Welcome to the guessing game: ")
  print("I am thinking of a number between 1 and 100")
  ask = input("Choose a difficulty. Type 'easy' or 'hard': ")
  difficulty_choice(ask)

  while continue_game:
    guess = int(input(f"You have {lives} attempts remaining to guess.\nMake a guess: "))
    if guess == random_num:
      print("You have won")
      continue_game = False
    elif guess != random_num:
      off_number(guess)
      lives -= 1
      end_game(lives)

  play = input("Would you want to play again?: ")
  if play == "yes":
    clear()
  else:
    print("Thank you for playing!!")
    play_again = False
