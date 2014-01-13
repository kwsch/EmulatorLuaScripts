$debug
-- mt19937.lua
--
-- a native Lua 3.2 implementation of the Mersenne Twister random
--   number generator by Makoto Matsumoto and Takuji Nishimura
-- for more information on the Mersenne Twister visit
--   http://www.math.keio.ac.jp/~matumoto/emt.html
--
-- Lua conversion by Dave Bollinger (dbollinger@compuserve.com) 12/20/1999
-- based on mt19937int.c, mt19937-1.c and mt19937-2.c (as of Oct-28-1999)
--   verified against mt19937int.out, mt19937-1.out and mt19937-2.out
--
-- Why native Lua?  For quick & dirty use by the stand-alone interpreter.
-- For when you need a "good" RNG in Lua but aren't really worried about
-- speed.  Without native integer support this Lua version is slower than
-- would otherwise be expected.  The code isn't optimized, more or less
-- just a straight verbatim port, but it does produce correct results.
-- If speed is a concern, just register the MT C code for Lua - works well.
--
-- Todo:  could write wrappers over the standard libraries random() and
--        randomseed() to call MT
--
-- Usage notes:  default behaviour is as mt19937-1  [0,1] interval
--   see comments below about "divisor" property and shortcuts for setting
--

--------------------------
-- UTILITIES
-- bitwise boolean support
-- for 32-bit "integers"
--------------------------

-- 2^n, n=[0,32]
POW2 = { [0]=1; 2, 4, 8, 16, 32, 64, 128,
         256, 512, 1024, 2048, 4096, 8192, 16384, 32768,
         65536, 131072, 262144, 524288, 1048576, 2097152, 4194304, 8388608,
         16777216, 33554432, 67108864, 134217728, 268435456, 536870912, 1073741824, 2147483648,
         4294967296 }

-- returns a "binary" representation of a number
function BIN(num)
  local bin={}
  num = floor(mod(num,POW2[32]))
  local i = 31
  while i>=0 do
    local pow2=POW2[i]
    if (num >= pow2) then
      bin[i] = 1
      num=num-pow2
    else
      bin[i] = nil
    end
    i=i-1
  end
  return bin
end

-- converts a "binary" back to a regular float
function NUM(bin)
  local i,num=31,0
  while i>=0 do
    if (bin[i]) then
      num=num+POW2[i]
    end
    i=i-1
  end
  return num
end

-- takes two floats, does bitwise and, returns float result
function AND(num1,num2)
  local bin1,bin2,result,i = BIN(num1),BIN(num2),{},0
  while i < 32 do
    result[i] = bin1[i] and bin2[i]
    i=i+1
  end
  return NUM(result)
end

-- takes two floats, does bitwise or, returns float result
function OR(num1,num2)
  local bin1,bin2,result,i = BIN(num1),BIN(num2),{},0
  while i < 32 do
    result[i] = bin1[i] or bin2[i]
    i=i+1
  end
  return NUM(result)
end

-- takes two floats, does bitwise xor, returns float result
function XOR(num1,num2)
  local bin1,bin2,result,i = BIN(num1),BIN(num2),{},0
  while i < 32 do
    result[i] = (bin1[i] == (not bin2[i]))
    i=i+1
  end
  return NUM(result)
end

-- takes one float, does pseudo bitwise shift right, returns float result
function SHR(num)
  return floor(num/2)
end

-- takes one float, returns least-significant bit as float 0 or 1
function BIT0(num)
  return floor(mod(num,2))
end

-------------------------
-- END OF UTILITIES
-- BEGIN MERSENNE TWISTER
-------------------------

