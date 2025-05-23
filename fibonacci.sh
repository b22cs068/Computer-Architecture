#!/bin/bash

fibonacci_sum(){
	n=$1
	a=0
	b=1
	sum=0

	for ((i=0;i<n;i++))
	do
		sum=$((sum+a))
		fib=$((a+b))
		a=$b
		b=$fib
	done
	echo $sum
}


echo "ENTER THE NUMBER N:"
read N

result=$(fibonacci_sum $N)

echo "THe sum of the first $N numbers in the fibonacci series is: $result"
