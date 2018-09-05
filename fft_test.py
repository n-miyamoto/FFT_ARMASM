# -*- coding: utf-8 -*-
import numpy as np

if __name__ == "__main__":
    N=16
    f = []
    for i in range(N):
        f.append(float(i)/N)

    F = np.fft.fft(f)/N
    print(f)
    print(F)

