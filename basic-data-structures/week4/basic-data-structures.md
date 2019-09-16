### BitFields

Redis uses the String data type to store BITFIELDS.

Bit Data
    - Bit fields and Bit arrays - provide dense amount of data in a single key
    - Compact , optimized structure
        - Use cases: File permissions, histogram of counters
    - No explicity bit data type, operates on strings    
Bit Field 
    - consists of a number of adjacent computer memory locations which have been allocated to hold a sequence of bits, stored so that any single bit or group of bits within the set can be addressed.A bit field is most commonly used to represent integral types of known, fixed bit-width.
    - Index by Offset and Index by Position (# - multiply by position * bitfield size to get the bitfield offset)
Bit Arrays
    - 

```
bitfield bf1 set u8 0 20
bitfield bf1 get u8 0
get bf1
```
![Lists](./bitfield_1.png?raw=true "Lists")

Redis considers a bitfield as a array of bits. The least significant bit, is the left most bit.

![Lists](./bitfield_2.png?raw=true "Lists")

The most significant bit of the first byte is a position zero, and has the value 1.
It is not the bit at position 7, which is the least signifcant bit of the first byte.

### Bit Arrays

These are compact optimized structures.
```
bitfield ba1 set u1 6 1
bitcount ba1
bitfield ba2 set u1 7 1
bitop or ba3 ba1 ba2 // Perfoming an OR operation on 2 bit arrays. The BITOP command performs a logical OR on the binary values
bitcount ba3 // equal to 2
```
![Lists](./bitfield_3.png?raw=true "Lists")

### Notes on Seat Reservation example (Python implementation)

For creating 10 seats, we follow the below logic:

```
10 Seats 
    --> (2 to power of 10) - 1 is 
        --> 1023
            --> This is stored in a bitfield with value 1023. However the bit represenation of this value would look like below:
                --> 1111111111 (i.e 10 1's are stored in this field which represents 10 available seats)
                    --> bitcount for this variable would return 10
To find 6 seats:
        --> (2 to power of 6) - 1 is  
            --> 63
                ---> The bit representation is - 111111 
The code does a bitwise & operation to see if 6 seats are available in 10. i.e 6 consecutive 1's - 111111 are available in 1111111111 (in a row)                
If not perform a binary left shift on 1111111111  and search again.
```

#### Publish and Unpublish channels
PUBLISH, SUBSCRIBE,UNPUBLISH

Messages will only be received to the clients that are currently subscribed.
A client can subscribe to one or more channels in a single or multiple SUBSCRIBE commands.

![Lists](./channel_1.png?raw=true "Lists")

PUBSUB, PSUBSCRIBE // Pattern subscriptions