MT19937 = {
  -- Period parameters
  N = 624,
  M = 397,
  MATRIX_A = 2567483615,
  UPPER_MASK = 2147483648,
  LOWER_MASK = 2147483647,
  -- Tempering parameters
  TEMPERING_MASK_B = 2636928640,
  TEMPERING_MASK_C = 4022730752,
  TEMPERING_SHIFT_U = function(y)  return floor(y / 2048)  end,
  TEMPERING_SHIFT_S = function(y)  return floor(y * 128)  end,
  TEMPERING_SHIFT_T = function(y)  return floor(y * 32768)  end,
  TEMPERING_SHIFT_L = function(y)  return floor(y / 262144)  end,
  -- array for the state vector
  mt = {},
  mti = 625, -- N+1
  -- CUSTOM STUFF
  divisor = 2.3283064370807974e-10
  -- set divisor (which is really 1/divisor) as follows:
  --   1.0                      -- [0,2^32-1] "integer"             mimics mt19937int
  --   2.3283064370807974e-10   -- [0,1] equiv to (y/MAXUINT)       mimics mt19937-1
  --   2.3283064365386963e-10   -- [0,1) equiv to (y/(MAXUINT+1))   mimics mt19937-2
}

-- shortcuts for setting the divisor
function MT19937:setintegerinterval()  self.divisor=1.0  end
function MT19937:setclosedinterval()  self.divisor=2.3283064370807974e-10  end
function MT19937:setopeninterval()  self.divisor=2.3283064365386963e-10  end

-- seed the array (originally "sgenrand")
function MT19937:randomseed(seed)
  local i=0
  while i<self.N do
    local temp = AND(seed,4294901760)
    seed = floor(mod(69069*seed+1,POW2[32]))
    local q = floor(AND(seed,4294901760) / 65536)
    self.mt[i] = OR(temp, q)
    seed = floor(mod(69069*seed+1,POW2[32]))
    i=i+1
  end
  self.mti=self.N
end

-- generate a number (originally "genrand")
function MT19937:random()
  local y
  if self.mti>=self.N then
    if self.mti==self.N+1 then
      self:randomseed(4357)
    end
    local kk=0
    while kk<self.N-self.M do
      y = OR( AND(self.mt[kk],self.UPPER_MASK) , AND(self.mt[kk+1],self.LOWER_MASK) )
      self.mt[kk] = XOR(self.mt[kk+self.M], XOR( SHR(y), BIT0(y)*self.MATRIX_A ))
      kk=kk+1
    end
    while kk<self.N-1 do
      y = OR( AND(self.mt[kk],self.UPPER_MASK) , AND(self.mt[kk+1],self.LOWER_MASK) )
      self.mt[kk] = XOR(self.mt[kk+(self.M-self.N)], XOR( SHR(y), BIT0(y)*self.MATRIX_A ))
      kk=kk+1
    end
    y = OR( AND(self.mt[self.N-1],self.UPPER_MASK) , AND(self.mt[0],self.LOWER_MASK) )
    self.mt[self.N-1] = XOR(self.mt[self.M-1], XOR( SHR(y), BIT0(y)*self.MATRIX_A ))
    self.mti=0
  end
  y = self.mt[self.mti]
  self.mti = self.mti+1
  y = XOR(y, self.TEMPERING_SHIFT_U(y))
  y = XOR(y, AND(self.TEMPERING_SHIFT_S(y), self.TEMPERING_MASK_B) )
  y = XOR(y, AND(self.TEMPERING_SHIFT_T(y), self.TEMPERING_MASK_C) )
  y = XOR(y, self.TEMPERING_SHIFT_L(y))
  return y * self.divisor
end

-- reproduce the validation output sequence (originally "main")
function MT19937:test(asInt)
  self:randomseed(4357);
  local j=0
  while j<1000 do
    if (asInt) then
      write( format("%10.0f ", self:random()) )
    else
      write( format("%10.8f ", self:random()) )
    end
    if mod(j,5)==4 then
      write("\n")
    end
    j=j+1
  end
end

-- test routine driver
-- creates two text files that can be directly diff'd or comp'd
-- with the official outputs to validate the conversion
function MT19937:CreateValidationOutput()
  writeto("mt19937int.out")
  self:setintegerinterval()
  self:test(1)
  writeto("mt19937-1.out")
  self:setclosedinterval()
  self:test()
  writeto("mt19937-2.out")
  self:setopeninterval()
  self:test()
  writeto()
end

--MT19937:CreateValidationOutput()

-- EOF
