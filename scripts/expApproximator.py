import decimal
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt


def main():
	# f(x) = x ^ (a/b)
	stake_pows = [n for n in range(1,9)]
	max_errs_perc = [0] * 8
	for i in range(8):
		stake = 10**(i+1)
		max_err, a, b = get_max_mapping_err(stake, 9, 10)
		max_errs_perc[i] = int(max_err * 10**5) / 10**3
		err_perc = decimal.Decimal(100 * max_err)
		print(f"10^{i} stake max_error is {float(round(err_perc,3))}% for y=x^({a}/{b})")
	
	plt.plot(stake_pows, [abs(y) for y in max_errs_perc])
	plt.xlabel("staked balance (in 10^x)")
	plt.ylabel("staked balance (in 10^x)")
	plt.show()



# gets the maximum error between approximate and actual value of total vote power
# for a given balance x, max exponent numerator a_max, and exponent denominator b_max
def get_max_mapping_err(x, a_max, b_max):
	max_err = 0
	a_err = 0
	b_err = 0
	for a in range(a_max+1):
		for b in range(1,b_max+1):
			y_o = x**(a/b)
			y_i = approximate(x, a, b, 2)
			err = calc_err_rate(y_o, y_i)
			if abs(err) > abs(max_err):
				max_err, a_err, b_err = err, a, b
	return max_err, a_err, b_err



# Solidity "pseudocode" for approx y=x^(a/b).. but in Python :+1:
# we approximate under the assumption that fractional exponents are prohibited
# - start by getting the exact value of ÿ = x^a
#   - result fits within uint256 assuming we limit the total supply to 10^8 and accept only whole number stakes
# - then approximate y ~ ÿ^(1/b) by searching over whole numbers
#   - can arbitrarily extend the number of decimals approximated to with some math
#   - e.g. for 123.4 can instead do 
def approximate(base, numerator, denominator, precision=0):
	subTotal = base ** numerator
	shift = 10**precision

	# TODO: implement approximation code (binary search can get us answer)
	total = subTotal**(1/denominator)
	total = int(total*shift)/shift
	return total


# standard error calc
def calc_err_rate(actual, guess): return (guess-actual)/actual



main()
