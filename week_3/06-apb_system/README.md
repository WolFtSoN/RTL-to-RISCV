# Day 20

## Design and Verify read/write system
- Write should have higher priority than read
- System can buffer up to 16 requests (read or write)
- Communication between APB Master and Slave

## Basic System Components
- ARB = Arbiter: Prioritizes Writes > Reads
- FIFO = Stores up to 16 transactions (reads/writes)
- APBM = APB Master: Issues transactions onto APB bus
- APBS = APB Slave: Responds to APB transactions (memory)