######################################################
# Name: Christelle Nieves                              #
# Assignment Name: Assignment 5                        #
# Description: Calculates the sum, mean, min, max      #
# and variance of a series of numbers.                 #
# Date: February 21, 2020                              #
######################################################

.data
    inputPrompt: .asciiz "Enter integer values, one per line, terminated by a negative value.\n"
    displaySum: .asciiz "Sum: "
    displayMin: .asciiz "Min: "
    displayMax: .asciiz "Max: "
    displayMean: .asciiz "Mean: "
    displayVariance: .asciiz "Variance: "
    nextLine: .asciiz "\n"
.globl main
.text
main:
    # Initialize registers
    li $t0, 0   # t0 will hold the running sum of the integers.
    li $t1, 0   # t1 will hold the counter for the loop.
    li $t2, 0   # t2 will hold the min value.
    li $t3, 0   # t3 will hold the max value.
    li $t4, 0   # t4 will hold the square of each integer.
    li $t5, 0   # t5 will hold the sum of all squares.

    li $v0, 4   # Prepare to print a string.
    la $a0, inputPrompt # Load address of inputPrompt to a0
    syscall # Ask the user to input integers.

    li $v0, 5   # Prepare to take input from user
    syscall     # Get the input

    move $t2, $v0   # Initialize the min value to the first integer.
    move $t3, $v0   # Initialize the max value to the first integer.

    loop:
        blt $v0, 0, calculateResults     # If integer is < 0, exit the loop.
        addi $t1, $t1, 1     # Update the loop counter. ( Number of items).
        add $t0, $t0, $v0       # Add the current integer to the running sum.
        bgt $v0, $t3, newMax
    secondLoop:
        blt $v0, $t2, newMin
    thirdLoop:
        mul $t4, $v0, $v0      # Square the current integer.
        add $t5, $t5, $t4       # Add the square to the sum of squares.
        li $v0, 5       # Read in the next integer from the user.
        syscall
        j loop
calculateResults:
        mtc1 $t1, $f3   # Put the number of ints in float register f3.
        cvt.s.w $f3, $f3    # Convert number of ints to a float.
        mtc1 $t5, $f4       # Put the sum of all squares into f4.
        cvt.s.w $f4, $f4    # Convert sum of squares to a float.
        mtc1 $t0, $f5       # Put the sum of ints in f5.
        cvt.s.w $f5, $f5    # Convert sum of ints to a float.
        cvt.s.w $f6, $f6    # Convert t6 to a float.

        div.s $f1, $f5, $f3     # Find the mean and store it in f1

    # Calculate the variance.
        mul.s $f6, $f5, $f5     # t6 = (SUM)^2
        div.s $f7, $f6, $f3     # f7 = f6 / f3
        sub.s $f8, $f4, $f7     # f8 = f4 - f7
        div.s $f9, $f8, $f3     # f9 = f8 / f3

        cvt.w.s $f10, $f5       # Convert the sum back to an integer.

        li $v0, 4       # Prepare to print a string.
        la $a0, displaySum  # Print "Sum: "
        syscall

        li $v0, 1       # Get ready to print the sum value
        mfc1 $a0, $f10  # Move the sum value to a0
        syscall     # Print the sum

        li $v0, 4       # Get ready to print a string.
        la $a0, nextLine
        syscall         # Print a newline character.

        li $v0, 4       # Get ready to print a string.
        la $a0, displayMin # Print "Min: "
        syscall

        li $v0, 1       # Get ready to print the min
        move $a0, $t2   # Move the address of min to a0
        syscall     # Print the min value.

        li $v0, 4       # Get ready to print a string.
        la $a0, nextLine
        syscall         # Print a newline character.

        li $v0, 4       # Get ready to print a string.
        la $a0, displayMax # Print "Max: "
        syscall

        li $v0, 1       # Get ready to print the max
        move $a0, $t3   # Move the address of max to a0
        syscall     # Print the max value.

        li $v0, 4       # Get ready to print a string.
        la $a0, nextLine
        syscall         # Print a newline character.

        li $v0, 4       # Prepare to print a string.
        la $a0, displayMean  # Print "Mean: "
        syscall

        li $v0, 2       # Get ready to print the mean value
        mov.s $f12, $f1 
        syscall     # Print the mean

        li $v0, 4       # Get ready to print a string.
        la $a0, nextLine
        syscall         # Print a newline character.

        li $v0, 4       # Prepare to print a string.
        la $a0, displayVariance  # Print "Variance: "
        syscall

        li $v0, 2       # Get ready to print the variance value
        mov.s $f12, $f9
        syscall     # Print the variance

        j End       # Jump to our end point.
    newMax:
        move $t3, $v0
        j secondLoop
    newMin:
        move $t2, $v0
        j thirdLoop
End:
    jr $ra  # Exit program