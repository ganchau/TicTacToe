//
//  main.m
//  TicTacToe
//
//  Created by Gan Chau on 4/21/15.
//  Copyright (c) 2015 Gantastic App. All rights reserved.
//

#import <Foundation/Foundation.h>

BOOL playerX = YES;                     // is it X turn?
BOOL gameOver = NO;                     // is the game over?
BOOL continueGame = NO;                 // continue playing the game?
long int selectedCell = 0;              // cell on board that player selects
NSString *contentOfBoard = @"";         // string used to display current state of the board
NSMutableArray *tictactoeBoard = nil;   // stores the content of the board


void updateContentOfBoard()
{
    // start with line break and add 'space' in between each cell for display
    // example: 1 2 3
    //          4 5 6
    //          7 8 9
    contentOfBoard = @"\n";
    for (int i = 0; i < [tictactoeBoard count]; i++) {
        contentOfBoard = [contentOfBoard stringByAppendingString:[NSString stringWithFormat:@"%@ ", tictactoeBoard[i]]];
        if ((i + 1) % 3 == 0) {
            contentOfBoard = [contentOfBoard stringByAppendingString:@"\n"];
        }
    }
}

void promptMessageForInput()
{
    // display current board content, and ask current player for his/her move
    if (playerX) {
        NSLog(@"\n%@\nX, select a number: ", contentOfBoard);
    } else {
        NSLog(@"\n%@\nO, select a number: ", contentOfBoard);
    }
    
    char input[10];
    char *invalidChar;
    long int temp = 0;
    
    if (fgets(input, sizeof(input), stdin))         // if player selection is not empty
    {
        temp = strtol(input, &invalidChar, 10);     // convert player input into a number
        
        if (input[0] != '\n' && (*invalidChar == '\n' || *invalidChar == '\0'))
        {
            selectedCell = temp;
        }
    }
}

void evaluateGame()
{
        // check rows for 3's
    if (([tictactoeBoard[0] isEqualToString:tictactoeBoard[1]] && [tictactoeBoard[1] isEqualToString:tictactoeBoard[2]]) ||
        ([tictactoeBoard[3] isEqualToString:tictactoeBoard[4]] && [tictactoeBoard[4] isEqualToString:tictactoeBoard[5]]) ||
        ([tictactoeBoard[6] isEqualToString:tictactoeBoard[7]] && [tictactoeBoard[7] isEqualToString:tictactoeBoard[8]]) ||
        
        // check columns for 3's
        ([tictactoeBoard[0] isEqualToString:tictactoeBoard[3]] && [tictactoeBoard[3] isEqualToString:tictactoeBoard[6]]) ||
        ([tictactoeBoard[1] isEqualToString:tictactoeBoard[4]] && [tictactoeBoard[4] isEqualToString:tictactoeBoard[7]]) ||
        ([tictactoeBoard[2] isEqualToString:tictactoeBoard[5]] && [tictactoeBoard[5] isEqualToString:tictactoeBoard[8]]) ||
        
        // check diagonals for 3's
        ([tictactoeBoard[0] isEqualToString:tictactoeBoard[4]] && [tictactoeBoard[4] isEqualToString:tictactoeBoard[8]]) ||
        ([tictactoeBoard[2] isEqualToString:tictactoeBoard[4]] && [tictactoeBoard[4] isEqualToString:tictactoeBoard[6]]))
    {
        if (playerX) {
            updateContentOfBoard();
            NSLog(@"\n%@\nX wins!", contentOfBoard);  // if X wins, show updated board
        } else {
            updateContentOfBoard();
            NSLog(@"\n%@\nO wins!", contentOfBoard);  // if O wins, show updated board
        }
        gameOver = YES;
    } else {
        // check for draw game
        int remainingMoves = 0;
        
        for (NSString *cell in tictactoeBoard) {
            if ([cell isNotEqualTo:@"X"] && [cell isNotEqualTo:@"O"]) {
                remainingMoves++;
            }
        }
        // if no move remains, it's a draw
        if (remainingMoves == 0) {
            updateContentOfBoard();
            NSLog(@"\n%@\nIt's a draw.", contentOfBoard);
            gameOver = YES;
        }
    }
}

void evaluateSelection()
{
    // check if the selection is a valid move
    if ((selectedCell >= 1 && selectedCell <= [tictactoeBoard count]) &&
        ([tictactoeBoard[selectedCell - 1] isNotEqualTo:@"X"] && [tictactoeBoard[selectedCell - 1] isNotEqualTo:@"O"]))
    {
        if (playerX)    // if it's X move,
        {
            [tictactoeBoard replaceObjectAtIndex:(selectedCell - 1) withObject:@"X"];  // update valid move for X
        } else {        // if it's O move,
            [tictactoeBoard replaceObjectAtIndex:(selectedCell - 1) withObject:@"O"];  // update valid move for O
        }
        evaluateGame();      // check for possible win or draw
        playerX = !playerX;  // switch player
    } else {
        NSLog(@"\nThat move is invalid.");    // if player selects an invalid cell, or one that's already selected
    }
}

void replayGame()
{
    // prompt if players want to restart and play again
    NSLog(@"\nWant to play again?\nEnter 1 for YES or any other key for NO.");
    
    char playAgainSelection[10];
    
    if (fgets(playAgainSelection, sizeof(playAgainSelection), stdin))  // if players enters a value
    {
        if (strncmp(playAgainSelection, "1\n", strlen(playAgainSelection)) == 0) {  // if players choose to play again
            continueGame = YES;  // continue the game
            gameOver = NO;       // reset values
            playerX = YES;
            selectedCell = 0;    // updated with this addition to fix a bug after replaying a game and entering a noninteger
        } else {                 // else if players choose not to play again
            continueGame = NO;   // quit the game
        }
    }
}

int main(int argc, const char * argv[]) {
    
    @autoreleasepool {
        do {
            tictactoeBoard = [@[@"1", @"2", @"3",     // initialize board with 9 selectable cells
                                @"4", @"5", @"6",
                                @"7", @"8", @"9"] mutableCopy];
            do {
                updateContentOfBoard();   // display current board
                promptMessageForInput();  // ask current player for move
                evaluateSelection();      // check if move is valid & potential win or draw
            } while (!gameOver);          // repeat while game is not over
            
            replayGame();                 // check if players want to play again
            
        } while (continueGame);           // repeat while game is to continue
    }
    
    return 0;
}
