### BitFields

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

