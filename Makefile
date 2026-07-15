CXX ?= g++
CXXFLAGS ?= -O3 -std=c++23
PKG_CONFIG ?= pkg-config

PKG_CONFIG_EXISTS := $(shell command -v $(PKG_CONFIG) 2>/dev/null || true)
BENCHMARK_CXXFLAGS := $(if $(PKG_CONFIG_EXISTS),$(shell $(PKG_CONFIG) --cflags benchmark 2>/dev/null),)
BENCHMARK_LDFLAGS := $(if $(PKG_CONFIG_EXISTS),$(shell $(PKG_CONFIG) --libs benchmark 2>/dev/null),)

UNAME := $(shell uname 2>/dev/null)
ifeq ($(findstring MINGW,$(UNAME)),MINGW)
DEFAULT_BENCHMARK_CXXFLAGS := -I/usr/local/include
DEFAULT_BENCHMARK_LDFLAGS := -L/usr/local/lib -lbenchmark -pthread
else ifeq ($(UNAME),Darwin)
DEFAULT_BENCHMARK_CXXFLAGS := -I/opt/homebrew/include
DEFAULT_BENCHMARK_LDFLAGS := -L/opt/homebrew/lib -lbenchmark -pthread
else
DEFAULT_BENCHMARK_CXXFLAGS := -I/usr/local/include
DEFAULT_BENCHMARK_LDFLAGS := -L/usr/local/lib -lbenchmark -pthread
endif

BENCHMARK_CXXFLAGS := $(or $(BENCHMARK_CXXFLAGS),$(DEFAULT_BENCHMARK_CXXFLAGS))
BENCHMARK_LDFLAGS := $(or $(BENCHMARK_LDFLAGS),$(DEFAULT_BENCHMARK_LDFLAGS))

SRC := benchmark.cpp
OUT := benchmark

.PHONY: all run clean

all: $(OUT)

$(OUT): $(SRC)
	$(CXX) $(CXXFLAGS) $(BENCHMARK_CXXFLAGS) $< -o $@ $(BENCHMARK_LDFLAGS)

run: $(OUT)
	./$(OUT)

clean:
	rm -f $(OUT)
