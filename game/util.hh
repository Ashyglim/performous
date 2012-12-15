#pragma once

#include <limits>
#include <stdexcept>

#if 0  // We don't need the following in C++11 mode

/** Implement C99 mathematical rounding (which C++ unfortunately currently lacks) **/
template <typename T> T round(T val) { return int(val + (val >= 0 ? 0.5 : -0.5)); }

/** Implement C99 remainder function (not precisely, but almost) **/
template <typename T> T remainder(T val, T div) { return val - round(val/div) * div; }

#endif

/** Limit val to range [min, max] **/
template <typename T> T clamp(T val, T min = 0, T max = 1) {
	if (min > max) throw std::logic_error("min > max");
	if (val < min) return min;
	if (val > max) return max;
	return val;
}

template <typename Numeric> struct MinMax {
	Numeric min, max;
	explicit MinMax(Numeric min = std::numeric_limits<Numeric>::min(), Numeric max = std::numeric_limits<Numeric>::max()): min(min), max(max) {}
	bool matches(Numeric val) const { return val >= min && val <= max; }
};

/** A convenient way for getting NaNs **/
static inline double getNaN() { return std::numeric_limits<double>::quiet_NaN(); }

/** A convenient way for getting infs **/
static inline double getInf() { return std::numeric_limits<double>::infinity(); }

static inline bool isPow2(unsigned int val) {
	if (val == 0) return false;
	if ((val & (val-1)) == 0) return true; // From Wikipedia: Power_of_two
	return false;
}

static inline unsigned int nextPow2(unsigned int val) {
	unsigned int ret = 1;
	while (ret < val) ret *= 2;
	return ret;
}

static inline unsigned int prevPow2(unsigned int val) {
	unsigned int ret = 1;
	while ((ret*2) < val) ret *= 2;
	return ret;
}

