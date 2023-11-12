.PHONY: all

CC = g++
PTHREAD_FLAG = -lpthread
CPPFLAGS = -O3 -march=native -ffast-math  
AVX_FLAG = -mavx
SOURCE = pi.cpp
# TARGET = $(SOURCE:.cpp=.out)
TARGET = $(patsubst %.cpp, %.out, $(SOURCE))

all:
	$(CC) $(SOURCE) $(PTHREAD_FLAG) $(CPPFLAGS) $(AVX_FLAG) -o $(TARGET)

clean:
	rm $(TARGET)