# Rev 3 Engineering Changelog

1. Added AXI4-Lite control/status so software can enable the engine, select configuration override, clear feedback history, and read counters.
2. Implemented independent AXI4-Lite AW and W channel capture; address and data are not required to arrive in the same cycle.
3. Added `TLAST` to the 256-bit AXI-Stream datapath and held output data/status/sidebands stable under backpressure.
4. Made the engine fail-safe disabled after reset.
5. Added asynchronous reset assertion and two-clock synchronous deassertion for the PL clock domain.
6. Marked the UART RX input synchronizer with `ASYNC_REG` for implementation-tool recognition.
7. Corrected the Versal device-family query to `XC2VE3858` and required explicit confirmation of the exact package/speed/temperature part string.
8. Kept the scalar four-phase REQ/ACK reference separate from the vector product top; no false claim of a clockless vector design is made.
