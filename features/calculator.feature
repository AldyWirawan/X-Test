Feature: Test online calculator scenarios (division, subtraction, and CE)

Scenario Outline: Test subtraction behavior on number 1 - number 2, and when number 2 is cleared
Given Open chrome browser and start application
When I press following button
			| 9|
			| -|
			| 3|
			| -|
			| CE|
			| 10|
			| -|
Then I should be able to see
			|expected |-4|
Examples:
		|button1	|button2	|button3	|button4	|button5	|button6	|button7|
		|9			|-			|3			|-			|CE 		|10			|-		|

Scenario Outline: Test subtraction behavior on number 1 is cleared
Given Open chrome browser and start application
When I press following button
			|9|
			|CE|
			|-|
			|9|
			|=|
Then I should be able to see
			|expected | -9|
Examples:
		|button1	|button2	|button3	|button4	|button5	|
		|9			|CE			|-			|9			|=			|

Scenario Outline: Check minus operation with 0 result
Given Open chrome browser and start application
When I press following button
			|1|
			|CE|
			|CE|
			|9|
			|-|
			|9|
			|=|
Then I should be able to see
			|expected | 0|
Examples:
		|button1	|button2	|button3	|button4	|button5	|button6	|button7|
		|1			|CE			|CE			|9			|- 			|9			|=		|

Scenario Outline: Check minus operation when number - number 2 / number 3 condition, where division will be calculated first
Given Open chrome browser and start application
When I press following button
			|9|
			|-|
			|3|
			|:|
			|CE|
			|CE|
			|9|
			|-|
			|6|
			|/|
			|3|
			|-|
Then I should be able to see
			|expected | 7|
Examples:
		|button1	|button2	|button3	|button4	|button5	|button6	|button7	|button8	|button9	|button10	|button11	|button12	|
		|9			|-			|3			|:			|CE 		|CE			|9			|-			|6			|/			|3			|-		|

Scenario Outline: Test subtraction behavior after division first (number1 / number2 -)
Given Open chrome browser and start application
When I press following button
			|8|
			|/|
			|4|
			|-|
Then I should be able to see
			|expected | 2|
Examples:
		|button1	|button2	|button3	|button4	|
		|8			|/			|4			|-			|

Scenario Outline: Negative test when number1 - number2 / number3, and number3 is cleared
Given Open chrome browser and start application
When I press following button
			|9|
			|-|
			|6|
			|/|
			|3|
			|CE|
			|-|
Then I should be able to see
			|expected |Error|
Examples:
		|button1	|button2	|button3	|button4	|button5	|button6	|button7|
		|9			|-			|6			|/			|3 			|CE			|-		|

Scenario Outline: Negative test when number1 - number2 / number3, and number3 is cleared
Given Open chrome browser and start application
When I press following button
			|12|
			|/|
			|3|
			|/|
			|CE|
			|3|
			|/|
Then I should be able to see
			|expected |1.33333333|
Examples:
		|button1	|button2	|button3	|button4	|button5	|button6	|button7|
		|12			|/			|3			|/			|CE 		|3			|/		|

Scenario Outline: Test division when first number is cleared
Given Open chrome browser and start application
When I press following button
			|9|
			|CE|
			|/|
			|9|
			|=|
Then I should be able to see
			|expected | 0|
Examples:
		|button1	|button2	|button3	|button4	|button5	|
		|9			|CE			|/			|9			|=			|

Scenario Outline: Test division after subtraction number1 - number2 / number3 / number4
Given Open chrome browser and start application
When I press following button
			|9|
			|-|
			|8|
			|/|
			|2|
			|/|
			|2|
			|=|
Then I should be able to see
			|expected |7|
Examples:
		|button1	|button2	|button3	|button4	|button5	|button6	|button7	|button8	|
		|9			|-			|8			|/			|2 			|/			|2			|=			|

Scenario Outline: Test division number1 : number2 with number2 cleared
Given Open chrome browser and start application
When I press following button
			|9|
			|/|
			|CE|
			|CE|
			|9|
			|/|
			|6|
			|CE|
			|-|
Then I should be able to see
			|expected |Error|
Examples:
		|button1	|button2	|button3	|button4	|button5	|button6	|button7	|button8	|button9
		|9			|/			|CE			|CE			|9 			|/			|6			|CE			|-

Scenario Outline: Test division number1 : number2 with number2 cleared
Given Open chrome browser and start application
When I press following button
			|9|
			|-|
			|8|
			|/|
			|2|
			|CE|
			|/|
Then I should be able to see
			|expected |Error|
Examples:
		|button1	|button2	|button3	|button4	|button5	|button6	|button7	|
		|9			|/			|CE			|CE			|9 			|/			|CE			|

Scenario Outline: Test max digit and subtraction
Given Open chrome browser and start application
When I press following button
			|9999999999|
			|-|
			|1|
			|=|
Then I should be able to see
			|expected | 999 999 998|
Examples:
		|button1	|button2	|button3	|button4	|
		|9999999999	|-			|1			|=			|

Scenario Outline: Test max digit and subtraction
Given Open chrome browser and start application
When I press following button
			|9999999999|
			|/|
			|333|
			|=|
Then I should be able to see
			|expected | 3 003 003|
Examples:
		|button1	|button2	|button3	|button4	|
		|9999999999	|/			|333		|=			|
