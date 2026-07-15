CXX ?= g++
CXXFLAGS ?= -O3 -std=c++23
PKG_CONFIG ?= pkg-config

UNAME := $(shell uname 2>/dev/null)

SRC := benchmark.cpp
OUT := benchmark

.PHONY: all run clean

all: $(OUT)

$(OUT): $(SRC)
	$(CXX) $(CXXFLAGS) $< -o $@

run: $(OUT)
	./$(OUT)

clean:
	rm -f $(OUT)

