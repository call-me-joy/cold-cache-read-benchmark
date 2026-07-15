#include <iostream>
#include <chrono>
#include <vector>  
#include <cstdint> // Required for uint8_t
#include <new>     // Required for hardware interference macros

// L1 cache - 32 kb for data and 32 KB for instruction
// total l1 cache size 64 kb
auto MeasureL1Latency()
{

// in order to make this cross platform compatible we have to hard code hardware interference size
#ifdef __cpp_lib_hardware_interference_size
    constexpr auto cache_line_size = std::hardware_destructive_interference_size;
#else
    // Fallback if the compiler lacks the standard macro
    #if defined(__aarch64__) || defined(_M_ARM64)
        // Apple Silicon M1-M4 processors natively use a 128-byte cache line size
        constexpr std::size_t cache_line_size = 128;
    #else
        // Standard default for x86_64 and other traditional architectures
        constexpr std::size_t cache_line_size = 64;
    #endif
#endif

    std::cout << "Cache Line Size : " << cache_line_size << std::endl;
    constexpr auto evict_cache_line_size = cache_line_size * (2 << 12);
    constexpr auto trials = 30000;
    std::vector<uint8_t> cache_line_data(cache_line_size), cache_line_evict_data(evict_cache_line_size);
    volatile uint64_t sink = 0;

    using namespace std::chrono;
    auto floodTime = 0.0;
    const auto startTrial = steady_clock::now();

    for (auto trial{0uz}; trial < trials; trial++)
    {
        auto floodStart = steady_clock::now();

        for (auto i{0uz}; i < cache_line_evict_data.size(); i += cache_line_size)
        {
            sink += cache_line_evict_data[i];
        }

        auto floodEnd = steady_clock::now();

        const auto iterationFloodTime = duration_cast<nanoseconds>(floodEnd - floodStart);

        floodTime += static_cast<double>(iterationFloodTime.count());

        sink += cache_line_data[0];
    }

    const auto endTrial = steady_clock::now();
    const auto totalTrial = static_cast<double>(duration_cast<nanoseconds>(endTrial - startTrial).count());

    const auto totalLatency = totalTrial - floodTime;

    return totalLatency / trials;
}

int main()
{

    std::cout << MeasureL1Latency() << " ns" << std::endl;
    return 0;
}
